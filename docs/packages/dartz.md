# Dartz

## Either

Either es un tipo de dato que puede contener un valor de dos tipos diferentes; esto es perfecto para el manejo de errores, donde L es el **error** y R es el **valor**.
De esta manera, los errores no tienen su propio `flujo de error` especial cuando lo hacen las execpciones, sino que se manejan como cualquier otro valor sin usar `try/catch`.

```dart
import 'package:dartz/dartz.dart';

Either<String, int> divide(int dividendo, int divisor) {
 if (divisor == 0) {
 return Left('División por cero');
 } else {
 return Right(dividendo ~/ divisor);
 }
}

void main() {
 var resultado = divide(10, 2);
 resultado.fold((error) => print('Error: $error'), (valor) => print('Resultado: $valor'));
}
```

El uso de `Either` en lugar de `try/catch` puede ser más explícito en el manejo de `errores` porque obliga a quien llame a la función a manejar explísitamente los errores.

El metodo `fold` de `Either` toma dos funciones como argumentos, la primera se ejecuta si el valor es `Left` y la segunda si es `Right`.
