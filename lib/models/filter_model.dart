import 'package:flutter/foundation.dart';

class FilterModel extends ChangeNotifier {
  bool latest = false;
  bool pending = false;
  bool getDateFilter() {
    return latest;
  }

  bool getStatusFilter() {
    return pending;
  }

  void setDateFilter(value) {
    latest = value;
    notifyListeners();
  }

  void setStatusFilter(value) {
    pending = value;
    notifyListeners();
  }
}
