import wollok.game.*
import estadosJuego.*
import controladorDePantallas.*
import musica.*

//------------------------------
//------gestor del juego--------
//------------------------------

object juego {
    var property estado = estadoControladorDePantallas

	method iniciar(){
        estado = estadoControladorDePantallas
		game.addVisual(pantallas)
        musicaDeFondo.play("musicaIntro.wav")
        keyboard.enter().onPressDo({
            estado.continuar()
        })
	}

    method tablero() {
        game.title("19042:conqueror of heaven") 
        game.width(10)
        game.height(8)
        game.cellSize(45)
    }
}