import 'package:garden/models/order.dart';

List<POrder> dateFilter(bool filter, List<POrder> olist) {
  if (filter) {
    olist.sort((b, a) => a.orderdate.compareTo(b.orderdate));
  }
  return olist;
}

int getPendingOrderCount(List<POrder> list) {
  int count = 0;
  for (var obj in list) {
    if (obj.status == "pending") {
      count = count + 1;
    }
  }
  return count;
}

List<POrder> statusFilter(bool filter, List<POrder> olist) {
  List<POrder> nlist = [];
  if (filter) {
    for (var obj in olist) {
      if (obj.status == 'pending') {
        nlist.add(obj);
      }
    }
  } else {
    nlist = olist;
  }
  return nlist;
}
