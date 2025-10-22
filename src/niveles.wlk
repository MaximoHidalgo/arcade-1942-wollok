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
        
        //Entradas Teclado
        keyboard.left().onPressDo({jugador.cambiarImagen("jugadorIzqu.png")})
        keyboard.right().onPressDo({jugador.cambiarImagen("jugadorDer.png")})
        keyboard.up().onPressDo({jugador.cambiarImagen("jugadorBase.png")})
        keyboard.down().onPressDo({jugador.cambiarImagen("jugadorBase.png")})
        keyboard.x().onPressDo{jugador.ataqueReg()} 

        const posicionesX = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

        game.onTick(3000, "spawEnemigos", {
            const posicionXRandom = posicionesX.anyOne()
            const enemigo = new Enemigo(vidas = 1, danio = 1, position = game.at(posicionXRandom,7), image = "enemigo.png")
            enemigo.spawnEnemigo()
            enemigos.add(enemigo)
        })
        
        game.onTick(1000, "moverEnemigo", {
            enemigos.forEach(
                {enemigo => enemigo.movimiento() ; enemigo.comprobarLimiteMapa()
                }
            )
        })

        //game.onCollideDo(jugador, {enemigo => enemigo.hacerDanio(jugador)})

        game.onCollideDo(jugador, {e =>if(e.image() == "enemigo.png"){
        e.hacerDanio(jugador)}})
    }
}


