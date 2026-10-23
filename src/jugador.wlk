import controladorDeNivel.*
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
  var property inmune = false
  
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
    nivelManager.actual().proyectiles().add(proyectil)
  }
  
  method recibirDanio(danio) {
    if (self.inmune()) return vidas // Si esta inmune, ignora el golpe
    vidas = vidas - danio

    if (vidas == 2) {
      cantVida.image("corazones2.png")
      game.sound("impactoJugador.wav").play()
    } 
    if (vidas == 1) {
      cantVida.image("corazones1.png")
      game.sound("impactoJugador.wav").play()
    }
    if (vidas <= 0) {
      cantVida.image("corazones0.png")
      self.morir()
      return 0
    }
    
    // Activar inmunidad temporal (3,5 segundos) solo si sigue con vida
    self.inmune(true)
    self.parpadear(6)
    game.schedule(3500, {self.inmune(false)})
    
    return vidas
  }

  method morir() {
    game.sound("sonidoMuerte.wav").play()
    self.image("jugadorPierde.png")
    game.schedule(500,{pantallas.pantallaFinalizacion("pantalla-derrota.png","sonidoDerrota.wav")})
  }

  method parpadear(veces) {
    var visible = true
    game.onTick(200, "blinkJugador", {
      visible = !visible
      if (visible) self.image("jugadorHerido.png")
        else self.image("jugadorTransparente.png")
    })

    game.schedule(3500, {
      game.removeTickEvent("blinkJugador")
      self.image("jugadorBase.png")
    })
  }
  
  method sumarPuntos(cantidad) {
    puntos += cantidad
  }
}