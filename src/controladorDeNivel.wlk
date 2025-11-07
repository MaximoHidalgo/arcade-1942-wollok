import wollok.game.*
import estadosJuego.*
import juego.*
import controladorDePantallas.*
import niveles.*

//---------------------------------
//------controlador de niveles-----
//---------------------------------

object nivelManager {
    const property niveles = [nivel1]
    var property actual = pantallas

    method iniciarSigNivel() {
        self.validarSigNivel()
        actual = niveles.first()
        actual.iniciar()
        niveles.remove(actual)
    }

    method validarSigNivel() {
        if (niveles.isEmpty()) {
            juego.estado(cargando)
            self.error("Ganaste?")
            pantallas.pantallaVictoria()
        }
    }

    method terminarNivel(){
        self.limpieza()
        pantallas.animacionCargando()
    }

    method limpieza(){
        game.clear()
    }

}