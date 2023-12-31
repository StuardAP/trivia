# Arquitectura Limpia y Flutter

## Introducción

![structure](https://miro.medium.com/v2/resize:fit:720/format:webp/0*zUtZYiJ1bDTugOYY)

Existe 3 capas principales en la arquitectura limpia: **Data , Domain y Prensetation**. Cada capa tiene su propósito y solo puede interacturar con la capa inmediatamente inferior.Los datos y la presentación solo pueden comunicarse con la ayuda de la capa dominio.

### 1. Data

La capa **Data** consta de `implementaciones del respositorio`(el contrato provienen de la capa dominio) y fuentes de datos: una suele ser para obtener datos remotos(API) y la otra para almacenar caché  de esos datos.

### 2. Domain

La capa **Domain** es el corazón de la arquitectura limpia. Es la encargada de definir los contratos y definir las reglas de negocio esta capa es independiente de cualquier otra capa. La capa de dominio es responsable de definir los casos de uso de la aplicación.

`Dato: Es la primera capa que se crea en la arquitectura limpia.`

### 3. Presentation

La capa **Presentation** es donde irá la interfaz de usuario.También necesitamos `Widgets` para mostrar algo en la pantalla. Estos `Widgets` están controlados por el estado mediante varios patrones de diseño de administración de estado como `BLoC, Provider, MobX, etc.`

### 4. Core

Si bien no es un capa en si, esta sirve para definir los modelos, excepciones, utilidades, etc. Esta capa es compartida por todas las capas.
