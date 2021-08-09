   module SW
     module Minimal_Example 

      def self.start
        Sketchup.active_model.start_operation('Progress Bar Example', true)
        SW::ProgressBar.start_task(
          method(:count_down),
          method(:on_complete),
          method(:on_abort)
          )
      end

      def self.count_down()
        count = 0
        while (count += 1) < 11
          Fiber.yield ["Executing Step: #{count}" , 10]
          # Modify the Sketchup model here
          sleep(0.5)
        end
        # we return instead yielding here so fiber knowns that the work has ended
        # that's how fibers work
      end
       
      def self.on_complete
        Sketchup.active_model.commit_operation
        puts 'Progress Bar Example Complete'
      end

      def self.on_abort(task, exception)
        Sketchup.active_model.abort_operation
         
        if exception.is_a? SW::ProgressBar::ProgressBarAbort
          puts 'Progress Bar Example Aborted: ' + exception.to_s
        else
          raise exception
        end
      end

      start()
      nil #
     
    end
   end
   