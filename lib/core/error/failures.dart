import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final List properties;
  const Failure([this.properties = const <dynamic>[]]);

  @override
  List<Object> get props => [properties];
}

//* GENERAL FAILURES

class ServerFailure extends Failure {}

class CacheFailure extends Failure {}
