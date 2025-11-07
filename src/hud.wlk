import wollok.game.*

object hud {
    method dibujar() {
        game.addVisual(barra)
        game.addVisual(cantVida)
        game.addVisual(cantPuntos)
        game.addVisual(textoPuntos)
    }
}

object barra {
    var property image = "barra.png"
    var property position = game.at(0,7)
}

object cantVida {
    var property image = "corazones3.png"
    var property position = game.at(0,7)
}

object textoPuntos {
    var property image = "textoPuntos.png"
    var property position = game.at(4,7)
}

object cantPuntos {
    var property digits = []
    var property position = game.at(6,7)
    var property image = "puntajeBase.png"

    method actualizar(puntos) {
        game.removeVisual(self)
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