module Resque
  module Plugins
    module JobTemplate
      class ResqueJob
        extend Resque::Plugins::Logged

        # This method exists for resque-scheduler
        # It currently uses Resque:Job.create so that it may place a job onto a specified queue.
        # Resque as of 1.15/1.19 did not have Resque.enqueue_to which allows a custom queue _and_ runs the before_ hooks.
        # When resque-lock is used to prevent multiple scheduled instances with resque-scheduler... it never executes because
        #   the before_ hook for it isn't executed. The job is placed directly on queue.
        #
        # Therefore, set custom_job_class AND class in the resque-scheduler yml file. This will trigger it to look for this method name
        #   which allows custom job classes (like JobWithStatus/resque-status) to have different method signatures but still get scheduled.
        # All resque-scheduler cares about is being able to get the job onto the queue.
        def self.scheduled(queue, klass_name, *params)
          @queue = queue
          Resque.enqueue(self, *params)
        end

      end
    end
  end
end