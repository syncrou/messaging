module RulesHelper
  def build_state_url(rule)
    if rule.active?
      "#{link_to "<b style='color:green;'>On</b>".html_safe, deactivate_rule_path(rule)}".html_safe
     else
      "#{link_to "<span style='color:red;'>Off</span>".html_safe, activate_rule_path(rule)}".html_safe
    end
  end
end
