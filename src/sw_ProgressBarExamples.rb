#-------------------------------------------------------------------------------
#
#
#-------------------------------------------------------------------------------

require "extensions.rb"

module SW
  module ProgressBarExamples
    VERSION =  '1.0.0'.freeze

    path = __FILE__
    path.force_encoding("UTF-8") if path.respond_to?(:force_encoding)

    PLUGIN_ID = File.basename(path, ".rb")
    PLUGIN_DIR = File.join(File.dirname(path), PLUGIN_ID)

    EXTENSION = SketchupExtension.new(
      "SW Progress Bar Examples",
      File.join(PLUGIN_DIR, "load_examples")
    )
    EXTENSION.creator     = "S. Williams"
    EXTENSION.description = "SW ProgressBar Examples"
    EXTENSION.version     = VERSION
    EXTENSION.copyright   = "#{EXTENSION.creator} Copyright (c) 2019"
    Sketchup.register_extension(EXTENSION, true)
    
    def self.version
      VERSION
    end

  end
end

