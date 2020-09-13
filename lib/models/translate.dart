class Translate {
  var translteMap = {
    'NotFound': 'לא נמצא משתמש, אנא נסו שנית',
    'NetworkError': 'ארעה שגיאת רשת, אנא נסו שנית',
    'SendValidationError': 'ארעה שגיאה בעת שליחת קוד העימות, אנא נסו שנית',
    'ValidationError': 'ארעה שגיאה באימות, אנא נסו שנית'
  };

  Map get translations {
    return this.translteMap;
  }
}
