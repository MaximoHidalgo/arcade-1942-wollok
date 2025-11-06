import wollok.game.*
import controladorDeNivel.*
import enemigos.*
import estadosJuego.*
import juego.*
import jugador.*
import main.*
import mapa.*
import niveles.*

//---------------------------
//------Menu de Inicio-------
//---------------------------

object menuInicio {
    var property position = game.origin()
    var property image = "menu.png"
    
    method fin() {
        game.sound("sonidoVictoria.wav").play()
        nivelManager.limpieza()
        game.allVisuals().forEach({visual => game.removeVisual(visual)})
        image = "pantalla-victoria.png"
        game.addVisual(self)
        game.schedule(2000,{game.stop()})
    }
    
    method infoControles() {
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

    method derrota() {
        game.sound("sonidoFinalPartida.wav").play()
        nivelManager.limpieza()
        game.allVisuals().forEach({visual => game.removeVisual(visual)})
        image = "pantalla-derrota.png"
        game.addVisual(self)
        game.schedule(2000,{game.stop()})
    }
}


object hud {

    method dibujar() {
        game.addVisual(barra)
        game.addVisual(cantVida)
        game.addVisual(cantPuntos)
        game.addVisual(textoPuntos)
    }
}

object barra {
    var property image = "barra.png"
    var property position = game.at(0,7)
}

object cantVida {
    var property image = "corazones3.png"
    var property position = game.at(0,7)
}

object textoPuntos {
  var property image = "textoPuntos.png"
    var property position = game.at(4,7)
}

object cantPuntos {
    var property digits = []
    var property position = game.at(6,7)
    var property image = "puntajeBase.png"

    method actualizar(puntos) {
        game.removeVisual(self)
        const texto = puntos.toString()

        digits.forEach({ d => game.removeVisual(d) })
        digits.clear()

        texto.length().times({ i =>
            const numero = texto.charAt(i - 1)
            const digito = object {
                var property image = numero + ".png"
                var property position = game.at(6 + (i - 1), 7)
            }
            digits.add(digito)
            game.addVisual(digito)
        })
    }
}