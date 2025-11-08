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
  var property esProyectil = true

  //Metodo para desplazar disparo:
  method spawnDisparo(posicion){
    game.addVisual(self)
    game.sound("proyectil.mp3").play()
    self.position(posicion)
   game.whenCollideDo(self, { otro =>
      if (otro.esEnemigo()) {otro.recibirDanio(self.danio())self.remover()}
      if (otro.esProyectil()) {self.remover()}}) 
  }
  
  //Metodo que remueve los disparos:
  method remover(){	
		game.removeVisual(self)
    self.position(game.at(-100, -100))
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

	override method remover(){	
		game.removeVisual(self)
    self.position(game.at(-100, -100))
    nivel1.proyectilesEnemigos().remove(self)
  }

  override method spawnDisparo(posicion){
    game.addVisual(self)
    game.sound("proyectil.mp3").play()
    self.position(posicion)
    game.whenCollideDo(self, { jugador =>if (jugador.esJugador()) {jugador.recibirDanio(self.danio()) self.remover()}})
  }
}