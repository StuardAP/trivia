import '../models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDataSource {
  /// Call http://numberapi.com/{number} endpoint
  ///
  /// Throws a [ServerException] for all error code.
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  /// Call http://numberapi.com/random endpoint
  ///
  /// Throws a [ServerException] for all error code.
  Future<NumberTriviaModel> getRandomNumberTrivia();
}
