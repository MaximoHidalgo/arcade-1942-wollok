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
      nivel1.enemigos().remove(self)
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

object jefe inherits Enemigo (vidas = 10, danio = 2, position = game.at(0,6), image = "jefeImagen1.png") {
  var property movimientos = ["derecha","derecha", "derecha", "derecha", "derecha","derecha","derecha","derecha",
  "izquierda", "izquierda","izquierda","izquierda","izquierda","izquierda","izquierda","izquierda"]
  var property indice = 0

  override method spawnEnemigo() {
    game.addVisual(self)
    game.sound("cancionjefe.wav").play()
    game.onCollideDo(self, { p => self.recibirDanio(p.danioProyectil()) })
  }

  override method movimiento() {
    const dir = movimientos.get(indice)

    if (dir == "derecha") {
      position = position.right(1)
    } else if (dir == "izquierda") {
      position = position.left(1)
    }

    indice += 1
    if (indice >= movimientos.size()) indice = 0
  }
  
  override method comprobarMorir(){
    if (vidas <= 0) {
      self.remover()
      game.removeTickEvent("moverJefe")
      game.removeTickEvent("disparoJefe")
      jugador.sumarPuntos(3000)
      cantPuntos.actualizar(jugador.puntos())
      game.schedule(2000,{menuInicio.fin()})
      }
    if (self.comprobarLimiteMapa()) {
      self.remover()
    }
  }

  method ataqueReg(){
    const proyectiljefe = new ProyectilJefe(position = self.position(), danio = 1)
    proyectiljefe.spawnDisparo(self.position())
    game.onTick(400, "ataqueJefe", { proyectiljefe.avanzar() ; proyectiljefe.comprobarLimiteMapa()})
  }
}
