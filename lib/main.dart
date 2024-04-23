import 'package:english_words/english_words.dart'; // 用於生成隨機英文單詞
import 'package:flutter/material.dart'; // Flutter的Material Design包
import 'package:flutter/rendering.dart'; // 提供渲染層的API，這裏其實不需要因為Material已涵蓋
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart'; // 狀態管理套件
import 'dart:async';
import 'global.dart' as globals;
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'screens/bluetooth_off_screen.dart';
import 'screens/scan_screen.dart';

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
      ),
    );
  }
}

// MyAppState是一個用於存儲應用狀態的類
class MyAppState extends ChangeNotifier {
  // 初始化一些狀態變量
  var current = WordPair.random(); // 當前隨機單詞對
  var favorites = <WordPair>[]; // 用戶喜歡的單詞對列表
  var selectedIndex = 0; // ...其他狀態變量
  var selectedIndexInAnotherWidget = 0;
  var indexInYetAnotherWidget = 42;
  var optionASelected = false;
  var optionBSelected = false;
  var loadingFromNetwork = false;

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
  int selectedIndex = 0; // 當前選擇的索引

  // 切換頁面的函數
  void _onItemTapped(int index) {
    setState(() {
      context.read<MyAppState>().setSelectedIndex(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyAppState>(context);
    final List<Widget> pages = [
      GeneratorPage(),
      StartPage(),
      AnalyticsPage(),
      SettingPage()
    ]; // 頁面列表

    return Scaffold(
      body: pages[appState.selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // 设置导航栏类型为fixed
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
        currentIndex: selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        onTap: _onItemTapped,
      ),
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<MyAppState>();
    String backgroundImage = 'assets/images/background.jpg';

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
        Image.asset(
          'assets/images/cat.png', // 確保這個路徑和檔案名稱與實際匹配
          fit: BoxFit.cover, // 根據需要選擇合適的 BoxFit 屬性
        ),
        SizedBox(height: 20),
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

class AnalyticsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 只返回一个居中的文本提示
    return Center(
      child: Text('Analytics Page Placeholder'),
    );
  }
}

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  Duration duration = Duration(); // 计时器的初始持续时间设置为0
  Timer? timer;
  bool isRunning = false; // 计时器是否正在运行的标记
  bool hasStarted = false; // 计时器是否开始过的标记
  String backgroundImage = 'assets/images/background.jpg';

  void toggleTimer() {
    if (isRunning) {
      pauseTimer();
    } else {
      startTimer();
    }
  }

  @override
  void initState() {
    super.initState();
    // 假设从设置页面获取的sittingTime以分钟为单位
    duration = Duration(minutes: globals.sittingTime.round());
  }

  void startTimer() {
    if (duration.inSeconds > 0) {
      setState(() {
        isRunning = true;
      });
      timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
        if (duration.inSeconds == 0) {
          t.cancel();
          setState(() {
            isRunning = false;
          });
        } else {
          setState(() {
            duration -= Duration(seconds: 1);
          });
        }
      });
    }
  }

  void pauseTimer() {
    setState(() {
      isRunning = false;
    });
    timer?.cancel();
  }

  void resetTimer() {
    timer?.cancel();
    setState(() {
      isRunning = false;

      duration = Duration(minutes: globals.sittingTime.round()); // 重置为初始设置的时间
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Your sitting posture is ',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(146, 247, 70, 70), // 深色文字
              ),
            ),
            SizedBox(height: 100),
            // 图片和加号
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  flex: 3, // 坐姿图标占较大空间
                  child: Image.asset(
                    'assets/images/sit1.png',
                    fit: BoxFit.contain, // 保持图像的原始比例
                  ),
                ),
                Flexible(
                  flex: 1, // 加号图标占较小空间
                  child: Image.asset(
                    'assets/images/add.png',
                    fit: BoxFit.contain,
                  ),
                ),
                Flexible(
                  flex: 2, // 坐姿图标占较大空间
                  child: Image.asset(
                    'assets/images/sit2.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
            // 文字描述
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // 将元素居中对齐
              children: [
                Flexible(
                  flex: 2, // 占据 2 份空间
                  child: Text(
                    'upperbody',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(147, 254, 92, 92), // 深色文字
                    ),
                  ),
                ),
                SizedBox(width: 50),
                Flexible(
                  flex: 2, // 占据 2 份空间
                  child: Text(
                    'lowerbody',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(147, 254, 92, 92), // 深色文字
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 50),
            // 计时器
            Text(formatDuration(duration),
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  icon: Icon(isRunning ? Icons.pause : Icons.play_arrow),
                  iconSize: 36.0,
                  color: isRunning ? Colors.red : Colors.green,
                  onPressed: toggleTimer,
                ),
                IconButton(
                  icon: Icon(Icons.stop),
                  iconSize: 36.0,
                  color: isRunning ? Colors.grey : Colors.blue,
                  onPressed: isRunning ? null : resetTimer,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

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

class BluetoothPage extends StatefulWidget {
  @override
  _BluetoothPageState createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<BluetoothPage> {
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
  late StreamSubscription<BluetoothAdapterState> _adapterStateSubscription;

  @override
  void initState() {
    super.initState();
    // 監聽藍牙適配器狀態
    _adapterStateSubscription = FlutterBluePlus.adapterState.listen((state) {
      setState(() {
        _adapterState = state;
      });
    });
  }

  @override
  void dispose() {
    _adapterStateSubscription.cancel(); // 取消監聽
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    // 根據藍牙狀態決定顯示哪個頁面
    if (_adapterState == BluetoothAdapterState.on) {
      content = const ScanScreen(); // 藍牙開啟時顯示掃描頁面
    } else {
      content =
          BluetoothOffScreen(adapterState: _adapterState); // 藍牙關閉時顯示藍牙關閉頁面
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Setting'),
      ),
      body: Center(
        child: content,
      ),
    );
  }
}
