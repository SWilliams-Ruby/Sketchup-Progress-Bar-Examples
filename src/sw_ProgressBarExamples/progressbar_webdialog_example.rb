# Subclassing the ProgressBar class

module SW
  module Progressbar_Webdialog_Example
    def self.demo()
      model = Sketchup.active_model.start_operation('Progress Bar Example', true)

      SW::ProgressBarWebDialog.new(method(:on_complete), method(:on_abort)) {|pbar|
        
        # create an array of random points 
        points = 1000.times.collect{[rand(100),rand(100),rand(100)]}

        points.each_with_index {|point, count|
          make_cube(point)
          if pbar.update?
            progress = 100 * count / points.size
            pbar.label = "#{progress}% completed"
            pbar.set_value(progress)
            pbar.refresh
          end
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
        puts 'Progress Bar Auyomamtic Example Aborted: ' + exception.to_s
      else 
        raise exception
      end
    end
  end
end


