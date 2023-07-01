import 'package:chewie/chewie.dart';
import 'package:connect/src/common/functions/seletattachement.dart';
import 'package:connect/src/interface/connect/component/userbutton.dart';
import 'package:flutter/material.dart';

class DialogAttachPreview extends StatefulWidget {
  final String previewType;
  final String attachUrl;

  const DialogAttachPreview({
    Key? key,
    required this.previewType,
    required this.attachUrl,
  }) : super(key: key);

  @override
  _DialogAttachPreview createState() => _DialogAttachPreview();
}

class _DialogAttachPreview extends State<DialogAttachPreview> {
  var videoController;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();

    loadShift();
  }

  @override
  void dispose() {
    if (videoController != null) videoController.dispose();
    super.dispose();
  }

  Future<void> loadShift() async {
    if (widget.previewType == '2') {
      videoController = await SelectAttachments()
          .loadVideoNetWorkController(widget.attachUrl);
    }
    isLoading = false;
    setState(() {});
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          // borderRadius: BorderRadius.circular(AppConst.padding),
          ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()), height: 120)
          : contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        if (widget.previewType == '1')
          Positioned(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(child: Image.network(widget.attachUrl))
              ],
            ),
          ),
        if (widget.previewType == '2')
          Positioned(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                    height: MediaQuery.of(context).size.height * 0.85,
                    child: videoController == null
                        ? Container()
                        : Chewie(controller: videoController))
              ],
            ),
          ),
        Positioned(
            right: -40,
            top: 0,
            child: UserBtnCircleClose(tapFunc: () => Navigator.pop(context))),
      ],
    );
  }
}
