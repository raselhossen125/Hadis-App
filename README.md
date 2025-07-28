
import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'package:background_locator_2/background_locator.dart';
import 'package:background_locator_2/location_dto.dart';
import 'package:background_locator_2/settings/android_settings.dart';
import 'package:background_locator_2/settings/locator_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:geolocator/geolocator.dart' as location;
import 'package:geolocator_android/geolocator_android.dart' as geoAndroid;
import 'package:geolocator_apple/geolocator_apple.dart' as geoApple;
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:global_muslim/view/screens/home/widget/todat_prayer_list_widget.dart';
import 'package:home_widget/home_widget.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:pray_times/pray_times.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart';
import 'package:workmanager/workmanager.dart';
import '../../../../background_location/callback_handler.dart';
import '../../../../background_location/location_service_isolate.dart';
import '../../../../controller/prayer_time_controller.dart';
import '../../../../controller/theme_controller.dart';
import '../../../../util/app_colors.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/images.dart';
import '../../../../util/styles.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'dart:ui';
import 'package:background_locator_2/settings/ios_settings.dart';

import '../../splash/splash_screen.dart';
import 'guide_screen.dart';

final FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();
bool _notificationsEnabled = false;
// LocationData? _currentPosition;
// Location location = new Location();
notificationDetails() async {
  return const NotificationDetails(
    android: AndroidNotificationDetails(
      'channelId',
      'channelName',
      importance: Importance.max,
      priority: Priority.high,
      enableLights: true,
      enableVibration: true,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('adhan_sound'),
    ),
    iOS: darwinNotificationDetails,
  );
}

notificationDetailsAdhan1() async {
  return const NotificationDetails(
    android: AndroidNotificationDetails(
      'channelIdAdhan1',
      'channelNameAdhan1',
      importance: Importance.max,
      priority: Priority.high,
      enableLights: true,
      enableVibration: true,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('adhan1'),
    ),
    iOS: darwinNotificationDetails,
  );
}

notificationDetailsAdhan2() async {
  return const NotificationDetails(
    android: AndroidNotificationDetails(
      'channelIdAdhan2',
      'channelNameAdhan2',
      importance: Importance.max,
      priority: Priority.high,
      enableLights: true,
      enableVibration: true,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('adhan2'),
    ),
    iOS: darwinNotificationDetails,
  );
}

notificationDetailsAdhan3() async {
  return const NotificationDetails(
    android: AndroidNotificationDetails(
      'channelIdAdhan3',
      'channelNameAdhan3',
      importance: Importance.max,
      priority: Priority.high,
      enableLights: true,
      enableVibration: true,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('al_aqsa'),
    ),
    iOS: darwinNotificationDetails,
  );
}

notificationDetailsAdhan4() async {
  return const NotificationDetails(
    android: AndroidNotificationDetails(
      'channelIdAdhan4',
      'channelNameAdhan4',
      importance: Importance.max,
      priority: Priority.high,
      enableLights: true,
      enableVibration: true,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('long_beep'),
    ),
    iOS: darwinNotificationDetails,
  );
}

notificationDetailsAdhan5() async {
  return const NotificationDetails(
    android: AndroidNotificationDetails(
      'channelIdAdhan5',
      'channelNameAdhan5',
      importance: Importance.max,
      priority: Priority.high,
      enableLights: true,
      enableVibration: true,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('short_beep'),
    ),
    iOS: darwinNotificationDetails,
  );
}

notificationDetailsNoSound() async {
  return const NotificationDetails(
    android: AndroidNotificationDetails(
      'channelIdNoSound',
      'channelNameNoSound',
      importance: Importance.max,
      priority: Priority.high,
      enableLights: true,
      enableVibration: true,
      playSound: false,
    ),
    iOS: darwinNotificationDetails,
  );
}

const DarwinNotificationDetails darwinNotificationDetails =
    DarwinNotificationDetails(sound: 'adhan_sound.aiff');

@pragma('vm:entry-point')
cancel(id) async => await notificationsPlugin.cancel(id);

@pragma('vm:entry-point')
cancelAll() async => await notificationsPlugin.cancelAll();

// fajr prayer switch
@pragma('vm:entry-point')
fajrPrayer(List<dynamic> args) async {
  RootIsolateToken rootIsolateToken = args[0];
  BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  if (args[1] == false) {
    await prefs.setBool('switch1Status', args[1]);
    await prefs.setInt('currentSwitch', args[2]);
    int? notiid1 = prefs.getInt('notiID1');

    // cancel existing notification
    await cancel(notiid1);
  } else {
    await prefs.setBool('switch1Status', args[1]);
    await prefs.setInt('currentSwitch', args[2]);
    await _onStart();
  }
}

// sunrise prayer switch
@pragma('vm:entry-point')
sunrisePrayer(List<dynamic> args) async {
  RootIsolateToken rootIsolateToken = args[0];
  BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  if (args[1] == false) {
    await prefs.setBool('switch2Status', args[1]);
    await prefs.setInt('currentSwitch', args[2]);
    int? notiid2 = prefs.getInt('notiID2');

    // cancel existing notification
    await cancel(notiid2);
  } else {
    await prefs.setBool('switch2Status', args[1]);
    await prefs.setInt('currentSwitch', args[2]);
    await _onStart();
  }
}

// Dhuhr prayer switch
@pragma('vm:entry-point')
dhuhrPrayer(List<dynamic> args) async {
  RootIsolateToken rootIsolateToken = args[0];
  BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  if (args[1] == false) {
    await prefs.setBool('switch3Status', args[1]);
    await prefs.setInt('currentSwitch', args[2]);
    int? notiid3 = prefs.getInt('notiID3');
    // cancel existing notification
    await cancel(notiid3);
  } else {
    await prefs.setBool('switch3Status', args[1]);
    await prefs.setInt('currentSwitch', args[2]);

    // if switch is turned on
    await _onStart();
  }
}

// Asr prayer switch
@pragma('vm:entry-point')
asrPrayer(List<dynamic> args) async {
  RootIsolateToken rootIsolateToken = args[0];
  BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  if (args[1] == false) {
    await prefs.setBool('switch4Status', args[1]);
    await prefs.setInt('currentSwitch', args[2]);
    int? notiid4 = prefs.getInt('notiID4');
    // cancel existing notification
    await cancel(notiid4);
  } else {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('switch4Status', args[1]);
    await prefs.setInt('currentSwitch', args[2]);

    // if switch is turned on
    await _onStart();
  }
}

// Maghrib prayer switch
@pragma('vm:entry-point')
maghribPrayer(List<dynamic> args) async {
  RootIsolateToken rootIsolateToken = args[0];
  BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  if (args[1] == false) {
    await prefs.setBool('switch5Status', args[1]);
    await prefs.setInt('currentSwitch', args[2]);
    int? notiid5 = prefs.getInt('notiID5');
    // cancel existing notification
    await cancel(notiid5);
  } else {
    await prefs.setBool('switch5Status', args[1]);
    await prefs.setInt('currentSwitch', args[2]);

    // if switch is turned on
    await _onStart();
  }
}

// Isha prayer switch
@pragma('vm:entry-point')
ishaPrayer(List<dynamic> args) async {
  RootIsolateToken rootIsolateToken = args[0];
  BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  if (args[1] == false) {
    await prefs.setBool('switch6Status', args[1]);
    await prefs.setInt('currentSwitch', args[2]);
    int? notiid6 = prefs.getInt('notiID6');
    // cancel existing notification
    await cancel(notiid6);
  } else {
    await prefs.setBool('switch6Status', args[1]);
    await prefs.setInt('currentSwitch', args[2]);

    // if switch is turned on
    await _onStart();
  }
}

// Cancel all notification with on/off alarm button
@pragma('vm:entry-point')
turnOnOfAlarm(List<dynamic> args) async {
  RootIsolateToken rootIsolateToken = args[0];
  BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  if (args[1] == false) {
    await prefs.setBool('turnOfOnAlarm', false);

    // cancel existing notification
    await cancelAll();
  } else {
    await prefs.setBool('turnOfOnAlarm', true);
  }
}

// Workmanager callbackDispatcher
@pragma('vm:entry-point')
callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // await getLocation();
    await _onStart();

    return Future.value(true);
  });
}

@pragma('vm:entry-point')
Future scheduleNotification({
  int? id,
  String? title,
  String? body,
  String? payLoad,
  TZDateTime? scheduledDate,
}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? soundPrefs = prefs.getBool('soundPrefs');
  String? selectedSoundPref = prefs.getString('selectedSoundPref');

  final notificationDetail = soundPrefs == false
      ? await notificationDetailsNoSound()
      : selectedSoundPref == 'Azan2'
      ? await notificationDetailsAdhan1()
      : selectedSoundPref == 'Azan3'
      ? await notificationDetailsAdhan2()
      : selectedSoundPref == 'Azan4'
      ? await notificationDetailsAdhan3()
      : selectedSoundPref == 'Long_Beep'
      ? await notificationDetailsAdhan4()
      : selectedSoundPref == 'Short_Beep'
      ? await notificationDetailsAdhan5()
      : await notificationDetails();

  return notificationsPlugin.zonedSchedule(
    id!,
    title,
    body,
    scheduledDate!,
    notificationDetail,
    payload: payLoad,
    matchDateTimeComponents: DateTimeComponents.time,
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  );
}

// @pragma('vm:entry-point')
// Future scheduleNotification({
//   int? id,
//   String? title,
//   String? body,
//   String? payLoad,
//   TZDateTime? scheduledDate,
// }) async {
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   bool? soundPrefs = prefs.getBool('soundPrefs');
//   String? selectedSoundPref = prefs.getString('selectedSoundPref');
//   return notificationsPlugin.zonedSchedule(
//       id!,
//       title,
//       body,
//       scheduledDate!,
//       soundPrefs == false
//           ? await notificationDetailsNoSound()
//           : selectedSoundPref == 'Azan2'
//               ? await notificationDetailsAdhan1()
//               : selectedSoundPref == 'Azan3'
//                   ? await notificationDetailsAdhan2()
//                   : selectedSoundPref == 'Azan4'
//                       ? await notificationDetailsAdhan3()
//                       : selectedSoundPref == 'Long_Beep'
//                           ? await notificationDetailsAdhan4()
//                           : selectedSoundPref == 'Short_Beep'
//                               ? await notificationDetailsAdhan5()
//                               : await notificationDetails(),
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//       matchDateTimeComponents: DateTimeComponents.time);
// }

// convert prayer time to DateTime
@pragma('vm:entry-point')
DateTime setDateTime(prayerTime) {
  var time = DateTime.now();
  var splitTime = prayerTime.split(":");

  var newHour = int.parse(splitTime[0]);
  var newMins = int.parse(splitTime[1]);
  time = time.toLocal();
  time = DateTime(
    time.year,
    time.month,
    time.day,
    newHour,
    newMins,
    time.second,
    time.millisecond,
    time.microsecond,
  );
  return time;
}

// convert prayer time to TZDateTime
@pragma('vm:entry-point')
TZDateTime configureLocalTimeZone(scheduledNotificationDateTime) {
  tz.initializeTimeZones();

  var time = TZDateTime.from(scheduledNotificationDateTime!, local);
  return time;
}

@pragma('vm:entry-point')
String compareDateTime(DateTime dateTime) {
  String dateFormatted = DateFormat('h:mm').format(dateTime);

  return dateFormatted;
}

// compare prayer time and discover if there's any change in prayer time.
// if there's prayer time change, cancel previously scheduled notification and set new notification with new time
@pragma('vm:entry-point')
comparePrayerTime(
  List<String>? prayerTimes,
  // pt.PrayerTimes prayerTimes,
) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.reload();

  // Add extra minutes formate
  // var fajrTime = DateFormat.Hm()
  //     .format(prayerTimes.fajrStartTime!.add(const Duration(minutes: 1)));
  // var sunriseTime = DateFormat.Hm()
  //     .format(prayerTimes.sunrise!.subtract(const Duration(minutes: 2)));
  // var dhuhrTime = DateFormat.Hm()
  //     .format(prayerTimes.dhuhrStartTime!.add(const Duration(minutes: 2)));
  // var asrTime = DateFormat.Hm()
  //     .format(prayerTimes.asrStartTime!.add(const Duration(minutes: 2)));
  // var maghribTime = DateFormat.Hm()
  //     .format(prayerTimes.maghribStartTime!.add(const Duration(minutes: 2)));
  // var ishaTime = DateFormat.Hm()
  //     .format(prayerTimes.ishaStartTime!.add(const Duration(minutes: 5)));

  // For test notification
  // var fajrTime = "22:50";
  // var sunriseTime = "22:51";
  // var dhuhrTime = "22:52";
  // var asrTime = "22:53";
  // var maghribTime = "22:54";
  // var ishaTime = "22:55";

  // real data
  var fajrTime = prayerTimes![0];
  var sunriseTime = prayerTimes[1];
  var dhuhrTime = prayerTimes[2];
  var asrTime = prayerTimes[3];
  var maghribTime = prayerTimes[5];
  var ishaTime = prayerTimes[6];
  RxString waqtTime = "--".obs;
  RxString waqtName = "--".obs;

  String currentTime = DateFormat.Hms().format(DateTime.now());
  var finalCurrentTime = DateTime.parse('2000-01-01 $currentTime');
  if (finalCurrentTime.isBefore(DateTime.parse('2000-01-01 $fajrTime:00'))) {
    waqtName.value = "Fajr";
    waqtTime.value = fajrTime.toString();
  } else if (finalCurrentTime.isBefore(
    DateTime.parse('2000-01-01 $sunriseTime:00'),
  )) {
    waqtName.value = "Sunrise";
    waqtTime.value = sunriseTime.toString();
  } else if (finalCurrentTime.isBefore(
    DateTime.parse('2000-01-01 $dhuhrTime:00'),
  )) {
    waqtName.value = "Dhuhr";
    waqtTime.value = dhuhrTime.toString();
  } else if (finalCurrentTime.isBefore(
    DateTime.parse('2000-01-01 $asrTime:00'),
  )) {
    waqtName.value = "Asr";
    waqtTime.value = asrTime.toString();
  } else if (finalCurrentTime.isBefore(
    DateTime.parse('2000-01-01 $maghribTime:00'),
  )) {
    waqtName.value = "Magrib";
    waqtTime.value = maghribTime.toString();
  } else if (finalCurrentTime.isBefore(
    DateTime.parse('2000-01-01 $ishaTime:00'),
  )) {
    waqtName.value = "Isha";
    waqtTime.value = ishaTime.toString();
  } else if (finalCurrentTime.isAfter(
    DateTime.parse('2000-01-01 $fajrTime:00'),
  )) {
    waqtName.value = "Fajr";
    waqtTime.value = fajrTime.toString();
  }

  await HomeWidget.saveWidgetData<String>('_nextPrayerName', waqtName.value);
  await HomeWidget.saveWidgetData<String>('_nextPrayerTime', waqtTime.value);
  await HomeWidget.saveWidgetData<String>('_fajaBegin', fajrTime);
  await HomeWidget.saveWidgetData<String>('_zuhrBegin', dhuhrTime);
  await HomeWidget.saveWidgetData<String>('_asarBegin', asrTime);
  await HomeWidget.saveWidgetData<String>('_magribBegin', maghribTime);
  await HomeWidget.saveWidgetData<String>('_ishaBegin', ishaTime);
  await HomeWidget.updateWidget(
    name: 'HomeScreenWidgetProvider',
    iOSName: 'HomeScreenWidgetProvider',
  );

  String? setPrayerTime1;
  String? setPrayerTime2;
  String? setPrayerTime3;
  String? setPrayerTime4;
  String? setPrayerTime5;
  String? setPrayerTime6;

  setPrayerTime1 = prefs.getString('setPrayerTime1');
  setPrayerTime2 = prefs.getString('setPrayerTime2');
  setPrayerTime3 = prefs.getString('setPrayerTime3');
  setPrayerTime4 = prefs.getString('setPrayerTime4');
  setPrayerTime5 = prefs.getString('setPrayerTime5');
  setPrayerTime6 = prefs.getString('setPrayerTime6');

  final bool? switch1Status = prefs.getBool('switch1Status');
  final bool? switch2Status = prefs.getBool('switch2Status');
  final bool? switch3Status = prefs.getBool('switch3Status');
  final bool? switch4Status = prefs.getBool('switch4Status');
  final bool? switch5Status = prefs.getBool('switch5Status');
  final bool? switch6Status = prefs.getBool('switch6Status');

  final int? currentSwitch = prefs.getInt('currentSwitch');

  final List<PendingNotificationRequest> pendingNotificationRequests =
      await notificationsPlugin.pendingNotificationRequests();

  // if there's no prayer time previously set in shared preference, then set new time
  // usually runs when app is installed and open for the first time on device
  if (pendingNotificationRequests.isEmpty &&
      fajrTime.isNotEmpty &&
      sunriseTime.isNotEmpty &&
      dhuhrTime.isNotEmpty &&
      asrTime.isNotEmpty &&
      maghribTime.isNotEmpty &&
      ishaTime.isNotEmpty &&
      setPrayerTime1 == null &&
      setPrayerTime2 == null &&
      setPrayerTime3 == null &&
      setPrayerTime4 == null &&
      setPrayerTime5 == null &&
      setPrayerTime6 == null) {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.reload();
    final bool? turnOfOnAlarm = prefs.getBool('turnOfOnAlarm');
    if (turnOfOnAlarm == true) {
      onSettingsChange(prayerTimes);
    } else if (turnOfOnAlarm == false) {
      // ignore scheduling notification as user turn of notification alarm
    }
  }

  // handle duplicate notification bug
  if (pendingNotificationRequests.isNotEmpty &&
      pendingNotificationRequests.length > 6 &&
      setPrayerTime1 != null &&
      setPrayerTime2 != null &&
      setPrayerTime3 != null &&
      setPrayerTime4 != null &&
      setPrayerTime5 != null &&
      setPrayerTime6 != null) {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.reload();
    final bool? turnOfOnAlarm = prefs.getBool('turnOfOnAlarm');
    if (turnOfOnAlarm == true) {
      await cancelAll();
      await onSettingsChange(prayerTimes);
    } else if (turnOfOnAlarm == false) {
      // ignore scheduling notification as user turn of notification alarm
    }
  }

  // logic for when there's any changes in any prayer time
  // changes in prayer time could occur if there's a change in location or time of prayer based on prayer API
  if (setPrayerTime1 != null && fajrTime != setPrayerTime1 ||
      setPrayerTime2 != null && setPrayerTime2 != sunriseTime ||
      setPrayerTime3 != null && setPrayerTime3 != dhuhrTime ||
      setPrayerTime4 != null && setPrayerTime4 != asrTime ||
      setPrayerTime5 != null && setPrayerTime5 != maghribTime ||
      setPrayerTime6 != null && setPrayerTime6 != ishaTime) {
    // cancel all notification request
    await cancelAll();

    if (switch1Status != false) {
      int? notiid1 = prefs.getInt('notiID1');
      // cancel existing notification
      // cancel(notiid1);
      int randNumb = Random().nextInt(4) + 1;
      int notiID1;
      if (notiid1 == randNumb) {
        notiID1 = notiid1 != 4 ? randNumb + 1 : randNumb - 1;
      } else {
        notiID1 = randNumb;
      }

      prefs.setInt("notiID1", notiID1);

      // set new shared preference prayer time
      prefs.setString("setPrayerTime1", fajrTime);

      // var _prayerTime = setDateTime(fajrTime);
      // TZDateTime scheduleTime = configureLocalTimeZone(_prayerTime);
      TZDateTime scheduleTime = configureLocalTimeZone(setDateTime(fajrTime));

      // schedule new notification
      await scheduleNotification(
        id: notiID1,
        title: 'Fajr Prayer Time',
        body: 'Notification for Fajr Prayer',
        scheduledDate: scheduleTime,
      );
    }

    if (switch2Status != false) {
      int? notiid2 = prefs.getInt('notiID2');
      // cancel existing notification
      // cancel(notiid1);
      int randNumb = Random().nextInt(5) + 5;
      int notiID2;
      if (notiid2 == randNumb) {
        notiID2 = notiid2 != 9 ? randNumb + 1 : randNumb - 1;
      } else {
        notiID2 = randNumb;
      }

      prefs.setInt("notiID2", notiID2);

      // set new shared preference prayer time
      prefs.setString("setPrayerTime2", sunriseTime);

      // var _prayerTime = setDateTime(fajrTime);
      // TZDateTime scheduleTime = configureLocalTimeZone(_prayerTime);
      TZDateTime scheduleTime = configureLocalTimeZone(
        setDateTime(sunriseTime),
      );

      // schedule new notification
      await scheduleNotification(
        id: notiID2,
        title: 'Sunrise Time',
        body: 'Notification for Sunrise',
        scheduledDate: scheduleTime,
      );
    }

    if (switch3Status != false) {
      int? notiid3 = prefs.getInt('notiID3');

      int randNumb = Random().nextInt(5) + 10;
      int notiID3;
      if (notiid3 == randNumb) {
        notiID3 = notiid3 != 14 ? randNumb + 1 : randNumb - 1;
      } else {
        notiID3 = randNumb;
      }

      prefs.setInt("notiID3", notiID3);

      // set new shared preference prayer time
      prefs.setString("setPrayerTime3", dhuhrTime);
      TZDateTime scheduleTime = configureLocalTimeZone(setDateTime(dhuhrTime));

      // schedule new notification
      await scheduleNotification(
        id: notiID3,
        title: 'Dhuhr Prayer Time',
        body: 'Notification for Dhuhr Prayer',
        scheduledDate: scheduleTime,
      );
    }

    if (switch4Status != false) {
      int? notiid4 = prefs.getInt('notiID4');

      int randNumb = Random().nextInt(5) + 15;
      int notiID4;
      if (notiid4 == randNumb) {
        notiID4 = notiid4 != 19 ? randNumb + 1 : randNumb - 1;
      } else {
        notiID4 = randNumb;
      }

      prefs.setInt("notiID4", notiID4);

      prefs.setString("setPrayerTime4", asrTime);
      TZDateTime scheduleTime = configureLocalTimeZone(setDateTime(asrTime));

      await scheduleNotification(
        id: notiID4,
        title: 'Asr Prayer Time',
        body: 'Notification for Asr Prayer',
        scheduledDate: scheduleTime,
      );
    }

    if (switch5Status != false) {
      int? notiid5 = prefs.getInt('notiID5');

      int randNumb = Random().nextInt(5) + 20;
      int notiID5;
      if (notiid5 == randNumb) {
        notiID5 = notiid5 != 24 ? randNumb + 1 : randNumb - 1;
      } else {
        notiID5 = randNumb;
      }

      prefs.setInt("notiID5", notiID5);

      prefs.setString("setPrayerTime5", maghribTime);
      TZDateTime scheduleTime = configureLocalTimeZone(
        setDateTime(maghribTime),
      );

      await scheduleNotification(
        id: notiID5,
        title: 'Maghrib Prayer Time',
        body: 'Notification for Maghrib Prayer',
        scheduledDate: scheduleTime,
      );
    }

    if (switch6Status != false) {
      int? notiid6 = prefs.getInt('notiID6');

      int randNumb = Random().nextInt(5) + 25;
      int notiID6;
      if (notiid6 == randNumb) {
        notiID6 = notiid6 != 29 ? randNumb + 1 : randNumb - 1;
      } else {
        notiID6 = randNumb;
      }

      prefs.setInt("notiID6", notiID6);

      prefs.setString("setPrayerTime6", ishaTime);
      TZDateTime scheduleTime = configureLocalTimeZone(setDateTime(ishaTime));

      await scheduleNotification(
        id: notiID6,
        title: 'Isha Prayer Time',
        body: 'Notification for Isha Prayer',
        scheduledDate: scheduleTime,
      );
    }
  }

  // logic for when user toggle off and on the switches while prayer time
  // and set prayer time are  equal
  if (setPrayerTime1 != null &&
      fajrTime == setPrayerTime1 &&
      switch1Status == true &&
      currentSwitch == 1) {
    var fajrPrayer = setDateTime(fajrTime);
    TZDateTime scheduleTime = configureLocalTimeZone(fajrPrayer);
    int? notiid1 = prefs.getInt('notiID1');

    int randNumb = Random().nextInt(4) + 1;
    int notiID1;
    if (notiid1 == randNumb) {
      notiID1 = notiid1 != 4 ? randNumb + 1 : randNumb - 1;
    } else {
      notiID1 = randNumb;
    }

    prefs.setInt("notiID1", notiID1);
    prefs.setInt('currentSwitch', 0);

    // schedule new notification
    await scheduleNotification(
      id: notiID1,
      title: 'Fajr Prayer Time',
      body: 'Notification for Fajr Prayer',
      scheduledDate: scheduleTime,
    );
  }

  if (setPrayerTime2 != null &&
      sunriseTime == setPrayerTime2 &&
      switch2Status == true &&
      currentSwitch == 2) {
    TZDateTime scheduleTime = configureLocalTimeZone(setDateTime(sunriseTime));
    int? notiid2 = prefs.getInt('notiID2');

    int randNumb = Random().nextInt(5) + 5;
    int notiID2;
    if (notiid2 == randNumb) {
      notiID2 = notiid2 != 9 ? randNumb + 1 : randNumb - 1;
    } else {
      notiID2 = randNumb;
    }

    prefs.setInt("notiID2", notiID2);
    prefs.setInt('currentSwitch', 0);

    // schedule new notification
    await scheduleNotification(
      id: notiID2,
      title: 'Sunrise Time',
      body: 'Notification for Sunrise',
      scheduledDate: scheduleTime,
    );
  }

  if (setPrayerTime3 != null &&
      dhuhrTime == setPrayerTime3 &&
      switch3Status == true &&
      currentSwitch == 3) {
    TZDateTime scheduleTime = configureLocalTimeZone(setDateTime(dhuhrTime));

    int? notiid3 = prefs.getInt('notiID3');

    int randNumb = Random().nextInt(5) + 10;
    int notiID3;
    if (notiid3 == randNumb) {
      notiID3 = notiid3 != 14 ? randNumb + 1 : randNumb - 1;
    } else {
      notiID3 = randNumb;
    }

    prefs.setInt("notiID3", notiID3);
    prefs.setInt('currentSwitch', 0);

    // schedule new notification
    await scheduleNotification(
      id: notiID3,
      title: 'Dhuhr Prayer Time',
      body: 'Notification for Dhuhr Prayer',
      scheduledDate: scheduleTime,
    );
  }

  if (setPrayerTime4 != null &&
      asrTime == setPrayerTime4 &&
      switch4Status == true &&
      currentSwitch == 4) {
    TZDateTime scheduleTime = configureLocalTimeZone(setDateTime(asrTime));

    int? notiid4 = prefs.getInt('notiID4');

    int randNumb = Random().nextInt(5) + 15;
    int notiID4;
    if (notiid4 == randNumb) {
      notiID4 = notiid4 != 19 ? randNumb + 1 : randNumb - 1;
    } else {
      notiID4 = randNumb;
    }

    prefs.setInt("notiID4", notiID4);
    prefs.setInt('currentSwitch', 0);

    // schedule new notification
    await scheduleNotification(
      id: notiID4,
      title: 'Asr Prayer Time',
      body: 'Notification for Asr Prayer',
      scheduledDate: scheduleTime,
    );
  }

  if (setPrayerTime5 != null &&
      maghribTime == setPrayerTime5 &&
      switch5Status == true &&
      currentSwitch == 5) {
    TZDateTime scheduleTime = configureLocalTimeZone(setDateTime(maghribTime));

    int? notiid5 = prefs.getInt('notiID5');

    int randNumb = Random().nextInt(5) + 20;
    int notiID5;
    if (notiid5 == randNumb) {
      notiID5 = notiid5 != 24 ? randNumb + 1 : randNumb - 1;
    } else {
      notiID5 = randNumb;
    }

    prefs.setInt("notiID5", notiID5);
    prefs.setInt('currentSwitch', 0);

    // schedule new notification
    await scheduleNotification(
      id: notiID5,
      title: 'Maghrib Prayer Time',
      body: 'Notification for Maghrib Prayer',
      scheduledDate: scheduleTime,
    );
  }

  if (setPrayerTime6 != null &&
      ishaTime == setPrayerTime6 &&
      switch6Status == true &&
      currentSwitch == 6) {
    TZDateTime scheduleTime = configureLocalTimeZone(setDateTime(ishaTime));

    int? notiid6 = prefs.getInt('notiID6');

    int randNumb = Random().nextInt(5) + 25;
    int notiID6;
    if (notiid6 == randNumb) {
      notiID6 = notiid6 != 29 ? randNumb + 1 : randNumb - 1;
    } else {
      notiID6 = randNumb;
    }

    prefs.setInt("notiID6", notiID6);
    prefs.setInt('currentSwitch', 0);

    // schedule new notification
    await scheduleNotification(
      id: notiID6,
      title: 'Isha Prayer Time',
      body: 'Notification for Isha Prayer',
      scheduledDate: scheduleTime,
    );
  }

  // logic for when user toggle off and on the switches while prayer time
  // and set prayer time are not equal
  if (setPrayerTime1 != null &&
      fajrTime != setPrayerTime1 &&
      switch1Status == true &&
      currentSwitch == 1) {
    var fajrPrayer = setDateTime(fajrTime);
    TZDateTime scheduleTime = configureLocalTimeZone(fajrPrayer);
    int? notiid1 = prefs.getInt('notiID1');

    int randNumb = Random().nextInt(4) + 1;
    int notiID1;
    if (notiid1 == randNumb) {
      notiID1 = notiid1 != 4 ? randNumb + 1 : randNumb - 1;
    } else {
      notiID1 = randNumb;
    }

    prefs.setInt("notiID1", notiID1);
    prefs.setInt('currentSwitch', 0);

    // schedule new notification
    await scheduleNotification(
      id: notiID1,
      title: 'Fajr Prayer Time',
      body: 'Notification for Fajr Prayer',
      scheduledDate: scheduleTime,
    );
  }

  if (setPrayerTime2 != null &&
      sunriseTime != setPrayerTime2 &&
      switch2Status == true &&
      currentSwitch == 2) {
    TZDateTime scheduleTime = configureLocalTimeZone(setDateTime(sunriseTime));
    int? notiid2 = prefs.getInt('notiID2');

    int randNumb = Random().nextInt(5) + 5;
    int notiID2;
    if (notiid2 == randNumb) {
      notiID2 = notiid2 != 9 ? randNumb + 1 : randNumb - 1;
    } else {
      notiID2 = randNumb;
    }

    prefs.setInt("notiID2", notiID2);
    prefs.setInt('currentSwitch', 0);

    // schedule new notification
    await scheduleNotification(
      id: notiID2,
      title: 'Sunrise Time',
      body: 'Notification for Sunrise',
      scheduledDate: scheduleTime,
    );
  }

  if (setPrayerTime3 != null &&
      dhuhrTime != setPrayerTime3 &&
      switch3Status == true &&
      currentSwitch == 3) {
    TZDateTime scheduleTime = configureLocalTimeZone(setDateTime(dhuhrTime));

    int? notiid3 = prefs.getInt('notiID3');

    int randNumb = Random().nextInt(5) + 10;
    int notiID3;
    if (notiid3 == randNumb) {
      notiID3 = notiid3 != 14 ? randNumb + 1 : randNumb - 1;
    } else {
      notiID3 = randNumb;
    }

    prefs.setInt("notiID3", notiID3);
    prefs.setInt('currentSwitch', 0);

    // schedule new notification
    await scheduleNotification(
      id: notiID3,
      title: 'Dhuhr Prayer Time',
      body: 'Notification for Dhuhr Prayer',
      scheduledDate: scheduleTime,
    );
  }

  if (setPrayerTime4 != null &&
      asrTime != setPrayerTime4 &&
      switch4Status == true &&
      currentSwitch == 4) {
    TZDateTime scheduleTime = configureLocalTimeZone(setDateTime(asrTime));

    int? notiid4 = prefs.getInt('notiID4');

    int randNumb = Random().nextInt(5) + 15;
    int notiID4;
    if (notiid4 == randNumb) {
      notiID4 = notiid4 != 19 ? randNumb + 1 : randNumb - 1;
    } else {
      notiID4 = randNumb;
    }

    prefs.setInt("notiID4", notiID4);
    prefs.setInt('currentSwitch', 0);

    // schedule new notification
    await scheduleNotification(
      id: notiID4,
      title: 'Asr Prayer Time',
      body: 'Notification for Asr Prayer',
      scheduledDate: scheduleTime,
    );
  }

  if (setPrayerTime5 != null &&
      maghribTime != setPrayerTime5 &&
      switch5Status == true &&
      currentSwitch == 5) {
    TZDateTime scheduleTime = configureLocalTimeZone(setDateTime(maghribTime));

    int? notiid5 = prefs.getInt('notiID5');

    int randNumb = Random().nextInt(5) + 20;
    int notiID5;
    if (notiid5 == randNumb) {
      notiID5 = notiid5 != 24 ? randNumb + 1 : randNumb - 1;
    } else {
      notiID5 = randNumb;
    }

    prefs.setInt("notiID5", notiID5);
    prefs.setInt('currentSwitch', 0);

    // schedule new notification
    await scheduleNotification(
      id: notiID5,
      title: 'Maghrib Prayer Time',
      body: 'Notification for Maghrib Prayer',
      scheduledDate: scheduleTime,
    );
  }

  if (setPrayerTime6 != null &&
      ishaTime != setPrayerTime6 &&
      switch6Status == true &&
      currentSwitch == 6) {
    TZDateTime scheduleTime = configureLocalTimeZone(setDateTime(ishaTime));

    int? notiid6 = prefs.getInt('notiID6');

    int randNumb = Random().nextInt(5) + 25;
    int notiID6;
    if (notiid6 == randNumb) {
      notiID6 = notiid6 != 29 ? randNumb + 1 : randNumb - 1;
    } else {
      notiID6 = randNumb;
    }

    prefs.setInt("notiID6", notiID6);
    prefs.setInt('currentSwitch', 0);

    // schedule new notification
    await scheduleNotification(
      id: notiID6,
      title: 'Isha Prayer Time',
      body: 'Notification for Isha Prayer',
      scheduledDate: scheduleTime,
    );
  }

  // if there's no pending scheduled notification
  if (pendingNotificationRequests.isEmpty &&
      setPrayerTime1 != null &&
      setPrayerTime2 != null &&
      setPrayerTime3 != null &&
      setPrayerTime4 != null &&
      setPrayerTime5 != null &&
      setPrayerTime6 != null) {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.reload();
    final bool? turnOfOnAlarm = prefs.getBool('turnOfOnAlarm');
    if (turnOfOnAlarm == true) {
      onSettingsChange(prayerTimes);
    } else if (turnOfOnAlarm == false) {
      // ignore scheduling notification as user turn of notification alarm
    }
  }

  // for changes in notification sound or settings
  if (setPrayerTime1 != null &&
      setPrayerTime2 != null &&
      setPrayerTime3 != null &&
      setPrayerTime4 != null &&
      setPrayerTime5 != null &&
      setPrayerTime6 != null) {
    bool? soundPrefs = prefs.getBool('soundPrefs');
    String? selectedSoundPref = prefs.getString('selectedSoundPref');

    bool? setSound = prefs.getBool('setSound');
    String? setSelectedSound = prefs.getString('setSelectedSound');

    if (soundPrefs != setSound || selectedSoundPref != setSelectedSound) {
      if (soundPrefs != null) {
        prefs.setBool('setSound', soundPrefs);
      }
      if (selectedSoundPref != null) {
        prefs.setString('setSelectedSound', selectedSoundPref);
      }

      // cancel all notification request
      await cancelAll();

      await onSettingsChange(prayerTimes);
    } else {}
  } else {}
}

// called when notification is empty or sound settings changes
@pragma('vm:entry-point')
onSettingsChange(
  // pt.PrayerTimes prayerTimes,
  List<String>? prayerTimes,
) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.reload();

  // Add extra minutes formate
  // var fajrTime = DateFormat.Hm()
  //     .format(prayerTimes.fajrStartTime!.add(const Duration(minutes: 1)));
  // var sunriseTime = DateFormat.Hm()
  //     .format(prayerTimes.sunrise!.subtract(const Duration(minutes: 2)));
  // var dhuhrTime = DateFormat.Hm()
  //     .format(prayerTimes.dhuhrStartTime!.add(const Duration(minutes: 2)));
  // var asrTime = DateFormat.Hm()
  //     .format(prayerTimes.asrStartTime!.add(const Duration(minutes: 2)));
  // var maghribTime = DateFormat.Hm()
  //     .format(prayerTimes.maghribStartTime!.add(const Duration(minutes: 2)));
  // var ishaTime = DateFormat.Hm()
  //     .format(prayerTimes.ishaStartTime!.add(const Duration(minutes: 5)));

  // For test notification
  // var fajrTime = "22:50";
  // var sunriseTime = "22:51";
  // var dhuhrTime = "22:52";
  // var asrTime = "22:53";
  // var maghribTime = "22:54";
  // var ishaTime = "22:55";

  // real data
  var fajrTime = prayerTimes![0];
  var sunriseTime = prayerTimes[1];
  var dhuhrTime = prayerTimes[2];
  var asrTime = prayerTimes[3];
  var maghribTime = prayerTimes[5];
  var ishaTime = prayerTimes[6];

  // DateTime fajrDateTime = DateTime.parse("2024-02-03 19:40");
  // DateTime sunriseDateTime = DateTime.parse("2024-02-03 19:41");
  // DateTime dhurDateTime = DateTime.parse("2024-02-03 19:42");
  // DateTime asrDateTime = DateTime.parse("2024-02-03 19:43");
  // DateTime magribDateTime = DateTime.parse("2024-02-03 19:44");
  // DateTime ishaDateTime = DateTime.parse("2024-02-03 19:45");
  //
  // // // Format the DateTime object
  // var fajrTime = DateFormat.Hm().format(fajrDateTime);
  // var sunriseTime = DateFormat.Hm().format(sunriseDateTime);
  // var dhuhrTime = DateFormat.Hm().format(dhurDateTime);
  // var asrTime = DateFormat.Hm().format(asrDateTime);
  // var maghribTime = DateFormat.Hm().format(magribDateTime);
  // var ishaTime = DateFormat.Hm().format(ishaDateTime);

  final bool? switch1Status = prefs.getBool('switch1Status');
  final bool? switch2Status = prefs.getBool('switch2Status');
  final bool? switch3Status = prefs.getBool('switch3Status');
  final bool? switch4Status = prefs.getBool('switch4Status');
  final bool? switch5Status = prefs.getBool('switch5Status');
  final bool? switch6Status = prefs.getBool('switch6Status');

  if (switch1Status != false) {
    // set new shared preference prayer time
    prefs.setString("setPrayerTime1", fajrTime);
    TZDateTime scheduleTime = configureLocalTimeZone(setDateTime(fajrTime));
    int notiID1 = Random().nextInt(4) + 1;
    prefs.setInt("notiID1", notiID1);

    // schedule new notification
    await scheduleNotification(
      id: notiID1,
      title: 'Fajr Prayer Time',
      body: 'Notification for Fajr Prayer',
      scheduledDate: scheduleTime,
    );
  }

  if (switch2Status != false) {
    // set new shared preference prayer time
    prefs.setString("setPrayerTime2", sunriseTime);
    TZDateTime scheduleTime = configureLocalTimeZone(setDateTime(sunriseTime));
    int notiID2 = Random().nextInt(5) + 5;
    prefs.setInt("notiID2", notiID2);

    // schedule new notification
    await scheduleNotification(
      id: notiID2,
      title: 'Sunrise Time',
      body: 'Notification for Sunrise',
      scheduledDate: scheduleTime,
    );
  }

  if (switch3Status != false) {
    prefs.setString("setPrayerTime3", dhuhrTime);
    TZDateTime scheduleTime = configureLocalTimeZone(setDateTime(dhuhrTime));

    int notiID3 = Random().nextInt(5) + 10;
    prefs.setInt("notiID3", notiID3);

    await scheduleNotification(
      id: notiID3,
      title: 'Dhuhr Prayer Time',
      body: 'Notification for Dhuhr Prayer',
      scheduledDate: scheduleTime,
    );
  }

  if (switch4Status != false) {
    prefs.setString("setPrayerTime4", asrTime);
    TZDateTime scheduleTime = configureLocalTimeZone(setDateTime(asrTime));

    int notiID4 = Random().nextInt(5) + 15;
    prefs.setInt("notiID4", notiID4);

    await scheduleNotification(
      id: notiID4,
      title: 'Asr Prayer Time',
      body: 'Notification for Asr Prayer',
      scheduledDate: scheduleTime,
    );
  }

  if (switch5Status != false) {
    prefs.setString("setPrayerTime5", maghribTime);
    TZDateTime scheduleTime = configureLocalTimeZone(setDateTime(maghribTime));

    int notiID5 = Random().nextInt(5) + 20;
    prefs.setInt("notiID5", notiID5);

    await scheduleNotification(
      id: notiID5,
      title: 'Maghrib Prayer Time',
      body: 'Notification for Maghrib Prayer',
      scheduledDate: scheduleTime,
    );
  }

  if (switch6Status != false) {
    prefs.setString("setPrayerTime6", ishaTime);
    TZDateTime scheduleTime = configureLocalTimeZone(setDateTime(ishaTime));

    int notiID6 = Random().nextInt(5) + 25;
    prefs.setInt("notiID6", notiID6);

    await scheduleNotification(
      id: notiID6,
      title: 'Isha Prayer Time',
      body: 'Notification for Isha Prayer',
      scheduledDate: scheduleTime,
    );
  }
}

class PrayerTimeWidget extends StatefulWidget {
  const PrayerTimeWidget({super.key});

  @override
  State<PrayerTimeWidget> createState() => _PrayerTimeWidgetState();
}

class _PrayerTimeWidgetState extends State<PrayerTimeWidget> {
  PrayerTimeController prayerTimeController = Get.put(PrayerTimeController());
  final ThemeController darkModeController = Get.put(ThemeController());
  ReceivePort port = ReceivePort();
  bool? alarmSwitchOn = false;
  bool loading = false;

  bool isOn1 = false;
  bool isOn2 = false;
  bool isOn3 = false;
  bool isOn4 = false;
  bool isOn5 = false;
  bool isOn6 = false;

  // bool prayerTime1Change = false;

  @override
  void initState() {
    super.initState();
    checkLocation();
    getSwitchStatus();
    onOffAlarm(true);
  }

  // checkPermission() async {
  //   location.LocationPermission permission =
  //       await location.Geolocator.checkPermission();
  //   print('Location permission in initstate is $permission');
  //   if (permission != location.LocationPermission.always) {
  //     return _dialogBuilder(context);
  //   }
  // }

  checkLocation() async {
    bool serviceEnabled = await location.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return enableLocation(context);
    } else {
      // location enabled
      // location.LocationPermission permission =
      //     await location.Geolocator.checkPermission();
      // print('Location permission in initstate is $permission');
      // if (permission != location.LocationPermission.always) {
      //   return _dialogBuilder(context);
      // }
    }
  }

  getSwitchStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.reload();
    setState(() {
      alarmSwitchOn = prefs.getBool("alarmSwitchOn") ?? false;

      isOn1 = prefs.getBool("isOn1") ?? false;
      isOn2 = prefs.getBool("isOn2") ?? false;
      isOn3 = prefs.getBool("isOn3") ?? false;
      isOn4 = prefs.getBool("isOn4") ?? false;
      isOn5 = prefs.getBool("isOn5") ?? false;
      isOn6 = prefs.getBool("isOn6") ?? false;
    });
  }

  switchControl(status) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool("alarmSwitchOn", status);
    prefs.setBool("isOn1", status);
    prefs.setBool("isOn2", status);
    prefs.setBool("isOn3", status);
    prefs.setBool("isOn4", status);
    prefs.setBool("isOn5", status);
    prefs.setBool("isOn6", status);

    setState(() {
      alarmSwitchOn = status;
      isOn1 = status;
      isOn2 = status;
      isOn3 = status;
      isOn4 = status;
      isOn5 = status;
      isOn6 = status;
      loading = true;
    });
  }

  // turn on big alarm button
  onOffAlarm(bool status) async {
    if (status == true) {
      location.LocationPermission permission =
          await location.Geolocator.checkPermission();
      if (permission != location.LocationPermission.always) {
        return givePermission(context);
        return _dialogBuilder(context);
      } else {
        switchControl(status);
        Workmanager().registerPeriodicTask(
          'backgroundTask',
          'backgroundPeriodicTask',
          initialDelay: const Duration(seconds: 10),
          frequency: const Duration(minutes: 15),
        );
        final token = RootIsolateToken.instance;
        List<dynamic> args = [token, true];
        await compute(turnOnOfAlarm, args);
      }
    } else {
      switchControl(status);

      await Workmanager().cancelAll();
      final token = RootIsolateToken.instance;
      List<dynamic> args = [token, false];
      await compute(turnOnOfAlarm, args);
    }
    Future.delayed(const Duration(seconds: 6), () {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // switchControl(status) async {
    //   final SharedPreferences prefs = await SharedPreferences.getInstance();
    //
    //   prefs.setBool("alarmSwitchOn", status);
    //   prefs.setBool("isOn1", status);
    //   prefs.setBool("isOn2", status);
    //   prefs.setBool("isOn3", status);
    //   prefs.setBool("isOn4", status);
    //   prefs.setBool("isOn5", status);
    //   prefs.setBool("isOn6", status);
    //
    //   setState(() {
    //     alarmSwitchOn = status;
    //     isOn1 = status;
    //     isOn2 = status;
    //     isOn3 = status;
    //     isOn4 = status;
    //     isOn5 = status;
    //     isOn6 = status;
    //     loading = true;
    //   });
    // }

    // // turn on big alarm button
    //     onOffAlarm(bool status) async {
    //       if (status == true) {
    //         location.LocationPermission permission =
    //             await location.Geolocator.checkPermission();
    //         if (permission != location.LocationPermission.always) {
    //           return _dialogBuilder(context);
    //         } else {
    //           switchControl(status);
    //           Workmanager().registerPeriodicTask(
    //             'backgroundTask',
    //             'backgroundPeriodicTask',
    //             initialDelay: const Duration(seconds: 10),
    //             frequency: const Duration(minutes: 15),
    //           );
    //           final token = RootIsolateToken.instance;
    //           List<dynamic> args = [token, true];
    //           await compute(turnOnOfAlarm, args);
    //         }
    //       } else {
    //         switchControl(status);
    //
    //         await Workmanager().cancelAll();
    //         final token = RootIsolateToken.instance;
    //         List<dynamic> args = [token, false];
    //         await compute(turnOnOfAlarm, args);
    //       }
    //       Future.delayed(
    //         const Duration(seconds: 6),
    //         () {
    //           setState(() {
    //             loading = false;
    //           });
    //         },
    //       );
    //     }

    _fajrSwitch(bool newState) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("isOn1", newState);

      setState(() {
        isOn1 = newState;
      });
      if (isOn1 == true) {
        final token = RootIsolateToken.instance;
        List<dynamic> args = [token, true, 1];
        await compute(fajrPrayer, args);
      } else {
        final token = RootIsolateToken.instance;
        List<dynamic> args = [token, false, 1];
        await compute(fajrPrayer, args);
      }
    }

    _sunriseSwitch(bool newState) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("isOn2", newState);

      setState(() {
        isOn2 = newState;
      });
      if (isOn2 == true) {
        final token = RootIsolateToken.instance;
        List<dynamic> args = [token, true, 2];
        await compute(sunrisePrayer, args);
      } else {
        final token = RootIsolateToken.instance;
        List<dynamic> args = [token, false, 2];
        await compute(sunrisePrayer, args);
      }
    }

    _dhuhrSwitch(bool newState) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("isOn3", newState);

      setState(() {
        isOn3 = newState;
      });
      if (isOn3 == true) {
        final token = RootIsolateToken.instance;
        List<dynamic> args = [token, true, 3];
        await compute(dhuhrPrayer, args);
      } else {
        final token = RootIsolateToken.instance;
        List<dynamic> args = [token, false, 3];
        await compute(dhuhrPrayer, args);
      }
    }

    _asrSwitch(bool newState) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("isOn4", newState);

      setState(() {
        isOn4 = newState;
      });
      if (isOn4 == true) {
        final token = RootIsolateToken.instance;
        List<dynamic> args = [token, true, 4];
        await compute(asrPrayer, args);
      } else {
        final token = RootIsolateToken.instance;
        List<dynamic> args = [token, false, 4];
        await compute(asrPrayer, args);
      }
    }

    _maghribSwitch(bool newState) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("isOn5", newState);

      setState(() {
        isOn5 = newState;
      });
      if (isOn5 == true) {
        final token = RootIsolateToken.instance;
        List<dynamic> args = [token, true, 5];
        await compute(maghribPrayer, args);
      } else {
        final token = RootIsolateToken.instance;
        List<dynamic> args = [token, false, 5];
        await compute(maghribPrayer, args);
      }
    }

    _ishaSwitch(bool newState) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("isOn6", newState);

      setState(() {
        isOn6 = newState;
      });
      if (isOn6 == true) {
        final token = RootIsolateToken.instance;
        List<dynamic> args = [token, true, 6];
        await compute(ishaPrayer, args);
      } else {
        final token = RootIsolateToken.instance;
        List<dynamic> args = [token, false, 6];
        await compute(ishaPrayer, args);
      }
    }

    return GetBuilder<PrayerTimeController>(
      init: PrayerTimeController(),
      builder: (prayerTimeController) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.PADDING_SIZE_SMALL,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                "Prayer Time of  ${prayerTimeController.currentAddress.value}",
                textAlign: TextAlign.center,
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                  fontWeight: FontWeight.bold,
                  color: darkModeController.isDarkMode
                      ? AppColors.whiteColor
                      : AppColors.blackColor,
                ),
              ),
              const SizedBox(height: 15),

              GetBuilder<ThemeController>(
                init: ThemeController(),
                builder: (_) {
                  return Obx(
                    () => Column(
                      children: [
                        TodayprayerList(
                          imagePath: Images.Fajr_logo,
                          prayerName: 'Fajr',
                          prayerTime: prayerTimeController.fajrTime.toString(),
                          value: isOn1,
                          onChanged: alarmSwitchOn == false
                              ? null
                              : _fajrSwitch,
                        ),
                        const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                        TodayprayerList(
                          imagePath: Images.SUNRISE,
                          prayerName: 'Sunrise',
                          prayerTime: prayerTimeController.sunriseTime
                              .toString(),
                          value: isOn2,
                          onChanged: alarmSwitchOn == false
                              ? null
                              : _sunriseSwitch,
                        ),
                        const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                        TodayprayerList(
                          imagePath: Images.Dhuhr_logo,
                          prayerName: 'Dhuhr',
                          prayerTime: prayerTimeController.dhuhrTime.toString(),
                          value: isOn3,
                          onChanged: alarmSwitchOn == false
                              ? null
                              : _dhuhrSwitch,
                        ),
                        const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                        TodayprayerList(
                          imagePath: Images.Asr_logo,
                          prayerName: 'Asr',
                          prayerTime: prayerTimeController.asrTime.toString(),
                          value: isOn4,
                          onChanged: alarmSwitchOn == false ? null : _asrSwitch,
                        ),
                        const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                        TodayprayerList(
                          imagePath: Images.Magrib_logo,
                          prayerName: 'Magrib',
                          prayerTime: prayerTimeController.maghribTime
                              .toString(),
                          value: isOn5,
                          onChanged: alarmSwitchOn == false
                              ? null
                              : _maghribSwitch,
                        ),
                        const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                        TodayprayerList(
                          imagePath: Images.Isha_logo,
                          prayerName: 'Isha',
                          prayerTime: prayerTimeController.ishaTime.toString(),
                          value: isOn6,
                          onChanged: alarmSwitchOn == false
                              ? null
                              : _ishaSwitch,
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 05),

              // prayer notification on and off switch
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     alarmSwitchOn == false
              //         ? FloatingActionButton(
              //             onPressed: () async {
              //               // turn on alarm
              //               await onOffAlarm(true);
              //             },
              //             backgroundColor: Theme.of(context).primaryColor,
              //             child: loading
              //                 ? const Center(
              //                     child: CircularProgressIndicator(
              //                     color: Colors.white,
              //                   ))
              //                 : Image.asset(
              //                     Images.Sound_on_logo,
              //                     height: 20,
              //                     fit: BoxFit.fill,
              //                     color: Colors.white,
              //                   ))
              //         : FloatingActionButton(
              //             onPressed: () async {
              //               await onOffAlarm(false);
              //             },
              //             backgroundColor: Colors.red,
              //             child: loading
              //                 ? const Center(
              //                     child: CircularProgressIndicator(
              //                     color: Colors.white,
              //                   ))
              //                 : Image.asset(
              //                     Images.Sound_off_logo,
              //                     height: 20,
              //                     fit: BoxFit.fill,
              //                     color: Colors.white,
              //                   ),
              //           ),
              //   ],
              // ),
              const SizedBox(height: 05),
            ],
          ),
        );
      },
    );
  }
}

/// Get Prayer time Function ===>
@pragma('vm:entry-point')
prayerTimePackage(double lat, double long) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var selectCalName = prefs.getString('calMethodName');
  var selectmazhabname = prefs.getString('mazhab');

  PrayerTimes prayers = PrayerTimes();
  var calMethodName = PrayerTimes().Karachi;
  var mazhabName = PrayerTimes().Shafii;

  if ("Karachi" == selectCalName) {
    calMethodName = prayers.Karachi;
    // print("Karachi");
  } else if ("Jafari" == selectCalName) {
    calMethodName = prayers.Jafari;
    // print("Jafari");
  } else if ("ISNA" == selectCalName) {
    calMethodName = prayers.ISNA;
    //print("ISNA");
  } else if ("MWL" == selectCalName) {
    calMethodName = prayers.MWL;
    //   print("MWL");
  } else if ("Makkah" == selectCalName) {
    //print("Makkah");
    calMethodName = prayers.Makkah;
  } else if ("Egypt" == selectCalName) {
    // print("Egypt");
    calMethodName = prayers.Egypt;
  } else if ("Tehran" == selectCalName) {
    // print("Tehran");
    calMethodName = prayers.Tehran;
  }

  if ("Hanafi" == selectmazhabname) {
    mazhabName = prayers.Hanafi;
    // print("Hanafi");
  } else if ("Non-Hanafi" == selectmazhabname) {
    mazhabName = prayers.Shafii;
    // print("Non-Hanafi");
  }

  // For get time Zone---->
  initializeDateFormatting();
  DateTime dateTime = DateTime.now().toLocal();
  var timeZone = dateTime.timeZoneOffset.toString();
  List<String> splitTimeZone = timeZone.split(":");
  String hourDuration = '${splitTimeZone[0]}.${splitTimeZone[1]}';

  double timezone = double.parse(hourDuration);
  prayers.setTimeFormat(prayers.Time24);
  prayers.setCalcMethod(calMethodName);
  prayers.setAsrJuristic(mazhabName);
  prayers.setAdjustHighLats(prayers.OneSeventh);
  var offsets = [0, 0, 0, 0, 0, 0, 0];
  prayers.tune(offsets);
  final date = DateTime.now();
  List<String> prayerTimes = prayers.getPrayerTimes(date, lat, long, timezone);
  // await FlutterIsolate.spawn(comparePrayerTime, prayerTimes);
  // data.insert(1, prayerTimes);
  await comparePrayerTime(prayerTimes);
  // return prayerTimes;
}

// start background locator
@pragma('vm:entry-point')
_onStart() async {
  await _startLocator();
}

// get user location and return location data
@pragma('vm:entry-point')
Future<void> _startLocator() async {
  Map<String, dynamic> data = {'countInit': 1};
  return await BackgroundLocator.registerLocationUpdate(
    locationDatacallback,
    initDataCallback: data,
    disposeCallback: LocationCallbackHandler.disposeCallback,
    iosSettings: const IOSSettings(
      accuracy: LocationAccuracy.NAVIGATION,
      distanceFilter: 0,
      stopWithTerminate: true,
    ),
    autoStop: false,
    androidSettings: const AndroidSettings(
      accuracy: LocationAccuracy.NAVIGATION,
      interval: 5,
      distanceFilter: 0,
      client: LocationClient.google,
      androidNotificationSettings: AndroidNotificationSettings(
        notificationChannelName: 'Mosque Global',
        notificationTitle: 'Start Location Tracking',
        notificationMsg: 'Track location in background',
        notificationBigMsg:
            'Background location is on to keep the app up-to-date with your location. This is required to deliver accurate prayer time alarm notification.',
        notificationIconColor: Colors.grey,
      ),
    ),
  );
}

// callback top level function for location data
@pragma('vm:entry-point')
Future<void> locationDatacallback(LocationDto locationDto) async {
  LocationServiceRepository myLocationCallbackRepository =
      LocationServiceRepository();

  await prayerTimePackage(locationDto.latitude, locationDto.longitude);
  await myLocationCallbackRepository.callback(locationDto);
}

Future<void> _dialogBuilder(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Column(
          children: [
            Image.asset(Images.APP_LOGO, height: 80),
            const SizedBox(height: 5),
            const Text('Mosque Global', style: TextStyle(fontSize: 20)),
          ],
        ),
        content: const Text(
          'To deliver accurate prayer notifications even when app is not open or when you change geographic location with different time zone, Mosque Global requires that you grant it "Allow all the time" location permission.',
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Give Permission'),
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return const GuideScreen();
                  },
                ),
              );
            },
          ),
          // TextButton(
          //   style: TextButton.styleFrom(
          //     textStyle: Theme.of(context).textTheme.labelLarge,
          //   ),
          //   child: const Text('Cancel'),
          //   onPressed: () {
          //     Navigator.of(context).pop();
          //   },
          // ),
        ],
      );
    },
  );
}

// location dialog box
Future<void> enableLocation(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Column(
          children: [
            Image.asset(Images.APP_LOGO, height: 80),
            const SizedBox(height: 5),
            const Text('LOCATION DISABLED', style: TextStyle(fontSize: 20)),
          ],
        ),
        content: const Text(
          'To get Prayer Time, Mosque Global requires that you enable device location.',
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Enable Location'),
            onPressed: () async {
              location.Geolocator.openLocationSettings();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Continue'),
            onPressed: () {
              Get.offAll(() => const SplashScreen());
            },
          ),
        ],
      );
    },
  );
}

Future<void> givePermission(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Column(
          children: [
            Image.asset(Images.APP_LOGO, height: 80),
            const SizedBox(height: 5),
            const Text(
              'Background Location Permission Required',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        content: const Text(
          'To provide accurate prayer times based on your location, our app requires background access to your location. This ensures that whenever you move from one place to another, you always receive the correct prayer times for your current location.\n\nThe process runs continuously in the background, allowing you to access the right prayer times no matter where you are. Even when you are not actively using the app, background location access ensures you receive accurate prayer time notifications.\n\nPlease grant background location permission to enable this feature.',
          textAlign: TextAlign.justify,
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Allow'),
            onPressed: () {
              Get.back();
              _dialogBuilder(context);
            },
          ),
        ],
      );
    },
  );
}
