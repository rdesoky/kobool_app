//legacy providers, initialized in main.dart overrides
import 'package:flutter_riverpod/legacy.dart';

//initialized from shared_preferences in main.dart overrides
final localeProvider = StateProvider<String?>((ref) => null);
