import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kobool/widgets/user_list.dart';

class Results extends HookWidget {
  const Results({super.key});

  @override
  Widget build(BuildContext context) {
    var page = useState(0);

    return Scaffold(
      appBar: AppBar(title: const Text('Active members'), centerTitle: false),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: UserList(page: page.value)),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                spacing: 12,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (page.value > 0)
                    ElevatedButton(
                      onPressed: () {
                        page.value = page.value - 1;
                      },
                      child: Text("Previous page"),
                    ),
                  ElevatedButton(
                    onPressed: () {
                      page.value = page.value + 1;
                    },
                    child: Text("Next page"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
