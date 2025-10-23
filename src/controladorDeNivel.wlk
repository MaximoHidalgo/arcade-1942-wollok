import wollok.game.*
import enemigos.*
import estadosJuego.*
import juego.*
import jugador.*
import main.*
import mapa.*
import menu.*
import niveles.*

object nivelManager {
    const property niveles = [nivel1]
    var property actual = menuInicio

    method iniciarSigNivel() {
        self.validarSigNivel()
        actual = niveles.first()
        actual.iniciar()
        niveles.remove(actual)
    }

    method validarSigNivel() {
        if (niveles.isEmpty()) {
            menuInicio.fin()
            juego.estado(cargando)
            self.error("Ganaste?")
        }
    }

    method limpieza() {
        game.clear()
    }

    method terminarNivel() {
        self.limpieza()
        menuInicio.animacionCargando()
    }
}