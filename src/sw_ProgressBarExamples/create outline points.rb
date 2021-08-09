# print the points defining a face in GL_POLYGON format

module SW
  module Whirly
    #ruby 1.8 style rounding function
    def self.round(fl)
           (1000000 * fl).round().to_f / 1000000
    end

    model = Sketchup.active_model
    ents = model.active_entities
    faces = ents.grep(Sketchup::Face)

    a = []
    faces[0].outer_loop.edges.each{|e|
      a << e.start.position.to_a.map{|e| round(e)}
    }
    p a    
  end
end
nil