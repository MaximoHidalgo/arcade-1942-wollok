import wollok.game.*
import enemigos.*
import jugador.*
import mapa.*
import hud.*
import musica.*

//---------------------
//-------Niveles-------
//---------------------


object nivel1 {
    var property img = "videoMapa1.gif"
    var property enemigos = []
    var property proyectiles = []

    method iniciar(){
        mapa.visualizarCon(img)
        game.addVisualCharacter(jugador)
        musicaDeFondo.play("musicaNivel1.mp3")
        
        //Entradas Teclado
        keyboard.left().onPressDo({jugador.image("jugadorIzqu.png")})
        keyboard.right().onPressDo({jugador.image("jugadorDer.png")})
        keyboard.up().onPressDo({jugador.image("jugadorBase.png")})
        keyboard.down().onPressDo({jugador.image("jugadorBase.png")})
        keyboard.x().onPressDo{jugador.ataque()}
        
        game.onTick(2000, "spawEnemigos", {
            const enemigo = new Enemigo(position = game.at(0.randomUpTo(game.width()),7))
            enemigo.spawnEnemigo()
            enemigos.add(enemigo)
        })
        
        game.onTick(1000, "moverEnemigo", {
            enemigos.filter({e => e.image() == "enemigo.png"}).forEach({enemigo => enemigo.movimiento() ; enemigo.comprobarLimiteMapa()})
        })

        game.onTick(4000, "spawnEnemigosRapidos", {
            const enemigoRapido = new Enemigo(position = game.at(0.randomUpTo(game.width()),7), image = "enemigoRapido.png")
            enemigoRapido.spawnEnemigo()
            enemigos.add(enemigoRapido)
            (enemigos.filter({e => e.vidas() == 2})).forEach({enemigo => enemigo.movimiento() ; enemigo.comprobarLimiteMapa()})
        })

        game.onTick(500, "moverEnemigoRapido", {
            (enemigos.filter({e => e.image() == "enemigoRapido.png"})).forEach({enemigo => enemigo.movimiento() ; enemigo.comprobarLimiteMapa()})
        })

        game.onTick(8000, "spawnEnemigoPesado", {
            const enemigoPesado= new EnemigoPesado(position = game.at(0.randomUpTo(game.width()),6))
            enemigoPesado.spawnEnemigo()
            enemigos.add(enemigoPesado)
        })

        game.onTick(3000, "moverEnemigoPesado", {
            (enemigos.filter({e => e.image() == "enemigoPesado.png"})).forEach({enemigo => enemigo.movimiento() ; enemigo.comprobarLimiteMapa()})
        }) 

        game.onTick(4000, "disparoEnemigoPesado",{
            (enemigos.filter({e => e.vidas() == 2})).forEach({enemigo => enemigo.ataque()})
        })

        game.onTick(100, "moverProyectiles", {
            proyectiles.forEach({p =>p.avanzar()p.comprobarLimiteMapa()})
        })

        game.onCollideDo(jugador, {otro => jugador.interactuarCon(otro)})
        


        game.schedule(61000, {
            jefe.spawnEnemigo()
            game.removeTickEvent("spawEnemigos")
            game.removeTickEvent("spawnEnemigosRapidos")
            game.removeTickEvent("spawnEnemigoPesado")
            game.removeTickEvent("disparoEnemigoPesado")
            game.schedule(10000, {game.removeTickEvent("moverProyectilesEnemigos")})
            game.schedule(10000, {game.removeTickEvent("moverEnemigo")})
            game.schedule(10000, {game.removeTickEvent("moverEnemigoRapido")})
            game.schedule(18000, {game.removeTickEvent("moverEnemigoPesado")})
            game.onTick(500, "moverJefe", {jefe.movimiento()})
            game.onTick(1500, "disparoJefe", {jefe.ataque()})
        })

        hud.dibujar()
    }
}
