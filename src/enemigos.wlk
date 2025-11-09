import wollok.game.*
import jugador.*
import controladorDePantallas.*
import niveles.*
import hud.*
import proyectiles.*
import musica.*

class Enemigo {
  //Atributos:
  var property position
  var property vidas = 1
  var property danio = 1
  var property image = "enemigo.png"
  

  method interactuarCon(otro) {
    otro.interactuarConEnemigo(self)
  }
  method interactuarConJugador(jugador) {
    jugador.recibirDanio(self.danio())
  }
  method interactuarConProyectil(proyectil) {
    self.recibirDanio(proyectil.danio())
    proyectil.remover()
  }
  
  method interactuarConProyectilRival(proyectil) { } // no hace nada
  method interactuarConEnemigo(enemigo) { } // nada, por si se tocan

  method spawnEnemigo(){
    game.addVisual(self)
    game.sound("vueloEnemigo.wav").play()
    game.onCollideDo(self, { otro => self.interactuarCon(otro) })
  }

  method movimiento(){
    self.position(self.position().down(1))
  }
  
  method remover(){
      game.removeVisual(self)
      nivel1.enemigos().remove(self)
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

  method recibirDanio(danioProyectil){
    vidas = vidas - danioProyectil
    game.sound("impactoAEnemigo.wav").play()
    self.comprobarMorir()
  } 
} 

class EnemigoPesado inherits Enemigo (vidas = 2, danio = 2, image = "enemigoPesado.png") {

  override method comprobarMorir() {
    if (vidas <= 0) {
      self.remover()
      jugador.sumarPuntos(300)
      cantPuntos.actualizar(jugador.puntos())
      }
    if (self.comprobarLimiteMapa()) {
      self.remover()
    }
  }

  method ataque() {
    const proyectilEnemigo = new ProyectilEnemigo(position = self.position(), danio = 1)
    proyectilEnemigo.spawnDisparo(self.position())
    nivel1.proyectiles().add(proyectilEnemigo)  
  }
}

object jefe inherits Enemigo (vidas = 10, danio = 2, position = game.at(0,6), image = "jefeImagen1.png") {
  
  var property movimientos = ["derecha","derecha", "derecha", "derecha", "derecha","derecha","derecha","derecha",
  "izquierda", "izquierda","izquierda","izquierda","izquierda","izquierda","izquierda","izquierda"]
  var property indice = 0

  override method spawnEnemigo() {
    musicaDeFondo.play("cancionjefe.wav")
    game.addVisual(self)
    game.onCollideDo(self, { otro => self.interactuarCon(otro) })
  }

  override method movimiento() {
    const dir = movimientos.get(indice)

    if (dir == "derecha") {position = position.right(1)} 
    else if (dir == "izquierda") {position = position.left(1)}

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
      game.schedule(2000,{pantallas.pantallaFinalizacion("pantalla-victoria.png","sonidoVictoria.wav")})
      }
    if (self.comprobarLimiteMapa()) {
      self.remover()
    }
  }

  method ataque(){
    const proyectiljefe = new ProyectilEnemigo(position = self.position(), danio = 1)
    proyectiljefe.spawnDisparo(self.position())
    nivel1.proyectiles().add(proyectiljefe)
  }
}
