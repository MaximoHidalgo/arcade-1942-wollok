import wollok.game.*
import controladorDePantallas.*
import niveles.*
import hud.*
import proyectiles.*

object jugador {
  var property position = game.at(5,1)
  var property vidas = 3
  var property puntos = 0
  var property esJugador = true
  var property image = "jugadorBase.png"
 
  method ataque(){
    const proyectil = new Proyectiles(position = self.position(), danio = 1)
    proyectil.spawnDisparo(self.position())
    game.onTick(400, "ataque", { proyectil.avanzar() ; proyectil.comprobarLimiteMapa()})
  }
  
  method recibirDanio(danio){
    vidas = vidas - danio
    if (vidas == 2){
      cantVida.image("corazones2.png") 
    } else if (vidas == 1){
     cantVida.image("corazones1.png") 
    } else if (vidas <= 0){
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

  method sumarPuntos(cantidad){
    puntos = puntos + cantidad
  }
}
