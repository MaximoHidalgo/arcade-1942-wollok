import wollok.game.*
import controladorDeNivel.*
import enemigos.*
import juego.*
import jugador.*
import main.*
import mapa.*
import menu.*
import niveles.*

//---------------------------
//-------Estados Juego-------
//---------------------------

class EstadoJuego {

    method mejorarEnergia() {}

    method continuar() {}
}

object estadoMenu inherits EstadoJuego() {
    
    override method continuar() {
        juego.estado(cargando)
        menuInicio.pantallaDeCarga()
        //juego.frenarSonidoMenu()
    }
}

/*object infoControles inherits EstadoJuego() {
    
    override method continuar() {
        juego.estado(cargando)
        menuInicio.pantallaDeCarga()
        juego.frenarSonidoMenu()
    }
}*/

object cargando inherits EstadoJuego() {}



