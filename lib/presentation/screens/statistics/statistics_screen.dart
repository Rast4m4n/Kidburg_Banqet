import 'package:flutter/material.dart';
import 'package:kidburg_banquet/domain/model/statistic_model.dart';
import 'package:kidburg_banquet/generated/l10n.dart';
import 'package:kidburg_banquet/presentation/screens/statistics/statistic_view_model.dart';
import 'package:kidburg_banquet/presentation/theme/app_paddings.dart';
import 'package:kidburg_banquet/presentation/widgets/custom_drawer.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final vm = StatisticViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const CustomDrawer(),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              S.of(context).statistic,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
      body: FutureBuilder<StatisticModel?>(
        future: vm.loadStatisticFromSharedPref(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.data == null) {
              return Center(
                child: Text(
                  S.of(context).noDataForStatistic,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              );
            }
            final data = snapshot.data!;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _SumOfMonthStat(
                    sum: data.sum,
                  ),
                  _TotalGuestsStat(
                    guests: data.guests,
                  ),
                  _AverageOrderCheckStat(
                    averageOrderCheck: data.sum ~/ data.numberOfOrder,
                  ),
                  _ProfitBanqueter(
                    profit: data.sum * (2.5 / 100),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class _ProfitBanqueter extends StatefulWidget {
  const _ProfitBanqueter({
    required this.profit,
  });
  final double profit;

  @override
  State<_ProfitBanqueter> createState() => _ProfitBanqueterState();
}

class _ProfitBanqueterState extends State<_ProfitBanqueter>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation =
        IntTween(begin: 0, end: widget.profit.round()).animate(_controller)
          ..addListener(() {
            setState(() {});
          });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          S.of(context).profit,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: AppPadding.big),
        Text(
          '${_animation.value}${S.of(context).markCurrency}',
          style: Theme.of(context).textTheme.displaySmall,
        )
      ],
    );
  }
}

class _AverageOrderCheckStat extends StatefulWidget {
  const _AverageOrderCheckStat({
    required this.averageOrderCheck,
  });
  final int averageOrderCheck;

  @override
  State<_AverageOrderCheckStat> createState() => _AverageOrderCheckStatState();
}

class _AverageOrderCheckStatState extends State<_AverageOrderCheckStat>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation =
        IntTween(begin: 0, end: widget.averageOrderCheck).animate(_controller)
          ..addListener(() {
            setState(() {});
          });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          S.of(context).averageCheck,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: AppPadding.big),
        Text(
          '${_animation.value}${S.of(context).markCurrency}',
          style: Theme.of(context).textTheme.displaySmall,
        )
      ],
    );
  }
}

class _TotalGuestsStat extends StatefulWidget {
  const _TotalGuestsStat({
    required this.guests,
  });
  final int guests;

  @override
  State<_TotalGuestsStat> createState() => _TotalGuestsStatState();
}

class _TotalGuestsStatState extends State<_TotalGuestsStat>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = IntTween(begin: 0, end: widget.guests).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          S.of(context).totalNumberOfGuests,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: AppPadding.big),
        Text(
          '${_animation.value}',
          style: Theme.of(context).textTheme.displaySmall,
        )
      ],
    );
  }
}

class _SumOfMonthStat extends StatefulWidget {
  const _SumOfMonthStat({
    required this.sum,
  });
  final int sum;

  @override
  State<_SumOfMonthStat> createState() => _SumOfMonthStatState();
}

class _SumOfMonthStatState extends State<_SumOfMonthStat>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = IntTween(begin: 0, end: widget.sum).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          S.of(context).totalAmountForTheMonth,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: AppPadding.big),
        Text(
          '${_animation.value}${S.of(context).markCurrency}',
          style: Theme.of(context).textTheme.displaySmall,
        ),
      ],
    );
  }
}
