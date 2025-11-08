import wollok.game.*
import niveles.*

//----------------------------------
//------Disparos de los aviones:----
//----------------------------------

class Proyectiles {
  //Atributos:
  var property position
  var property danio
  var property image = "proyectiles.png"
  

  method interactuarCon(otro) {
  otro.interactuarConProyectil(self)
}
method interactuarConProyectilRival(proyectil) { } // no hace nada
method interactuarConProyectil(proyectil) { } // no hace nada
method interactuarConEnemigo(enemigo) {
  enemigo.recibirDanio(self.danio())
  self.remover()
}

method interactuarConJugador(jugador) { } // no daña al jugador

  //Metodo para desplazar disparo:
  method spawnDisparo(posicion){
    game.addVisual(self)
    game.sound("proyectil.mp3").play()
    self.position(posicion)
   game.whenCollideDo(self, {otro => self.interactuarCon(otro)}) 
  }
  
  //Metodo que remueve los disparos:
  method remover(){	
		game.removeVisual(self)
    self.position(game.at(-100, -100))
    nivel1.proyectiles().remove(self)
  }
  
  method comprobarLimiteMapa(){
    if(self.position().y() > game.height() -1){self.remover()}
  }

	//Metodo de avance del disparo:
	method avanzar(){
    self.position(self.position().up(1))
  }	

  method hacerDanio(enemigo){
    enemigo.recibirDanio(danio)
  }
}

class ProyectilEnemigo inherits Proyectiles (image = "proyectilesJefe1.png") {

  

  override method avanzar(){
    self.position(self.position().down(1))
  }

  override method comprobarLimiteMapa(){
    if(self.position().y() < 0){ self.remover()}
  }

	/*override method remover(){	
		game.removeVisual(self)
    self.position(game.at(-100, -100))
    nivel1.proyectiles().remove(self)
  } */

  override method spawnDisparo(posicion){
    game.addVisual(self)
    game.sound("proyectil.mp3").play()
    self.position(posicion)
    game.whenCollideDo(self, { otro => self.interactuarCon(otro)})
  }

override method interactuarCon(otro) {
  otro.interactuarConProyectilRival(self)
}

override method interactuarConJugador(jugador) {
  jugador.recibirDanio(self.danio())
  self.remover()
}

override method interactuarConEnemigo(enemigo) { } // no daña a otros enemigos

}
