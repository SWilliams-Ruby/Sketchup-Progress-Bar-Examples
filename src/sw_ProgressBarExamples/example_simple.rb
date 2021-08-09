module SW
  module ProgressBarExampleSimple
        
    def self.start()
      model = Sketchup.active_model.start_operation('Progress Bar Example 0', true)

      SW::ProgressBar.new(method(:on_complete), method(:on_abort)) do |pbar|
        for count in 1..10
          pbar.label= "Step: #{count}"
          pbar.set_value(count * 10)
          pbar.refresh
          sleep(0.3)
        end
      end
    end
    
    def self.on_complete
      Sketchup.active_model.commit_operation
      SW::ProgressBar.display_safe_messagebox {UI.messagebox('Example Completed.')}
    end
    
    
    def self.on_abort(exception)
      Sketchup.active_model.abort_operation
      if exception.is_a?(SW::ProgressBar::ProgressBarAbort)
        # the user has hit the Escape key or clicked on another tool
        SW::ProgressBar.display_safe_messagebox {UI.messagebox('Progress Bar Example Aborted: ' + exception.to_s)}
      else
        raise exception
      end
    end
   
  end 

end
nil
