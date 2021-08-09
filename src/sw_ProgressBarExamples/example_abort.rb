module SW
  module ProgressBarExampleCrash# Exception class for Progress bar user code errors


    class CustomException < RuntimeError; end
    
    
    ####################################
    # entry point
    # - the toolbar buttons are created in the loader file
    #
       
    def self.start
      model = Sketchup.active_model.start_operation('Progress Bar Fail Example', true)
      SW::ProgressBar.new(method(:on_complete), method(:on_abort)) do |bar|
        count = 3.0
        
        while (count -= 0.5) >= 0
          bar.label = "Aborting in #{count} seconds"
          bar.refresh
          sleep(0.5)
          bar.advance_value(16.6)
        end

        raise CustomException, 'Countdown Ended'
      end
    end
    
    
    
    def self.on_complete
      puts 'Progress Bar Example Complete'
      Sketchup.active_model.commit_operation
      SW::ProgressBar.display_safe_messagebox {UI.messagebox('Example Completed.') }
    end
    
    def self.on_abort(exception)
      Sketchup.active_model.abort_operation

      case 
      when exception.is_a?(CustomException)
        SW::ProgressBar.display_safe_messagebox {UI.messagebox(exception.to_s + "\nin: " + exception.backtrace[1..-2].join("\n\nin: "), MB_MULTILINE)}
      
      when exception.is_a?(SW::ProgressBar::ProgressBarError)
        SW::ProgressBar.display_safe_messagebox {UI.messagebox(exception.to_s + "\nin: " + exception.backtrace[1..-3].join("\n\nin: "), MB_MULTILINE)}
      
      when exception.is_a?(SW::ProgressBar::ProgressBarAbort)
        puts 'Progress Bar Example Aborted: ' + exception.to_s
      
      else
        raise exception
      
      end
    end

  end 
end
nil
