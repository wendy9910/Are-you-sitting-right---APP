import 'package:english_words/english_words.dart'; // 用於生成隨機英文單詞
import 'package:flutter/material.dart'; // Flutter的Material Design包
import 'package:flutter/rendering.dart'; // 提供渲染層的API，這裏其實不需要因為Material已涵蓋
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart'; // 狀態管理套件
import 'dart:async';
import 'dart:math';
import '../global.dart' as globals;
import 'analyticsPage.dart';
import 'package:intl/intl.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  Duration duration = Duration(); // 计时器的初始持续时间设置为0
  Timer? timer;
  bool isRunning = false; // 计时器是否正在运行的标记
  bool hasStarted = false; // 计时器是否开始过的标记
  bool endDetect = false;
  PostureDetector detector = PostureDetector(); // 创建PostureDetector的实例
  String backgroundImage = 'assets/images/background.jpg';

  String upperBodyText = '';
  String lowerBodyText = '';

  String getUpperBodyText(UpperBodyAction action) {
    switch (action) {
      case UpperBodyAction.BackRest:
        return 'BackRest';
      case UpperBodyAction.BackUpright:
        return 'BackUpright';
      case UpperBodyAction.BackHunchedForward:
        return 'BackHunchedForward';
      case UpperBodyAction.BackSlouchingLeft:
        return 'BackSlouchingLeft';
      case UpperBodyAction.BackSlouchingRight:
        return 'BackSlouchingRight';
      case UpperBodyAction.OnTheEdgeHunchedForward:
        return 'OnTheEdgeHunchedForward';
      case UpperBodyAction.OnTheEdgeRest:
        return 'OnTheEdgeRest';
      default:
        return 'Unknown';
    }
  }

  String getLowerBodyText(LowerBodyAction action) {
    switch (action) {
      case LowerBodyAction.FootStraight:
        return 'FootStraight';
      case LowerBodyAction.FootCrossedLeft:
        return 'FootCrossedLeft';
      case LowerBodyAction.FootCrossedRight:
        return 'FootCrossedRight';
      default:
        return 'Unknown';
    }
  }

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
    if (duration.inSeconds > 0 && !isRunning) {
      setState(() {
        isRunning = true;
      });
      timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
        // 每秒接收数据并更新统计（此处应替换为真实数据接收逻辑）
        // simulateSittingPostureData(detector, t);
        simulateSittingPostureData(detector, t);
        if (duration.inSeconds == 0) {
          t.cancel();
          setState(() {
            isRunning = false;
          });
          showStatistics(detector);
          // 时间结束时显示统计数据
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text(detector.getStatistics().toString()),
              );
            },
          );
        } else {
          setState(() {
            duration -= Duration(seconds: 1);
          });
          simulateSittingPostureData(detector, t);
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
    print(detector.getStatistics());
    detector = PostureDetector(); // 重置PostureDetector的实例
  }

  // 模拟接收坐姿数据的函数
  void simulateSittingPostureData(PostureDetector detector, Timer timer) {
    Random random = Random();

    int upperBodyCode = random.nextInt(UpperBodyAction.values.length);
    int lowerBodyCode = 8 + random.nextInt(LowerBodyAction.values.length);

    // 调用 PostureDetector 的 receiveData 方法模拟数据接收
    detector.receiveData(upperBodyCode, lowerBodyCode);

    setState(() {
      upperBodyText = getUpperBodyText(UpperBodyAction.values[upperBodyCode]);
      lowerBodyText =
          getLowerBodyText(LowerBodyAction.values[lowerBodyCode - 8]);
    });

    // 检查是否需要结束数据生成（比如倒计时结束）
    if (timer.tick >= duration.inSeconds) {
      timer.cancel();
      // 可以在这里调用任何需要在数据接收结束时进行的操作
      showStatistics(detector); // 显示统计信息
    }
  }

  // 显示统计信息的函数
  void showStatistics(PostureDetector detector) {
    // 显示或处理统计数据
    print(detector.getStatistics());

    // 获得百分比数据
    final percentages = detector.calculatePosturePercentages();

    // 创建时间戳
    final timestamp = DateFormat('yyyyMMdd_Hm').format(DateTime.now());

    // 导航到AnalyticsPage
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AnalyticsPage()),
    );
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
                    upperBodyText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(147, 254, 92, 92), // 深色文字
                    ),
                  ),
                ),
                SizedBox(width: 50),
                Flexible(
                  flex: 2, // 占据 2 份空间
                  child: Text(
                    lowerBodyText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
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

// 枚举定义上半身和下半身的动作
enum UpperBodyAction {
  BackRest,
  BackUpright,
  BackHunchedForward,
  BackSlouchingLeft,
  BackSlouchingRight,
  OnTheEdgeHunchedForward,
  OnTheEdgeRest,
  Background,
}

enum LowerBodyAction {
  FootStraight,
  FootCrossedLeft,
  FootCrossedRight,
}

// PostureDetector 类负责处理姿势检测逻辑
class PostureDetector {
  // 计数器，记录各种姿势的检测次数
  final Map<UpperBodyAction, int> upperBodyCounters = {};
  final Map<LowerBodyAction, int> lowerBodyCounters = {};

  // 总检测次数
  int totalDetect = 0;

  PostureDetector() {
    // 初始化计数器
    UpperBodyAction.values.forEach((action) => upperBodyCounters[action] = 0);
    LowerBodyAction.values.forEach((action) => lowerBodyCounters[action] = 0);
  }

  // 更新姿势检测计数器
  void updateCounters(
      UpperBodyAction upperBodyAction, LowerBodyAction lowerBodyAction) {
    // 更新上半身姿势计数器
    upperBodyCounters.update(upperBodyAction, (value) => value + 1,
        ifAbsent: () => 1);

    // 更新下半身姿势计数器
    lowerBodyCounters.update(lowerBodyAction, (value) => value + 1,
        ifAbsent: () => 1);

    // 更新总检测次数
    totalDetect++;
  }

  Map<String, dynamic> getStatistics() {
    return {
      'totalDetect': totalDetect,
      'upperBodyCounters': upperBodyCounters,
      'lowerBodyCounters': lowerBodyCounters,
    };
  }

  UpperBodyAction decodeUpperBodyAction(int code) {
    if (code >= 0 && code < UpperBodyAction.values.length) {
      return UpperBodyAction.values[code];
    } else {
      throw Exception('Invalid code for upper body action');
    }
  }

  LowerBodyAction decodeLowerBodyAction(int code) {
    if (code >= 8 && code <= 10) {
      return LowerBodyAction.values[code - 8]; // 减去8因为下半身动作的编码从8开始
    } else {
      throw Exception('Invalid code for lower body action');
    }
  }

  void receiveData(int upperBodyCode, int lowerBodyCode) {
    try {
      UpperBodyAction upperAction = decodeUpperBodyAction(upperBodyCode);
      LowerBodyAction lowerAction = decodeLowerBodyAction(lowerBodyCode);
      updateCounters(upperAction, lowerAction);
    } catch (e) {
      print('Error processing data: $e');
    }
  }

  bool isUpperBodyPostureIncorrect(UpperBodyAction action) {
    // 定义上半身错误坐姿
    const incorrectPostures = {
      UpperBodyAction.BackHunchedForward,
      UpperBodyAction.BackSlouchingLeft,
      UpperBodyAction.BackSlouchingRight,
      UpperBodyAction.OnTheEdgeHunchedForward,
      UpperBodyAction.OnTheEdgeRest,
    };
    return incorrectPostures.contains(action);
  }

  bool isLowerBodyPostureIncorrect(LowerBodyAction action) {
    // 定义下半身错误坐姿
    const incorrectPostures = {
      LowerBodyAction.FootCrossedLeft,
      LowerBodyAction.FootCrossedRight,
    };
    return incorrectPostures.contains(action);
  }

  Map<String, double> calculatePosturePercentages() {
    Map<String, double> percentages = {};
    int upperTotal = upperBodyCounters.values.fold(0, (sum, e) => sum + e);
    int lowerTotal = lowerBodyCounters.values.fold(0, (sum, e) => sum + e);

    upperBodyCounters.forEach((key, value) {
      percentages['upper_${key.toString()}'] = (value / upperTotal) * 100;
    });
    lowerBodyCounters.forEach((key, value) {
      percentages['lower_${key.toString()}'] = (value / lowerTotal) * 100;
    });

    return percentages;
  }
}
