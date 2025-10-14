import wollok.game.*
import mapa.*


object jugador {
  var property position = game.at(5,1)
  var property vidas = 3
  var property puntos = 0
  var property disparos_activo = false
  var img = "jugadorBase.png"

  method cambiarImagen(nuevaImagen) {
        img = nuevaImagen
    }
    
  method image() = img


  method ataqueReg(){
    const proyectil = new Proyectiles(position = self.position(), danioProyectil = 1, image = "proyectiles.png")
    proyectil.spawnDisparo(self.position())
    game.onTick(500, "ataque", { proyectil.avanzar() ; proyectil.comprobarLimiteMapa()})
  }
  
  method recibirDanio(danio){
    vidas = vidas - danio

    if (vidas <= 0){self.morir()}
    return vidas
  }
  
  method morir() {if (self.vidas() <= 0){game.stop()}}

  //Cambiar por un gif del avion moviendose,
  //para poder dar la sensacion de que el avion se mueve
}

//Disparos del avion: // inherits Consumible

class Proyectiles {
  //Atributos:
  var property position = game.origin()
  var property danioProyectil = 1
  var property image = "proyectiles.png"

  method danioProyectil() = danioProyectil
  
  //Metodo para desplazar disparo:
  method spawnDisparo(posicion){
    //Se añade la visual:
    game.addVisual(self)
    //El proyectil empieza por la posición del jugador:
    self.position(posicion)
    }
  
  //Metodo que remueve los disparos:
  method remover(){	
		game.removeVisual(self)
		//game.removeTickEvent("ataque")
    }
  
  method comprobarLimiteMapa(){
    if(self.position().y() > game.height() -1){  //Limite arriba
    self.remover()}
    }

	//Metodo de avance del disparo:
	method avanzar(){
    self.position(self.position().up(1))
    }	
  
  method poderAtaque(enemigo){
        enemigo.recibirDanioDeJugador(danioProyectil)
    }
  }