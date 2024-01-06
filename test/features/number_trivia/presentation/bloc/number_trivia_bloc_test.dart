import 'package:flutter_test/flutter_test.dart';
import 'package:trivia/core/error/failures.dart';
import 'package:trivia/core/usecases/usecase.dart';
import 'package:trivia/core/utils/input_converter.dart';
import 'package:trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';

@GenerateMocks([GetConcreteNumberTrivia, GetRandomNumberTrivia, InputConverter])
import 'number_trivia_bloc_test.mocks.dart';

void main() {
  late NumberTriviaBloc bloc;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
        getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
        getRandomNumberTrivia: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter);
  });

  test('initialState should be Empty', () {
    // assert
    expect(bloc.state, equals(Empty()));
  });

  group('GetTriviaForConcreteNumber', () {
    const tNumberString = '3';
    const tNumberParsed = 3;
    const tNumberTrivia = NumberTrivia(number: 3, text: 'test trivia');
    setUp(() {
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => const Right(tNumberTrivia));
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(const Right(tNumberParsed));
    });
    test(
        'Should call the InputConverter to validate and convert the string to an unsigned integer',
        () async {
      //* Arrange
      //! Act
      bloc.add(const GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
      //! Assert
      verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
    });

    test('Should emit [Error] when the input is invalid', () async {
      //! Arrange
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Left(InvalidInputFailure()));
      //! Assert later
      final expected = [
        const Error(message: INVALID_INPUT_FAILURE_MESSAGE),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      //! Act
      bloc.add(const GetTriviaForConcreteNumber(tNumberString));
    });

    test('Should get data from the concrete use case', () async {
      //* Arrange
      //! Act
      bloc.add(const GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockGetConcreteNumberTrivia(any));
      //! Assert
      verify(mockGetConcreteNumberTrivia(const Params(number: tNumberParsed)));
    });

    test('Should emit [Loading, Loaded] when data is gotten successfully',
        () async {
      //! Arrange
      //! Assert later
      final expected = [
        Loading(),
        const Loaded(trivia: tNumberTrivia),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      //! Act
      bloc.add(const GetTriviaForConcreteNumber(tNumberString));
    });

    test('Should emit [Loading, Error] when getting data fails', () async {
      //! Arrange
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      //! Assert later
      final expected = [
        Loading(),
        const Error(message: SERVER_FAILURE_MESSAGE)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      //! Act
      bloc.add(const GetTriviaForConcreteNumber(tNumberString));
    });

    test(
        'Should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      //! Arrange
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      //! Assert later
      final expected = [Loading(), const Error(message: CACHE_FAILURE_MESSAGE)];
      expectLater(bloc.stream, emitsInOrder(expected));
      //! Act
      bloc.add(const GetTriviaForConcreteNumber(tNumberString));
    });
  });

  //! --------------------RANDOM-----------------------

  group('GetTriviaForRandomNumber', () {
    const tNumberTrivia = NumberTrivia(number: 3, text: 'test trivia');

    test('Should get data from the random use case', () async {
      // Arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => const Right(tNumberTrivia));
      // Act
      bloc.add(GetTriviaForRandomNumber());
      await untilCalled(mockGetRandomNumberTrivia(any));
      // Assert
      verify(mockGetRandomNumberTrivia(NoParams()));
    });

    test('Should emit [Loading, Loaded] when data is gotten successfully',
        () async {
      // Arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => const Right(tNumberTrivia));
      // Assert later
      final expected = [
        Loading(),
        const Loaded(trivia: tNumberTrivia),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // Act
      bloc.add(GetTriviaForRandomNumber());
    });
    test('Should emit [Loading, Error] when getting data fails', () async {
      // Arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      // Assert later
      final expected = [
        Loading(),
        const Error(message: SERVER_FAILURE_MESSAGE)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // Act
      bloc.add(GetTriviaForRandomNumber());
    });
    test(
        'Should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      // Arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      // Assert later
      final expected = [Loading(), const Error(message: CACHE_FAILURE_MESSAGE)];
      expectLater(bloc.stream, emitsInOrder(expected));
      // Act
      bloc.add(GetTriviaForRandomNumber());
    });
  });
}
