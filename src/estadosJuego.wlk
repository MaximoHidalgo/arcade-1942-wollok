import wollok.game.*
import juego.*
import controladorDePantallas.*

//---------------------------
//-------Estados Juego-------
//---------------------------

class EstadoJuego {
    method continuar() {}
}

object estadoControladorDePantallas inherits EstadoJuego() {
    override method continuar() {
        juego.estado(cargando)
        pantallas.pantallaDeCarga()
    }
}

object cargando inherits EstadoJuego() {}



