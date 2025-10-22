import wollok.game.*
import controladorDeNivel.*
import enemigos.*
import estadosJuego.*
import jugador.*
import main.*
import mapa.*
import menu.*
import niveles.*

//------------------------------
//------gestor del juego--------
//------------------------------

object juego {
	var property estado = estadoMenu
    //var property estadoJugador = vivo
    //var property musicaActual = musicaMenu

    method iniciarSonidoMenu() {
        //musicaActual.play()
    }

    method frenarSonidoMenu() {
        //musicaActual.stop()
    }

	method iniciar(){
        //self.iniciarSonidoMenu()
        estado = estadoMenu
		game.addVisual(menuInicio)
        keyboard.enter().onPressDo({estado.continuar()})
	}

    /*
	method iniciarCon(nuevoNivel){
		estado = nuevoNivel
		estado.iniciar()
	}*/

    method tablero() {
        game.title("19042:conqueror of heaven") 
        game.width(10)
        game.height(8)
        game.cellSize(45)
    }

}

