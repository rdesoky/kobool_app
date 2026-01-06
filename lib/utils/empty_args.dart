class EmptyArgs {
  static Map<String, dynamic> get instance => EmptyArgs()._map;
  final Map<String, dynamic> _map;
  EmptyArgs() : _map = {};
}
