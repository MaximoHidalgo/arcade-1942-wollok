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
        game.schedule(6000,{self.animacionCargando()})
    }

    method pantallaDeInicio() {
        image = "Inicio2.png"
        game.sound("sonidoStart.wav").play()
        game.schedule(700,{self.pantallaInfoControles()})
    }

    method animacionCargando() {
        juego.estado(cargando)
        self.image("cargando.gif")
        musicaDeFondo.play("audioCargando.wav")
        game.schedule(6800, {self.limpiar()})
    }

    method limpiar() {
        game.allVisuals().forEach({visual => game.removeVisual(visual)})
        self.abandonarCargando()
    }

    method abandonarCargando() {
        nivelManager.iniciarSigNivel()
        game.removeVisual(self)
    }

    method pantallaFinalizacion(imagen, musica) {
        nivelManager.limpieza()
        game.sound(musica).play()
        game.allVisuals().forEach({visual => game.removeVisual(visual)})
        image = imagen
        game.addVisual(self)
        game.schedule(2000,{game.stop()})
    }
}
