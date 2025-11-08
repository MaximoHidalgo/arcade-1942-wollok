import wollok.game.*
import hud.*

object mapa inherits ObjetoPasivo {
    var property position = game.at(0,0)
    var property image = ""

    method visualizarCon(img){
        image = img 
        game.addVisual(self)
    }
}
