import 'package:flutter/material.dart';
import 'package:kidburg_banquet/presentation/screens/preorder_form/vm/dish_vm.dart';
import 'package:kidburg_banquet/presentation/theme/app_paddings.dart';
import 'package:kidburg_banquet/presentation/theme/app_theme.dart';
import 'package:kidburg_banquet/presentation/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class RowDish extends StatelessWidget {
  const RowDish({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DishViewModel>();
    final totalPrice = vm.totalPrice != 0 ? "${vm.totalPrice}" : null;
    return Column(
      children: [
        const SizedBox(height: AppPadding.low),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 2,
                child: _InfoDishBoxWidget(
                  name: vm.dish.nameDish!,
                ),
              ),
              const SizedBox(width: AppPadding.low),
              Expanded(
                flex: 1,
                child: CustomTextField(
                  textAlign: TextAlign.center,
                  floatingLabelAlignment: FloatingLabelAlignment.center,
                  onChanged: (value) {
                    vm.updateCount(
                      (int.tryParse(value) ?? 0).toString(),
                    );
                  },
                  label: 'Кол-во',
                ),
              ),
              const SizedBox(width: AppPadding.low),
              Expanded(
                flex: 2,
                child: PriceBoxWidget(totalPrice: totalPrice),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppPadding.low),
      ],
    );
  }
}

class PriceBoxWidget extends StatelessWidget {
  const PriceBoxWidget({
    super.key,
    required this.totalPrice,
  });

  final String? totalPrice;

  @override
  Widget build(BuildContext context) {
    final InputDecorationTheme textFieldTheme =
        Theme.of(context).inputDecorationTheme;
    return TextField(
      maxLines: null,
      minLines: null,
      expands: true,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        floatingLabelAlignment: FloatingLabelAlignment.center,
        labelText: 'Сумма',
        enabledBorder: textFieldTheme.border,
        focusedBorder: InputBorder.none,
        filled: true,
        fillColor: AppColor.textFieldColor,
        border: InputBorder.none,
      ),
      readOnly: true,
      controller: TextEditingController(
        text: totalPrice,
      ),
    );
  }
}

class _InfoDishBoxWidget extends StatelessWidget {
  const _InfoDishBoxWidget({
    super.key,
    required this.name,
  });
  final String name;
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColor.textFieldColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.low),
        child: Text(name),
      ),
    );
  }
}
