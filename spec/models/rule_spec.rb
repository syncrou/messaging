describe Rule do
  before(:each) do
    @r = Rule.new(rule: "select 'bob', 'frankel', '4568973445'", rule_body: "This is a test sms to <%= first %> <%= last %> at <%= phone %>",
                 extra_var_1: "last", extra_var_2: "first", extra_var_3: "phone", customer_id: 1,
                 name: "dummy test", state: "active")
    @temp_vars = @r.send(:declared)
  end

  it "allows sql for the rule and embedded erb to build the rule_body" do
    expect(@r.valid?).to eq true

    erbified = Merger::render_from_hash(@r.rule, {})

    expect(erbified).to eq "select 'bob', 'frankel', '4568973445'"

  end

  it "merges extra_var values into the rule body" do
    erbed_rule_body = ""
    erbified = Merger::render_from_hash(@r.rule, {})
    executed_sql = Rule.connection.execute(erbified)
    executed_sql.each do |rule|
      sms_vars = combine_to_vars(rule)
      erbed_rule_body = Merger::render_from_hash(@r.rule_body, sms_vars)
    end
    expect(erbed_rule_body).to eq "This is a test sms to frankel bob at 4568973445"

  end

  def combine_to_vars(returns)
    current_vars = @temp_vars.dup
    current_vars.each do |k, v|
      current_vars[k] = returns[v]
    end
    current_vars
  end
end

