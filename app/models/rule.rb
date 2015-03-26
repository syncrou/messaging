# == Schema Information
#
# Table name: rules
#
#  id          :integer          not null, primary key
#  rule        :text
#  rule_body   :text
#  extra_var_1 :string(255)
#  extra_var_2 :string(255)
#  extra_var_3 :string(255)
#  customer_id :integer
#  name        :string(255)
#  rule_type   :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  deliver_at  :string(255)
#  extra_var_4 :string(255)
#  state       :string(255)
#  subject     :string(255)
#

class Rule < ActiveRecord::Base
  belongs_to :customer

  state_machine :state, :initial => :inactive do
    state :active
    state :inactive

    event :activate do
      transition [:inactive, :active] => :active
    end

    event :deactivate do
      transition [:active, :inactive] => :inactive
    end
  end

  scope :active, -> { where(state: 'active').order(:id) }
  scope :inactive, -> { where(state: 'inactive').order(:id) }

  validates_presence_of :subject, if: Proc.new { |x| x.rule_type == 'Email' }

  # Determine the returned ruleset and merge to the rule body
  #
  # * Grab the rule query - loop and map the return
  #   to match what is needed in the sms table
  # * Build the accounting row for this batch
  # * Simply drop the accounting row and return if there is nothing to send

  def maps
    @uuid = UUID.new
    @temp_vars = declared
    @acct = Accounting.create(:customer_id => customer_id)
    rc = RemoteConnect.establish_connection customer.control.name.to_sym
    deliver = Merger::render_from_hash(deliver_at, {})
    erbified = Merger::render_from_hash(rule, {})
    remote_returns = rc.connection.execute(erbified)

    @acct.destroy && return if (remote_returns.present? && remote_returns.size == 0)
    return unless remote_returns.present?

    remote_returns.each do |s|
      if rule_type == 'SMS'
        sms_vars = combine_to_vars(s)
        to_sms(sms_vars, deliver)
      else
        email_vars = combine_to_vars(s)
        to_email(email_vars, deliver)
      end
    end
  end

  private

  # Determine the layout of the built sms
  #
  # * build and save the correctly laid out sms

  def to_sms(sms_vars, deliver)
    sms = Sms.new(:name => set_sms_name,
                  :customer_id => customer_id,
                  :to_deliver => deliver,
                  :repeat => 1,
                  :accounting => @acct,
                  :to_phone => sms_vars[:phone],
                  :body => Merger::render_from_hash(rule_body, sms_vars)
                 )
    sms.save if sms.valid?
  end

  # Determine the layout of the built email
  #
  # * build and save the correctly laid out email

  def to_email(email_vars, deliver)
    email = Email.new(:name => set_email_name,
                      :customer_id => customer_id,
                      :to_deliver => deliver,
                      :repeat => 1,
                      :accounting => @acct,
                      :to_email => email_vars[:email],
                      :subject => subject,
                      :body => Merger::render_from_hash(rule_body, email_vars)
                    )
    email.save if email.valid?
  end

  def set_sms_name
    u = @uuid.generate(:compact)[0..5].upcase
    "S#{u}"
  end

  def set_email_name
    e = @uuid.generate(:compact)[0..5].upcase
    "E#{e}"
  end


  def combine_to_vars(returns)
    current_vars = @temp_vars.dup
    current_vars.each do |k, v|
      current_vars[k] = returns[v]
    end
    current_vars
  end

  def declared
    h = {}
    inc = 0
    arr = [extra_var_1, extra_var_2, extra_var_3, extra_var_4].compact
    arr.each do |ex|
      h[ex.to_sym] = inc if ex.present?
      inc += 1 if ex.present?
    end
    h
  end

end
