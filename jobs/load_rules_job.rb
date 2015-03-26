class LoadRulesJob < Resque::Plugins::JobTemplate::ResqueJob
  extend Resque::Plugins::Lock

  @queue = :general

  def self.lock(*args)
    return 'lock:load_rules_job'
  end


  def self.perform
    begin
      rules = Rule.active
      rules.each do |rule|
        rule.maps
      end
    rescue => e
      Rails.logger.error "[load_rules_job] Error: #{e.inspect} Backtrace: #{e.backtrace.join("\n")}"
    end
  end
end

