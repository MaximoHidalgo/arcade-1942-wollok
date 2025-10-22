# Paradigma Orientado a Objetos - Trabajo Práctico Final - WollokGame

## 📄 Consigna:

# Entrega 1 - Ideas y Prototipo Inicial

## 📌 Objetivo
Presentar diferentes ideas de juegos y un primer prototipo sencillo que implemente las funcionalidades iniciales vistas en clase.

## 🎮 Ideas de Juego Presentada

1. **The Legend of Zelda 1986**  
   El personaje se encuentra liberado en un mapa y tiene una mision, salvar el mundo. Hasta ahora puede moverse e interactuar con algunas cosas.  
   - Al tocar objetos, los consume y los puede usar.  
   - Al tocar un corazon gana una vida, si tiene el maximo, queda igual.  
   - Al ser tocado por los enemigos, pierde vidas, si llega a 0 muere.

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

<img width="1118" height="487" alt="image" src="https://github.com/user-attachments/assets/6e424451-41d6-49a8-9a8c-770de1b80163" />



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
