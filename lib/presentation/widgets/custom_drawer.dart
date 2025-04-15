import 'package:flutter/material.dart';
import 'package:kidburg_banquet/generated/l10n.dart';
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
          title: Text(S.of(context).placeAnOrder),
          leading: const Icon(Icons.home),
          onTap: () => Navigator.of(context).pushNamed(AppRoute.mainPage),
        ),
        ListTile(
          title: Text(S.of(context).listOfBanquets),
          leading: const Icon(Icons.subject),
          onTap: () =>
              Navigator.of(context).pushNamed(AppRoute.listBanquetPage),
        ),
        ListTile(
          title: Text(S.of(context).statistic),
          leading: const Icon(Icons.bar_chart_rounded),
          onTap: () => Navigator.of(context).pushNamed(AppRoute.statisticPage),
        ),
        ListTile(
          title: Text(S.of(context).profile),
          leading: const Icon(Icons.person),
          onTap: () =>
              Navigator.of(context).pushNamed(AppRoute.selectionKidburgPage),
        ),
      ],
    );
  }
}
