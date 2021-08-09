module SW
  module ProgressBarExampleMessageBox
    
    def self.start()
      model = Sketchup.active_model.start_operation('Progress Bar Example', true)
      
      SW::ProgressBar.new(method(:on_complete_1), method(:on_abort), id: 'message_box_bar') do |pbar|
        pbar.label= "Checking Data"
        pbar.set_value(0)
        count = 3000
        
        # create an array of random points
        @points = count.times.collect{ |i|
          sleep(0.0005) # pretend we're doing some heavy lifting
          if pbar.update?
            pbar.set_value(100 * i /count)
            pbar.refresh
          end
          [rand(100),rand(100),rand(100)]
        }
      end
      
    end 
    
    def self.on_complete_1()
      SW::ProgressBar.display_safe_messagebox() {
        if UI.messagebox("Add #{@points.size} entities to the model?", MB_YESNO) == IDYES
          @bar = SW::ProgressBar.new(method(:on_complete_2), method(:on_abort), method(:op_2), id: 'message_box_bar' ) 
          @bar.animate_label = true
        end
      }
    end
    
    ####################
    # Start of second stage
    #
     
    def self.op_2(pbar)  
      pbar.label= "Adding"
            pbar.refresh
      
      @points.each_with_index {|point, index|
        make_cube(point)
        if pbar.update?
          pbar.set_value(100.0 * index/@points.size) 
            pbar.refresh
        end
      }
    end
    
    #add a cube to the model  
    def self.make_cube(point)
      ents = Sketchup.active_model.entities
      grp = ents.add_group
      face = grp.entities.add_face [0,0,0],[2,0,0],[2,2,0],[0,2,0]
      face.pushpull(2)
      grp.material = "red"
      tr = Geom::Transformation.new(point)
      grp.transform!(tr)
    end
    
   
    ####################
    # End of second stage
    #
    def self.on_complete_2
      Sketchup.active_model.commit_operation
      puts 'Progress Bar Example Completed'
      SW::ProgressBar.display_safe_messagebox() { UI.messagebox('Example Completed.') }
    end
    
    ####################
    # Handle user abort and Exceptions
    #
    def self.on_abort(exception)
      Sketchup.active_model.abort_operation
      if exception.is_a? SW::ProgressBar::ProgressBarAbort
        puts 'Progress Bar Example Aborted: ' + exception.to_s
        SW::ProgressBar.display_safe_messagebox() { UI.messagebox('Progress Bar Example Aborted: ' + exception.to_s) }
      else
        raise exception
      end
    end
    
  end

end
nil
    



