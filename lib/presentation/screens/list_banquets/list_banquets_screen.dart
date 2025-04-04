import 'package:flutter/material.dart';
import 'package:kidburg_banquet/presentation/widgets/custom_drawer.dart';

class ListBanquetsScreen extends StatelessWidget {
  const ListBanquetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const CustomDrawer(),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Список банкетов',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
      body: const Column(),
    );
  }
}
