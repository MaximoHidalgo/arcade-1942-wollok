import wollok.game.*
import controladorDeNivel.*
import enemigos.*
import estadosJuego.*
import juego.*
import main.*
import mapa.*
import menu.*
import niveles.*

object jugador {
  var property position = game.at(5,1)
  var property vidas = 3
  var property puntos = 0
  var property disparos_activo = false
  var property esJugador = true
  var img = "jugadorBase.png"

  method cambiarImagen(nuevaImagen) {
        img = nuevaImagen
    }
    
  method image() = img
  
  method ataqueReg(){
    const proyectil = new Proyectiles(position = self.position(), danio = 1)
    proyectil.spawnDisparo(self.position())
    game.onTick(400, "ataque", { proyectil.avanzar() ; proyectil.comprobarLimiteMapa()})
  }
  
  
  method recibirDanio(danio){
    vidas = vidas - danio
    if (vidas == 2){
      cantVida.image("corazones2.png") 
    } else if (vidas == 1){
     cantVida.image("corazones1.png") 
    } else if (vidas <= 0){
      cantVida.image("corazones0.png") 
      self.morir()
      }
    return vidas
  }

  method morir() {
      game.sound("sonidoMuerte.wav").play()
      img = "jugadorPierde.png"
      game.schedule(700,{menuInicio.derrota()})
  }

  method sumarPuntos(cantidad){
    puntos = puntos + cantidad
  } 


  //Cambiar por un gif del avion moviendose,
  //para poder dar la sensacion de que el avion se mueve
}

//Disparos del avion:
class Proyectiles {
  //Atributos:
  var property position
  var property danio
  var property image = "proyectiles.png"
  var property esProyectil = true

  //Metodo para desplazar disparo:
  method spawnDisparo(posicion){
    //Se añade la visual:
    game.addVisual(self)
    game.sound("proyectil.mp3").play()
    //El proyectil empieza por la posición del jugador:
    self.position(posicion)
   game.whenCollideDo(self, { otro =>
      if (otro.esEnemigo()) {
        otro.recibirDanio(self.danio())
        self.remover()
      }
      if (otro.esProyectil()) {
        self.remover()
      }
    })
   
  }
  
  //Metodo que remueve los disparos:
  method remover(){	
		game.removeVisual(self)
    self.position(game.at(-100, -100))
  }
  
  method comprobarLimiteMapa(){
    if(self.position().y() > game.height() -1){  //Limite arriba
    self.remover()}
  }

	//Metodo de avance del disparo:
	method avanzar(){
    self.position(self.position().up(1))
  }	

  method hacerDanio(enemigo){
    enemigo.recibirDanio(danio)
  }
}


class ProyectilRival inherits Proyectiles {
  override method avanzar(){
    self.position(self.position().down(1))
  }
	override method remover(){	
		game.removeVisual(self)
    self.position(game.at(-100, -100))
    nivel1.proyectilesRivales().remove(self)

  }
  override method spawnDisparo(posicion){
    //Se añade la visual:
    game.addVisual(self)
    //El proyectil empieza por la posición del jugador:
    self.position(posicion)
   game.whenCollideDo(self, { otro =>
      if (otro.esJugador()) {
        otro.recibirDanio(self.danio())
        self.remover()
      }
      
    })
   
  }
  
}

class ProyectilJefe inherits Proyectiles (image = "proyectilesJefe1.png") {

  override method comprobarLimiteMapa(){
    if(self.position().y() < 0){  //Limite abajo
    self.remover()}
  }

  override method avanzar(){
    self.position(self.position().down(1))
  }

  override method spawnDisparo(posicion){
    game.addVisual(self)
    game.sound("proyectil.mp3").play()
    self.position(posicion)
    game.whenCollideDo(self, { jugador =>if (jugador.esJugador()) {jugador.recibirDanio(self.danio()) self.remover() }})
  }
}
