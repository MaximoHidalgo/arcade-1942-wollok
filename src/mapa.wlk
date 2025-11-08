import wollok.game.*

class ObjetoPasivo{
    method interactuarCon(otro) { } // no hace nada
    method interactuarConJugador(jugador) { }
    method interactuarConEnemigo(enemigo) { }
    method interactuarConProyectil(proy) { }
    method interactuarConProyectilRival(proy) { }
}
object mapa inherits ObjetoPasivo {
    var property position = game.at(0,0)
    var property image = ""

    method visualizarCon(img) {
        image = img 
        game.addVisual(self)
    }
}
