import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

part 'expence.g.dart';

//create a unique id using uuid
final uuid = const Uuid().v4();

//date formatter
final formattedDate = DateFormat.yMd();

//enum for category
enum Category { food, travel, leasure, work }

//category icons
final CategoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.leasure: Icons.leak_add,
  Category.travel: Icons.travel_explore,
  Category.work: Icons.work,
};

@HiveType(typeId: 1)

class ExpenceModel {
  //constructor
  ExpenceModel(
      {required this.amount,
      required this.date,
      required this.title,
      required this.category})
      : id = uuid;

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final Category category;

  //getter > formatted date
  String get getFormattedDate {
    return formattedDate.format(date);
  }
}
