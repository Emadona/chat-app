import 'package:chatapp/src/models/receipt.dart';
import 'package:chatapp/src/models/user.dart';

abstract class IReceiptService {
  Future<bool> send(Receipt receipt);
  Future<bool> update(Receipt receipt);
  Stream<Receipt> receipts(User user);
  void dispose();
}
