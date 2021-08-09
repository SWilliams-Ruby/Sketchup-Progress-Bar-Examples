module SW
  module ProgressBarDrop
  
    # A red rubber ball
    class Ball
      attr_accessor(:position, :vector, :last_update, :created, :color)
      @@radius = 5
      @@gravity =  -385.827 # 9.8 meters/sec^2 in inches
      @@damping = 0.9
      
      def initialize()
        # Ball location, direction, and speed
        @position = Geom::Point3d.new(0,0,50)
        @vector = Geom::Vector3d.new(40 + rand(100), -100 + rand(100),  500 + rand(100))
        @last_update = Time.now
        @created = Time.now # might be used to 'age out' old objects
        make_perimeter()
      end
      
      def make_perimeter()
        # p 'make perimeter'
        # Create the ball outline 
        return if defined? @@puck_periemeter
        center = Geom::Point3d.new(0, 0, 0)
        rotate_around_vector = Geom::Vector3d.new(0, 0, 1)
        angle = 7.2.degrees
        tr = Geom::Transformation.rotation(center, rotate_around_vector, angle)
        vector = Geom::Vector3d.new(@@radius, 0, 0)
        @@puck_perimeter = 51.times.map {center + vector.transform!(tr) }
      end
      
      def draw(view)
        # Draw the ball
        camera = view.camera
        tr = Geom::Transformation.axes([0,0,0], camera.xaxis, camera.yaxis, camera.zaxis)
        tr = Geom::Transformation.translation(@position) * tr
        ball_perimeter = @@puck_perimeter.collect{|pt| pt.transform(tr)}
        #alpha = 256 - (Time.now - @created) * 100
        #alpha = 0 if alpha < 0
        alpha = 256
        view.drawing_color = Sketchup::Color.new(256, 32, 32, alpha)
        view.draw(GL_POLYGON, ball_perimeter)
      end
       
      # reflection off of a plane 
      # ray1 = Geom::Vector3d.new(-1,0,0)
      # plane_normal = Geom::Vector3d.new(1,0,0)
      # tr = Geom::Transformation.rotation( [0,0,0], plane_normal, 180.degrees)
      # ray2 = ray1.transform(tr)

      def move()
        # movement in a gravitational system
        # a = 1/2 * g * t^2
        # y(t) = y0 + v0t + a

        #update position
        dt = Time.now - @last_update
        a = (@@gravity * dt**2) /2
        @position.z += @vector.z * dt + a
        @position.x += dt * @vector.x
        @position.y += dt * @vector.y
        
        # update velocity
        @vector.z += @@gravity * dt
        @last_update = Time.now

        # did we pass through the zero plane
        if @vector.z < 0 && (@position.z - @@radius) < 0
          # flip the Z set_value
          @vector.z = -@vector.z * @@damping
         end
      end
    end # class Ball


    #########################################
    #
    # Bouncing ball demo
    # start the demo
    #
    #

    def self.start()
      # start the progress bar tool
      @bar = SW::ProgressBar.new(
        method(:on_complete),
        method(:on_abort),
        method(:demo)
      )
      
      return unless @bar
      # Setup up the user_draw method
      @bar.on_draw = method(:user_draw)

      # create an instance variable to hold the bounding box of the geometry we will draw
      # and add the getExtents method to the tool
      @bar.instance_variable_set(:@bbox, nil)
      @bar.define_singleton_method(:getExtents) {
        @bbox if @bbox
      }
      
      # demo length and state
      @demo_length = 10
      @in_play = true
      @start_time = Time.now
      @frame_count = 0 # for statistics

      # simulate with a bunch of balls
      @balls = []
      50.times {@balls << Ball.new()}

    end # start
    
    #################################################################
    #
    # user_draw routine will be called whenever the ProgressBarTool is redrawn
    #
    
    def self.user_draw(view, bar_progress, label)
      @frame_count += 1 # statistics
      
      ######################################################
      # update the ball location, and generate a new bounding box
      #
      bb = Geom::BoundingBox.new
      @balls.each {|ball|
        ball.move()
        bb.add(ball.position)
        ball.draw(view)
      }

      # update the drawing extents of the progressbartool
      @bar.instance_variable_set(:@bbox, bb)
      
    end #user_draw
  
   
    def self.demo(pbar)
      # run for demo_length in seconds
      while @in_play && (Time.now - @start_time) < @demo_length
        # Redraws are tied to the monitor refresh rate,  50hz or 60hz
        # trigger a redraw
        pbar.refresh
      end
    end
     
    def self.on_complete
      puts 'Ball demo completed'
   
      # print statistics
      elapsed = Time.now - @start_time
      puts "fps: #{@frame_count / elapsed}" # frames per second
      
    end

    def self.on_abort(exception)
      # Did the user ESC or change tools?
      if exception.is_a? SW::ProgressBar::ProgressBarAbort
         puts 'Ball Demo aborted'
      else
        raise exception
      end
    end

  end
end