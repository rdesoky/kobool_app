//legacy providers, initialized in main.dart overrides
import 'package:flutter_riverpod/legacy.dart';

//StateProvider<T> bundles notifier and state into a single provider
final localeProvider = StateProvider<String?>(
  (ref) => null,
); //null is initialized from shared_preferences in main.dart overrides
