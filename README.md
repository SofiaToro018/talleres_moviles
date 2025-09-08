# talleres_moviles
# Taller Flutter - Widgets Básicos

## Descripción
Aplicación Flutter desarrollada como taller práctico que demuestra el uso de widgets básicos y gestión de estado con 'setState()'. La aplicación incluye una interfaz con múltiples componentes interactivos que cumplen con los requisitos solicitados.

## Datos del Estudiante
- **Nombre:** Laura Sofía Toro Garcia
- **Código:** [230222021]

## Pasos para ejecutar
1. Clonar o descargar el proyecto
2. Ejecutar 'flutter pub get' para obtener dependencias
3. Configurar el emulador, en mi caso no utilice emulador ya que tengo recursos limitados con mi pc.
4. Ejecutar 'flutter run' para iniciar la aplicación

## Capturas de la aplicación
- **Estado inicial de la app:** Al iniciar la aplicación, se visualiza una interfaz con un AppBar que muestra el título "Hola, Flutter" en color blanco sobre fondo azul, seguido del nombre "Laura Sofía Toro Garcia" en azul y negrita, una galería con dos imágenes (una cargada desde internet y otra desde assets locales) dentro de Containers decorativos con bordes y esquinas redondeadas, un botón azul para cambiar el título, un contador inicializado en cero con su botón de incremento, una ListView con cuatro elementos con iconos descriptivos, y finalmente un ElevatedButton con icono de añadir.
![Est. inicial](image.png)
![Est. inicial](image-1.png)

- **Estado tras presionar el botón:** Al presionar el botón "Cambiar título de la AppBar", el título de la AppBar alterna entre "Hola, Flutter" y "¡Título cambiado!", mostrando simultáneamente un SnackBar en la parte inferior con el mensaje "Título actualizado" que permanece visible durante 1 segundo.
![Est. presionar el boton](image-2.png)

- **Funcionamiento de los widgets adicionales:**
- **Container decorativo:** Se utilizó para enmarcar las imágenes con bordes grises y esquinas redondeadas de 10px, mejorando la presentación visual.
- **ListView:** Implementa una lista de cuatro elementos (favorito, destacado, contacto y configuración) con iconos temáticos y flechas indicadoras en cada ListTile.
- **OutlinedButton:** Utilizado para el contador, permite incrementar el valor numérico con cada pulsación.
- **ElevatedButton.icon:** Botón con icono de añadir que muestra un SnackBar con el mensaje "Botón con icono presionado" durante 1 segundo al ser presionado.
![Contador y Lista](image-3.png)
![Lista y Boton agregar](image-4.png)

