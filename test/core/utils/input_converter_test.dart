import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trivia/core/utils/input_converter.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignedInt', () {
    test(
        'Should return an integer when the string represents  an unsigned integer',
        () async {
      // Arrange
      const str = '69';
      // Act
      final result = inputConverter.stringToUnsignedInteger(str);
      // Assert
      expect(result, const Right(69));
    });

    test('Should return failure when the string is not an integer', () async {
      // Arrange
      const str = 'str';
      // Act
      final result = inputConverter.stringToUnsignedInteger(str);
      // Assert
      expect(result,  Left(InvalidInputFailure()));
    });

    test('Should return failure when the string is a negative integer',
    () async {
      // Arrange
      const str = '-69';
      // Act
      final result = inputConverter.stringToUnsignedInteger(str);
      // Assert
      expect(result,  Left(InvalidInputFailure()));

    }
    );
  });
}
