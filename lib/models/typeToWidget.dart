import 'package:schooly/components/events/Events.dart';
import 'package:schooly/components/galleries/Galleries.dart';
import 'package:schooly/components/homework/HomeworkManagement.dart';
import 'package:schooly/components/messages/Messages.dart';

class TypeToWidget {
  var currentWidget = {
    'homework_management': HomeworkManagement(),
    'messages': Messages(),
    'galleries': Galleries(),
    'events': Events(),
  };

  Map get translations {
    return this.currentWidget;
  }
}
