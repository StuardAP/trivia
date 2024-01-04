import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final List properties;
  const Failure([this.properties = const <dynamic>[]]);

  @override
  List<Object> get props => [properties];
}

//* GENERAL FAILURES

class ServerFailure extends Equatable {
  @override
  List<Object> get props => [];
}

class CacheFailure extends Equatable {
  @override
  List<Object> get props => [];
}
