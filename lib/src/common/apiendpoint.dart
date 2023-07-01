// String apiBase = 'https://www.visit-pos.com/cloud_devotion';
String apiBase = 'http://192.168.115.41';

String api = '$apiBase/apis';

String organImageUrl = apiBase + '/assets/images/organs/';
String ticketImageUrl = apiBase + '/assets/images/tickets/';
String menuImageUrl = apiBase + '/assets/images/menus/';
String adviseMovieBase = apiBase + '/assets/video/advise/';

String apiLoadCompanyStaffListUrl = apiBase + '/apistaffs/loadStaffCompanyList';
String apiAddStaffPointDataUrl = apiBase + '/apistaffs/submitAddPoint';

String apiLoadUserFromQrCodeUrl = apiBase + '/apiusers/loadUserFromQrNo';
String apiSaveUserInfoUrl = apiBase + '/apiusers/saveUserInfo';
String apiDeleteUserInfoUrl = '$apiBase/apiusers/deleteUser';

String apiLoadOrganListUrl = apiBase + '/apiorgans/loadOrganList';
String apiLoadOrganInfo = apiBase + '/apiorgans/loadOrganInfo';
String apiSaveOrganUrl = apiBase + '/apiorgans/saveOrgan';
String apiDeleteOrgan = apiBase + '/apiorgans/deleteOrgan';
String apiUploadOrganPhoto = apiBase + '/apiorgans/uploadPicture';

String apiLoadMenuViewList = apiBase + '/apimenus/loadViewMenuList';
String apiLoadAdminMenuInfoUrl = apiBase + '/apimenus/loadAdminMenuInfo';
String apiLoadMenuListUrl = apiBase + '/apimenus/loadMenuList';

String apiLoadMessagesUrl = apiBase + '/apimessages/loadMessages';
String apiLoadMessageUserListUrl = apiBase + '/apimessages/loadMessageUserList';
String apiUploadMessageAttachFileUrl =
    apiBase + '/apimessages/uploadAttachment';

String apiLoadCouponListUrl = apiBase + '/apicoupons/loadCouponList';
String apiLoadUserCouponsUrl = apiBase + '/apicoupons/loadUserCouponList';
String apiUpdateUserCouponUseFlagUrl = apiBase + '/apicoupons/updateUserCouponUseFlag';
String apiDeleteCouponInfoUrl = apiBase + '/apicoupons/deleteCouponInfo';
String apiLoadCouponInfoUrl = apiBase + '/apicoupons/getUserCouponInfo';
String apiSaveCouponUrl = apiBase + '/apicoupons/saveCoupon';
String apiLoadUserStampUrl = apiBase + '/apicoupons/loadUserStampList';

String apiLoadFavortieQuestionUrl =
    apiBase + '/apiquestions/loadFavoriteQuestions';
String apiSaveFavortieQuestionUrl =
    apiBase + '/apiquestions/saveFavoriteQuestion';

String apiSaveQuestionUrl = apiBase + '/apiquestions/saveQuestion';

String apiLoadReserveDataUrl = apiBase + '/apireserves/loadUserReserveData';
String apiLoadReserveSelStatusUrl = apiBase + '/apireserves/loadSelectStatus';
String apiLoadReservePossibleUrl = apiBase + '/apireserves/loadPossibleReserve';
String apiSaveReserveDataUrl = apiBase + '/apireserves/saveUserReserve';
String apiLoadReserveInfo = apiBase + '/apireserves/loadReserveInfo';

String apiRegisterDeviceToekn = apiBase + '/api/registerDeviceToken';
String apiLoadSaleSiteUrl = apiBase + '/api/loadSaleSite';

String apiLoadTeacherListUrl = apiBase + '/apiteachers/loadTeacherList';

String apiLoadAdviseListUrl = apiBase + '/apiadvises/loadAdviseList';
String apiLoadAdviseInfoUrl = apiBase + '/apiadvises/loadAdviseInfo';
String apiSaveAdviseInfoUrl = apiBase + '/apiadvises/saveAdviseInfo';
String apiUploadAdviseVideo = apiBase + '/apiadvises/uploadVideo';

String apiLoadMenuReviewUrl = apiBase + '/apireviews/loadMenuReview';
String apiSaveMenuReviewUrl = apiBase + '/apireviews/saveMenuReview';

String apiLoadCardListUrl = apiBase + '/apisquare/loadCardList';
String apiRenderPrintLogo = apiBase + '/apiorgans/renderPrintLogo?organ_id=';

String apiLoadReserveCondition = '$api/reserve/loadReserveConditions';
String apiSaveReserveByUser = '$api/reserve/saveReserveByUser';
