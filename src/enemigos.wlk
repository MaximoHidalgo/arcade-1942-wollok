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
  var property esEnemigo = true

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
      self.remover()
      jugador.sumarPuntos(100)
      cantPuntos.actualizar(jugador.puntos())
      }
    if (self.comprobarLimiteMapa()) {
      self.remover()
    }
  }
  
method comprobarLimiteMapa() = self.position().y() > game.height() - 1 || self.position().y() < 0

  method hacerDanio(jugador){
    jugador.recibirDanio(danio)
  }

  method recibirDanio(danioProyectil){
    vidas = vidas - danioProyectil
    game.sound("impactoAEnemigo.wav").play()
    self.comprobarMorir()
  } 
} 
//Enemigo Pesado Cambiarle el Sprite
class EnemigoPesado inherits Enemigo (vidas = 2, danio = 2, image = "jugadorBase.png") {

method ataqueReg() {
    const proyectilRival = new ProyectilRival(position = self.position(), danio = 1)
    proyectilRival.spawnDisparo(self.position())
    nivel1.proyectilesRivales().add(proyectilRival)  
  }
 }


