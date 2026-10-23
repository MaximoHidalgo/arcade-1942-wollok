import wollok.game.*

class ObjetoPasivo{
    method interactuarCon(otro) {} // no hace nada
    method interactuarConJugador(jugador) {}
    method interactuarConEnemigo(enemigo) {}
    method interactuarConProyectil(proy) {}
    method interactuarConProyectilRival(proy) {}
}

object hud inherits ObjetoPasivo {
    method dibujar() {
        game.addVisual(barra)
        game.addVisual(cantVida)
        game.addVisual(cantPuntos)
        game.addVisual(textoPuntos)
    }
}

object barra inherits ObjetoPasivo {
    var property image = "barra.png"
    var property position = game.at(0,7)
}

object cantVida inherits ObjetoPasivo {
    var property image = "corazones3.png"
    var property position = game.at(0,7)
}

object textoPuntos inherits ObjetoPasivo {
    var property image = "textoPuntos.png"
    var property position = game.at(4,7)
}

object cantPuntos inherits ObjetoPasivo {
    var property digits = []
    var property position = game.at(6,7)
    var property image = "puntajeBase.png"
    var property inicializado = false

    method actualizar(puntos) {
        if (!inicializado) {
            game.removeVisual(self)
            inicializado = true
        }
        const texto = puntos.toString()

        digits.forEach({ d => game.removeVisual(d) })
        digits.clear()

        texto.length().times({ i =>
            const numero = texto.charAt(i - 1)
            const digito = object {
                var property image = numero + ".png"
                var property position = game.at(6 + (i - 1), 7)
            }
            digits.add(digito)
            game.addVisual(digito)
        })
    }
}
