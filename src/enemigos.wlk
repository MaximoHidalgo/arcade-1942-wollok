// src/enemigos.wlk
import wollok.game.*
import controladorDeNivel.*
import estadosJuego.*
import juego.*
import jugador.*
import main.*
import mapa.*
import menu.*
import niveles.*

class Enemigo {
  //Atributos:
  var property position = game.at(4,10)
  var property vidas = 1
  var property danio = 1
  var property image = "enemigo.png"


  method terminarPersecucion(){}
  
  method terminarSpawnCycle(){}

  method spawnEnemigo(){
    //Se añade la visual:
    game.addVisual(self)
    game.onCollideDo(self, {p => 
    self.recibirDanioDeJugador(p.danioProyectil())})
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