class SendSmsJob < Resque::Plugins::JobTemplate::ResqueJob
  extend Resque::Plugins::Lock

  @queue=:general

  def self.lock(*args)
    return "lock:send_sms_job"
  end

  # Send the sms's
  #
  # * Loop through all the undelivereds - Send only those that are less then
  #   the SEND_TIME_DIFFERENCE from the to_deliver timestamp
  def self.perform
    begin
      Sms.undelivered.each do |sms|
        correct_env_action(sms) if Time.now.utc >= sms.to_deliver && sms.to_deliver <= Sms::SEND_TIME_DIFFERENCE.minutes.from_now.utc && sms.to_deliver >= Sms::SEND_TIME_DIFFERENCE.minutes.ago.utc
      end
    rescue => e
      Rails.logger.error "[send_sms_job] Error: #{e.inspect} Backtrace: #{e.backtrace}"
    end
  end

  private

  def self.correct_env_action(sms)
    unless Rails.env.production?
      sms.print_me!
    else
      sms.send_me!
    end

  end
end
