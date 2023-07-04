const String APPCOMANYID = '2';
const String APPDOMAIN = 'riraku-kan.jp';
const String APPCOMPANYTITLE = 'りらくーかん';

const int constIsTestApi = 0;
const bool IsFirebaseMode = true;

// const String RESERVE_REQUEST = '1';
// const String RESERVE_APPLY = '2';
// const String RESERVE_REJECT = '3';
// const String RESERVE_CANCEL = '4';
// const String RESERVE_ENTERING = '5';
// const String RESERVE_COMPLETE = '6';

List<String> weekAry = ['月', '火', '水', '木', '金', '土', '日'];

List<dynamic> constSex = [
  {'value': '1', 'label': '男'},
  {'value': '2', 'label': '女'},
];

String errServerString = "システムエラーが発生しました。";
String errNetworkString =
    "通信ができませんでした。\nご使用端末の通信環境をご確認ください。\n通信環境を改善しても本メッセージが表示される場合はサポートへご連絡をお願いします";

const String ORDER_STATUS_NONE = '0';
const String ORDER_STATUS_RESERVE_REQUEST = '1';
const String ORDER_STATUS_RESERVE_REJECT = '2';
const String ORDER_STATUS_RESERVE_CANCEL = '3';
const String ORDER_STATUS_RESERVE_APPLY = '4';
const String ORDER_STATUS_TABLE_REJECT = '5';
const String ORDER_STATUS_TABLE_START = '6';
const String ORDER_STATUS_TABLE_END = '7';
const String ORDER_STATUS_TABLE_COMPLETE = '8';

String constCheckinTypeNone = '0';
String constCheckinTypeBoth = '1';
String constCheckinTypeOnlyReserve = '2';
