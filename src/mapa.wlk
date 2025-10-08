/*object fondo {
    var property position = game.at(0, 0)
    var property velocidadDesplazamiento = 1

    method desplazarArriba() {
        self.position = game.at(self.position.x, self.position.y - velocidadDesplazamiento)
    }
}
*/

object desplazamientoMapa {
    var property velocidadDesplazamiento = 1
    var property position = game.at(0,0)
    var property image = "tile001.png"


     method desplazarArriba() {
        velocidadDesplazamiento += 1
        return game.at(0, velocidadDesplazamiento)
    }

}