import 'package:connect/src/interface/connect/product/product_cart.dart';
import 'package:flutter/material.dart';

class DialogAddCart extends StatefulWidget {
  final String showString;

  const DialogAddCart({
    Key? key,
    required this.showString,
  }) : super(key: key);

  @override
  _DialogAddCart createState() => _DialogAddCart();
}

class _DialogAddCart extends State<DialogAddCart> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(children: <Widget>[
          contentBox(),
        ]));
  }

  contentBox() {
    return Container(
        height: 190,
        alignment: Alignment.center,
        child: Column(
          children: [
            SizedBox(height: 24),
            Container(
                child: Text(
              'カートに追加されました',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            )),
            SizedBox(height: 16),
            Container(
                child: Text(widget.showString, style: TextStyle(fontSize: 14))),
            SizedBox(height: 28),
            ElevatedButton(onPressed: () => pushCart(), child: Text('カートを見る'))
          ],
        ));
  }

  void pushCart() {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return ProductCart();
    }));
  }
}
