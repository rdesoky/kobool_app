import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class UserView extends HookWidget {
  final int index;
  final Map<String, dynamic> props;
  const UserView({super.key, required this.index, required this.props});

  @override
  Widget build(BuildContext context) {
    // final userResult = useState<String>(''); // Initialize with an empty string

    final login = props['login_id'] ?? '';
    final age = props['age'] ?? props['ag'] ?? '';
    final title = props['ad_title'] ?? '';
    final self_desc = props['self_desc'] ?? '';
    final mate_desc = props['mate_desc'] ?? '';
    final gender = props['gender'] ?? '';
    final isMale = gender == "0";

    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Card(
        child: SizedBox(
          width: 600,
          // height: double.infinity,
          // constraints: BoxConstraints(minHeight: 120),
          child: ListTile(
            isThreeLine: true,
            minTileHeight: 120,
            leading: Icon(Icons.person),
            iconColor: isMale ? Colors.blue : Colors.pink,
            title: Row(
              spacing: 12,
              children: [
                SizedBox(
                  width: 100,
                  child: Text(
                    login.toString(),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Text(
                    title.toString(),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: colorScheme.tertiary),
                  ),
                ),
              ],
            ),
            subtitle: Column(
              spacing: 12,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: 6,
                  children: [
                    isMale ? Icon(Icons.male) : Icon(Icons.female),
                    Text('Age: ${age.toString()}'),
                  ],
                ),
                Text(
                  self_desc.toString(),
                  style: TextStyle(color: colorScheme.tertiary),
                ),
                Text(mate_desc.toString()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
