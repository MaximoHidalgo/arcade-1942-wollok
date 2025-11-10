import wollok.game.*
import juego.*
import controladorDePantallas.*

//---------------------------
//-------Estados Juego-------
//---------------------------

class EstadoJuego {
    method continuar() {}
}

//Con esto se evita que el jugador pueda tocar enter mientras esta 
//jugando los niveles y se active de nuevo la pantalla de Inicio y de Carga

object estadoControladorDePantallas inherits EstadoJuego() {
    override method continuar() {
        juego.estado(cargando)
        pantallas.pantallaDeInicio()
    }
}

object cargando inherits EstadoJuego() {}



