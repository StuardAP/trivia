# TEST

- `setUp()` sirve para configurar el test antes de ejecutarlo. Por ejemplo, puedes crear una instancia de la clase que quieres testear y asignarla a una variable global para que puedas acceder a ella desde cualquier test.

- `when()` es un metodo de Mockito y se utiliza para especificar el comportamiento de un objeto mock cuando se llama a un metodo específico. En otras palabras, `when()` te permite decirle a `mockito` **"Cuando se llame a este método en este objeto mock , haz esto".**

- `thenReturn()` es un metodo de Mockito y se utiliza para especificar el valor **fijo** que se debe devolver cuando se llama el metodo mock.

- `thenAnswer()` es un metodo de Mockito y se utiliza para especificar el valor **dinámico** que se debe devolver cuando se llama el metodo mock. Por ejemplo, puedes especificar que se debe devolver un valor aleatorio cuando se llama el metodo mock.

`Nota: Debes usar thenReturn() cuando quieras que el valor de retorno sea siempre el mismo, y thenAnswer() cuando quieras que el valor de retorno se calcule en tiempo de ejecució`

- `verify()` es un metodo de Mockito y se utiliza para verificar que un metodo mock fue llamado.

```dart
  test('should call MyService.method', ()   async {
     final myService = MockService();
     final myClass = MyClass(myService);

     await myClass.doSomething();

     verify(myService.method()).called(1);
   });

```

- `verifyZeroInteractions()` es útil cuando quieras asegurarte que el objeto simulado no está siendo utilizado en absoluto durante la prueba.

- `expect()` es un metodo de Mockito y se utiliza para verificar que el resultado de un metodo mock es el esperado.

- `isA()` es un metodo de Mockito y se utiliza para verificar que el argumento de un metodo mock es del tipo esperado.

## Stubbing Asíncrono

El uso de `thenReturn` para devolver un `Future` o `Stream` arrojará un error `ArgumentError`. Esto se debe a que dar lugar a comportamientos inesperados. Por ejemplo, si usas `thenReturn` para devolver un `Future` que se resuelve con un valor, el test se completará inmediatamente, incluso si el `Future` aún no se ha resuelto.

```dart
  // BAD
  when(mock.methodThatReturnsFuture()).thenReturn(Future.value('stub'));
  when(mock.methodThatReturnsStream()).thenReturn(Stream.fromIterable(['stub']));


  // GOOD
  when(mock.methodThatReturnsFuture()).thenAnswer((_) async => Future.value('stub'));
  when(mock.methodThatReturnsStream()).thenAnswer((_) async => Stream.fromIterable(['stub']));

```

Si, por alguna razón, desea el comportamiento de ,puede devolver una instancia predifinida . `thenReturn`

```dart
  final future = Future.value('stub');
  when(mock.methodThatReturnsFuture()).thenReturn((_)=>future);
```
