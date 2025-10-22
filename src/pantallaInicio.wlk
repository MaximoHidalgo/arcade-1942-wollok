// src/pantallaInicio.wlk
import wollok.game.*
import main.*
import mapa.*
import jugador.*
import enemigos.*
import juego.*

//---------------------------
//------Menu de Inicio-------
//---------------------------

object menuInicio {
    var property position = game.origin()
    var property image = "menu.png"
    
    method fin() {
        image = "pantalla-victoria.png"
    }
    
    method infoControles() {
        image = "Controles.png"
    }

    method pantallaDeCarga() {
        image = "carga3.png"
        game.schedule(700,{self.abandonarCargando()})
    }

    method abandonarCargando() {
        nivelManager.iniciarSigNivel()
        game.removeVisual(self)
    }

    method animacionCargando() {
        juego.estado(cargando)
        game.addVisual(self)
        image = "carga1.png"
        game.schedule(400, {image="carga2.png"})
        game.schedule(800, {self.limpiar()})
    }

    method limpiar() {
        image = "carga3.png"
        game.allVisuals().forEach({visual => game.removeVisual(visual)})
        game.addVisual(self)
        self.abandonarCargando()
    }

    method derrota() {
        game.sound("sonido-derrota.mp3").play()
        nivelManager.limpieza()
        game.allVisuals().forEach({visual => game.removeVisual(visual)})
        image = "pantalla-derrota.png"
        game.addVisual(self)
        game.schedule(2000,{game.stop()})
    }
}




//---------------------
//-------Niveles-------
//---------------------

object nivelManager {
    const property niveles = [nivel1]
    var property actual = menuInicio

    method iniciarSigNivel() {
        self.validarSigNivel()
        actual = niveles.first()
        actual.iniciar()
        niveles.remove(actual)
    }

    method validarSigNivel() {
        if (niveles.isEmpty()) {
            menuInicio.fin()
            juego.estado(cargando)
            self.error("Ganaste?")
        }
    }

    method limpieza() {
        //obstaculos.clear()
        //actual.ost().stop() 
        //Enemigo.terminarPersecucion()
        //Enemigo.terminarSpawnCycle()
    }

    method terminarNivel() {
        //managerItems.darleTodoAlPersonaje()
        self.limpieza()
        menuInicio.animacionCargando()
    }
}

object nivel1 {
    var property img = "panoramica1.gif"
    var property enemigos = []
    //method tablero()
    //const property ost
    

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
            const enemigo = new Enemigo(vidas = 1, danio = 1, position = game.at(posicionXRandom,7), image = "sprite.png")
            enemigo.spawnEnemigo()
            enemigos.add(enemigo)
            game.onCollideDo(enemigo, {elemento => 
            enemigo.recibirDanioDeJugador(elemento.danioProyectil())
            })
        })
        
        game.onTick(1000, "moverEnemigo", {
            enemigos.forEach(
                {enemigo => enemigo.movimiento() ; enemigo.comprobarLimiteMapa()
                }
            )
        })

        game.onCollideDo(jugador, {elemento => elemento.hacerDanio(jugador)})
    }
}

class EstadoJuego {

    method personaje (){}

    method mejorarEnergia() {}

    method continuar() {}
}

object estadoMenu inherits EstadoJuego() {
    
    override method continuar() {
        juego.estado(cargando)
        menuInicio.pantallaDeCarga()
        //juego.frenarSonidoMenu()
    }
}

/*object infoControles inherits EstadoJuego() {
    
    override method continuar() {
        juego.estado(cargando)
        menuInicio.pantallaDeCarga()
        juego.frenarSonidoMenu()
    }
}*/

object cargando inherits EstadoJuego() {}



