module Resque
  module Plugins
    module Logged
      # Delayed extend since the namespaced module below isn't known until the parent module has been loaded.
      def self.extended(base)
        base.extend Logging
      end


      # Main method which yields to the Job but provides pretty logging.
      def around_perform_log_job(*args)
        err = false
        start_time = Time.now.utc
        log_processing_before_perform(*args)
        ms = [Benchmark.ms { yield }, 0.01].max
      rescue StandardError, Timeout::Error => e
        err = true
        log_processing_for_job_failure(e)
        raise
      ensure
        ms ||= ((Time.now.utc - start_time) * 1000.0).to_i # Convert to milliseconds
        log_processing_for_after_perform(ms, err)
      end

      ### Failure hook should we decide to use one.
      #def on_failure_hook_name_goes_here(e, *args)
      #  awesome_recovery_or_requeueing_method(e)
      #end

      # The overall structure is shamelessly lifted from ActionController::Base & Benchmark.
      # I wanted a nice clean block in the resque logfile using the normal Rails logging functions.
      module Logging
        HOSTNAME = Socket.gethostname rescue nil

        def log_processing_before_perform(*args)
          if logger && logger.info?
            log_processing_for_job_begin
            log_processing_for_job_enqeued_parameters(*args)
            log_processing_for_active_record
          end
        end

        def log_processing_for_after_perform(ms, err)
          if logger && logger.info?

            log_message = (err ? 'Failed' : 'Completed')
            log_message << " #{self} in %.0fms" % ms

            if logging_active_record?
              log_message << " ("
              log_message << active_record_runtime + ")"
            end

            log_message << " [#{HOSTNAME}:#{Process.pid}]"

            logger.send((err ? :error : :info), log_message)
          end
        ensure
          logger.flush if logger && logger.respond_to?(:flush)
        end

        def log_processing_for_job_failure(e)
          if logger && logger.fatal?
            job_failure = "Resque job failure #{self}\##{self.superclass} [#{HOSTNAME}:#{Process.pid}] at #{Time.now.to_s(:db)}"
            logger.fatal(job_failure)
            logger.fatal("\n#{e.class} (#{e.message}):\n    " +
                         e.backtrace.join("\n    ")
            )
          end
        end

      private
        def logger
          Rails.logger
        end

        def log_processing_for_job_begin
          job_begin = "\nProcessing #{self}\##{self.superclass}\##{@queue} [#{HOSTNAME}:#{Process.pid}] at #{Time.now.to_s(:db)}"
          logger.info(job_begin)
        end

        def log_processing_for_job_enqeued_parameters(*args)
          logger.info "  Enqueued Parameters: #{args.inspect}"
        end

        def log_processing_for_job_perform_parameters(*args)
          logger.info "   Perform Parameters: #{args.inspect}"
        end

        def log_processing_for_active_record
          if logging_active_record?
            ""
          end
        end

        def logging_active_record?
          return Object.const_defined?('ActiveRecord') && ActiveRecord::Base.connected?
        end

        def active_record_runtime
          ""
        end
      end
    end
  end
end

