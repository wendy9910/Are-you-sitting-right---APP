import 'package:english_words/english_words.dart'; // 用於生成隨機英文單詞
import 'package:flutter/material.dart'; // Flutter的Material Design包
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart'; // 狀態管理套件
import 'dart:async';
import '../global.dart' as globals;

class CalibrationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calibration'),
      ),
      body: Center(
        child: Text('Calibration Page Content'),
      ),
    );
  }
}
