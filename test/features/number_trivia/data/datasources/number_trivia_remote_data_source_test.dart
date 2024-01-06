import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:trivia/core/error/exeptions.dart';
import 'package:trivia/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:trivia/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';
@GenerateMocks([http.Client])
import 'number_trivia_remote_data_source_test.mocks.dart';

void main() {
  late NumberTriviaRemoteDataSourceImpl dataSourceImpl;
  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    dataSourceImpl = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test('''Should perform a GET request on URL with number
     being the endpoint and with application/json header''', () async {
      // Arrange
      setUpMockHttpClientSuccess200();
      // Act
      dataSourceImpl.getConcreteNumberTrivia(tNumber);
      // Assert
      verify(mockHttpClient.get(
        Uri.parse('http://numbersapi.com/$tNumber'),
        headers: {'Content-Type': 'application/json'},
      ));
    });

    test('Should return NumberTrivia when the response code is 200 (success)',
        () async {
      // Arrange
      setUpMockHttpClientSuccess200();
      // Act
      final result = await dataSourceImpl.getConcreteNumberTrivia(tNumber);
      // Assert
      expect(result, equals(tNumberTriviaModel));
    });

    test(
        'Should throw a ServerException when the response code is 404 or other',
        () async {
      // Arrange
      setUpMockHttpClientFailure404();
      // Act
      final call = dataSourceImpl.getConcreteNumberTrivia;
      // Assert
      expect(() => call(tNumber), throwsA(isA<ServerException>()));
    });
  });

  //! -----------------RANDOM NUMBER TRIVIA--------------------
    group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test('''Should perform a GET request on URL with number
     being the endpoint and with application/json header''', () async {
      // Arrange
      setUpMockHttpClientSuccess200();
      // Act
      dataSourceImpl.getRandomNumberTrivia();
      // Assert
      verify(mockHttpClient.get(
        Uri.parse('http://numbersapi.com/random'),
        headers: {'Content-Type': 'application/json'},
      ));
    });

    test('Should return NumberTrivia when the response code is 200 (success)',
        () async {
      // Arrange
      setUpMockHttpClientSuccess200();
      // Act
      final result = await dataSourceImpl.getRandomNumberTrivia();
      // Assert
      expect(result, equals(tNumberTriviaModel));
    });

    test(
        'Should throw a ServerException when the response code is 404 or other',
        () async {
      // Arrange
      setUpMockHttpClientFailure404();
      // Act
      final call = dataSourceImpl.getRandomNumberTrivia;
      // Assert
      expect(() => call(), throwsA(isA<ServerException>()));
    });
  });

}
