// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Banquets`
  String get banquets {
    return Intl.message('Banquets', name: 'banquets', desc: '', args: []);
  }

  /// `Next`
  String get next {
    return Intl.message('Next', name: 'next', desc: '', args: []);
  }

  /// `Customer name`
  String get customerName {
    return Intl.message(
      'Customer name',
      name: 'customerName',
      desc: '',
      args: [],
    );
  }

  /// `Customer phone number`
  String get customerPhoneNumber {
    return Intl.message(
      'Customer phone number',
      name: 'customerPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Date of event`
  String get dateOfEvent {
    return Intl.message(
      'Date of event',
      name: 'dateOfEvent',
      desc: '',
      args: [],
    );
  }

  /// `Time of event`
  String get timeOfEvent {
    return Intl.message(
      'Time of event',
      name: 'timeOfEvent',
      desc: '',
      args: [],
    );
  }

  /// `Prepayment`
  String get prepayment {
    return Intl.message('Prepayment', name: 'prepayment', desc: '', args: []);
  }

  /// `Children`
  String get children {
    return Intl.message('Children', name: 'children', desc: '', args: []);
  }

  /// `Adults`
  String get adults {
    return Intl.message('Adults', name: 'adults', desc: '', args: []);
  }

  /// `Name of cake`
  String get nameOfCake {
    return Intl.message('Name of cake', name: 'nameOfCake', desc: '', args: []);
  }

  /// `Note`
  String get note {
    return Intl.message('Note', name: 'note', desc: '', args: []);
  }

  /// `Place of event`
  String get placeOfEvent {
    return Intl.message(
      'Place of event',
      name: 'placeOfEvent',
      desc: '',
      args: [],
    );
  }

  /// `University`
  String get university {
    return Intl.message('University', name: 'university', desc: '', args: []);
  }

  /// `Carlson`
  String get carlson {
    return Intl.message('Carlson', name: 'carlson', desc: '', args: []);
  }

  /// `Cabin Company`
  String get cabinCompany {
    return Intl.message(
      'Cabin Company',
      name: 'cabinCompany',
      desc: '',
      args: [],
    );
  }

  /// `Magic`
  String get magic {
    return Intl.message('Magic', name: 'magic', desc: '', args: []);
  }

  /// `Western`
  String get western {
    return Intl.message('Western', name: 'western', desc: '', args: []);
  }

  /// `Princess`
  String get princess {
    return Intl.message('Princess', name: 'princess', desc: '', args: []);
  }

  /// `Cafe`
  String get cafe {
    return Intl.message('Cafe', name: 'cafe', desc: '', args: []);
  }

  /// `Castle princess`
  String get castlePrincess {
    return Intl.message(
      'Castle princess',
      name: 'castlePrincess',
      desc: '',
      args: [],
    );
  }

  /// `Disco`
  String get disco {
    return Intl.message('Disco', name: 'disco', desc: '', args: []);
  }

  /// `Cosmos`
  String get cosmos {
    return Intl.message('Cosmos', name: 'cosmos', desc: '', args: []);
  }

  /// `Jurassic Period`
  String get jurassicPeriod {
    return Intl.message(
      'Jurassic Period',
      name: 'jurassicPeriod',
      desc: '',
      args: [],
    );
  }

  /// `Miracle Island`
  String get miracelIsland {
    return Intl.message(
      'Miracle Island',
      name: 'miracelIsland',
      desc: '',
      args: [],
    );
  }

  /// `Place an order`
  String get placeAnOrder {
    return Intl.message(
      'Place an order',
      name: 'placeAnOrder',
      desc: '',
      args: [],
    );
  }

  /// `List of banquets`
  String get listOfBanquets {
    return Intl.message(
      'List of banquets',
      name: 'listOfBanquets',
      desc: '',
      args: [],
    );
  }

  /// `Statistic`
  String get statistic {
    return Intl.message('Statistic', name: 'statistic', desc: '', args: []);
  }

  /// `Profile`
  String get profile {
    return Intl.message('Profile', name: 'profile', desc: '', args: []);
  }

  /// `Required field`
  String get requiredFiled {
    return Intl.message(
      'Required field',
      name: 'requiredFiled',
      desc: '',
      args: [],
    );
  }

  /// `Kidburg banquets`
  String get kidburgBanquets {
    return Intl.message(
      'Kidburg banquets',
      name: 'kidburgBanquets',
      desc: '',
      args: [],
    );
  }

  /// `Manager name`
  String get managerName {
    return Intl.message(
      'Manager name',
      name: 'managerName',
      desc: '',
      args: [],
    );
  }

  /// `Manager phone number`
  String get managerPhoneNumber {
    return Intl.message(
      'Manager phone number',
      name: 'managerPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Establishment`
  String get establishment {
    return Intl.message(
      'Establishment',
      name: 'establishment',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `Russian`
  String get russian {
    return Intl.message('Russian', name: 'russian', desc: '', args: []);
  }

  /// `English`
  String get english {
    return Intl.message('English', name: 'english', desc: '', args: []);
  }

  /// `Select establishment`
  String get selectEstablishment {
    return Intl.message(
      'Select establishment',
      name: 'selectEstablishment',
      desc: '',
      args: [],
    );
  }

  /// `CDM`
  String get cdm {
    return Intl.message('CDM', name: 'cdm', desc: '', args: []);
  }

  /// `Riviera`
  String get riviera {
    return Intl.message('Riviera', name: 'riviera', desc: '', args: []);
  }

  /// `Total sum`
  String get totalSum {
    return Intl.message('Total sum', name: 'totalSum', desc: '', args: []);
  }

  /// `Food service removed`
  String get foodServiceRemoved {
    return Intl.message(
      'Food service removed',
      name: 'foodServiceRemoved',
      desc: '',
      args: [],
    );
  }

  /// `Add serving dishes`
  String get addServingDishes {
    return Intl.message(
      'Add serving dishes',
      name: 'addServingDishes',
      desc: '',
      args: [],
    );
  }

  /// `quantity`
  String get quantity {
    return Intl.message('quantity', name: 'quantity', desc: '', args: []);
  }

  /// `Serving dishes on`
  String get servingDishesOn {
    return Intl.message(
      'Serving dishes on',
      name: 'servingDishesOn',
      desc: '',
      args: [],
    );
  }

  /// `$`
  String get markCurrency {
    return Intl.message('\$', name: 'markCurrency', desc: '', args: []);
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Go to the list of banquets`
  String get goToTheListOfBanquets {
    return Intl.message(
      'Go to the list of banquets',
      name: 'goToTheListOfBanquets',
      desc: '',
      args: [],
    );
  }

  /// `EVENT`
  String get event {
    return Intl.message('EVENT', name: 'event', desc: '', args: []);
  }

  /// `Customer`
  String get customer {
    return Intl.message('Customer', name: 'customer', desc: '', args: []);
  }

  /// `Date`
  String get date {
    return Intl.message('Date', name: 'date', desc: '', args: []);
  }

  /// `Room`
  String get room {
    return Intl.message('Room', name: 'room', desc: '', args: []);
  }

  /// `Time`
  String get time {
    return Intl.message('Time', name: 'time', desc: '', args: []);
  }

  /// `pcs`
  String get pcs {
    return Intl.message('pcs', name: 'pcs', desc: '', args: []);
  }

  /// `The file is saved in the directory`
  String get theFileIsSavedInTheDirectory {
    return Intl.message(
      'The file is saved in the directory',
      name: 'theFileIsSavedInTheDirectory',
      desc: '',
      args: [],
    );
  }

  /// `Open`
  String get open {
    return Intl.message('Open', name: 'open', desc: '', args: []);
  }

  /// `Share`
  String get share {
    return Intl.message('Share', name: 'share', desc: '', args: []);
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `Delete file`
  String get deleteFile {
    return Intl.message('Delete file', name: 'deleteFile', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Change language?`
  String get changeLanguage {
    return Intl.message(
      'Change language?',
      name: 'changeLanguage',
      desc: '',
      args: [],
    );
  }

  /// `When changing the language, the list of all saved orders will be cleared and the order directory in the file system will be deleted`
  String
  get whenChangingTheLanguageTheListOfAllSavedOrdersWillBeClearedAndTheOrderDirectoryInTheFileSystemWillBeDeleted {
    return Intl.message(
      'When changing the language, the list of all saved orders will be cleared and the order directory in the file system will be deleted',
      name:
          'whenChangingTheLanguageTheListOfAllSavedOrdersWillBeClearedAndTheOrderDirectoryInTheFileSystemWillBeDeleted',
      desc: '',
      args: [],
    );
  }

  /// `Change language`
  String get changeLang {
    return Intl.message(
      'Change language',
      name: 'changeLang',
      desc: '',
      args: [],
    );
  }

  /// `List is Empty`
  String get listIsEmpty {
    return Intl.message(
      'List is Empty',
      name: 'listIsEmpty',
      desc: '',
      args: [],
    );
  }

  /// `No data for statistic`
  String get noDataForStatistic {
    return Intl.message(
      'No data for statistic',
      name: 'noDataForStatistic',
      desc: '',
      args: [],
    );
  }

  /// `Profit`
  String get profit {
    return Intl.message('Profit', name: 'profit', desc: '', args: []);
  }

  /// `Average check`
  String get averageCheck {
    return Intl.message(
      'Average check',
      name: 'averageCheck',
      desc: '',
      args: [],
    );
  }

  /// `Total number of guests`
  String get totalNumberOfGuests {
    return Intl.message(
      'Total number of guests',
      name: 'totalNumberOfGuests',
      desc: '',
      args: [],
    );
  }

  /// `Total amount for the month`
  String get totalAmountForTheMonth {
    return Intl.message(
      'Total amount for the month',
      name: 'totalAmountForTheMonth',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get nameDish {
    return Intl.message('Name', name: 'nameDish', desc: '', args: []);
  }

  /// `Weight`
  String get weight {
    return Intl.message('Weight', name: 'weight', desc: '', args: []);
  }

  /// `Price`
  String get price {
    return Intl.message('Price', name: 'price', desc: '', args: []);
  }

  /// `Sum`
  String get sum {
    return Intl.message('Sum', name: 'sum', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
