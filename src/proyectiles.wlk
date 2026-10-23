import wollok.game.*
import controladorDeNivel.*

//----------------------------------
//------Disparos de los aviones:----
//----------------------------------

class Proyectiles {
  var property position
  var property danio
  var property image = "proyectiles.png"

  method interactuarCon(otro){
    otro.interactuarConProyectil(self)
  }

  method interactuarConEnemigo(enemigo){
    enemigo.recibirDanio(self.danio())
    self.remover()
  }

  method interactuarConProyectilRival(proyectil) {
    game.sound("impactoProyectiles.wav").play()
    self.remover()
    proyectil.remover()
  }

  method interactuarConProyectil(proyectil) {} // no hace nada
  method interactuarConJugador(jugador) {}    // no daña al jugador

  method spawnDisparo(posicion){
    game.addVisual(self)
    game.sound("proyectil.mp3").play()
    self.position(posicion)
    game.onCollideDo(self, {otro => self.interactuarCon(otro)}) 
  }
  
  method remover(){	
    game.removeVisual(self)
    self.position(game.at(-100, -100))
    nivelManager.actual().proyectiles().remove(self)
  }
  
  method comprobarLimiteMapa(){
    if (self.position().y() > game.height() - 1 || self.position().y() < 0 || self.position().x() < 0 || self.position().x() > game.width() - 1) {
      self.remover()
    }
  }

  method avanzar(){
    self.position(self.position().up(0.5))
  }
}

class ProyectilEnemigo inherits Proyectiles (image = "proyectilesJefe1.png") {

  override method avanzar(){
    self.position(self.position().down(0.5))
  }

  override method spawnDisparo(posicion){
    game.addVisual(self)
    game.sound("proyectil.mp3").play()
    self.position(posicion)
    game.onCollideDo(self, { otro => self.interactuarCon(otro)})
  }

  override method interactuarCon(otro) {
    otro.interactuarConProyectilRival(self)
  }
  
  override method interactuarConJugador(jugador) {
    jugador.recibirDanio(self.danio())
    self.remover()
  }

  override method interactuarConProyectil(proyectil) {
    game.sound("impactoProyectiles.wav").play()
    self.remover()
    proyectil.remover()
  }

  override method interactuarConEnemigo(enemigo) {}       // no daña a otros enemigos
  override method interactuarConProyectilRival(proyectil) {} // no daña a otros proyectiles rivales
}

// Proyectil direccional con vector de desplazamiento para cono y esquirlas
class ProyectilDireccional inherits ProyectilEnemigo {
  var property dirX = 0
  var property dirY = -0.5

  override method avanzar() {
    self.position(self.position().right(dirX).up(dirY))
  }
}

// Proyectil Explosivo: Desciende, parpadea y detona liberando 4 esquirlas
class ProyectilExplosivo inherits ProyectilEnemigo (image = "proyectilBomba.png") {
  var property ticksParaDetonar = 8
  var property blinkState = false

  override method avanzar() {
    self.position(self.position().down(0.2))
    self.verificarDetonacion()
  }

  method verificarDetonacion() {
    ticksParaDetonar -= 1
    blinkState = !blinkState
    if (blinkState) {
      self.image("proyectilBombaBlink.png")
    } else {
      self.image("proyectilBomba.png")
    }

    if (ticksParaDetonar <= 0) {
      self.detonar()
    }
  }

  method detonar() {
    game.sound("impactoProyectiles.wav").play()
    const pos = self.position()
    self.remover()

    const pArriba = new ProyectilDireccional(position = pos, danio = 1, dirX = 0, dirY = 0.5, image = "proyectilFragmento.png")
    const pAbajo = new ProyectilDireccional(position = pos, danio = 1, dirX = 0, dirY = -0.5, image = "proyectilFragmento.png")
    const pIzq = new ProyectilDireccional(position = pos, danio = 1, dirX = -0.5, dirY = 0, image = "proyectilFragmento.png")
    const pDer = new ProyectilDireccional(position = pos, danio = 1, dirX = 0.5, dirY = 0, image = "proyectilFragmento.png")

    const fragmentos = [pArriba, pAbajo, pIzq, pDer]
    fragmentos.forEach({ f =>
      f.spawnDisparo(f.position())
      nivelManager.actual().proyectiles().add(f)
    })
  }
}
