module SW
  def self.run_demo()
    state = 0
    model =  Sketchup.active_model
    model.start_operation('Demo', false)
    
    grp = model.active_entities.add_group
    UI.start_timer(0.5) { add_circle(state, grp) }
  end
  
  def self.add_circle(state, grp)
    cp = [0, state, state]
	  cir = grp.entities.add_circle cp, [0, 0, 1], (1)
	  face1 = grp.entities.add_face(cir)
	  face1.reverse! if face1.normal == [0, 0, -1]

    if (state += 1) <= 10
      UI.start_timer(0.5) {add_circle(state, grp)}
    else
      UI.start_timer(0.5) {the_end(grp)}
    end
    # the view will be redrawn after we return from this method
  end
    
  def self.the_end(grp)
     Sketchup.active_model.abort_operation()
     puts 'tada'
  end
  
end # SW

SW.run_demo()
nil