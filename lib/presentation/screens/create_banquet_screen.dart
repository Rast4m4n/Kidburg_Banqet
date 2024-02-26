import 'package:flutter/material.dart';
import 'package:kidburg_banquet/presentation/screens/create_banquet_vm.dart';
import 'package:kidburg_banquet/presentation/theme/app_paddings.dart';
import 'package:kidburg_banquet/presentation/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class CreateBanquetScreen extends StatelessWidget {
  CreateBanquetScreen({super.key});

  final CreateBanquetVM vm = CreateBanquetVM();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Кидбург банкеты',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppPadding.low),
        child: ChangeNotifierProvider(
          create: (context) => vm,
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomTextField(
                    controller: TextEditingController(),
                    maxWidth: 137,
                    maxHeight: 40,
                    hint: 'Имя заказчика',
                  ),
                  const _TextFieldDatePicker(),
                  CustomTextField(
                    controller: TextEditingController(),
                    maxWidth: 65,
                    maxHeight: 40,
                    hint: 'Дети',
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _TextFieldDatePicker extends StatelessWidget {
  const _TextFieldDatePicker({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final CreateBanquetVM vm = Provider.of<CreateBanquetVM>(context);
    final String isPickedDate = vm.selectedDate != null
        ? "${vm.selectedDate!.day}.${vm.selectedDate!.month}.${vm.selectedDate!.year}"
        : 'Дата мероприятия';

    return CustomTextField(
      controller: TextEditingController(),
      maxWidth: 160,
      maxHeight: 40,
      hint: isPickedDate,
      onTap: () => vm.showDate(context),
    );
  }
}
