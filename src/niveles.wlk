import wollok.game.*
import enemigos.*
import jugador.*
import mapa.*
import hud.*
import musica.*

//---------------------
//-------Niveles-------
//---------------------

class Nivel{
    var property enemigos = []
    var property proyectiles = []
    var property imagenFondo
    var property musicaFondo

    method iniciar() {
        self.limpiarColecciones()
        mapa.visualizarCon(imagenFondo)
        musicaDeFondo.play(musicaFondo)
        game.addVisualCharacter(jugador)
        self.configurarControles()
        hud.dibujar()
        self.iniciarSpawners()
        self.configurarColisiones()
    }

    method limpiarColecciones() {
        enemigos.clear()
        proyectiles.clear()
    }

    method configurarControles() {
        keyboard.left().onPressDo({ jugador.image("jugadorIzqu.png") })
        keyboard.right().onPressDo({ jugador.image("jugadorDer.png") })
        keyboard.up().onPressDo({ jugador.image("jugadorBase.png") })
        keyboard.down().onPressDo({ jugador.image("jugadorBase.png") })
        keyboard.x().onPressDo({ jugador.ataque() })
    }

    method configurarColisiones() {
        game.onCollideDo(jugador, { otro => jugador.interactuarCon(otro) })
    }

    method iniciarSpawners() {}
}

// =============================================================================
// NIVEL 1: Escuadrón Inicial sobre el Océano
// =============================================================================
object nivel1 inherits Nivel(imagenFondo = "videoMapa1.gif", musicaFondo = "musicaNivel1.mp3") {

    override method iniciarSpawners() {
        game.onTick(2000, "spawEnemigos", {
            const enemigo = new Enemigo(position = game.at(0.randomUpTo(game.width()),7))
            enemigo.spawnEnemigo()
            enemigos.add(enemigo)
        })
        
        game.onTick(1000, "moverEnemigo", {
            enemigos.copy().filter({e => e.image() == "enemigo.png"}).forEach({enemigo => enemigo.movimiento() ; enemigo.comprobarLimiteMapa()})
        })

        game.onTick(4000, "spawnEnemigosRapidos", {
            const enemigoRapido = new Enemigo(position = game.at(0.randomUpTo(game.width()),7), image = "enemigoRapido.png")
            enemigoRapido.spawnEnemigo()
            enemigos.add(enemigoRapido)
        })

        game.onTick(500, "moverEnemigoRapido", {
            (enemigos.copy().filter({e => e.image() == "enemigoRapido.png"})).forEach({enemigo => enemigo.movimiento() ; enemigo.comprobarLimiteMapa()})
        })

        game.onTick(8000, "spawnEnemigoPesado", {
            const enemigoPesado= new EnemigoPesado(position = game.at(0.randomUpTo(game.width()),6))
            enemigoPesado.spawnEnemigo()
            enemigos.add(enemigoPesado)
        })

        game.onTick(3000, "moverEnemigoPesado", {
            (enemigos.copy().filter({e => e.image() == "enemigoPesado.png"})).forEach({enemigo => enemigo.movimiento() ; enemigo.comprobarLimiteMapa()})
        }) 

        game.onTick(4000, "disparoEnemigoPesado",{
            (enemigos.copy().filter({e => e.image() == "enemigoPesado.png"})).forEach({enemigo => enemigo.ataque()})
        })

        game.onTick(100, "moverProyectiles", {
            proyectiles.copy().forEach({p => p.avanzar() ; p.comprobarLimiteMapa()})
        })

        // Programar aparición del jefe 1 a los 35 segundos
        game.schedule(35000, {
            jefe.spawnEnemigo()
            game.removeTickEvent("spawEnemigos")
            game.removeTickEvent("spawnEnemigosRapidos")
            game.removeTickEvent("spawnEnemigoPesado")
            game.removeTickEvent("disparoEnemigoPesado")
            game.schedule(8000, {game.removeTickEvent("moverEnemigo")})
            game.schedule(8000, {game.removeTickEvent("moverEnemigoRapido")})
            game.schedule(12000, {game.removeTickEvent("moverEnemigoPesado")})
            game.onTick(500, "moverJefe", {jefe.movimiento()})
            game.onTick(1500, "disparoJefe", {jefe.ataque()})
        })
    }
}

// =============================================================================
// NIVEL 2: Asedio Aéreo Avanzado (Solo Rápidos, Pesados, Bombarderos y Jefe 2)
// =============================================================================
object nivel2 inherits Nivel(imagenFondo = "videoMapa2.gif", musicaFondo = "musicaNivel1.mp3") {

    override method iniciarSpawners() {
        // Cazas Rápidos con mayor frecuencia (cada 2.5s)
        game.onTick(2500, "spawnRapidos2", {
            const rapido = new Enemigo(position = game.at(0.randomUpTo(game.width()), 7), image = "enemigoRapido.png")
            rapido.spawnEnemigo()
            enemigos.add(rapido)
        })

        game.onTick(400, "moverRapidos2", {
            (enemigos.copy().filter({e => e.image() == "enemigoRapido.png"})).forEach({e => e.movimiento() ; e.comprobarLimiteMapa()})
        })

        // Cazas Pesados estándar (cada 6s)
        game.onTick(6000, "spawnPesados2", {
            const pesado = new EnemigoPesado(position = game.at(0.randomUpTo(game.width()), 6))
            pesado.spawnEnemigo()
            enemigos.add(pesado)
        })

        game.onTick(2500, "moverPesados2", {
            (enemigos.copy().filter({e => e.image() == "enemigoPesado.png"})).forEach({e => e.movimiento() ; e.comprobarLimiteMapa()})
        })

        game.onTick(3000, "disparoPesados2", {
            (enemigos.copy().filter({e => e.image() == "enemigoPesado.png"})).forEach({e => e.ataque()})
        })

        // NUEVO: Bombarderos Pesados con Proyectil Explosivo en racimo (cada 7s)
        game.onTick(7000, "spawnBombarderos2", {
            const bombardero = new EnemigoPesadoExplosivo(position = game.at(0.randomUpTo(game.width()), 6))
            bombardero.spawnEnemigo()
            enemigos.add(bombardero)
        })

        game.onTick(2800, "moverBombarderos2", {
            (enemigos.copy().filter({e => e.image() == "enemigoExplosivo.png"})).forEach({e => e.movimiento() ; e.comprobarLimiteMapa()})
        })

        game.onTick(3500, "disparoBombarderos2", {
            (enemigos.copy().filter({e => e.image() == "enemigoExplosivo.png"})).forEach({e => e.ataque()})
        })

        // Mover todos los proyectiles (aliados, en cono, bombas y esquirlas)
        game.onTick(100, "moverProyectiles", {
            proyectiles.copy().forEach({p => p.avanzar() ; p.comprobarLimiteMapa()})
        })

        // Programar aparición del Jefe Final de Nivel 2 a los 40 segundos
        game.schedule(40000, {
            jefeNivel2.spawnEnemigo()
            game.removeTickEvent("spawnRapidos2")
            game.removeTickEvent("spawnPesados2")
            game.removeTickEvent("disparoPesados2")
            game.removeTickEvent("spawnBombarderos2")
            game.removeTickEvent("disparoBombarderos2")
            game.schedule(8000, {game.removeTickEvent("moverRapidos2")})
            game.schedule(10000, {game.removeTickEvent("moverPesados2")})
            game.schedule(10000, {game.removeTickEvent("moverBombarderos2")})
            // Rutina del Jefe 2: movimiento ágil + ráfagas en cono + bombas de racimo
            game.onTick(400, "moverJefe2", { jefeNivel2.movimiento() })
            game.onTick(1600, "disparoJefe2", { jefeNivel2.ataque() })
            game.onTick(6000, "bombaJefe2", { jefeNivel2.soltarBomba() })
        })
    }
}

object nivel3 inherits Nivel(imagenFondo = "videoMapa3.gif", musicaFondo = "musicaNivel3.mp3") {}
