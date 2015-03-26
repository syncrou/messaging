rails_root = ENV['RAILS_ROOT'] || File.expand_path('../../..', __FILE__)
rails_env  = ENV['RAILS_ENV'] || 'development'


require 'resque-status'
require 'resque'
require 'resque/failure/redis'
require 'resque/plugins/lock'
require 'resque/job_with_status'
require 'resque/server'
require 'resque/status_server'
require 'resque_scheduler'
require 'resque_scheduler/server'


### resque-web and resque-scheduler don't need to boot the full environment
### Specific requires for the Schedule tab
if Kernel.caller.grep(/resque-web/) || Kernel.caller.grep(/resque-scheduler/)
#  require 'resque-cleaner'
  unless rails_env == 'test'
    require_relative  '../../jobs/resque/plugins/logged'
    require_relative  '../../jobs/resque/plugins/job_template/resque_job'
    require_relative  '../../jobs/resque/plugins/job_template/resque_job_with_status'
  end
  Dir[File.join(rails_root, 'jobs/*.rb')].each { |file| require file }
end

Resque.redis = YAML.load_file(rails_root + '/config/resque/resque.yml')[rails_env]

Resque.schedule = YAML.load_file(rails_root + '/config/resque/resque_schedule.yml')

# Expire Resque::Plugins::Statuses after 7 days.
Resque::Plugins::Status::Hash.expire_in = (7 * 24 * 60 * 60)

# Make sure we have a good db connection. The magic of AR reconnect doesn't always happen in staging.
if defined? ActiveRecord
  Resque.after_fork do |job|
    ActiveRecord::Base.clear_active_connections!
  end
end

# We have the full Rails evironment so let's go!
# Load multiple failure backends so we get error messages in Hoptoad and resque-web/redis.
if defined?(Rails) && defined?(APP_LOADED_FOR_RESQUE) && APP_LOADED_FOR_RESQUE
  Rails.logger.auto_flushing = 3000 if Rails.env.production?

  require 'resque/failure/multiple'
  Resque::Failure::Multiple.classes = [Resque::Failure::Redis ]
  Resque::Failure.backend = Resque::Failure::Multiple
end

# Clear up Hoptoad and New Relic logging weirdness in resque.log due to the parent log not being flushed before forking children.
Resque.before_first_fork do
  Rails.logger.flush
end


