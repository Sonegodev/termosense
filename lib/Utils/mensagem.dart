import 'package:flutter/material.dart';
import 'package:termosense/style/colors.dart';

void showMessage ({String? message,
BuildContext? context}) {
  ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
    content: Text(
      message!,
      style: const TextStyle(color: AppColors.branco),
    ),
    backgroundColor: AppColors.azul,));
}