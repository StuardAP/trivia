import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:trivia/core/network/network.dart';
import 'package:trivia/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:trivia/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:trivia/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';

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

  test('Should ', () async {
    // Arrange

    // Act

    // Assert
  });
}
