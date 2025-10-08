object jugador {
  var property position = game.at(5,1)
  var property vidas = 3
  var property puntos = 0
  var img = "jugadorBase.png"

  method cambiarImagen(nuevaImagen) {
        img = nuevaImagen
    }
    
  method image() = img

  method recibirDanio(){
    vidas = vidas - 1

    if (vidas <= 0){self.morir()}

    return vidas
  }

  method morir() {if (self.vidas() <= 0){game.stop()}}

  
  
  //Cambiar por un gif del avion moviendose,
  //para poder dar la sensacion de que el avion se mueve
  


}
