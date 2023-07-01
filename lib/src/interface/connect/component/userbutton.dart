import 'package:flutter/material.dart';

// class AdminDeleteButton extends StatelessWidget {
//   final tapFunc;
//   const AdminDeleteButton({required this.tapFunc, Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//         onPressed: tapFunc,
//         child: Text('削除'),
//         style: ElevatedButton.styleFrom(
//             side: BorderSide(
//               width: 1,
//               color: Colors.redAccent,
//             ),
//             primary: Colors.white, //Color.fromARGB(255, 160, 30, 30),
//             onPrimary: Colors.redAccent,
//             elevation: 0,
//             textStyle: TextStyle(
//               fontSize: 12,
//             )));
//   }
// }

class UserAddButton extends StatelessWidget {
  final String label;
  final tapFunc;
  const UserAddButton({required this.label, required this.tapFunc, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: ElevatedButton(
            onPressed: tapFunc,
            child: Row(children: [Container(width: 10), Text(label)]),
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(8),
                side: BorderSide(
                  width: 1,
                  color: Colors.grey,
                ),
                primary: Colors.white, //Color.fromARGB(255, 160, 30, 30),
                onPrimary: Colors.grey,
                elevation: 0,
                textStyle: TextStyle(
                  fontSize: 20,
                ))));
  }
}

class UserPrimaryButton extends StatelessWidget {
  final String label;
  final tapFunc;
  const UserPrimaryButton(
      {required this.label, required this.tapFunc, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: tapFunc,
        child: Text(label),
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(8),
            side: BorderSide(
              width: 1,
              color: Colors.grey,
            ),
            primary: Colors.white, //Color.fromARGB(255, 160, 30, 30),
            onPrimary: Colors.grey,
            elevation: 0,
            textStyle: TextStyle(
              fontSize: 20,
            )));
  }
}

class AdminUserTicketAddButton extends StatelessWidget {
  final tapFunc;
  const AdminUserTicketAddButton({required this.tapFunc, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          child: ElevatedButton(
              child: Text('すべてのユーザーのチケットを+1枚'),
              onPressed: tapFunc,
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(10),
                  side: BorderSide(
                    width: 0.5,
                    color: Colors.black,
                  ),
                  primary: Colors.white, //Color.fromARGB(255, 160, 30, 30),
                  onPrimary: Colors.black,
                  elevation: 0,
                  textStyle: TextStyle(fontSize: 14))))
    ]);
  }
}

// class AdminImageUploadButton extends StatelessWidget {
//   final tapFunc;
//   const AdminImageUploadButton({required this.tapFunc, Key? key})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         child: ElevatedButton(
//             child: Row(children: [Text('画像アップロード')]),
//             onPressed: tapFunc,
//             style: ElevatedButton.styleFrom(
//                 padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
//                 side: BorderSide(
//                   width: 0.5,
//                   color: Colors.black,
//                 ),
//                 primary: Colors.white, //Color.fromARGB(255, 160, 30, 30),
//                 onPrimary: Colors.black,
//                 elevation: 0,
//                 textStyle: styleAddButtonText)));
//   }
// }

class AdminBtnIconRemove extends StatelessWidget {
  final tapFunc;
  const AdminBtnIconRemove({required this.tapFunc, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: new EdgeInsets.all(0.0),
      icon: Icon(Icons.delete, color: Colors.redAccent),
      onPressed: tapFunc,
    );
  }
}

class UserBtnIconDefualt extends StatelessWidget {
  final tapFunc;
  final icon;
  const UserBtnIconDefualt(
      {required this.tapFunc, required this.icon, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: new EdgeInsets.all(0.0),
      icon: Icon(icon, color: Colors.red),
      onPressed: tapFunc,
    );
  }
}

class UserBtnCircleIcon extends StatelessWidget {
  final tapFunc;
  final icon;
  const UserBtnCircleIcon({required this.tapFunc, required this.icon, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.all(4),
        width: 24,
        height: 24,
        // padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
      onTap: tapFunc,
    );
  }
}

class UserBtnCircleClose extends StatelessWidget {
  final tapFunc;
  const UserBtnCircleClose({required this.tapFunc, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Icon(Icons.close, size: 18, color: Colors.white),
      ),
      onTap: tapFunc,
    );
  }
}

class IncreaseButton extends StatelessWidget {
  final icon;
  final tapFunc;
  const IncreaseButton({required this.icon, required this.tapFunc, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.8),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(
          icon,
        ),
      ),
      onTap: tapFunc,
    );
  }
}
