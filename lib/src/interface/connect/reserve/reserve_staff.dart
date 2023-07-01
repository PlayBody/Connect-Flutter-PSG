import 'package:connect/src/common/bussiness/staffs.dart';
import 'package:connect/src/common/dialogs.dart';
import 'package:connect/src/interface/component/button/default_buttons.dart';
import 'package:connect/src/interface/component/dropdown/dropdownmodel.dart';
import 'package:connect/src/interface/component/form/main_form.dart';
import 'package:connect/src/interface/component/text/label_text.dart';
import 'package:connect/src/interface/connect/reserve/reserve_date_first.dart';
import 'package:connect/src/model/stafflistmodel.dart';
import 'package:flutter/material.dart';
import '../../../common/globals.dart' as globals;

class ReserveStaff extends StatefulWidget {
  final String organId;
  const ReserveStaff({required this.organId, Key? key}) : super(key: key);

  @override
  _ReserveStaff createState() => _ReserveStaff();
}

class _ReserveStaff extends State<ReserveStaff> {
  int selectSex = 0;
  String? selectStaff;
  bool isShowAmountContent = true;
  bool isShowStaffComment = false;
  String staffName = "";
  String staffComment = "";

  late Future<List> loadData;
  List<StaffListModel> staffs = [];

  final dropdownState = GlobalKey<FormFieldState>();

  @override
  void initState() {
    super.initState();
    loadData = loadInitData();
  }

  Future<List> loadInitData() async {
    if (selectSex == 3)
      staffs = await ClStaff().loadStaffs(context,
          {'organ_id': widget.organId, 'min_auth': '1', 'max_auth': '4'});
    else
      staffs = [];

    // selectStaff = null;
    // if (staffs.length > 0) dropdownState.currentState!.didChange(null);
    staffName = '';
    isShowStaffComment = false;

    setState(() {});

    return [];
  }

  void onChangeStaffType(int val) {
    selectSex = val;
    loadInitData();
  }

  void onSelectStaff(String? staffId) {
    selectStaff = staffId;
    if (staffId == null) return;
    StaffListModel selStaff =
        staffs.firstWhere((element) => element.staffId == staffId);

    staffName = selStaff.staffNick == ''
        ? (selStaff.staffFirstName! + ' ' + selStaff.staffLastName!)
        : selStaff.staffNick;
    staffComment = selStaff.comment;
    isShowStaffComment = true;
    setState(() {});
  }

  void pushReserveDateFirst() {
    if (selectSex == 3 && selectStaff == null) {
      Dialogs().infoDialog(context, 'スタッフを選択いてください');
      return;
    }

    globals.selStaffType = selectSex;
    if (selectSex != 3) selectStaff = null;

    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return ReserveDateFirst(organId: widget.organId, staffId: selectStaff);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return MainForm(
      title: '予約',
      bgColor: Color(0xfff4f4ea),
      render: FutureBuilder<List>(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _getBodyContent();
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // By default, show a loading spinner.
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget _getBodyContent() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: <Widget>[
          Expanded(child: SingleChildScrollView(child: _getMainColumn())),
          PrimaryButton(label: '次へ', tapFunc: () => pushReserveDateFirst())
        ],
      ),
    );
  }

  Widget _getMainColumn() {
    return Column(
      children: [
        LeftSectionTitleText(label: 'ご指名はございますか？'),
        _getStaffTypeSelect(),
        if (selectSex == 3) _getStaffSelect(),
        SizedBox(height: 16),
        _getAboutAmountTitle(),
        SizedBox(height: 8),
        if (isShowAmountContent) _getAboutAmountContent(),
        if (staffName != '') _getStaffName(),
        if (isShowStaffComment) CommentBigText(label: staffComment)
      ],
    );
  }

  Widget _getStaffTypeSelect() {
    return Container(
      padding: EdgeInsets.only(left: 30, bottom: 24),
      child: Column(
        children: [
          _getSelectSexItem('なし', 0, selectSex),
          _getSelectSexItem('男性希望', 1, selectSex),
          _getSelectSexItem('女性希望', 2, selectSex),
          _getSelectSexItem('あり', 3, selectSex),
        ],
      ),
    );
  }

  Widget _getSelectSexItem(label, val, groupVal) {
    return GestureDetector(
        onTap: () => onChangeStaffType(val),
        child: Container(
            margin: EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Icon(val == groupVal ? Icons.circle : Icons.circle_outlined),
                SizedBox(width: 8),
                TextLabel(label: label)
              ],
            )));
  }

  Widget _getStaffSelect() {
    return Container(
      child: DropDownModelSelect(
        dropdownState: dropdownState,
        value: selectStaff,
        items: [
          ...staffs.map((e) => DropdownMenuItem(
                child: Text(
                  e.staffNick == ''
                      ? (e.staffFirstName! + ' ' + e.staffLastName!)
                      : e.staffNick,
                  style: TextStyle(
                      color:
                          e.staffSex == '1' ? Colors.blue : Colors.pinkAccent),
                ),
                value: e.staffId,
              ))
        ],
        tapFunc: (v) => onSelectStaff(v),
      ),
    );
  }

  Widget _getAboutAmountTitle() {
    return GestureDetector(
      onTap: () => setState(() => isShowAmountContent = !isShowAmountContent),
      child: Row(
        children: [
          Expanded(child: CommentTitleText(label: '指名料金について')),
          Icon(isShowAmountContent
              ? Icons.keyboard_arrow_up
              : Icons.keyboard_arrow_down)
        ],
      ),
    );
  }

  Widget _getAboutAmountContent() {
    return Container(
      child: Column(
        children: [
          CommentText(label: '※男性、女性指名料は220円税込み\n（施術時間に関係なく）'),
          SizedBox(height: 18),
          CommentText(label: '※個別指名料金は施術時間で変わります。'),
          CommentText(label: '～85分まで220円税込み'),
          CommentText(label: '90分から115分まで330円税込み'),
          CommentText(label: '120分以上　440円税込み'),
        ],
      ),
    );
  }

  Widget _getStaffName() {
    return GestureDetector(
      onTap: () => setState(() => isShowStaffComment = !isShowStaffComment),
      child: Row(
        children: [
          Expanded(child: LeftSectionTitleText(label: staffName)),
          Icon(isShowStaffComment
              ? Icons.keyboard_arrow_up
              : Icons.keyboard_arrow_down)
        ],
      ),
    );
  }
}
