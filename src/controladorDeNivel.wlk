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
        if (niveles.isEmpty()) {
            juego.estado(cargando)
            pantallas.pantallaFinalizacion("pantalla-victoria.png","sonidoVictoria.wav")
        }
        actual = niveles.first()
        actual.iniciar()
        niveles.remove(actual)
    }

    method terminarNivel(){
        self.limpieza()
        pantallas.animacionCargando()
    }

    method limpieza(){
        game.clear()
        actual.musicaNivel1().stop()
    }

}