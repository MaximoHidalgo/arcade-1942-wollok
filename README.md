# Paradigma Orientado a Objetos - Trabajo Práctico Final - WollokGame

## 📄 Consigna:

# Entrega 1 - Ideas y Prototipo Inicial

## 📌 Objetivo
Presentar diferentes ideas de juegos y un primer prototipo sencillo que implemente las funcionalidades iniciales vistas en clase.

## 🎮 Ideas de Juego Presentada

1. **Arcade 1942**  
  El objetivo del jugador es sobrevivir y completar la misión, demostrando habilidad, reflejos y estrategia en cada enfrentamiento.

Durante la partida, el jugador debe:

   - Moverse libremente por el mapa evitando los ataques enemigos.
   - Derribar aviones enemigos mientras esquiva proyectiles.
   - Superar oleadas de enemigos y enfrentarse a jefe final para sumar puntos.

## Metas del juego
Este prototipo demuestra los primeros pasos del desarrollo y sirve como base para incorporar futuras ideas. Entre los objetivos se encuentra intentar incorporar otras mecanicas, jefes, mas armas o herramientas y mejorar las interfaces para el jugador.


# Entrega 2 - Lógica principal funcionando

Diagrama: 
[≪object≫;jugador|position; vidas; puntos; img |cambiarImagen(nuevaImagen);image();ataqueReg();recibirDanio(danio); morir()]

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

En jugador.wlk después de definir el objeto jugador creamos una class Proyectiles para definir los atributos y comportamientos que tienen los proyectiles que lanza el jugador. Usando herencia creamos la class ProyectilesRival que hereda de la class Proyectiles. De la misma manera que se hizo con ProyectilesRival se hizo ProyectilJefe. Luego la creación y movimientos de los proyectiles están definidos por un onTick en niveles.wlk.

En enemigos.wlk utilizamos una class Enemigo para definir a los enemigos del juego con sus atributos base y sus comportamientos esto para luego poder crear múltiples enemigos. Luego gracias a la herencia podemos crear subclases de enemigos que compartan atributos y comportamiento como también que haya comportamientos que cambien utilizando override como ejemplo a la subclase EnemigoPesado que hace un override a method comprobarLimiteMapa(), method avanzar() y a method spawnDisparo(). También gracias a la herencia, pero no este caso no siendo una subclase utilizamos la herencia para crear al objeto jefe. Luego los enemigos son creados y se mueven mediante un onTick que está definido en niveles.wlk.

En menu.wlk es donde especificamos como se va a crear el hud del juego y como este se va a ir actualizando en función de la vida del jugador y de la cantidad de puntos que este consiga eliminando enemigos. 

En niveles.wlk se utiliza el onTick para poder definir cómo y cada cuanto va a ser el spawn de enemigos, cada cuanto se mueven ellos y en el caso de ciertos enemigos como se mueven sus proyectiles. También se genera el puntaje del jugador que se va actualizando a medida que este elimine enemigos y las vidas que tiene el jugador.




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
