import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:trivia/core/network/network_info.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

@GenerateMocks([InternetConnectionChecker])
import 'network_info_test.mocks.dart';

void main() {
  late NetworkInfoImpl networkInfoImpl;
  late MockInternetConnectionChecker mockInternetConnectionChecker;

  setUp(() {
    mockInternetConnectionChecker = MockInternetConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(mockInternetConnectionChecker);
  });

  test('Should forward the call to DataConnectionChecker.hasConnection', () async {
    // Arrange
    final tHasConnectionFuture = Future.value(true);
    when(mockInternetConnectionChecker.hasConnection)
        .thenAnswer((_) async => tHasConnectionFuture);
    // Act
    final result = await networkInfoImpl.isConnected;
    // Assert
    expect(result,true);
  });
}
