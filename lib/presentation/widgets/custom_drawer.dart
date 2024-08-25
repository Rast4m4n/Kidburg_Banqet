import 'package:flutter/material.dart';
import 'package:kidburg_banquet/presentation/navigation/app_route.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      children: [
        ListTile(
          title: const Text('Оформить заказ'),
          leading: const Icon(Icons.home),
          onTap: () => Navigator.of(context).pushNamed(AppRoute.mainPage),
        ),
        ListTile(
          title: const Text('Список банкетов'),
          leading: const Icon(Icons.subject),
          onTap: () =>
              Navigator.of(context).pushNamed(AppRoute.listBanquetPage),
        ),
        ListTile(
          title: const Text('Статистика'),
          leading: const Icon(Icons.bar_chart_rounded),
          onTap: () => Navigator.of(context).pushNamed(AppRoute.statisticPage),
        ),
        ListTile(
          title: const Text('Профиль'),
          leading: const Icon(Icons.person),
          onTap: () =>
              Navigator.of(context).pushNamed(AppRoute.selectionKidburgPage),
        ),
      ],
    );
  }
}
