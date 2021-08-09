module SW
  module User_Draw_Example 

    def self.start
      model = Sketchup.active_model.start_operation('Progress Bar Example', true)
      bar = SW::ProgressBar.new(method(:on_complete), method(:on_abort), method(:count_down))
      bar.options[:location] = [100, 100]
      bar.options[:width] = 200
      bar.options[:height] = 200
      
      # define a custom draw method
      bar.define_singleton_method(:draw) { |view|
        x, y = bar.options[:location]
        
        if label
          point = Geom::Point3d.new(x, y + 170, 0)
          view.draw_text(point, label, size: 14)
        end
        
        ################################
        # draw a lime pie
        x, y = bar.options[:location]
        center = Geom::Point3d.new(x + 100, y + 100, 0)
        around_vector = Geom::Vector3d.new(0, 0, 1)
        angle = 3.6.degrees
        tr = Geom::Transformation.rotation([0,0,0], around_vector, angle)
        radius = Geom::Vector3d.new(50, 0, 0)
        @pie_perimeter = 101.times.map { center + radius.transform!(tr) }
          
        # Draw the background
        view.line_stipple = '' # Solid line
        view.line_width = 2
        view.drawing_color = Sketchup::Color.new(255, 255, 255)
        view.draw2d(GL_POLYGON, @pie_perimeter)
        
        # Add the progress slices
        radius = Geom::Vector3d.new(0, -50, 0)
        pie_slices = [center, center + radius]  
        
        (value * 100).to_i.times {
          radius = radius.transform(tr)
          pie_slices << Geom::Point3d.new(center + radius)
        }

        view.drawing_color = Sketchup::Color.new(128, 220, 128)
        view.draw2d(GL_TRIANGLE_FAN, *pie_slices) if pie_slices.size > 2
        
        # Draw the outline
        view.line_stipple = '' # Solid line
        view.line_width = 2
        view.drawing_color = Sketchup::Color.new(64, 64, 64)
        view.draw2d(GL_LINE_STRIP, @pie_perimeter)
      }
    end
     

    def self.count_down(pbar)
      count = 0
      while (count += 1) <= 100
        pbar.label= "ProgressBar Step: #{count}"
        pbar.advance_value(1.0)
        pbar.refresh
        sleep(0.01)
      end
    end
     
    def self.on_complete
      Sketchup.active_model.commit_operation
      puts 'Progress Bar Example Complete'
    end

    def self.on_abort(exception)
      Sketchup.active_model.abort_operation
       
      if exception.is_a? SW::ProgressBar::ProgressBarAbort
         puts 'Progress Bar Example Aborted: ' + exception.to_s
      else
        raise exception
      end
    end

  end
end
