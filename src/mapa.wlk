import wollok.game.*
import main.*
import pantallaInicio.*
import jugador.*
import enemigos.*
import juego.*

object mapa {
    var property position = game.at(0,0)
    var property image = ""

    method visualizarCon(img) {
        image = img 
        game.addVisual(self)
    }
}