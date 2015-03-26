require 'resque/tasks'

# Currently, we always need our Rails env when doing Resque jobs. If this changes, then this will need to change.
# However, for now, we want to chain the requirements for loading resque so that when the environment is
#   loaded expressly for Resque workers, we set a global constant to allow us to configure the Rails
#   logger for logging the jobs.

task 'resque:preinit' do
  Object.const_set('APP_LOADED_FOR_RESQUE', true)
end

task 'resque:setup' => [:preinit, :environment] do
end

