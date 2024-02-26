import 'package:flutter/material.dart';
import 'package:kidburg_banquet/presentation/theme/app_paddings.dart';
import 'package:kidburg_banquet/presentation/widgets/custom_text_field.dart';

class CreateBanquetScreen extends StatelessWidget {
  const CreateBanquetScreen({super.key});

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
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomTextField(
                  controller: TextEditingController(),
                  maxWidth: 137,
                  maxHeight: 40,
                  label: const Text('Имя заказчика'),
                ),
                _TextFieldDatePicker(),
                CustomTextField(
                  controller: TextEditingController(),
                  maxWidth: 65,
                  maxHeight: 40,
                  label: const Text('Дети'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _TextFieldDatePicker extends StatefulWidget {
  const _TextFieldDatePicker({
    super.key,
  });

  @override
  State<_TextFieldDatePicker> createState() => _TextFieldDatePickerState();
}

class _TextFieldDatePickerState extends State<_TextFieldDatePicker> {
  DateTime selectedDate = DateTime.now();

  Future<void> _showDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print(selectedDate);
    return CustomTextField(
      controller: TextEditingController(),
      maxWidth: 140,
      maxHeight: 40,
      label: const Text('Дата мероприятия'),
      onTap: () async => _showDate(context),
    );
  }
}
