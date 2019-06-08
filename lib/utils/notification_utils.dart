import 'package:mt/domain/entity/card_entity.dart';
import 'package:mt/presentation/app.dart';
import 'package:mt/utils/string_utils.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const String _kNotificationChannelId = 'ScheduledNotification';
const String _kNotificationChannelName = 'Scheduled Notification';
const String _kNotificationChannelDescription =
    'Pushes a notification at a specified date';

Future scheduleNotification(CardEntity card) async {
  final notificationDetails = NotificationDetails(
    AndroidNotificationDetails(
      _kNotificationChannelId,
      _kNotificationChannelName,
      _kNotificationChannelDescription,
      importance: Importance.Max,
      priority: Priority.High,
    ),
    IOSNotificationDetails(),
  );

  await notificationManager.schedule(
    _dateToUniqueInt(card.addedDate),
    card.name,
    !isBlank(card.description)
        ? card.description
        : card.bulletPoints.map((b) => '- ${b.text}').join('    '),
    card.notificationDate,
    notificationDetails,
    payload: card.addedDate.toIso8601String(),
  );
}

void cancelNotification(CardEntity card) async {
  final id = _dateToUniqueInt(card.addedDate);
  await notificationManager.cancel(id);
}

int _dateToUniqueInt(DateTime date) {
  return date.year * 10000 + date.minute * 100 + date.second;
}
