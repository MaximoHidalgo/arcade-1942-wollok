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
  var property removido = false

  method spawnEnemigo(){
    //Se añade la visual:
    game.addVisual(self)
    game.sound("vueloEnemigo.wav").play()
    game.onCollideDo(self, {p => 
    self.recibirDanio(p.danioProyectil())})
  }

  method movimiento(){
    self.position(self.position().down(1))
  }
  
  method remover(){
    if(!removido){
      removido = true
      game.removeVisual(self)
    }
  }

  //Metodo morir:
  method comprobarMorir() {
    if (vidas <= 0) {
      self.remover()}
  }

  method comprobarLimiteMapa(){
  if(!removido && self.position().y() < 1){
    self.remover()
  }}

  method hacerDanio(jugador){
    jugador.recibirDanio(danio)
  }

  method recibirDanio(danioProyectil){
    vidas = vidas - danioProyectil
    game.sound("impactoAEnemigo.wav").play()
    self.comprobarMorir()
  } 
}
