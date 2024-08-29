import 'package:english_words/english_words.dart'; // 用於生成隨機英文單詞
import 'package:flutter/material.dart'; // Flutter的Material Design包
import 'package:flutter/rendering.dart'; // 提供渲染層的API，這裏其實不需要因為Material已涵蓋
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart'; // 狀態管理套件
import 'dart:async';
import 'global.dart' as globals;
import 'page/bluetoothcontrol.dart';
import 'page/analyticsPage.dart';
import 'page/StartPage.dart';
import 'page/SettingPage.dart';
import 'page/CalibrationPage.dart';

// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'screens/bluetooth_off_screen.dart';
// import 'screens/scan_screen.dart';

// 主函數，這是應用程序的入口點。
void main() {
  runApp(MyApp());
}

// MyApp是一個無狀態widget，這意味著它不會維護任何狀態。
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // build方法是用於描述如何根據其他低級別的widget構建用戶界面的
  @override
  Widget build(BuildContext context) {
    // ChangeNotifierProvider是provider套件中的一個widget，用於將狀態向下傳遞給子widget
    return ChangeNotifierProvider(
      // MyAppState是一個狀態管理類，它繼承自ChangeNotifier
      create: (context) => MyAppState(),
      // MaterialApp是Flutter中的一個widget，用於配置一些全局設定，比如主題
      child: MaterialApp(
        title: 'Name App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(), // 首頁的widget
        navigatorObservers: [BluetoothAdapterStateObserver()],
      ),
    );
  }
}

// MyAppState是一個用於存儲應用狀態的類
class MyAppState extends ChangeNotifier {
  // 初始化一些狀態變量
  var selectedIndex = 0; // ...其他狀態變量

  void setSelectedIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}

// MyHomePage是有狀態的widget，會創建一個狀態對象 _MyHomePageState
class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // 切換頁面的函數
  void _onItemTapped(int index) {
    setState(() {
      context.read<MyAppState>().setSelectedIndex(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MyAppState>(
        builder: (context, appState, child) {
          final List<Widget> pages = [
            GeneratorPage(),
            StartPage(),
            AnalyticsPage(),
            SettingPage()
          ];
          return pages[appState.selectedIndex];
        },
      ),
      bottomNavigationBar: Consumer<MyAppState>(
        builder: (context, appState, child) {
          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.slideshow_rounded),
                label: 'Start',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.analytics),
                label: 'Analytics',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_rounded),
                label: 'Settings',
              ),
            ],
            currentIndex: appState.selectedIndex,
            selectedItemColor: Theme.of(context).colorScheme.secondary,
            onTap: _onItemTapped,
          );
        },
      ),
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<MyAppState>();
    String backgroundImage = 'assets/images/BG_blue.jpg';

    return Container(
      decoration: BoxDecoration(
        // Use BoxDecoration to set the background image
        image: DecorationImage(
          image: AssetImage(backgroundImage),
          fit: BoxFit.cover, // Cover the entire widget area
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BTButton(),
            BigCard(),
            SizedBox(height: 50),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CalibrationPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(200, 50), // 设置按钮的最小尺寸
                    padding:
                        EdgeInsets.symmetric(horizontal: 16), // 也可以通过内边距来调整按钮大小
                  ),
                  child: Text(
                    'Calibration Task',
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BTButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 5.0, right: 8.0),
        child: Ink(
          decoration: ShapeDecoration(
            shape:
                StadiumBorder(), // This makes the background of the button elliptical
            color: Color.fromARGB(221, 27, 2,
                249), // You can set the background color of the button here
          ),
          child: IconButton(
            icon: Icon(
              Icons.bluetooth,
              color: Color.fromARGB(221, 27, 2, 249),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      BluetoothPage(), // Assuming BluetoothPage is a defined widget
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center, // 居中對齊
      children: <Widget>[
        // Image.asset(
        //   'assets/images/cat.png', // 確保這個路徑和檔案名稱與實際匹配
        //   fit: BoxFit.cover, // 根據需要選擇合適的 BoxFit 屬性
        // ),
        SizedBox(height: 40),
        Text(
          'Are you sitting right?',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
            color: Colors.black87, // 深色文字
          ),
        )
      ],
    );
  }
}
