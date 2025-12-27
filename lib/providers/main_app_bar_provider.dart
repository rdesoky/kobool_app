//legacy providers, initialized in main.dart overrides
import 'package:flutter_riverpod/legacy.dart';

//StateProvider<T> bundles notifier and state into a single provider
final mainAppBarProvider = StateProvider<bool>((ref) => true);
