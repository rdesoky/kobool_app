// singular instance
class EmptyArgs {
  factory EmptyArgs() => _instance;
  static final EmptyArgs _instance = EmptyArgs._(); //the singular instance
  EmptyArgs._() : _map = <String, dynamic>{};
  final Map<String, dynamic> _map;
  Map<String, dynamic> get instance =>
      _map; //accessing the singular instance via EmptyArgs().instance
}
