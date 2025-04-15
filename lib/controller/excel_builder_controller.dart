import 'package:excel/excel.dart';
import 'package:flutter/material.dart' show BuildContext;
import 'package:intl/intl.dart';
import 'package:kidburg_banquet/domain/model/banqet_model.dart';
import 'package:kidburg_banquet/domain/model/category_model.dart';
import 'package:kidburg_banquet/domain/model/dish_model.dart';
import 'package:kidburg_banquet/domain/model/table_model.dart';
import 'package:kidburg_banquet/generated/l10n.dart';
import 'package:kidburg_banquet/presentation/utils/date_time_formatter.dart';

class ExcelBuilderController {
  ExcelBuilderController({required this.sheet});

  final Sheet sheet;

  Future<void> writeNewExcelFile(
    BanquetModel banquet,
    BuildContext context,
  ) async {
    int rowIndex = 8;
    sheet.setColumnWidth(0, 19);
    sheet.setColumnWidth(1, 18);
    sheet.setColumnWidth(3, 11);
    sheet.setColumnWidth(4, 11);
    sheet.setColumnWidth(5, 13);
    sheet.setColumnWidth(6, 10);
    _titleColumnCell(rowIndex, context);
    rowIndex += 1;

    int lastIndex = _listDishesAndServing(banquet, rowIndex);
    _leftHeaderInfo(sheet, banquet, lastIndex, context);
    _headerSizedBoxCell(sheet);
    _rightHeaderInfo(sheet, banquet, context);
    _remarkOfbanquetCell(sheet, banquet, lastIndex, context);
    lastIndex += 1;
    _cakeCell(sheet, banquet, lastIndex, context);
  }

  void _leftHeaderInfo(
    Sheet sheet,
    BanquetModel banquet,
    int lastIndexRow,
    BuildContext context,
  ) {
    int rowIndex = 1;
    final border = Border(
      borderColorHex: ExcelColor.fromHexString('#000000'),
      borderStyle: BorderStyle.Thin,
    );

    final cellStyle = CellStyle(
      fontFamily: 'Corbel',
      fontSize: 13,
      bold: true,
      backgroundColorHex: ExcelColor.fromHexString('#FFF2CC'),
      verticalAlign: VerticalAlign.Center,
      horizontalAlign: HorizontalAlign.Center,
      textWrapping: TextWrapping.Clip,
      bottomBorder: border,
      leftBorder: border,
      rightBorder: border,
      topBorder: border,
    );
    final Map<String, dynamic> headerInfo = {
      S.of(context).event: 'День рождение',
      S.of(context).customer: banquet.nameClient,
      S.of(context).customerPhoneNumber: banquet.phoneNumberOfClient ?? '',
      S.of(context).managerName: banquet.managerModel.name,
      S.of(context).managerPhoneNumber: banquet.managerModel.phoneNumber,
      // lastIndexRow это самое последнее добавленное блюдо в файл
      // Он необходим для подсчёта суммы всех блюд
      S.of(context).totalSum: 'SUM(F11:F$lastIndexRow)-F5',
    };
    for (var el in headerInfo.entries) {
      sheet.cell(CellIndex.indexByString("A$rowIndex")).value =
          TextCellValue(el.key);

      if (el.key == S.of(context).totalSum) {
        sheet.merge(
          CellIndex.indexByString("A$rowIndex"),
          CellIndex.indexByString("A${rowIndex + 1}"),
        );
        sheet.cell(CellIndex.indexByString("A${rowIndex + 1}")).cellStyle =
            cellStyle;
      }
      sheet.cell(CellIndex.indexByString("A$rowIndex")).cellStyle =
          cellStyle.copyWith(
        horizontalAlignVal: HorizontalAlign.Left,
      );

      if (el.key == S.of(context).totalSum) {
        sheet.cell(CellIndex.indexByString("B$rowIndex")).setFormula(el.value);

        sheet.merge(
          CellIndex.indexByString("B$rowIndex"),
          CellIndex.indexByString("B${rowIndex + 1}"),
        );
        sheet.setMergedCellStyle(
          CellIndex.indexByString('B$rowIndex'),
          cellStyle.copyWith(
            fontColorHexVal: ExcelColor.fromHexString('#FF0101'),
            fontSizeVal: 16,
          ),
        );
      } else {
        sheet.cell(CellIndex.indexByString("B$rowIndex")).value =
            TextCellValue(el.value);
        sheet.cell(CellIndex.indexByString("B$rowIndex")).cellStyle = cellStyle;
      }

      rowIndex += 1;
    }
  }

  void _rightHeaderInfo(
      Sheet sheet, BanquetModel banquet, BuildContext context) {
    int rowIndex = 1;
    final border = Border(
      borderColorHex: ExcelColor.fromHexString('#000000'),
      borderStyle: BorderStyle.Thin,
    );
    final cellStyle = CellStyle(
      fontFamily: 'Corbel',
      fontSize: 13,
      bold: true,
      backgroundColorHex: ExcelColor.fromHexString('#FFF2CC'),
      verticalAlign: VerticalAlign.Center,
      horizontalAlign: HorizontalAlign.Center,
      textWrapping: TextWrapping.WrapText,
      bottomBorder: border,
      leftBorder: border,
      rightBorder: border,
      topBorder: border,
    );
    final prePayment = banquet.prepayment ?? 0;
    final Map<String, dynamic> headerInfo = {
      'Заказ №': '',
      S.of(context).dateOfEvent: DateFormat('d MMMM').format(banquet.dateStart),
      S.of(context).timeOfEvent:
          DateTimeFormatter.convertToHHMMString(banquet.timeStart),
      S.of(context).placeOfEvent: banquet.place,
      S.of(context).prepayment: prePayment,
      S.of(context).children: banquet.amountOfChildren ?? 1,
      S.of(context).adults: banquet.amountOfAdult ?? 1,
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
      sheet.cell(CellIndex.indexByString("E$rowIndex")).cellStyle = cellStyle;

      if (el.value is int) {
        sheet.cell(CellIndex.indexByString("F$rowIndex")).value =
            IntCellValue(el.value);
      } else {
        sheet.cell(CellIndex.indexByString("F$rowIndex")).value =
            TextCellValue(el.value);
      }
      sheet.merge(
        CellIndex.indexByString("F$rowIndex"),
        CellIndex.indexByString("G$rowIndex"),
      );
      if (el.key == S.of(context).prepayment) {
        sheet.setMergedCellStyle(
            CellIndex.indexByString('F$rowIndex'),
            cellStyle.copyWith(
              fontColorHexVal: ExcelColor.fromHexString('#00B050'),
            ));
      } else {
        sheet.setMergedCellStyle(
            CellIndex.indexByString('F$rowIndex'), cellStyle);
      }

      rowIndex += 1;
    }
  }

  int _listDishesAndServing(BanquetModel banquet, int rowIndex) {
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
          _countDishCell(sheet, rowIndex, dish);
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

  void _tableNameCell(TableModel table, int rowIndex, BanquetModel banquet) {
    final border = Border(
      borderColorHex: ExcelColor.fromHexString('#000000'),
      borderStyle: BorderStyle.Thin,
    );
    sheet.setRowHeight(rowIndex - 1, 30);

    final cellStyle = CellStyle(
      fontFamily: 'Ebrima',
      fontSize: 14,
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
      backgroundColorHex: ExcelColor.fromHexString('#F7E88D'),
      bottomBorder: border,
      leftBorder: border,
      rightBorder: border,
      topBorder: border,
      bold: true,
    );

    sheet.cell(CellIndex.indexByString('A$rowIndex')).value = TextCellValue(
      table.name,
    );

    sheet.merge(
      CellIndex.indexByString('A$rowIndex'),
      CellIndex.indexByString('G$rowIndex'),
    );
    sheet.setMergedCellStyle(CellIndex.indexByString('A$rowIndex'), cellStyle);
  }

  void _categoryNameCell(int rowIndex, CategoryModel category) {
    final border = Border(
      borderColorHex: ExcelColor.fromHexString('#000000'),
      borderStyle: BorderStyle.Thin,
    );
    final cellStyle = CellStyle(
      fontSize: 14,
      fontFamily: 'Corbel',
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
      bold: true,
      backgroundColorHex: ExcelColor.fromHexString('#99FFCC'),
      bottomBorder: border,
      leftBorder: border,
      rightBorder: border,
      topBorder: border,
    );
    sheet.cell(CellIndex.indexByString('A$rowIndex')).value =
        TextCellValue(category.name);

    sheet.merge(
      CellIndex.indexByString("A$rowIndex"),
      CellIndex.indexByString("G$rowIndex"),
    );
    sheet.cell(CellIndex.indexByString('A$rowIndex')).cellStyle = cellStyle;
    sheet.cell(CellIndex.indexByString('B$rowIndex')).cellStyle = cellStyle;
    sheet.cell(CellIndex.indexByString('C$rowIndex')).cellStyle = cellStyle;
    sheet.cell(CellIndex.indexByString('D$rowIndex')).cellStyle = cellStyle;
    sheet.cell(CellIndex.indexByString('E$rowIndex')).cellStyle = cellStyle;
    sheet.cell(CellIndex.indexByString('F$rowIndex')).cellStyle = cellStyle;
    sheet.cell(CellIndex.indexByString('G$rowIndex')).cellStyle = cellStyle;
  }

  void _titleColumnCell(int rowIndex, BuildContext context) {
    final border = Border(
      borderColorHex: ExcelColor.fromHexString('#000000'),
      borderStyle: BorderStyle.Thin,
    );
    final cellStyle = CellStyle(
      fontSize: 13,
      fontFamily: 'Corbel',
      verticalAlign: VerticalAlign.Center,
      bold: true,
      horizontalAlign: HorizontalAlign.Center,
      backgroundColorHex: ExcelColor.fromHexString('#F7E88D'),
      bottomBorder: border,
      leftBorder: border,
      rightBorder: border,
      topBorder: border,
    );
    sheet.cell(CellIndex.indexByString('A$rowIndex')).value =
        TextCellValue(S.of(context).nameDish);
    sheet.cell(CellIndex.indexByString('A$rowIndex')).cellStyle =
        cellStyle.copyWith(
      horizontalAlignVal: HorizontalAlign.Left,
    );
    sheet.merge(
      CellIndex.indexByString('A$rowIndex'),
      CellIndex.indexByString('B$rowIndex'),
    );
    sheet.setMergedCellStyle(CellIndex.indexByString('A$rowIndex'), cellStyle);

    sheet.cell(CellIndex.indexByString('C$rowIndex')).value =
        TextCellValue(S.of(context).weight);
    sheet.cell(CellIndex.indexByString('C$rowIndex')).cellStyle = cellStyle;
    sheet.cell(CellIndex.indexByString('D$rowIndex')).value =
        TextCellValue(S.of(context).quantity);
    sheet.cell(CellIndex.indexByString('D$rowIndex')).cellStyle = cellStyle;
    sheet.cell(CellIndex.indexByString('E$rowIndex')).value =
        TextCellValue(S.of(context).price);
    sheet.cell(CellIndex.indexByString('E$rowIndex')).cellStyle = cellStyle;
    sheet.cell(CellIndex.indexByString('F$rowIndex')).value =
        TextCellValue(S.of(context).sum);
    sheet.merge(
      CellIndex.indexByString("F$rowIndex"),
      CellIndex.indexByString("G$rowIndex"),
    );
    sheet.setMergedCellStyle(CellIndex.indexByString('F$rowIndex'), cellStyle);
  }

  void _formulaSumCell(Sheet sheet, int rowIndex) {
    final border = Border(
      borderColorHex: ExcelColor.fromHexString('#000000'),
      borderStyle: BorderStyle.Thin,
    );
    final cellStyle = CellStyle(
      fontSize: 12,
      fontFamily: 'Ebrima',
      verticalAlign: VerticalAlign.Center,
      horizontalAlign: HorizontalAlign.Center,
      bottomBorder: border,
      leftBorder: border,
      rightBorder: border,
      topBorder: border,
    );
    sheet.cell(CellIndex.indexByString('F$rowIndex')).setFormula(
          'SUM(D$rowIndex*E$rowIndex)',
        );
    sheet.merge(
      CellIndex.indexByString("F$rowIndex"),
      CellIndex.indexByString("G$rowIndex"),
    );
    sheet.setMergedCellStyle(CellIndex.indexByString('F$rowIndex'), cellStyle);
  }

  void _priceDishCell(Sheet sheet, int rowIndex, DishModel dish) {
    final border = Border(
      borderColorHex: ExcelColor.fromHexString('#000000'),
      borderStyle: BorderStyle.Thin,
    );
    sheet.cell(CellIndex.indexByString('E$rowIndex')).value =
        IntCellValue(dish.price!);
    // NumFormat.custom(formatCode: '# ##0,00 ₽').read(dish.price!);

    sheet.cell(CellIndex.indexByString('E$rowIndex')).cellStyle = CellStyle(
      fontSize: 12,
      fontFamily: 'Ebrima',
      numberFormat: NumFormat.defaultNumeric,
      // NumFormat.custom(formatCode: r'$#,##0'),
      verticalAlign: VerticalAlign.Center,
      horizontalAlign: HorizontalAlign.Center,
      bottomBorder: border,
      leftBorder: Border(
        borderColorHex: ExcelColor.fromHexString('#FF0000'),
        borderStyle: BorderStyle.Thin,
      ),
      rightBorder: border,
      topBorder: border,
    );
  }

  void _countDishCell(Sheet sheet, int rowIndex, DishModel dish) {
    final border = Border(
      borderColorHex: ExcelColor.fromHexString('#FF0000'),
      borderStyle: BorderStyle.Thin,
    );
    sheet.cell(CellIndex.indexByString('D$rowIndex')).value =
        IntCellValue(dish.count);
    sheet.cell(CellIndex.indexByString('D$rowIndex')).cellStyle = CellStyle(
      fontSize: 12,
      fontFamily: 'Ebrima',
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
      borderColorHex: ExcelColor.fromHexString('#000000'),
      borderStyle: BorderStyle.Thin,
    );
    sheet.cell(CellIndex.indexByString('C$rowIndex')).value =
        TextCellValue(dish.weight!);
    sheet.cell(CellIndex.indexByString("C$rowIndex")).cellStyle = CellStyle(
      fontSize: 12,
      fontFamily: 'Ebrima',
      verticalAlign: VerticalAlign.Center,
      horizontalAlign: HorizontalAlign.Center,
      bottomBorder: border,
      leftBorder: border,
      rightBorder: Border(
        borderColorHex: ExcelColor.fromHexString('#FF0000'),
        borderStyle: BorderStyle.Thin,
      ),
      topBorder: border,
    );
  }

  void _nameDishCell(Sheet sheet, int rowIndex, DishModel dish) {
    final border = Border(
      borderColorHex: ExcelColor.fromHexString('#000000'),
      borderStyle: BorderStyle.Thin,
    );
    final cellStyle = CellStyle(
      fontSize: 12,
      fontFamily: 'Ebrima',
      textWrapping: TextWrapping.WrapText,
      bottomBorder: border,
      leftBorder: border,
      rightBorder: border,
      topBorder: border,
      verticalAlign: VerticalAlign.Center,
    );
    sheet.setRowHeight(rowIndex - 1, 30);
    sheet.cell(CellIndex.indexByString('A$rowIndex')).value =
        TextCellValue(dish.nameDish!);
    sheet.merge(
      CellIndex.indexByString('A$rowIndex'),
      CellIndex.indexByString('B$rowIndex'),
    );
    sheet.setMergedCellStyle(CellIndex.indexByString('A$rowIndex'), cellStyle);
    // sheet.cell(CellIndex.indexByString('A$rowIndex')).cellStyle = cellStyle;
    // sheet.cell(CellIndex.indexByString('B$rowIndex')).cellStyle = cellStyle;
  }

  void _headerSizedBoxCell(Sheet sheet) {
    final border = Border(
      borderColorHex: ExcelColor.fromHexString('#000000'),
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

  void _remarkOfbanquetCell(
      Sheet sheet, BanquetModel banquet, int rowIndex, BuildContext context) {
    final border = Border(
      borderColorHex: ExcelColor.fromHexString('#000000'),
      borderStyle: BorderStyle.Thin,
    );
    final double rowHeight = banquet.remark!.length >= 16 ? 30 : 15;
    sheet.setRowHeight(rowIndex - 1, rowHeight);
    final cellStyle = CellStyle(
      fontFamily: 'Corbel',
      fontSize: 12,
      textWrapping: TextWrapping.WrapText,
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
      backgroundColorHex: ExcelColor.fromHexString('#F7E88D'),
      bottomBorder: border,
      leftBorder: border,
      rightBorder: border,
      topBorder: border,
      bold: true,
    );
    sheet.cell(CellIndex.indexByString('A$rowIndex')).value =
        TextCellValue(S.of(context).note);
    sheet.merge(
      CellIndex.indexByString('A$rowIndex'),
      CellIndex.indexByString('E$rowIndex'),
    );
    sheet.setMergedCellStyle(CellIndex.indexByString('A$rowIndex'), cellStyle);

    sheet.cell(CellIndex.indexByString('F$rowIndex')).value =
        TextCellValue(banquet.remark ?? ' ');
    sheet.merge(
      CellIndex.indexByString('F$rowIndex'),
      CellIndex.indexByString('G$rowIndex'),
    );
    sheet.setMergedCellStyle(CellIndex.indexByString('F$rowIndex'), cellStyle);
  }

  void _cakeCell(
      Sheet sheet, BanquetModel banquet, int rowIndex, BuildContext context) {
    final border = Border(
      borderColorHex: ExcelColor.fromHexString('#000000'),
      borderStyle: BorderStyle.Thin,
    );
    final double rowHeight = banquet.remark!.length >= 16 ? 30 : 15;
    sheet.setRowHeight(rowIndex - 1, rowHeight);
    final cellStyle = CellStyle(
      fontFamily: 'Corbel',
      fontSize: 12,
      textWrapping: TextWrapping.WrapText,
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
      bottomBorder: border,
      leftBorder: border,
      rightBorder: border,
      bold: true,
      topBorder: border,
      fontColorHex: ExcelColor.fromHexString('#FF0000'),
    );
    sheet.cell(CellIndex.indexByString('A$rowIndex')).value =
        TextCellValue(S.of(context).nameOfCake);
    sheet.merge(
      CellIndex.indexByString('A$rowIndex'),
      CellIndex.indexByString('E$rowIndex'),
    );
    sheet.setMergedCellStyle(CellIndex.indexByString('A$rowIndex'), cellStyle);

    sheet.cell(CellIndex.indexByString('F$rowIndex')).value =
        TextCellValue(banquet.cake ?? ' ');
    sheet.merge(
      CellIndex.indexByString('F$rowIndex'),
      CellIndex.indexByString('G$rowIndex'),
    );
    sheet.setMergedCellStyle(CellIndex.indexByString('F$rowIndex'), cellStyle);
  }
}
