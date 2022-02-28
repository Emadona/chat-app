// @dart=2.9
import 'dart:async';

import 'package:chatapp/src/models/receipt.dart';
import 'package:chatapp/src/models/user.dart';
import 'package:chatapp/src/services/receipt/receipt_service_contract.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReceiptFirebase implements IReceiptService {
  final _controller = StreamController<Receipt>.broadcast();
  final CollectionReference collectionReceipts =
      FirebaseFirestore.instance.collection('receipts');
  StreamSubscription _changefeed;

  @override
  void dispose() {
    _controller?.close();
    _changefeed?.cancel();
  }

  @override
  Stream<Receipt> receipts(User user) {
    _startReceivingReceipts(user);
    return _controller.stream;
  }

  @override
  Future<bool> send(Receipt receipt) async {
    final record = await collectionReceipts.add(receipt.toJson());
    final bool = true;
    return bool;
  }

  _startReceivingReceipts(User user) {
    _changefeed = collectionReceipts
        .where('recipient', isEqualTo: user.id)
        .snapshots()
        .listen((event) {
      event.docs.forEach((element) {
        final receipt = Receipt.fromJson(element.data(), element.id);
        print('firebase receipt = ' + receipt.status.toString());
        _removeDeliverredReceipt(receipt);
        _controller.sink.add(receipt);
      });
    });
  }

  _removeDeliverredReceipt(Receipt receipt) {
    collectionReceipts.doc(receipt.id).delete();
  }

  @override
  Future<bool> update(Receipt receipt) async {
    final record =
        await collectionReceipts.doc(receipt.id).update(receipt.toJson());
  }
}
