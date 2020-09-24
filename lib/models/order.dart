class POrder {
  final int pId;
  final String pname;
  final String features;
  final DateTime orderdate;
  final String imageUrl;
  final int prize;
  final int quantity;
  final String status;
  final String phonenumber;
  final Map address;
  POrder(
      {this.pId,
      this.pname,
      this.features,
      this.imageUrl,
      this.orderdate,
      this.phonenumber,
      this.prize,
      this.quantity,
      this.status,
      this.address});
}
