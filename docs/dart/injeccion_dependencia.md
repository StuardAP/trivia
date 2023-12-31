# Injección de dependencia

La injección de dependencia es un patrón de diseño que permite descoplar la creación de objetos de uso.

```dart
  class Motor {
    void encender() => print('Motor encendido');
  }

  class Vehiculo {
    final Motor motor;

    const Vehiculo(this.motor);

    void conducir(){
      motor.encender();
      print('Vehiculo en movimiento');
    }
  }

  void main(){
    var motor = Motor();
    final vehiculo = Vehiculo(motor);
    vehiculo.conducir();
  }
```

En este ejemplo, `Vehiculo` no crea una instancia de `Motor`, sino que recibe una instancia de `Motor` como parámetro en su constructor. Esto permite que `Vehiculo` pueda recibir cualquier tipo de `Motor` sin importar su implementación.

La injección de dependencia tiene varias ventajas:

1. **Separación de responsabilidades**: `Vehiculo` no tiene que preocuparse por la creación de `Motor`, solo se preocupa por usarlo.Cada clase se encarga de una sola cosa.`Vehiculo` se encarga de conducir, `Motor` se encarga de encender.No se encargan de crearce mutuamente.

2. **Flexibilidad**: Puedes injectar cualquier objeto que implemente la interfaz de `Motor`. Por ejemplo, puedes injectar un `MotorElectrico` en vez de un `MotorCombustion`.

3. **Testeabilidad**: Puedes injectar un `Motor` de prueba en vez de un `Motor` real para poder testear `Vehiculo` sin tener que testear `Motor`.

```dart
@GenerateMocks([Motor])

void main(){
  late MockMotor mockMotor;
  late Vehiculo vehiculo;
  setUp((){
    mockMotor = MockMotor();
    vehiculo = Vehiculo(mockMotor);
  });

  test('Carrro conduce',(){
      // Configurar el mock para que imprima una mensaje cuando se llame a encender
      when(mockMotor.encender()).thenAnswer((_) => print('Motor encendido'));

      final result = vehiculo.conducir();

      // Verificar que el mock Motor fue llamado
      verify(mockMotor.encender());

      // Verificar que el resultado es el esperado
      expect(result, 'Vehiculo en movimiento');
  })
}

```
