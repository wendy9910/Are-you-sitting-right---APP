import 'package:english_words/english_words.dart'; // 用於生成隨機英文單詞
import 'package:flutter/material.dart'; // Flutter的Material Design包
import 'package:flutter/rendering.dart'; // 提供渲染層的API，這裏其實不需要因為Material已涵蓋
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart'; // 狀態管理套件
import 'dart:async';
import '../global.dart' as globals;

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool isRealTime = true;
  //double sittingTime = 60; // 假设初始值为1小时，这里的值以分钟为单位
  String backgroundImage = 'assets/images/background.jpg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundImage),
            fit: BoxFit.cover, // 覆盖整个容器区域
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Bad Posture Remind:',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 50),
              ListTile(
                title: Text('Real Time', style: TextStyle(fontSize: 20)),
                leading: Radio(
                  value: true,
                  groupValue: isRealTime,
                  onChanged: (bool? value) {
                    setState(() {
                      isRealTime = value!;
                    });
                  },
                ),
              ),
              ListTile(
                title: Text('10 seconds', style: TextStyle(fontSize: 20)),
                leading: Radio(
                  value: false,
                  groupValue: isRealTime,
                  onChanged: (bool? value) {
                    setState(() {
                      isRealTime = value!;
                    });
                  },
                ),
              ),
              SizedBox(height: 50),
              Text(
                'Sitting Time Setting:',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Slider(
                min: 10,
                max: 90,
                divisions: 8,
                value: globals.sittingTime,
                label: '${globals.sittingTime.round()} minutes',
                onChanged: (double value) {
                  setState(() {
                    globals.sittingTime = value;
                  });
                },
              ),
              Text('${globals.sittingTime.round()} minutes',
                  style: TextStyle(fontSize: 20)),
            ],
          ),
        ),
      ),
    );
  }
}
