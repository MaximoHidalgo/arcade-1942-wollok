# Paradigma Orientado a Objetos - Trabajo Práctico Final - WollokGame

## 📄 Consigna:

# Entrega 1 - Ideas y Prototipo Inicial

## 📌 Objetivo
Presentar diferentes ideas de juegos y un primer prototipo sencillo que implemente las funcionalidades iniciales vistas en clase.

## 🎮 Ideas de Juego Presentada

1. Arcade 1942
El objetivo del jugador es sobrevivir y completar la misión, demostrando habilidad, reflejos y estrategia en cada enfrentamiento.
Durante la partida, el jugador debe:

   - Moverse libremente por el mapa evitando los ataques enemigos.
   - Derribar aviones enemigos mientras esquiva proyectiles.
   - Hacer la mayor cantidad de puntos posibles.
   - Superar oleadas de enemigos y enfrentarse a jefe final para sumar puntos.

## Metas del juego
Este prototipo demuestra los primeros pasos del desarrollo y sirve como base para incorporar futuras ideas. Entre los objetivos se encuentra intentar incorporar otras mecanicas, jefes, mas armas y mejorar las interfaces para el jugador.


# Entrega 2 - Lógica principal funcionando

Diagrama Estático: 
[≪object≫;jugador|position; vidas; puntos; img |cambiarImagen(nuevaImagen);image();ataque();recibirDanio(danio); morir()]

[Proyectiles|position; danioProyectil; image|cambiarImagen(nuevaImagen);danioProyectil();spawnDisparo(posicion);remover();comprobarLimiteMapa();avanzar();poderAtaque(enemigo)]

[Enemigos|position; vida; image; danio|spawnEnemigo(position);movimiento()hacerDanio();remover();comprobarLimiteMapa();comprobarMorir();recibirDanioDelJugador]

// Relaciones
[jugador]<->[Enemigos]
[Proyectiles]->[Enemigos]
[jugador]-.->[Proyectiles]

<img width="600" height="450" alt="image" src="https://github.com/user-attachments/assets/6e424451-41d6-49a8-9a8c-770de1b80163" />

# Entrega 3 

# Explicaciones Teóricas

Explicaciones Teóricas

En jugador.wlk después de definir el objeto jugador creamos una class Proyectiles para definir los atributos y comportamientos que tienen los proyectiles que lanza el jugador. Usando herencia creamos la class ProyectilEnemigo que hereda de la class Proyectiles. Luego la creación y movimientos de los proyectiles están definidos por un onTick en niveles.wlk.

En enemigos.wlk utilizamos una class Enemigo para definir a los enemigos del juego con sus atributos base y sus comportamientos esto para luego poder crear múltiples enemigos. Luego gracias a la herencia podemos crear subclases de enemigos que compartan atributos y comportamiento como también que haya comportamientos que cambien utilizando override como ejemplo a la subclase EnemigoPesado que hace un override a method comprobarLimiteMapa(), method avanzar() y a method spawnDisparo(). También gracias a la herencia, pero no este caso no siendo una subclase utilizamos la herencia para crear al objeto jefe. Luego los enemigos son creados y se mueven mediante un onTick que está definido en niveles.wlk.

En hud.wlk es donde especificamos como se va a crear el hud del juego y como este se va a ir actualizando en función de la vida del jugador y de la cantidad de puntos que este consiga eliminando enemigos. 

En niveles.wlk se utiliza el onTick para poder definir cómo y cada cuanto va a ser el spawn de enemigos, cada cuanto se mueven ellos y en el caso de ciertos enemigos como se mueven sus proyectiles. También se genera el puntaje del jugador que se va actualizando a medida que este elimine enemigos y las vidas que tiene el jugador.

*Diagrama Estático actualizado*:

<img width="623" height="1723" alt="image" src="https://github.com/user-attachments/assets/0ccbfd35-babb-44d0-a1bb-fcabe3894462" />

# Presentacion del Juego:

## Explicación de como es el jugador:

Arrancamos creando al objeto jugador con sus vidas, puntos, imagen, su inmunidad y su posición inicial como atributos. Después tenemos el method interactuarConEnemigo() que hace que, si el jugador colisiona con un enemigo, el jugador reciba daño. Algo parecido ocurre con el method interactuarConProyectilRival() que hace lo mismo, pero agregando que al colisionar con el proyectil este se remueva. Cuando colisiona el proyectil o el enemigo se aplica el method recibirDanio() que le resta vida al jugador y actualiza la cantidad de vidas visibles en el hud, con la particularidad de que si la inmunidad esta activada esto se ignora y el jugador sigue con la misma vida. La inmunidad se activa después de que el jugador reciba daño y hace que por 3,5 segundos el jugador tenga inmunidad definido por un schedule. El method parpadear() hace que el jugador alterne entre visible y transparente mientras dura la inmunidad, mostrando la imagen de “jugador herido” y luego volviendo a la imagen base. Si el jugador se queda sin vidas se pasa al method morir que lo que hace es cambiar a la pantalla de derrota con su música de derrota. Para realizar un ataque tenemos el method ataque que por cada vez que se presiona la tecla "x" se crea un nuevo proyectil que está definido por la clase Proyectiles. Cuando el jugador logra eliminar enemigos el method sumarPuntos() incrementa la cantidad de puntos del jugador.


``` wollok
object jugador {
  var property position = game.at(5, 1)
  var property vidas = 3
  var property puntos = 0
  var property image = "jugadorBase.png"
  var property inmune = false
  
  method interactuarCon(otro) {
    otro.interactuarConJugador(self)
  }
  
  method interactuarConEnemigo(enemigo) {
    self.recibirDanio(enemigo.danio())
  }
  
  method interactuarConProyectilRival(proyectil) {
    self.recibirDanio(proyectil.danio())
    proyectil.remover()
  }
  
  method interactuarConProyectil(proyectil) {} // no hace nada
  
  method ataque() {
    const proyectil = new Proyectiles(position = self.position(), danio = 1)
    proyectil.spawnDisparo(self.position())
    nivel1.proyectiles().add(proyectil)
  }
  
  method recibirDanio(danio) {
    if (self.inmune()) return vidas// Si está inmune, ignora el golpe
    vidas = vidas - danio
    

    if (vidas == 2) {cantVida.image("corazones2.png") game.sound("impactoJugador.wav").play()} 
    if (vidas == 1) {cantVida.image("corazones1.png") game.sound("impactoJugador.wav").play()}
    if (vidas <= 0) {cantVida.image("corazones0.png")
      self.morir()
    }
    
    // Activar inmunidad temporal (3,5 segundos)
    self.inmune(true)
    self.parpadear(6)
    game.schedule(3500, {self.inmune(false)})
    
    return vidas
  }

  method morir() {
    game.sound("sonidoMuerte.wav").play()
    self.image("jugadorPierde.png")
    game.schedule(500,{pantallas.pantallaFinalizacion("pantalla-derrota.png","sonidoDerrota.wav")})
  }

  method parpadear(veces) {
    var visible = true
    game.onTick(200, "blinkJugador", {
      visible = !visible
      if (visible) self.image("jugadorHerido.png")
        else self.image("jugadorTransparente.png")
    })

    game.schedule(3500, {
      game.removeTickEvent("blinkJugador")
      self.image("jugadorBase.png")
    })
  }
  
  method sumarPuntos(cantidad) {
    puntos += cantidad
  }
}
```
## Explicación del controlador de nivel:

Se crea el objeto nivelManager que tiene una lista constante de niveles y otro atributo llamado actual que apunta al objeto pantallas. En el method iniciarSigNivel hace que si la lista niveles esta vacía el juego pasa a una pantalla de victoria utilizando el method pantallaFinalizacion(), sino agarra el primer nivel que está en la lista, lo inicia para luego removerlo de la lista y que no se repita. Con el method terminarNivel() se usa el method limpieza() que limpia los elementos del nivel actual y se pasa al method animaciónCargando() para mostrar la pantalla de carga antes del siguiente nivel. El method limpieza hace un game.clear() y detiene la música de fondo.

``` wollok
object nivelManager {
    const property niveles = [nivel1]
    var property actual = pantallas

    method iniciarSigNivel() {
        if (niveles.isEmpty()) {
            juego.estado(cargando)
            pantallas.pantallaFinalizacion("pantalla-victoria.png","sonidoVictoria.wav")
        }
        actual = niveles.first()
        actual.iniciar()
        niveles.remove(actual)
    }

    method terminarNivel(){
        self.limpieza()
        pantallas.animacionCargando()
    }

    method limpieza(){
        game.clear()
        musicaDeFondo.stop()
    }

}
```
## Explicación del controlador de pantallas:

El controlador de pantallas tiene al objeto pantallas que actúa como controlador visual y hereda de ObjetoPasivo, lo que significa que no interactúa activamente con otros objetos, sino que muestra imágenes y sonidos. El juego arranca con una imagen de inicio para que después de tocar "enter" se ejecute el method pantallaIncio() que cambia la imagen, agrega un sonido y luego de un schedule pase al method animacionCargando() donde se vuelve a cambiar la imagen por un gif de cargando y luego de otro schedule se hace el method limpiar() que remueve todos los visuales y pasa al method abandonarCargando() que lo que hace es que el nivelManager haga el method iniciarSigNivel(). El method pantallaFinalizacion() hace que el nivelMangaer haga el method limpieza() para que remueva los elementos del nivel anterior, ejecute sonido, remueva los visuales, pone imagen de victoria y luego de un schedule se realice un game.stop().

``` wollok
object pantallas inherits ObjetoPasivo {
    var property position = game.origin()
    var property image = "inicio.png"
     
    method pantallaInfoControles() {
        image = "Controles.png"
    }

    method pantallaDeInicio() {
        image = "Inicio2.png"
        game.sound("sonidoStart.wav").play()
        game.schedule(700,{self.animacionCargando()})
    }

    method animacionCargando() {
        juego.estado(cargando)
        self.image("cargando.gif")
        musicaDeFondo.play("audioCargando.wav")
        game.schedule(6800, {self.limpiar()})
    }

    method limpiar() {
        game.allVisuals().forEach({visual => game.removeVisual(visual)})
        self.abandonarCargando()
    }

    method abandonarCargando() {
        nivelManager.iniciarSigNivel()
        game.removeVisual(self)
    }

    method pantallaFinalizacion(imagen, musica) {
        nivelManager.limpieza()
        game.sound(musica).play()
        game.allVisuals().forEach({visual => game.removeVisual(visual)})
        image = imagen
        game.addVisual(self)
        game.schedule(2000,{game.stop()})
    }
```
## Polimorfismo y herencia:

El concepto del herencia se puede observar por ejemplo en los enemigosPesados y el objeto Jefe, los cuales heredan la clase Enemigo y por ende conservan sus métodos con algún posible override entre ellos o agregar variables/métodos propios. También los Proyectiles son heredados por proyectilEnemigo. Todo esto se puede observar en el Diagrama Estático presentado previamente.
Otro ejemplo fuera del diagrama es la clase llamada Nivel que es heredada luego por los objetos nivel1, nivel2 y nivel3, aunque para esta primera versión sólo tenemos detalles del nivel1. Pero en caso de seguir desarrollando el juego, el nivel2, nivel3 y futuros nuevos niveles usarían la misma estructura de Nivel.
```
class Nivel{
    var property enemigos = []
    var property proyectiles = []
    var property imagenFondo
    var property musicaFondo

    method iniciar() {
        mapa.visualizarCon(imagenFondo)
        musicaDeFondo.play(musicaFondo)
        game.addVisualCharacter(jugador)
        self.configurarControles()
        hud.dibujar()
        self.iniciarSpawners()
        self.configurarColisiones()
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
object nivel1 inherits Nivel(imagenFondo = "videoMapa1.gif", musicaFondo = "musicaNivel1.mp3") {

    override method iniciarSpawners() {
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
        // Programar aparición del jefe
        game.schedule(40000, {
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
    }
}
object nivel2 inherits Nivel(imagenFondo = "videoMapa2.gif", musicaFondo = "musicaNivel2.mp3") {}
object nivel3 inherits Nivel(imagenFondo = "videoMapa3.gif", musicaFondo = "musicaNivel3.mp3") {}
```
En cuanto al polimorfismo por si sólo lo podemos ver por un lado en el Visual, el cual es una interfaz presente en el diagrama también, que hace que jugador, Enemigos (en todas sus variantes) y Proyectiles puedan ser visualizados con una posición concreta.
Y, por otro lado, lo podemos observar en las interacciones entre estos objetos, las cuales permiten entre otras cosas que el jugador pierda vidas cuando choca o *colisiona* con un proyectil enemigo o con el enemigo mismo, o que los enemigos mueran cuando son alcanzados por proyectiles del jugador. En el caso de que alguno de estos se quede sin vidas se "muere" el objeto removiendolo visualmente, particularmente en el caso del jugador se termina el juego.
Es importante destacar que para que el polimorfismo se pueda aprovechar al máximo los proyectiles, enemigos y jugador tienen que entender todos los métodos vinculados a interacciones, aún si pareciera inútil que un jugador colisione con su propio proyectil o un enemigo choque con otro enemigo. Esto se soluciona con métodos que existen pero no hacen nada concreto, pero el objeto sabe de su existencia.
```
class Enemigo {
  //Atributos:
  var property position
  var property vidas = 1
  var property danio = 1
  var property image = "enemigo.png"
  
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
  method interactuarConProyectilRival(proyectil) { } // no hace nada
  method interactuarConEnemigo(enemigo) { } // nada, por si se tocan
  method spawnEnemigo(){
    game.addVisual(self)
    game.sound("vueloEnemigo.wav").play()
    game.onCollideDo(self, { otro => self.interactuarCon(otro) })
  }
  method movimiento(){
    self.position(self.position().down(1))
  }
  method remover(){
      game.removeVisual(self)
      nivel1.enemigos().remove(self)
  }
  //Metodo morir:
  method comprobarMorir() {
    if (vidas <= 0) {
      self.remover()
      jugador.sumarPuntos(100)
      cantPuntos.actualizar(jugador.puntos())
      }
    if (self.comprobarLimiteMapa()) {
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
```
En el ejemplo de código anterior el Enemigo podría colisionar con otro de su misma clase o con un proyectil de otro enemigo pero no sucede nada en ninguno de estos casos, a diferencia de los proyectiles del jugador.


# 🧠 Grupo El ultimo paradigma

## 📚 Paradimas de programacion - Año 2025  

## 👥 Integrantes del Grupo

| Nombre completo                | GitHub                                      |
|-------------------------------|---------------------------------------------|
| Jeremías Boutet               | [Jereboutet](https://github.com/Jereboutet) |
| Máximo Juan Manuel Hidalgo    | [MaximoHidalgo](https://github.com/MaximoHidalgo) |
| Dario Regojo                  | [dregojo](https://github.com/dregojo)     |
| Elian Spallina Alcoba         | [elianspal](https://github.com/elianspal) |
| Matías Miguel Del Rosso Smolar| [MatiasDelRosso](https://github.com/MatiasDelRosso) |

---
