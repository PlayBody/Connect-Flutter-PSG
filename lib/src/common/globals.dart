library my_prj.globals;

import 'package:connect/src/model/menumodel.dart';

import '../model/rankmodel.dart';

// connect globals
String userId = '';
String userName = '';
String connectHeaerTitle = '';

String connectDeviceToken = '';

List<dynamic> connectReserveMenuList = [];
List<dynamic> reserveMultiUsers = [];
int menuSelectNumber = 1;
int selStaffType = 0;
int reserveTime = 0;
int reserveUserCnt = 1;

bool isCart = true;
String squareToken = '';

int progressPercent = 0;
bool isUpload = false;
RankModel? userRank;
