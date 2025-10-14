// src/enemigos.wlk
import wollok.game.*
import jugador.*

class Enemigo {
  //Atributos:
  var property vidas = 1
  var property position = game.at(4,10)
  var property danio = 1
  var property image = "sprite.png"

/*var property orientacion = 0
  var property arriba = 0
  var property abajo = 1
  var property izquierda = 2
  var property derecha = 3
  */
  //const aves = #{pepita, pepito, lila, agatha}
  
  method spawnEnemigo(){
    //Se añade la visual:
    game.addVisual(self)
    }

  method movimiento(){
    self.position(self.position().down(1))
    }
    
    method hacerDanio(jugador){
        jugador.recibirDanio(danio)
    }

    
  method remover(){	
		game.removeVisual(self)
		//game.removeTickEvent("ataque")
    }

  //Metodo morir:
  method comprobarMorir() {
    if (vidas <= 0) {
      self.remover()}
    }

  method comprobarLimiteMapa(){
    if(self.position().y() < 1){  
    self.remover()}
    }

    method recibirDanioDeJugador(danioProyectil){
    vidas = vidas - danioProyectil
    self.comprobarMorir()
    }

    
}