module Resque
  module Plugins
    module JobTemplate
      class ResqueJobWithStatus < Resque::JobWithStatus
        extend Resque::Plugins::Logged

        # Need to override the JobWithStatus instance logger.
        # We are not really going to use it because a) it just gets logged to Redis, and b) it's not easy to get at in resque-web
        #   without creating views. Hoptoad and our logging structure for Resque should be sufficient. None of resque-status seems
        #   to rely on the logger.
        def logger
          Rails.logger
        end
        alias_method :job_with_status_logger, :logger

        # N.B. When trying to update resque-web and alter the Resque::Status object that comes back, keep the following in mind.
        #   The Resque::Status object is essentially a hash.
        #     :message is set by (see the docs): at, tick, and set_status. At and tick check also whether the job should get killed.
        #       the message string is only set if a string is passed as one of the elements. If multiple strings are passed, then the last one wins.
        #       the message string also is overwritten by the job's failure with resque-status's default messaging.
        #    Passing hashes during tick, at, or set_status will cause any hashes to become part of the Status.
        #    Passing the same key later will cause it to get overwritten.
        #  Resque::Plugins::Status.status which is usually queued, working, failed, or completed is also hard to overwrite. You have to play within Resque::Plugins::Status boundaries.
        #    You can alter this so it displays in the resque-web, but when the job fails or completes, it will force it to completed or failed.
        #    If you call failed('Super awesome failure') but the job completes without an error during the perform, it will show completed and the default messaging from resque-status.
        #    Only if you do completed('spectacularly') will you get your own custom message but the job must complete successfully. Otherwise, it goes to failed and gets a message related to the exception.
        #
        #  So, in general, simple strings passed to tick, set_status, and at cannot be relied upon to stick around for the final Resque::Status.message hash value. They can be consumed by UIs.
        #    Use your own hash keys to communicate important messages or values.

        @num_steps = 0       # declare the number of steps in the subclass
        @current_step = 0    # the current step being processed in the job


        # Updates the status of the job to the next step
        def next_step(status)
          @current_step = 0 unless @current_step
          logger.info status
          at(@current_step+=1, @num_steps, status)
        end
      end
    end
  end
end