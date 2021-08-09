include Math

module SW
  module ProgressBarLissajous
  
    # A red rubber jelly_bean
    class Jelly_bean
      attr_accessor(:position, :vector, :last_update, :created, :color)
      @@radius = 5
      @@gravity =  -385.827 # 9.8 meters/sec^2 in inches
      @@damping = 0.9
      @@start_time = Time.now
      @@scale = 200
      
      def initialize()
        # jelly_bean location, direction, and speed
        @instance_time_offset = rand() * 4 * PI
        @position = Geom::Point3d.new(0,0,50)
        @saved_position = @position
        @saved_update_time = Time.now - 0.01
        @vector = Geom::Vector3d.new(40 + rand(100), -100 + rand(100),  500 + rand(100))
        @last_update = Time.now
        @created = Time.now # might be used to 'age out' old objects
        make_perimeter()
      end
      
      def make_perimeter()
        # p 'make perimeter'
        # Create the jelly_bean outline 
        return if defined? @@puck_periemeter
        center = Geom::Point3d.new(0, 0, 0)
        rotate_around_vector = Geom::Vector3d.new(0, 0, 1)
        angle = 7.2.degrees
        tr = Geom::Transformation.rotation(center, rotate_around_vector, angle)
        vector = Geom::Vector3d.new(@@radius, 0, 0)
        @@puck_perimeter = 51.times.map {center + vector.transform!(tr) }
      end
      
      def draw(view)
        # Draw the jelly_bean
        camera = view.camera
        tr = Geom::Transformation.axes([0,0,0], camera.xaxis, camera.yaxis, camera.zaxis)
        tr = Geom::Transformation.translation(@position) * tr
        jelly_bean_perimeter = @@puck_perimeter.collect{|pt| pt.transform(tr)}
        #alpha = 256 - (Time.now - @created) * 100
        #alpha = 0 if alpha < 0
        alpha = 256
        #return if @velocity.nan?
        v = @velocity / 10
        h = v.modulo(360)
        return if h.nan?

        rgb = hsv_to_rgb(h, 100, 100)
        view.drawing_color = Sketchup::Color.new(*rgb, alpha)
        
        #view.drawing_color = Sketchup::Color.new(256, 32, 32, alpha)
        view.draw(GL_POLYGON, jelly_bean_perimeter)
      end
      
      # def draw_path(view)
        # t = Time.now - @@start_time + @instance_time_offset
        # t_max = t + 20
        # step = 0.1
        # lines = []
        # while t < t_max 
          # lines << algo(t)
          # t += step
        # end
        # view.drawing_color = Sketchup::Color.new('black')
        # view.draw(GL_LINE_STRIP, lines)
      # end
      
      def hsv_to_rgb(h, s, v)
        h, s, v = h.to_f/360, s.to_f/100, v.to_f/100
        h_i = (h*6).to_i
        f = h*6 - h_i
        p = v * (1 - s)
        q = v * (1 - f*s)
        t = v * (1 - (1 - f) * s)
        r, g, b = v, t, p if h_i==0
        r, g, b = q, v, p if h_i==1
        r, g, b = p, v, t if h_i==2
        r, g, b = p, q, v if h_i==3
        r, g, b = t, p, v if h_i==4
        r, g, b = v, p, q if h_i==5
        [(r*255).to_i, (g*255).to_i, (b*255).to_i]
      end

       

      def move()
        @saved_position = Geom::Point3d.new(@position.to_a)
        
        # update position
        delta_T = Time.now - @@start_time + @instance_time_offset
        @position.z, @position.x, @position.y = algo(delta_T)
        delta_t = Time.now - @saved_update_time
        @velocity = (@position.distance(@saved_position)) / delta_t
        @saved_update_time = Time.now
      end
      
      def algo(delta_T)
        [
        sin(delta_T + 2) * @@scale,
        sin(delta_T * 3.3) * @@scale,
        sin(delta_T * 2.5) * @@scale
        ]
      end
      
      
    end # class jelly_bean


    #########################################
    #
    class Lissajous < SW::ProgressBar
      def initialize(*args)
        super
        @bbox = nil
        
        # simulate with a bunch of jelly_beans
        @jelly_beans = []
        #100.times {@jelly_beans << Jelly_bean.new()}
        50.times {@jelly_beans << Jelly_bean.new()}
        
        if @@lookaway
          look_back()
          @@lookaway = false
        end
      end
      
      def getExtents()
        @bbox if @bbox
      end

      def onMouseMove(flags, x, y, view)
        #SW::Frames::FramesManager.tool.onMouseMove(flags, x, y, view)
      end     

      def onLButtonDown(flags, x, y, view)
        #SW::Frames::FramesManager.tool.onLButtonDown(flags, x, y, view)
      end
      
      def onLButtonUp(flags, x, y, view)
        #SW::Frames::FramesManager.tool.onLButtonUp(flags, x, y, view)
      end
      

      def draw(view)
        ######################################################
        # update the jelly_bean location, and generate a new bounding box
        #
        bb = Geom::BoundingBox.new
        @jelly_beans.each {|jelly_bean|
          jelly_bean.move()
          bb.add(jelly_bean.position)
          jelly_bean.draw(view)
        }
        
        #@jelly_beans.first.draw_path(view)

        # update the drawing extents of the progressbartool
        @bbox = bb
        #SW::Frames::FramesManager.update_frames(view)
      end #user_draw
        
    end # Class Lissijous
    
    
    def self.start()
      # start the progress bar tool
      @bar = SW::ProgressBarLissajous::Lissajous.new(
        method(:on_complete),
        method(:on_abort),
        method(:demo)
      )
      
      return unless @bar
      
      # demo length and state
      @demo_length = 100
      @in_play = true
      @@start_time = Time.now
      @frame_count = 0 # for statistics

      
    end # start
   
   
    def self.demo(pbar)
      # run for demo_length in seconds
      while @in_play && (Time.now - @@start_time) < @demo_length
        # Redraws are tied to the monitor refresh rate,  50hz or 60hz
        # trigger a redraw
        @frame_count += 1
        pbar.refresh
      end
    end
     
    def self.on_complete
      puts 'jelly_bean demo completed'
   
      # print statistics
      elapsed = Time.now - @@start_time
      puts "fps: #{@frame_count / elapsed}" # frames per second
      
    end

    def self.on_abort(exception)
      # Did the user ESC or change tools?
      if exception.is_a? SW::ProgressBar::ProgressBarAbort
         puts 'jelly_bean Demo aborted'
      else
        raise exception
      end
    end

  end
end