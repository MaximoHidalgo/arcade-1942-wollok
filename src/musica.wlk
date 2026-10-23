import wollok.game.*

object musicaDeFondo{
    var property volumen = 1
    var property temaActual = null

    method play(nombreArchivo) {
        self.stop()
        temaActual = game.sound(nombreArchivo)
        temaActual.play()
        temaActual.volume(volumen)
    }

    method stop() {
        if (temaActual != null) {
            if (temaActual.played()) {
                temaActual.stop()
            }
            temaActual = null
        }
    }

    method volumeUp(num){
        volumen += num
        if (temaActual != null) temaActual.volume(volumen)
    }

    method volumeDown(num){
        volumen -= num
        if (temaActual != null) temaActual.volume(volumen)
    }
}
