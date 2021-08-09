module SW
	module FrameExample
		def self.start()
    
      SW::Frames::FramesManager.activate_tool
     
      frame = SW::Frames::FramesManager.create_top_level_frame(SW::Frames::FRAME_OUTLINED, :test_buttons, true) {|frame|
        frame.label = 'Choose a toy'
        frame.height = 120
        frame.width = 160
        frame.content_offset = [10,5]
       } 

      # add buttons
      entity = SW::Frames::BUTTON_PLAIN.new {SW::ProgressBarPong.start}
      entity.label = 'Play Pong'
      frame.add_entity(entity)

      entity = SW::Frames::BUTTON_PLAIN.new {SW::ProgressBarLissajous.start}
      entity.label = 'Jelly Beans'
      frame.add_entity(entity)

      entity = SW::Frames::BUTTON_TOGGLE.new {p 'toggle'}
      entity.label = 'Toggle'
      frame.add_entity(entity)

		end
	end
end