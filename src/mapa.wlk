import wollok.game.*

object mapa {
    var property position = game.at(0,0)
    var property image = ""

    method visualizarCon(img) {
        image = img 
        game.addVisual(self)
    }
}