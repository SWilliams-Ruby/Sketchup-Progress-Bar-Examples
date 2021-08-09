# Subclassing the ProgressBar class
# modify the on screen appearance by redefining the draw method

module SW
  module Progressbar_Customdraw_Example
    def self.demo()
      SW::ProgressBarCustomDraw.new(method(:on_complete), method(:on_abort)) {|pbar|
       pbar.options = {
          location:  [50, 50],
          width:  350,
          height:  80,
          bar_location:  [10, 50],
          bar_width:  330,
          bar_height:  6,
          text_location:  [15, 15]
        }
        
        for count in 1..40
          sleep(0.1)
          pbar.set_value(count * 2.5)
          pbar.label = "#{count}% completed"
          pbar.refresh
        end
      } 
    end
    
    
    def self.on_complete()
      p 'complete'
    end

    def self.on_abort(exception)
      p exception
    end
  end
end


