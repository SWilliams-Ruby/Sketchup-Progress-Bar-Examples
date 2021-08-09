# ProgressBarSpinner
#   Spins the cursor but does not draw the progressbar, check for keyboard
#   or mouse input every auto_interval
 
module SW
  module Progressbar_Spinner_Example
    # example:
    
    def self.demo()
      model = Sketchup.active_model.start_operation('Progress Bar Example', true)
      
      SW::ProgressBarSpinnerAndLabelAuto.new(method(:on_complete), method(:on_abort)) {|pbar|
        pbar.redraw_label('ik ben ermee bezig.')

        # create an array of random points 
        points = 2500.times.collect{[rand(100),rand(100),rand(100)]}
        points.each{|point|
          make_cube(point)
        }
      }

    end
    
      
    # add a cube to the model  
    def self.make_cube(point)
      ents = Sketchup.active_model.entities
      grp = ents.add_group
      face = grp.entities.add_face [0,0,0],[2,0,0],[2,2,0],[0,2,0]
      face.pushpull(2)
      grp.material = "green"
      tr = Geom::Transformation.new(point)
      grp.transform!(tr)
    end
    
    
    def self.on_complete()
      Sketchup.active_model.commit_operation
      SW::ProgressBar.display_safe_messagebox { UI.messagebox('Progress Bar Example Completed.') }
    end

    def self.on_abort(exception)
      Sketchup.active_model.abort_operation
      if exception.is_a? SW::ProgressBar::ProgressBarAbort
        SW::ProgressBar.display_safe_messagebox { UI.messagebox('Progress Bar Example Aborted.') }
      else 
        raise exception
      end
    end
  end
end
nil