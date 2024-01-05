import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:trivia/core/error/exeptions.dart';
import 'package:trivia/core/error/failures.dart';
import 'package:trivia/core/network/network.dart';
import 'package:trivia/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:trivia/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:trivia/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:trivia/features/number_trivia/domain/entities/number_trivia.dart';

@GenerateMocks(
    [NumberTriviaLocalDataSource, NumberTriviaRemoteDataSource, NetworkInfo])
import 'number_trivia_repository_impl_test.mocks.dart';

void main() {
  late NumberTriviaRepositoryImpl repositoryImpl;
  late MockNumberTriviaLocalDataSource mockNumberTriviaLocalDataSource;
  late MockNumberTriviaRemoteDataSource mockNumberTriviaRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;
  setUp(() {
    mockNetworkInfo = MockNetworkInfo();
    mockNumberTriviaLocalDataSource = MockNumberTriviaLocalDataSource();
    mockNumberTriviaRemoteDataSource = MockNumberTriviaRemoteDataSource();
    repositoryImpl = NumberTriviaRepositoryImpl(
        networkInfo: mockNetworkInfo,
        localDataSource: mockNumberTriviaLocalDataSource,
        remoteDataSource: mockNumberTriviaRemoteDataSource);
  });

  void runTestsOnline(Function body) {
   group('Device is Offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  void runTestsOffline(Function body) {
    group('Device is Offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      body();
    });
  }

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    const tNumberTriviaModel =
        NumberTriviaModel(text: 'Test Text', number: tNumber);
    const NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test('Should check if device is online', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(any))
          .thenAnswer((_) async => tNumberTriviaModel);
      // Act
      await repositoryImpl.getConcreteNumberTrivia(tNumber);
      // Assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
          'Should return remote data when the call to remote data source is sucessful',
          () async {
        // Arrange
        when(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);
        // Act
        final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);
        // Assert
        verify(
            mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber));
        expect(result, equals(const Right(tNumberTrivia)));
      });
      test(
          'Should cache the data locally when the call to remote data source is successful',
          () async {
        // Arrange
        when(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .thenAnswer((_) async => tNumberTriviaModel);
        // Act
        await repositoryImpl.getConcreteNumberTrivia(tNumber);
        // Assert
        verify(
            mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verify(mockNumberTriviaLocalDataSource
            .cacheNumberTrivia(tNumberTriviaModel));
      });
      test(
          'Should return server failure when the call to remote data source is unsuccessful',
          () async {
        // Arrange
        when(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .thenThrow(ServerException());
        // Act
        final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);
        // Assert
        verify(
            mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verifyZeroInteractions(mockNumberTriviaLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    //! OFFLINE
    runTestsOffline(() {
      test(
          'Should return last locally cached data when the cached data is present',
          () async {
        //! Arrange
        when(mockNumberTriviaLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        //! Act
        final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);
        //! Assert
        verifyZeroInteractions(mockNumberTriviaRemoteDataSource);
        verify(mockNumberTriviaLocalDataSource.getLastNumberTrivia());
        expect(result, equals(const Right(tNumberTrivia)));
      });
      test('Should return CacheFailure when there is no cached data present',
          () async {
        //! Arrange
        when(mockNumberTriviaLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());
        //! Act
        final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);
        //! Assert
        verifyZeroInteractions(mockNumberTriviaRemoteDataSource);
        verify(mockNumberTriviaLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });

//! RANDOM NUMBER TRIVIA
  group('getRandomNumberTrivia', () {
    const tNumberTriviaModel = NumberTriviaModel(text: 'Test Text', number: 1);
    const NumberTrivia tNumberTrivia = tNumberTriviaModel;

      test('Should check if device is online', () async {
        // Arrange
        when(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // Act
        await repositoryImpl.getRandomNumberTrivia();
        // Assert
        verify(mockNetworkInfo.isConnected);
      });

    //* ONLINE
    runTestsOnline(() {
      test(
          'Should return remote data when the call to remote data source is successful',
          () async {
        // Arrange
        when(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        // Act
        final result = await repositoryImpl.getRandomNumberTrivia();
        // Assert
        verify(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia());
        expect(result, equals(const Right(tNumberTrivia)));
      });
      test(
          'Should cache the data locally when the call to remote data source is successful',
          () async {
        // Arrange
        when(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        // Act
        await repositoryImpl.getRandomNumberTrivia();
        // Assert
        verify(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia());
        verify(mockNumberTriviaLocalDataSource
            .cacheNumberTrivia(tNumberTriviaModel));
      });
      test(
          'Should return server failure when the call to remote data source is unsuccessful',
          () async {
        // Arrange
        when(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia())
            .thenThrow(ServerException());
        // Act
        final result = await repositoryImpl.getRandomNumberTrivia();
        // Assert
        verify(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia());
        verifyZeroInteractions(mockNumberTriviaLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });
    //! OFFLINE
    runTestsOffline(() {
      test(
          'Should return last locally cached data when the cached data is present',
          () async {
        //! Arrange
        when(mockNumberTriviaLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        //! Act
        final result = await repositoryImpl.getRandomNumberTrivia();
        //! Assert
        verifyZeroInteractions(mockNumberTriviaRemoteDataSource);
        verify(mockNumberTriviaLocalDataSource.getLastNumberTrivia());
        expect(result, equals(const Right(tNumberTrivia)));
      });
      test('Should return CacheFailure when there is no cached data present',
          () async {
        //! Arrange
        when(mockNumberTriviaLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());
        //! Act
        final result = await repositoryImpl.getRandomNumberTrivia();
        //! Assert
        verifyZeroInteractions(mockNumberTriviaRemoteDataSource);
        verify(mockNumberTriviaLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });
}
