import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class UserResultView extends HookWidget {
  final int index;
  final Map<String, dynamic> props;
  const UserResultView({super.key, required this.index, required this.props});

  @override
  Widget build(BuildContext context) {
    // final userResult = useState<String>(''); // Initialize with an empty string

    final login = props['login_id'] ?? '';
    final age = props['age'] ?? props['ag'] ?? '';
    final title = props['ad_title'] ?? '';
    final gender = props['gender'] ?? '';

    return ListTile(
      leading: Icon(Icons.person),
      iconColor: gender == "0" ? Colors.blue : Colors.pink,
      trailing: gender == "0" ? Icon(Icons.male) : Icon(Icons.female),
      title: Text(login.toString()),
      subtitle: Text('Age: ${age.toString()}, ${title.toString()}'),
    );
    ;
  }
}
