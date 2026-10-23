import wollok.game.*
import jugador.*
import controladorDeNivel.*
import controladorDePantallas.*
import niveles.*
import hud.*
import proyectiles.*
import musica.*

class Enemigo {
  var property position
  var property vidas = 1
  var property danio = 1
  var property image = "enemigo.png"
  var property activo = true

  method interactuarCon(otro) {
    otro.interactuarConEnemigo(self)
  }
  method interactuarConJugador(jugador) {
    jugador.recibirDanio(self.danio())
  }
  method interactuarConProyectil(proyectil) {
    self.recibirDanio(proyectil.danio())
    proyectil.remover()
  }
  
  method interactuarConProyectilRival(proyectil) {} // no hace nada
  method interactuarConEnemigo(enemigo) {}         // nada, por si se tocan

  method spawnEnemigo(){
    game.addVisual(self)
    game.sound("vueloEnemigo.wav").play()
    game.onCollideDo(self, { otro => self.interactuarCon(otro) })
  }

  method movimiento(){
    self.position(self.position().down(1))
  }
  
  method remover(){
    if (activo) {
      activo = false
      if (game.allVisuals().contains(self)) {
        game.removeVisual(self)
      }
      nivelManager.actual().enemigos().remove(self)
    }
  }

  method comprobarMorir() {
    if (vidas <= 0) {
      self.remover()
      jugador.sumarPuntos(100)
      cantPuntos.actualizar(jugador.puntos())
    } else if (self.comprobarLimiteMapa()) {
      self.remover()
    }
  }
  
  method comprobarLimiteMapa() = self.position().y() > game.height() - 1 || self.position().y() < 0

  method recibirDanio(danioProyectil){
    vidas = vidas - danioProyectil
    game.sound("impactoAEnemigo.wav").play()
    self.comprobarMorir()
  } 
} 

class EnemigoPesado inherits Enemigo (vidas = 2, danio = 2, image = "enemigoPesado.png") {

  override method comprobarMorir() {
    if (vidas <= 0) {
      self.remover()
      jugador.sumarPuntos(300)
      cantPuntos.actualizar(jugador.puntos())
    } else if (self.comprobarLimiteMapa()) {
      self.remover()
    }
  }

  method ataque() {
    const proyectilEnemigo = new ProyectilEnemigo(position = self.position(), danio = 1)
    proyectilEnemigo.spawnDisparo(self.position())
    nivelManager.actual().proyectiles().add(proyectilEnemigo)  
  }
}

// NUEVO: Bombardero Pesado con proyectiles explosivos en racimo
class EnemigoPesadoExplosivo inherits EnemigoPesado (vidas = 2, danio = 2, image = "enemigoExplosivo.png") {
  override method ataque() {
    const bomba = new ProyectilExplosivo(position = self.position(), danio = 1)
    bomba.spawnDisparo(self.position())
    nivelManager.actual().proyectiles().add(bomba)
  }
}

// Jefe del Nivel 1
object jefe inherits Enemigo (vidas = 10, danio = 2, position = game.at(0,6), image = "jefeImagen1.png") {
  var property movimientos = ["derecha","derecha", "derecha", "derecha", "derecha","derecha","derecha","derecha",
  "izquierda", "izquierda","izquierda","izquierda","izquierda","izquierda","izquierda","izquierda"]
  var property indice = 0

  override method spawnEnemigo() {
    musicaDeFondo.play("cancionjefe.wav")
    game.addVisual(self)
    game.onCollideDo(self, { otro => self.interactuarCon(otro) })
  }

  override method movimiento() {
    const dir = movimientos.get(indice)
    if (dir == "derecha") { position = position.right(1) } 
    else if (dir == "izquierda") { position = position.left(1) }

    indice += 1
    if (indice >= movimientos.size()) indice = 0
  }
  
  override method comprobarMorir(){
    if (vidas <= 0) {
      self.remover()
      game.removeTickEvent("moverJefe")
      game.removeTickEvent("disparoJefe")
      jugador.sumarPuntos(3000)
      cantPuntos.actualizar(jugador.puntos())
      // Transición hacia el Nivel 2
      game.schedule(1500, { nivelManager.terminarNivel() })
    } else if (self.comprobarLimiteMapa()) {
      self.remover()
    }
  }

  method ataque(){
    const proyectiljefe = new ProyectilEnemigo(position = self.position(), danio = 1)
    proyectiljefe.spawnDisparo(self.position())
    nivelManager.actual().proyectiles().add(proyectiljefe)
  }
}

// NUEVO: Jefe del Nivel 2 (Disparo en Cono + Fase de Furia + Bombas de Racimo)
object jefeNivel2 inherits Enemigo (vidas = 16, danio = 3, position = game.at(0,6), image = "jefeNivel2.png") {
  var property movimientos = ["derecha","derecha", "derecha", "derecha", "derecha","derecha","derecha","derecha",
  "izquierda", "izquierda","izquierda","izquierda","izquierda","izquierda","izquierda","izquierda"]
  var property indice = 0
  var property enFuria = false

  override method spawnEnemigo() {
    musicaDeFondo.play("cancionjefe.wav")
    game.addVisual(self)
    game.onCollideDo(self, { otro => self.interactuarCon(otro) })
  }

  override method movimiento() {
    const dir = movimientos.get(indice)
    if (dir == "derecha") { position = position.right(1) } 
    else if (dir == "izquierda") { position = position.left(1) }

    indice += 1
    if (indice >= movimientos.size()) indice = 0
  }

  override method recibirDanio(danioProyectil){
    vidas = vidas - danioProyectil
    game.sound("impactoAEnemigo.wav").play()
    
    // OPCION A: Fase de Furia al llegar a <= 8 vidas (50%)
    if (vidas <= 8 && !enFuria) {
      enFuria = true
      self.image("jefeNivel2Furia.png")
      game.sound("vueloEnemigo.wav").play()
      self.soltarBomba()
    }
    self.comprobarMorir()
  }

  override method comprobarMorir(){
    if (vidas <= 0) {
      self.remover()
      game.removeTickEvent("moverJefe2")
      game.removeTickEvent("disparoJefe2")
      game.removeTickEvent("bombaJefe2")
      jugador.sumarPuntos(5000)
      cantPuntos.actualizar(jugador.puntos())
      // Fin del juego -> Pantalla de victoria final
      game.schedule(2000, { nivelManager.iniciarSigNivel() })
    } else if (self.comprobarLimiteMapa()) {
      self.remover()
    }
  }

  // Disparo en Cono (3 proyectiles en fase normal, 5 en fase de furia)
  method ataque(){
    const pos = self.position()
    if (!enFuria) {
      // 3 proyectiles en abanico
      const pIzq = new ProyectilDireccional(position = pos, danio = 1, dirX = -0.3, dirY = -0.5, image = "proyectilesJefe1.png")
      const pCentro = new ProyectilDireccional(position = pos, danio = 1, dirX = 0, dirY = -0.5, image = "proyectilesJefe1.png")
      const pDer = new ProyectilDireccional(position = pos, danio = 1, dirX = 0.3, dirY = -0.5, image = "proyectilesJefe1.png")
      const rafaga = [pIzq, pCentro, pDer]
      rafaga.forEach({ p =>
        p.spawnDisparo(p.position())
        nivelManager.actual().proyectiles().add(p)
      })
    } else {
      // 5 proyectiles en abanico amplio (Fase de Furia)
      const pExtIzq = new ProyectilDireccional(position = pos, danio = 1, dirX = -0.5, dirY = -0.4, image = "proyectilFragmento.png")
      const pIzq = new ProyectilDireccional(position = pos, danio = 1, dirX = -0.25, dirY = -0.5, image = "proyectilesJefe1.png")
      const pCentro = new ProyectilDireccional(position = pos, danio = 1, dirX = 0, dirY = -0.5, image = "proyectilFragmento.png")
      const pDer = new ProyectilDireccional(position = pos, danio = 1, dirX = 0.25, dirY = -0.5, image = "proyectilesJefe1.png")
      const pExtDer = new ProyectilDireccional(position = pos, danio = 1, dirX = 0.5, dirY = -0.4, image = "proyectilFragmento.png")
      const rafagaFuria = [pExtIzq, pIzq, pCentro, pDer, pExtDer]
      rafagaFuria.forEach({ p =>
        p.spawnDisparo(p.position())
        nivelManager.actual().proyectiles().add(p)
      })
    }
  }

  // OPCION C: Bombas de racimo periódicas
  method soltarBomba(){
    const bomba = new ProyectilExplosivo(position = self.position(), danio = 1)
    bomba.spawnDisparo(self.position())
    nivelManager.actual().proyectiles().add(bomba)
  }
}
