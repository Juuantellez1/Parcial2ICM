# Parcial 2 ICM - Concéntrese

Aplicación móvil desarrollada en Flutter como parte del Parcial 2.

El proyecto implementa un juego de memoria llamado **Concéntrese**, en el que el jugador debe recordar una secuencia de números y responder correctamente para aumentar su puntaje.

## Objetivo

Desarrollar una aplicación móvil utilizando Flutter que permita practicar conceptos de:

- Manejo de estado.
- Navegación entre pantallas.
- Temporizadores.
- Validación de datos.
- Manejo de puntajes.
- Uso de Provider.

## Funcionamiento del juego

1. El usuario ingresa su nombre.
2. Se inicia una partida con 5 vidas.
3. El sistema genera números aleatorios entre 0 y 100.
4. La secuencia se muestra durante algunos segundos.
5. Después, la secuencia desaparece y el jugador debe ingresar el último número mostrado.
6. Si la respuesta es correcta, aumenta el puntaje.
7. Si la respuesta es incorrecta, se pierde una vida.
8. En cada ronda se agrega un nuevo número.
9. El juego termina cuando el jugador pierde todas sus vidas.

## Pantallas

### Pantalla principal

Permite:

- Ingresar el nombre del jugador.
- Iniciar una nueva partida.
- Consultar el mejor jugador.

### Pantalla de juego

Muestra:

- Secuencia de números.
- Temporizador.
- Nombre del competidor.
- Puntaje actual.
- Vidas restantes.
- Campo para ingresar la respuesta.
- Botón para validar.

### Mejor jugador

Muestra el jugador con el mejor puntaje registrado durante la sesión.

También muestra:

- Nombre.
- Puntaje.
- Fecha y hora del resultado.

## Manejo de estado

El proyecto utiliza la librería:

```dart
provider: ^6.1.5
