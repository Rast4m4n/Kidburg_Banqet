import 'package:excel/excel.dart';
import 'package:kidburg_banquet/domain/model/banqet_model.dart';
import 'package:kidburg_banquet/domain/model/category_model.dart';
import 'package:kidburg_banquet/domain/model/dish_model.dart';
import 'package:kidburg_banquet/domain/model/table_model.dart';
import 'package:kidburg_banquet/presentation/utils/date_time_formatter.dart';

class ExcelBuilder {
  ExcelBuilder({required this.sheet});

  final Sheet sheet;

  Future<void> writeNewExcelFile(BanqetModel banquet) async {
    int rowIndex = 8;
    _titleColumnCell(rowIndex);
    rowIndex += 1;
    final lastIndex = _listDishesAndServing(banquet, rowIndex);
    _leftHeaderInfo(sheet, banquet, lastIndex);
    _headerSizedBox(sheet);
    _rightHeaderInfo(sheet, banquet);
  }

  void _leftHeaderInfo(Sheet sheet, BanqetModel banquet, int lastIndexRow) {
    int rowIndex = 1;
    final border = Border(
      borderColorHex: '#000000',
      borderStyle: BorderStyle.Thin,
    );
    sheet.setColumnWidth(0, 20);
    final cellStyle = CellStyle(
      bold: true,
      backgroundColorHex: '#F7E88D',
      verticalAlign: VerticalAlign.Center,
      horizontalAlign: HorizontalAlign.Center,
      textWrapping: TextWrapping.Clip,
      bottomBorder: border,
      leftBorder: border,
      rightBorder: border,
      topBorder: border,
    );
    final Map<String, String> headerInfo = {
      'Мероприятие': 'День рождение',
      'Заказчик': banquet.nameClient,
      'Телефон': '',
      'Менеджер': '',
      'Контактный тел.': '',
      // lastIndexRow это самое последнее добавленное блюдо в в файл
      // Он необходим для подсчёта суммы всех блюд
      "Сумма заказа": 'SUM(F14:F$lastIndexRow)',
    };
    for (var el in headerInfo.entries) {
      sheet.cell(CellIndex.indexByString("A$rowIndex")).value =
          TextCellValue(el.key);

      if (el.key == 'Сумма заказа') {
        sheet.merge(
          CellIndex.indexByString("A$rowIndex"),
          CellIndex.indexByString("A${rowIndex + 1}"),
        );
      }
      sheet.cell(CellIndex.indexByString("A$rowIndex")).cellStyle =
          cellStyle.copyWith(
        horizontalAlignVal: HorizontalAlign.Left,
      );

      if (el.key == 'Сумма заказа') {
        sheet.cell(CellIndex.indexByString("B$rowIndex")).setFormula(el.value);
        sheet.merge(
          CellIndex.indexByString("B$rowIndex"),
          CellIndex.indexByString("B${rowIndex + 1}"),
        );
      } else {
        sheet.cell(CellIndex.indexByString("B$rowIndex")).value =
            TextCellValue(el.value);
      }
      sheet.cell(CellIndex.indexByString("B$rowIndex")).cellStyle = cellStyle;

      rowIndex += 1;
    }
  }

  void _rightHeaderInfo(Sheet sheet, BanqetModel banquet) {
    int rowIndex = 1;
    final border = Border(
      borderColorHex: '#000000',
      borderStyle: BorderStyle.Thin,
    );
    final cellStyle = CellStyle(
      bold: true,
      backgroundColorHex: '#F7E88D',
      verticalAlign: VerticalAlign.Center,
      horizontalAlign: HorizontalAlign.Center,
      textWrapping: TextWrapping.WrapText,
      bottomBorder: border,
      leftBorder: border,
      rightBorder: border,
      topBorder: border,
    );
    final Map<String, String> headerInfo = {
      'Заказ №': '',
      'Заказчик': DateTimeFormatter.convertToDDMMYYY(banquet.dateStart),
      'Время проведения': DateTimeFormatter.convertToUTC24StringFormat(
          banquet.firstTimeServing),
      'Место проведения': banquet.place,
      'Предоплата': '',
      'Кол-во детей': banquet.amountOfChildren.toString(),
      'Кол-во взрослых': banquet.amountOfAdult.toString(),
    };
    for (var el in headerInfo.entries) {
      sheet.cell(CellIndex.indexByString("D$rowIndex")).value =
          TextCellValue(el.key);
      sheet.merge(
        CellIndex.indexByString("D$rowIndex"),
        CellIndex.indexByString("E$rowIndex"),
      );
      sheet.cell(CellIndex.indexByString("D$rowIndex")).cellStyle =
          cellStyle.copyWith(
        horizontalAlignVal: HorizontalAlign.Left,
      );

      sheet.cell(CellIndex.indexByString("F$rowIndex")).value =
          TextCellValue(el.value);
      sheet.cell(CellIndex.indexByString("F$rowIndex")).cellStyle = cellStyle;

      rowIndex += 1;
    }
  }

  int _listDishesAndServing(BanqetModel banquet, int rowIndex) {
    for (var table in banquet.tables!) {
      _tableNameCell(table, rowIndex, banquet);
      rowIndex += 1;
      for (var category in table.categories) {
        _categoryNameCell(rowIndex, category);
        rowIndex += 1;
        for (var dish in category.dishes) {
          // Название блюда
          _nameDishCell(sheet, rowIndex, dish);
          //Вес блюда
          _weightDishCell(sheet, rowIndex, dish);
          //Количество блюд
          _counDishCell(sheet, rowIndex, dish);
          // Цена блюда
          _priceDishCell(sheet, rowIndex, dish);
          // Формула подсчёта суммы
          _formulaSumCell(sheet, rowIndex);
          rowIndex += 1;
        }
      }
    }
    return rowIndex;
  }

  void _tableNameCell(TableModel table, int rowIndex, BanqetModel banquet) {
    final border = Border(
      borderColorHex: '#000000',
      borderStyle: BorderStyle.Thin,
    );
    final secondServing =
        DateTimeFormatter.calculateNextServingTime(banquet.firstTimeServing);
    if (table.name == 'СТОЛ ДЛЯ ВЗРОСЛЫХ') {
      sheet.cell(CellIndex.indexByString('A$rowIndex')).value = TextCellValue(
        "${table.name} ${DateTimeFormatter.convertToUTC24StringFormat(banquet.firstTimeServing)}",
      );
    } else {
      sheet.cell(CellIndex.indexByString('A$rowIndex')).value = TextCellValue(
          "${table.name} ${DateTimeFormatter.convertToUTC24StringFormat(secondServing)}");
    }

    sheet.merge(
      CellIndex.indexByString('A$rowIndex'),
      CellIndex.indexByString('F$rowIndex'),
    );
    sheet.cell(CellIndex.indexByString('A$rowIndex')).cellStyle = CellStyle(
      fontSize: 18,
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
      bold: true,
      backgroundColorHex: '#F7E88D',
      bottomBorder: border,
      leftBorder: border,
      rightBorder: border,
      topBorder: border,
    );
  }

  void _categoryNameCell(int rowIndex, CategoryModel category) {
    final border = Border(
      borderColorHex: '#000000',
      borderStyle: BorderStyle.Thin,
    );
    sheet.cell(CellIndex.indexByString('A$rowIndex')).value =
        TextCellValue(category.name);

    sheet.merge(
      CellIndex.indexByString('A$rowIndex'),
      CellIndex.indexByString('F$rowIndex'),
    );
    sheet.cell(CellIndex.indexByString('A$rowIndex')).cellStyle = CellStyle(
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
      bold: true,
      backgroundColorHex: '#99FFCC',
      bottomBorder: border,
      leftBorder: border,
      rightBorder: border,
      topBorder: border,
    );
  }

  void _titleColumnCell(int rowIndex) {
    final border = Border(
      borderColorHex: '#000000',
      borderStyle: BorderStyle.Thin,
    );
    final cellStyle = CellStyle(
      verticalAlign: VerticalAlign.Center,
      bold: true,
      horizontalAlign: HorizontalAlign.Center,
      backgroundColorHex: '#F7E88D',
      bottomBorder: border,
      leftBorder: border,
      rightBorder: border,
      topBorder: border,
    );
    sheet.cell(CellIndex.indexByString('A$rowIndex')).value =
        const TextCellValue('Наименование');
    sheet.cell(CellIndex.indexByString('A$rowIndex')).cellStyle =
        cellStyle.copyWith(
      horizontalAlignVal: HorizontalAlign.Left,
    );
    sheet.merge(
      CellIndex.indexByString('A$rowIndex'),
      CellIndex.indexByString('B$rowIndex'),
    );

    sheet.cell(CellIndex.indexByString('C$rowIndex')).value =
        const TextCellValue('Вес');
    sheet.cell(CellIndex.indexByString('C$rowIndex')).cellStyle = cellStyle;
    sheet.cell(CellIndex.indexByString('D$rowIndex')).value =
        const TextCellValue('Кол-во');
    sheet.cell(CellIndex.indexByString('D$rowIndex')).cellStyle = cellStyle;
    sheet.cell(CellIndex.indexByString('E$rowIndex')).value =
        const TextCellValue('Цена');
    sheet.cell(CellIndex.indexByString('E$rowIndex')).cellStyle = cellStyle;
    sheet.cell(CellIndex.indexByString('F$rowIndex')).value =
        const TextCellValue('Сумма');
    sheet.cell(CellIndex.indexByString('F$rowIndex')).cellStyle = cellStyle;
  }

  void _formulaSumCell(Sheet sheet, int rowIndex) {
    final border = Border(
      borderColorHex: '#000000',
      borderStyle: BorderStyle.Thin,
    );
    sheet.cell(CellIndex.indexByString('F$rowIndex')).setFormula(
          'SUM(D$rowIndex*E$rowIndex)',
        );
    sheet.cell(CellIndex.indexByString('F$rowIndex')).cellStyle = CellStyle(
      verticalAlign: VerticalAlign.Center,
      horizontalAlign: HorizontalAlign.Center,
      bottomBorder: border,
      leftBorder: border,
      rightBorder: border,
      topBorder: border,
    );
  }

  void _priceDishCell(Sheet sheet, int rowIndex, DishModel dish) {
    final border = Border(
      borderColorHex: '#000000',
      borderStyle: BorderStyle.Thin,
    );
    sheet.cell(CellIndex.indexByString('E$rowIndex')).value =
        IntCellValue(int.parse(dish.price!));

    sheet.cell(CellIndex.indexByString('E$rowIndex')).cellStyle = CellStyle(
      numberFormat: NumFormat.defaultNumeric,
      // NumFormat.custom(formatCode: '#,##0 ₽'),
      verticalAlign: VerticalAlign.Center,
      horizontalAlign: HorizontalAlign.Center,
      bottomBorder: border,
      leftBorder: Border(
        borderColorHex: '#FF0000',
        borderStyle: BorderStyle.Thin,
      ),
      rightBorder: border,
      topBorder: border,
    );
  }

  void _counDishCell(Sheet sheet, int rowIndex, DishModel dish) {
    final border = Border(
      borderColorHex: '#FF0000',
      borderStyle: BorderStyle.Thin,
    );
    sheet.cell(CellIndex.indexByString('D$rowIndex')).value =
        IntCellValue(dish.count!);
    sheet.cell(CellIndex.indexByString('D$rowIndex')).cellStyle = CellStyle(
      numberFormat: NumFormat.defaultNumeric,
      verticalAlign: VerticalAlign.Center,
      horizontalAlign: HorizontalAlign.Center,
      bottomBorder: border,
      leftBorder: border,
      rightBorder: border,
      topBorder: border,
    );
  }

  void _weightDishCell(Sheet sheet, int rowIndex, DishModel dish) {
    final border = Border(
      borderColorHex: '#000000',
      borderStyle: BorderStyle.Thin,
    );
    sheet.cell(CellIndex.indexByString('C$rowIndex')).value =
        TextCellValue("${dish.weight!}г");
    sheet.cell(CellIndex.indexByString("C$rowIndex")).cellStyle = CellStyle(
      verticalAlign: VerticalAlign.Center,
      horizontalAlign: HorizontalAlign.Center,
      bottomBorder: border,
      leftBorder: border,
      rightBorder: Border(
        borderColorHex: '#FF0000',
        borderStyle: BorderStyle.Thin,
      ),
      topBorder: border,
    );
  }

  void _nameDishCell(Sheet sheet, int rowIndex, DishModel dish) {
    final border = Border(
      borderColorHex: '#000000',
      borderStyle: BorderStyle.Thin,
    );
    sheet.cell(CellIndex.indexByString('A$rowIndex')).value =
        TextCellValue(dish.nameDish!);
    sheet.cell(CellIndex.indexByString('A$rowIndex')).cellStyle = CellStyle(
      textWrapping: TextWrapping.WrapText,
      bottomBorder: border,
      leftBorder: border,
      rightBorder: border,
      topBorder: border,
    );
    sheet.merge(
      CellIndex.indexByString('A$rowIndex'),
      CellIndex.indexByString('B$rowIndex'),
    );
  }

  void _headerSizedBox(Sheet sheet) {
    final border = Border(
      borderColorHex: '#000000',
      borderStyle: BorderStyle.Thin,
    );
    sheet.merge(CellIndex.indexByString("C1"), CellIndex.indexByString("C7"));
    sheet.cell(CellIndex.indexByString('C1')).cellStyle = CellStyle(
      bottomBorder: border,
      leftBorder: border,
      rightBorder: border,
      topBorder: border,
    );
  }
}
