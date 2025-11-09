import wollok.game.*
object musicaDeFondo{
    var property volumen = 1
    var property temaActual = null

    method play(nombreArchivo) {
        if (temaActual != null) {
            temaActual.stop()
        }
        temaActual = game.sound(nombreArchivo)
        temaActual.play()
        temaActual.volume(volumen)
    }

    method stop() {
        if (temaActual != null) temaActual.stop()
    }

    method volumeUp(num){
        volumen += num
        temaActual.volume(volumen)
    }

    method volumeDown(num){
        volumen -= num
        temaActual.volume(volumen)
    }
}