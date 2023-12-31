# Caso de Uso

Los casos de uso son aquellos en donde se ejecutará la lógica de negocio de la aplicación.

![Use Cases](https://i0.wp.com/resocoder.com/wp-content/uploads/2019/08/domain-layer-diagram.png?w=141&ssl=1)

## Flujo y manejo de errores

Sabemos que los caso de uso obtendrán entidades de los respositorios para luego pasarlo a la capa de presentación. Por lo tanto el tipo devuelto por un usecase será asincrono. `¿Qué pasa si ocurre un error?` `Es la mejor opción dejar que las exepciones se progragen libremente ,teniedo que recordar detectarlas en otro lugar del codigo?` No creo. En su lugar, queremos dectectar excepciones lo antes posible (**En el repositorio**) y luego devolver objetos de error de los metodos en cuestión.

## Contrato de repositorio

Un repositorio del que el caso uso obtiene datos pertenece tanto a la capa de datos como a la capa de dominio.En la capa dominio tenemos el contrato y el la capa datos su implementación.

Esto permite una independencia total de la capa dominio, pero tenemos tambien otro beneficio: **La capacidad de prueba**.

Escribir un `contrato` del repositorio , que el caso de dart es una clase abstractra , nos permitirá escribir pruebas (estilo TDD) para los casos de uso sin tener un `implementación` real del Repositorio.

`NOTA: Las pruebas sin implementación concreta de las clases son posibles con simulación gracias a los mocks.`
