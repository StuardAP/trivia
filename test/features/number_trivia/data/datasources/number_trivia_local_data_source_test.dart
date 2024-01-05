import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trivia/core/error/exeptions.dart';
import 'package:trivia/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:trivia/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';
@GenerateMocks([SharedPreferences])
import 'number_trivia_local_data_source_test.mocks.dart';

void main() {
  late NumberTriviaLocalDataSourceImpl dataSourceImpl;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSourceImpl = NumberTriviaLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences);
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));
    test(
        'Should return NumberTrivia from SharedPreferences when there is one in the cache',
        () async {
      // Arrange
      when(mockSharedPreferences.getString(any))
          .thenReturn(fixture('trivia_cached.json'));
      // Act
      final result = await dataSourceImpl.getLastNumberTrivia();
      // Assert
      verify(mockSharedPreferences.getString('CACHED_NUMBER_TRIVIA'));
      expect(result, equals(tNumberTriviaModel));
    });
    test('Should throw a CacheExeption when there is not  a cached value',
        () async {
      // Arrange
      when(mockSharedPreferences.getString(any)).thenReturn(null);
      // Act
      //* Not calling the method here, just storing it inside a call variable
      final call = dataSourceImpl.getLastNumberTrivia;
      // Assert
      expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
    });
  });

  group('cacheNumberTrivia', () {
    const tNumberTriviaModel = NumberTriviaModel(text: 'Test Text', number: 1);

    test('Should call SharedPreferences to cache the data', () async {
      //! Arrange
      when(mockSharedPreferences.setString(any, any))
          .thenAnswer((_) async => true);
      //! Act
      dataSourceImpl.cacheNumberTrivia(tNumberTriviaModel);
      //! Assert
      final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
      verify(mockSharedPreferences.setString(
          CACHED_NUMBER_TRIVIA, expectedJsonString));
    });
  });
}
