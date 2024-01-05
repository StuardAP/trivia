abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl extends NetworkInfo{

  @override
  Future<bool> get isConnected async => false;

}
