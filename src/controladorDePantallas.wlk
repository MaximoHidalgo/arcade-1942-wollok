import wollok.game.*
import controladorDeNivel.*
import estadosJuego.*
import juego.*
import hud.*
import musica.*

//-----------------------------------
//------controlador de pantallas-----
//-----------------------------------

object pantallas inherits ObjetoPasivo {
    var property position = game.origin()
    var property image = "inicio.png"
     
    method pantallaInfoControles() {
        image = "Controles.png"
        game.schedule(5000, { self.animacionCargando() })
    }

    method pantallaDeInicio() {
        image = "Inicio2.png"
        game.sound("sonidoStart.wav").play()
        game.schedule(700, { self.pantallaInfoControles() })
    }

    method animacionCargando() {
        juego.estado(cargando)
        self.image("cargando.gif")
        if (!game.allVisuals().contains(self)) {
            game.addVisual(self)
        }
        musicaDeFondo.play("audioCargando.wav")
        game.schedule(3500, { self.abandonarCargando() })
    }

    method abandonarCargando() {
        if (game.allVisuals().contains(self)) {
            game.removeVisual(self)
        }
        nivelManager.iniciarSigNivel()
    }

    method pantallaFinalizacion(imagen, musica) {
        nivelManager.limpieza()
        game.sound(musica).play()
        image = imagen
        if (!game.allVisuals().contains(self)) {
            game.addVisual(self)
        }
        game.schedule(5000, { game.stop() })
    }
}
