module SW
  module ProgressBarExampleUpdateFlag

    def self.start()
      model = Sketchup.active_model.start_operation('Progress Bar Example', true)

      SW::ProgressBar.new(method(:on_complete), method(:on_abort), id: 'update_flag_bar') do |pbar|
        pbar.animate_cursor = true

        # The user can force an update of the progressbar at anytime by calling
        # refresh. You would want to do this before calling a long sketchup
        # operation that blocks the ruby code.
        pbar.label= "Starting"
        pbar.set_value(0)
        pbar.refresh
        
        # imagine the user is opening a large file
        sleep(0.5)
      
        # create an array of random points 
        points = 1000.times.collect{[rand(100),rand(100),rand(100)]}

        # Add cubes to the model, keeping the progress bar updated
        points.each_with_index {|point, index|
          make_cube(point)
          if pbar.update?
            pbar.label= "Remaining: #{points.size - index}"
            pbar.set_value( 100 * index / points.size)
            pbar.refresh
          end
        }
      end
    end
    
    # add a cube to the model  
    def self.make_cube(point)
      ents = Sketchup.active_model.entities
      grp = ents.add_group
      face = grp.entities.add_face [0,0,0],[2,0,0],[2,2,0],[0,2,0]
      face.pushpull(2)
      grp.material = "red"
      tr = Geom::Transformation.new(point)
      grp.transform!(tr)
    end
    
    
    def self.on_complete
      Sketchup.active_model.commit_operation
      SW::ProgressBar.display_safe_messagebox { UI.messagebox('Progress Bar Automatic Example Completed.') }
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
nil
