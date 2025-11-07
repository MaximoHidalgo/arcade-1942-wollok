import wollok.game.*
import controladorDeNivel.*
import estadosJuego.*
import juego.*

//-----------------------------------
//------controlador de pantallas-----
//-----------------------------------

object pantallas {
    var property position = game.origin()
    var property image = "inicio.png"
     
    method pantallaInfoControles() {
        image = "Controles.png"
    }

    method pantallaDeCarga() {
        image = "carga3.png"
        game.sound("sonidoStart.wav").play()
        game.schedule(700,{self.abandonarCargando()})
    }

    method abandonarCargando() {
        nivelManager.iniciarSigNivel()
        game.removeVisual(self)
    }

    method animacionCargando() {
        juego.estado(cargando)
        game.addVisual(self)
        image = "carga1.png"
        game.schedule(400, {image="carga2.png"})
        game.schedule(800, {self.limpiar()})
    }

    method limpiar() {
        image = "carga3.png"
        game.allVisuals().forEach({visual => game.removeVisual(visual)})
        game.addVisual(self)
        self.abandonarCargando()
    }

    method pantallaDerrota() {
        game.sound("sonidopantallaVictoriaalPartida.wav").play()
        nivelManager.limpieza()
        game.allVisuals().forEach({visual => game.removeVisual(visual)})
        image = "pantalla-derrota.png"
        game.addVisual(self)
        game.schedule(2000,{game.stop()})
    }

    method pantallaVictoria() {
        game.sound("sonidoVictoria.wav").play()
        nivelManager.limpieza()
        game.allVisuals().forEach({visual => game.removeVisual(visual)})
        image = "pantalla-victoria.png"
        game.addVisual(self)
        game.schedule(2000,{game.stop()})
    }
}
