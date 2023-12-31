# Equatable

En ocaciones necesitamos comparar objetos y la manera nativa de hacerlo en Dart es con el operador `==` y `hashCode`.

veamos que pasa si intentamos comparar dos objetos sin sobreescribir el operador `==` y `hashCode`:

```dart
class Person {
  final String name;
  final int age;

  Person(this.name, this.age);
}

void main() {
  final juan1 = Person('Juan', 20);
  final juan2 = Person('Juan', 20);

  print(juan1 == juan2); // Ouput false
}
```

Como podemos ver el resultado es `false` ya que estamos comparando dos objetos que son diferentes, aunque tengan los mismos valores. Esto se debe a que Dart compara los objetos por referencia y no por valor.

Comparar los objetos por referencia es verificar si los objetos son el mismo, es decir,`si apuntan a la misma dirección de memoria`.

Para poder comprar si los objetos son iguales por valor, debemos sobreescribir el operador `==` y `hashCode`:

```dart
class Person {
  final String name;
  final int age;

  Person(this.name, this.age);

  @override
  bool operator == (Object other) {
    if (identical(this, other)) return true;

    return other is Person &&  other.name == name && other.age == age;
  }

  @override
  int get hashCode => name.hashCode ^ age.hashCode;
}
```

Primero verificamos si los objetos son el mismo, si es así retornamos `true`, de lo contrario verificamos si el objeto es de tipo `Person` y si los valores de `name` y `age` son iguales.

Hacemos lo anterior ya que `identical()` lo que hace es verificar la referencia de memoria, es decir, si los objetos son el mismo.

```dart
void main() {
 var persona1 = Persona('Bob',18);
 var persona2 = Persona('Bob', 30);
 var persona3 = persona1;

 print(identical(persona1, persona2)); // false, porque son dos objetos diferentes
 print(identical(persona1, persona3)); // true, porque son el mismo objeto
}
```

De no ser así, verificamos si los objetos son de tipo `Person` y si los valores de `name` y `age` son iguales. Posteriormente, sobreescribimos el método `hashCode` para que retorne un valor único para cada objeto.

El método `hashCode` es un valor entero que representa el objeto, este valor es único para cada objeto. Este valor es utilizado por las estructuras de datos como `Map` y `Set` para poder almacenar los objetos.

Cuando sobreescribimos el método `hashCode` está calculando un valor único para cada objeto, por lo que si dos objetos son iguales, el valor de `hashCode` debe ser el mismo.El operador `^` es un operador XOR, que es un operador binario que compara los bits de dos valores y retorna un nuevo valor con los bits que son diferentes.

```dart
void main() {
 var persona1 = Persona('Juan', 25);
 var persona2 = Persona('Juan', 25);
 var persona3 = persona1;

 print(persona1 == persona2); // true, porque son iguales según el método ==
 print(persona1 == persona3); // true, porque son el mismo objeto
 print(persona1.hashCode == persona2.hashCode); // true, porque tienen el mismo código hash
 print(persona1.hashCode == persona3.hashCode); // true, porque tienen el mismo código hash
}

```

`Se debe sobreescribir el método hashCode cuando se sobreescribe el método ==` la razón es que si por ejemplo no sobreescribimos el metodo `hashCode` tendremos problemas al utilizar los objetos en estructuras de datos como `Map` y `Set`.

```dart
void main() {
 var mapPersonas = Map<Person, String>();
 var persona1 = Persona('Juan', 25);
 var persona2 = Persona('Juan', 25);

  mapPersonas[persona1] = 'Juan';
  mapPersonas[persona2] = 'Ana';
  print(mapPersonas[persona1]); // Ana, ¡Debería ser Juan!

  var setPersonas = Set<Person>();
  setPersonas.add(persona1);
  setPersonas.add(persona2);
  print(setPersonas.length); // 2, porque los objetos son diferentes , pero debería ser 1!
}
```

## ¿Qué es Equatable?

Equatable es una librería que nos permite sobreescribir el método `==` y `hashCode` de una manera más sencilla.

Asi por ejemplo el código anterior se vería de la siguiente manera:

```dart
import 'package:equatable/equatable.dart';

class Person extends Equatable {
  final String name;
  final int age;

  Person(this.name, this.age);

  @override
  List<Object> get props => [name, age];
}

void main() {
  final juan1 = Person('Juan', 20);
  final juan2 = Person('Juan', 20);

  print(juan1 == juan2); // Ouput true
}
```
