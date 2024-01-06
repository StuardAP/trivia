import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/input_converter.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/usecases/get_concrete_number_trivia.dart';
import '../../domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
 final GetConcreteNumberTrivia getConcreteNumberTrivia;
 final GetRandomNumberTrivia getRandomNumberTrivia;
 final InputConverter inputConverter;

 NumberTriviaBloc({
  required this.getConcreteNumberTrivia,
  required this.getRandomNumberTrivia,
  required this.inputConverter,
 }) : super(Empty()) {
   on<GetTriviaForConcreteNumber>(_onGetTriviaForConcreteNumber);
   on<GetTriviaForRandomNumber>(_onGetTriviaForRandomNumber);
 }

 Future<void> _onGetTriviaForConcreteNumber(
   GetTriviaForConcreteNumber event,
   Emitter<NumberTriviaState> emit,
 ) async {
   final inputEither =
       inputConverter.stringToUnsignedInteger(event.numberString);

   await inputEither.fold(
     (failure) async {
       emit(const Error(message: INVALID_INPUT_FAILURE_MESSAGE));
     },
     (integer) async {
       emit(Loading());
       final failureOrTrivia =
           await getConcreteNumberTrivia(Params(number: integer));
       await _eitherLoadedOrErrorState(failureOrTrivia, emit);
     },
   );
 }

 Future<void> _onGetTriviaForRandomNumber(
   GetTriviaForRandomNumber event,
   Emitter<NumberTriviaState> emit,
 ) async {
   emit(Loading());
   final failureOrTrivia = await getRandomNumberTrivia(NoParams());
   await _eitherLoadedOrErrorState(failureOrTrivia, emit);
 }

 Future<void> _eitherLoadedOrErrorState(
   Either<Failure, NumberTrivia> failureOrTrivia,
   Emitter<NumberTriviaState> emit,
 ) async {
   await failureOrTrivia.fold(
     (failure) async {
       emit(Error(message: _mapFailureToMessage(failure)));
     },
     (trivia) async {
       emit(Loaded(trivia: trivia));
     },
   );
 }

 String _mapFailureToMessage(Failure failure) {
   switch (failure.runtimeType) {
     case ServerFailure:
       return SERVER_FAILURE_MESSAGE;
     case CacheFailure:
       return CACHE_FAILURE_MESSAGE;
     default:
       return 'Unexpected error';
   }
 }
}
