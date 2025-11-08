import wollok.game.*
import controladorDePantallas.*
import niveles.*
import hud.*
import proyectiles.*

object jugador {
  var property position = game.at(5, 1)
  var property vidas = 3
  var property puntos = 0
  var property image = "jugadorBase.png"
  
  method interactuarCon(otro) {
    otro.interactuarConJugador(self)
  }
  
  method interactuarConEnemigo(enemigo) {
    self.recibirDanio(enemigo.danio())
  }
  
  method interactuarConProyectilRival(proyectil) {
    self.recibirDanio(proyectil.danio())
    proyectil.remover()
  }
  
  method interactuarConProyectil(proyectil) {} // no hace nada
  
  method ataque() {
    const proyectil = new Proyectiles(position = self.position(), danio = 1)
    proyectil.spawnDisparo(self.position())
    nivel1.proyectiles().add(proyectil)
  }
  
  method recibirDanio(danio) {
    vidas -= danio
    if (vidas == 2) {
      cantVida.image("corazones2.png")
    } 
    if (vidas == 1) {
      cantVida.image("corazones1.png")
    }
    if (vidas <= 0) {
      cantVida.image("corazones0.png")
      self.morir()
    }
    return vidas
  }
  
  method morir() {
    game.sound("sonidoMuerte.wav").play()
    self.image("jugadorPierde.png")
    game.schedule(700,{pantallas.pantallaFinalizacion("pantalla-derrota.png","sonidoDerrota.wav")})
  }
  
  method sumarPuntos(cantidad) {
    puntos += cantidad
  }
}