path = File.join(SW::ProgressBarExamples::PLUGIN_DIR, "example_simple.rb")
require path
path = File.join(SW::ProgressBarExamples::PLUGIN_DIR, "example_update_flag.rb")
require path
path = File.join(SW::ProgressBarExamples::PLUGIN_DIR, "example_messagebox.rb")
require path
path = File.join(SW::ProgressBarExamples::PLUGIN_DIR, "example_tool.rb")
require path
path = File.join(SW::ProgressBarExamples::PLUGIN_DIR, "example_userdraw.rb")
require path
path = File.join(SW::ProgressBarExamples::PLUGIN_DIR, "example_abort.rb")
require path

#subclass examples
path = File.join(SW::ProgressBarExamples::PLUGIN_DIR, "progressbar_customdraw_example.rb")
require path
path = File.join(SW::ProgressBarExamples::PLUGIN_DIR, "progressbar_webdialog_example.rb")
require path
path = File.join(SW::ProgressBarExamples::PLUGIN_DIR, "progressbar_spinner_example.rb")
require path

##################
path = File.join(SW::ProgressBarExamples::PLUGIN_DIR, "example_frame.rb")
require path
path = File.join(SW::ProgressBarExamples::PLUGIN_DIR, "example_lissajous.rb")
require path
#path = File.join(SW::ProgressBarExamples::PLUGIN_DIR, "pong/pong.rb")
#require path





module SW
  module ProgressBarExamples
    def self.load_menus()
          
      # Load Menu Items  
      if !@loaded
        toolbar = UI::Toolbar.new "SW Progress Bar"
        
        cmd = UI::Command.new("Progress Bar Example Simple") {SW::ProgressBarExampleSimple.start()}
        cmd.large_icon = cmd.small_icon =  File.join(SW::ProgressBarExamples::PLUGIN_DIR, "icons/example1.png")
        cmd.tooltip = "Progress Bar Example Simple"
        cmd.status_bar_text = "Step Bar"
        toolbar = toolbar.add_item cmd

        cmd = UI::Command.new("Progress Bar Example Update_flag") {SW::ProgressBarExampleUpdateFlag.start()}
        cmd.large_icon = cmd.small_icon =  File.join(SW::ProgressBarExamples::PLUGIN_DIR, "icons/example2.png")
        cmd.tooltip = "Progress Bar Example Update_flag"
        cmd.status_bar_text = "Automatic"
        toolbar = toolbar.add_item cmd

        cmd = UI::Command.new("Progress Bar Example w/Messagebox") {ProgressBarExampleMessageBox.start()}
        cmd.large_icon = cmd.small_icon =  File.join(SW::ProgressBarExamples::PLUGIN_DIR, "icons/example3.png")
        cmd.tooltip = "SW Progress Bar Example w/Messagebox"
        cmd.status_bar_text = "Load Geometry"
        toolbar = toolbar.add_item cmd

        cmd = UI::Command.new("Progress Bar Tool Example") {ProgressBarExampleTool.start()}
        cmd.large_icon = cmd.small_icon =  File.join(SW::ProgressBarExamples::PLUGIN_DIR, "icons/example4.png")
        cmd.tooltip = "Progress Bar Tool Example"
        cmd.status_bar_text = "Fuzzball"
        toolbar = toolbar.add_item cmd
        
        cmd = UI::Command.new("Error Handling Example") {ProgressBarExampleCrash.start()}
        cmd.large_icon = cmd.small_icon =  File.join(SW::ProgressBarExamples::PLUGIN_DIR, "icons/example5.png")
        cmd.tooltip = "Error Handling Example"
        cmd.status_bar_text = "Raise an Exception in a Fiber"
        toolbar = toolbar.add_item cmd


        cmd = UI::Command.new("User Draw Example") {User_Draw_Example.start()}
        cmd.large_icon = cmd.small_icon =  File.join(SW::ProgressBarExamples::PLUGIN_DIR, "icons/example6.png")
        cmd.tooltip = "User Draw Example"
        cmd.status_bar_text = "Demonstration of user drawn progressbar "
        toolbar = toolbar.add_item cmd


        cmd = UI::Command.new("SubClass Progressbar") {SW::Progressbar_Customdraw_Example.demo()}
        cmd.large_icon = cmd.small_icon =  File.join(SW::ProgressBarExamples::PLUGIN_DIR, "icons/example7.png")
        cmd.tooltip = "SubClass Progressbar"
        cmd.status_bar_text = "Start the Demo"
        toolbar = toolbar.add_item cmd


        cmd = UI::Command.new("SubClass WebDialog") {SW::Progressbar_Webdialog_Example.demo()}
        cmd.large_icon = cmd.small_icon =  File.join(SW::ProgressBarExamples::PLUGIN_DIR, "icons/example8.png")
        cmd.tooltip = "SubClass w/UI::WebDialog"
        cmd.status_bar_text = "Run Demo"
        toolbar = toolbar.add_item cmd
        
        
        cmd = UI::Command.new("Spinner Example") {SW::Progressbar_Spinner_Example.demo()}
        cmd.large_icon = cmd.small_icon =  File.join(SW::ProgressBarExamples::PLUGIN_DIR, "icons/example9.png")
        cmd.tooltip = "Spnner only Progressbar"
        cmd.status_bar_text = "Run Demo"
        toolbar = toolbar.add_item cmd

        cmd = UI::Command.new("Lissajous Example") {SW::FrameExample.start()}
        cmd.large_icon = cmd.small_icon =  File.join(SW::ProgressBarExamples::PLUGIN_DIR, "icons/toys.png")
        cmd.tooltip = "Dialog"
        cmd.status_bar_text = "Open Dialog"
        toolbar = toolbar.add_item cmd


        # cmd = UI::Command.new("Play Pong") {ProgressBarPong.start()}
        # cmd.large_icon = cmd.small_icon =  File.join(SW::ProgressBarExamples::PLUGIN_DIR, "icons/pong.png")
        # cmd.tooltip = "Play Pong"
        # cmd.status_bar_text = "Start a Game"
        # toolbar = toolbar.add_item cmd
        

        
        
        
        toolbar.show
      @loaded = true
      end
    end
    load_menus()
  end
  
end

