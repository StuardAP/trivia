import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:trivia/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tNumberTriviaModel = NumberTriviaModel(text: 'Test Text', number: 1);

  test('Should be a subclass of NumberTrivia entity ', () async {
    // Arrange

    // Act

    // Assert
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });

  group('fromJson', () {
    test('Should return a valid model when the JSON number is an integer',
        () async {
      // Arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture('trivia.json'));
      // Act
      final result = NumberTriviaModel.fromJson(jsonMap);
      // Assert
      expect(result, tNumberTriviaModel);
    });
    test(
        'Should return a valid model when the JSON number is regarded as double',
        () async {
      // Arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('trivia_double.json'));
      // Act
      final result = NumberTriviaModel.fromJson(jsonMap);
      // Assert
      expect(result, tNumberTriviaModel);
    });
  });
  group('toJson', () {
    test('Should return a valid model when the JSON number is an integer',
        () async {
      // Arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture('trivia.json'));
      // Act
      final result = NumberTriviaModel.fromJson(jsonMap);
      // Assert
      expect(result, tNumberTriviaModel);
    });
    test('Should return a JSON map containing the proper data', () async {
      // Arrange
      // Act
      final result = tNumberTriviaModel.toJson();
      // Assert
      final Map<String, dynamic> expectedJson = {
        "text": "Test Text",
        "number": 1
      };
      expect(result, expectedJson);
    });
  });
}
