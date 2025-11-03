import wollok.game.*
import controladorDeNivel.*
import enemigos.*
import estadosJuego.*
import juego.*
import jugador.*
import main.*
import mapa.*
import menu.*

//---------------------
//-------Niveles-------
//---------------------


object nivel1 {
    var property img = "panoramica1.gif"
    var property enemigos = []

    method iniciar(){
        mapa.visualizarCon(img)
        game.addVisualCharacter(jugador)
        game.sound("musicaNivel1.mp3").play()
        
        //Entradas Teclado
        keyboard.left().onPressDo({jugador.cambiarImagen("jugadorIzqu.png")})
        keyboard.right().onPressDo({jugador.cambiarImagen("jugadorDer.png")})
        keyboard.up().onPressDo({jugador.cambiarImagen("jugadorBase.png")})
        keyboard.down().onPressDo({jugador.cambiarImagen("jugadorBase.png")})
        keyboard.x().onPressDo{jugador.ataqueReg()}
        
        game.onTick(2000, "spawEnemigos", {
            const enemigo = new Enemigo(vidas = 1, danio = 1, position = game.at(0.randomUpTo(game.width()),7), image = "enemigo.png")
            enemigo.spawnEnemigo()
            enemigos.add(enemigo)
        })
        
        game.onTick(1000, "moverEnemigo", {
            enemigos.forEach({enemigo => enemigo.movimiento() ; enemigo.comprobarLimiteMapa()})
        })

        game.onCollideDo(jugador, {e =>if(e.image() == "enemigo.png"){
        e.hacerDanio(jugador)}})

        hud.dibujar()
    }
}
