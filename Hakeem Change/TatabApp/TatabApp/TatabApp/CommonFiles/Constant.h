//
//  Constant.h
//  ShreeAirlines
//
//  Created by NetprophetsMAC on 4/5/17.
//  Copyright © 2017 Netprophets. All rights reserved.
//

#ifndef Constant_h
#define Constant_h



#define TAG_USERTYPE_CONSULTING 1001
#define TAG_USERTYPE_AWARENESS 1002



#define BoolValueKey @"BoolValue"

//Cloud Related

#define NOTIFICATION_PATIENT_ID @"gcm.notification.patient_id"
#define NOTIFICATION_DOCTOR_ID @"gcm.notification.doctor_id"
#define NOTIFICATION_BOOl @"NOTIFICATION_BOOl"
//Api related

#define PATIENT_ID @"patient_id"
#define DEPENDANT_ID @"dependent_id"
#define DOCTOR_ID @"doctor_id"
#define loginDOB @"date_of_birth"
#define loginPassword @"password"
#define loginemail @"email"
#define loginfirstname @"first_name"
#define logInImageUrl @"user_pic"
#define loginlastname @"last_name"
#define loginmobile @"mobile_number"
#define loginusergroup @"user_group"
#define loginuserId @"user_id"
#define LOGIN_IS_MOBILE_VERIFY @"is_mobile_verify"
#define loginuserType @"user_type"
#define loginuserGender @"gender"
#define loginuseIsComplete @"is_complete"
#define loginUserToken @"token"
#define loginUser @"user"
#define isLoggedIn @"isLoggedIn"
#define isLoggedInHit @"isLoggedInHit"

#define Gender @"gender"
#define Nationality @"nationality"
#define Residence @"residence"
#define WorkPlace @"workplace"
#define HomeLocation @"home_location"
#define Passport @"passport"
#define Specialist @"specialist"
#define currentGrade @"current_grade"
#define SubSpecialist @"sub_specialist"
#define classification @"classification"
#define Experience @"experience"
#define HospitalName @"hospital_name"
#define WorkedSince @"worked_since"
#define ResignedSince @"resigned_since"
#define IBAN @"iban"
#define Photo @"photo"
#define Document @"document"
#define isAwarenessApiHIt @"Api"
#define RelationApi @"IsRelationApiHIt"
//Alert Related Constant
#define EjabbrdIP @"ec2-13-127-164-75.ap-south-1.compute.amazonaws.com"
#define Tag_For_Remove_Alert 100
#define OK_Btn @"ok"
#define Cancel_Btn @"cancel"
#define AlertKey @"alert"
#define Warning_Key @"Warning"
#define Error_Key @"error"
#define Alert_Key_For_Image @"success"
#define Warning_Key_For_Image @"warning"
#define Error_Key_For_Image @"error_red"
#define Sevrer_Issue_Message @"Some network issue. Try Again."

#define Network_Issue_Message @"No Network Access"

#define codeForActivatedAccount @"NP001"
//Color related

#define primary_Color @"00b1dd"
#define Primary_GreenColor @"7ac430"

//EMR

#define Selected_Patient_Weight @"SWeight"
#define Selected_Patient_Height @"Shight"
//Notificatio Related
#define Notification_Related @"Notification"
//Url Related
#define firstName @"firstName"
#define lastName @"lastName"
#define emailId @"emailId"
#define mobileNo @"mobile_no"
#define recordID @"recordId"
#define isdCode @"isdCode"
#define passwordToStore @"password"


#define isValidHitNP @"NP001"
#define isValidHitOther @"SA001"
#define LoginData @"userPojo"
#define NPHeaderName @"np-usr-rest:internal@123"
#define ShreeHeaderName @"np-appusr-rest:Xy#!@#@123"
#define LocationHeaderName @"np-loc-rest:internal@123"
#define PlaceHolder @"Add some text..."


#define selected_Nationality @"Nationality"


#define SuccessNotification @"RegisterSuccessNotiFication"
#define Privacy @"Privacy"
#define TermsAndCondition @"Terms"
#define FarePolicy @"Fair"
#define ContactUS @"Contact"

#define UPCOMING @"upcoming"
#define COMPLETED @"completed"
#define CANCELED @"canceled"
#define DEVICE_ID @"device_id"
#define DEVICE_ID_LoginUSer @"device_id_Login"


//LanguageRelated
#define Selected_Language @"Selected_Language"
#define Selected_Language_English @"English"
#define Selected_Language_Arebic @"Arebic"
#define IsLanguageSelected @"IsLanguageSelected"


//testing url


static NSString* const COLORCODE = @"#d22424";
static NSString* const COLORCODE_FOR_TEXTFIELD = @"#00b1dd";
static NSString* const COLORCODE_FOR_BUTTON = @"7ac430";

static NSString* const API_BASE_URL = @"http://www.dataheadstudio.com/test/api/";
static NSString* const API_FETCH_DOCTOR = @"specialization";
static NSString* const API_SA_BASE_URL = @"sa-service/";
static NSString* const API_USER_URL = @"np-user-service/users/";
static NSString* const API_LOCATION_URL = @"np-location-service/locations/";
static NSString* const API_SUPPORT = @"support";
static NSString* const API_Get_Doctor = @"getdoctor";
static NSString* const API_Update_Doctor = @"updatedoctor";
static NSString* const API_REGISTER_USER_URL = @"registerpatient";
static NSString* const API_LOGIN_URL = @"login";
static NSString* const API_ADD_PATIENT_URL = @"addpatient";
static NSString* const API_CHANGE_PASSWORD_URL = @"manage/AdminUser";
static NSString* const API_RESET_PASSWORD_URL = @"forgotPassword/AdminUser";
static NSString* const API_HISTORY = @"mybookings";
static NSString* const API_HISTORY_DETAIL = @"getBookingDetails";

static NSString* const API_COUNTRY_CODE = @"list/NpCountry";
static NSString* const API_WEATHER = @"list/Weather";
static NSString* const API_REPORT = @"pdfreport";

static NSString* const API_UploadDocument = @"upload";
static NSString* const API_FETCH_PATIENTS = @"patients";
static NSString* const API_DELETE_DEPENDANTS = @"dependentdelete";
static NSString* const API_ADD_DEPENDANTS = @"dependentadd";
static NSString* const API_FETCH_DEPENDANTS = @"fetchpatient";
static NSString* const API_GET_CHAT_GROUP = @"getchatgroup";
static NSString* const API_ADD_CHAT_GROUP = @"chatgroup";
static NSString* const API_GET_PRES_FOLLOW_UP_DETAILS = @"getprescription";
static NSString* const API_UPLOAD_DOCTOR_ADVICE = @"prescription";
static NSString* const API_RegisterDoctor = @"registerdoctor";
static NSString* const API_GET_BLOODSUGAR = @"getbloodsugar";
static NSString* const API_UPLOAD_BLOODSUGAR = @"reportbloodsugar";
static NSString* const API_GET_BLOODPRESSURE = @"getbloodpressure";
static NSString* const API_UPLOAD_BLOODPRESSURE = @"reportbloodpressure";
static NSString* const API_GET_WEIGHT = @"getreportweight";
static NSString* const API_UPLOAD_WEIGHT = @"reportweight";
static NSString* const API_GET_FEVER_REPORT = @"getreportfever";
static NSString* const API_UPLOAD_FEVER_REPORT = @"reportfever";
static NSString* const API_FOR_GET_RELATIONSHIP = @"getrelationships";
static NSString* const API_FOR_GET_COMMENTS = @"comments";
static NSString* const API_FOR_ADD_COMMENTS = @"usercomment";
static NSString* const API_FOR_PAYMENT = @"make_payment";
static NSString* const API_FOR_CHECK_FOLLOWUP = @"checkfollowup";
static NSString* const API_VERIFY_OTP = @"verify_otp";
static NSString* const API_GETOTP = @"get_otp";
#endif /* Constant_h */
