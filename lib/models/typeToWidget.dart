import 'package:schooly/components/homework/HomeworkManagement.dart';
import 'package:schooly/components/messages/Messages.dart';

class TypeToWidget {
  var currentWidget = {
    'homework_management': HomeworkManagement(),
    'messages': Messages(),
  };

  Map get translations {
    return this.currentWidget;
  }
}
