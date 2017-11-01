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


//Api related


#define loginPassword @"password"
#define loginemail @"email"
#define loginfirstname @"first_name"
#define loginlastname @"last_name"
#define loginmobile @"mobile_number"
#define loginusergroup @"user_group"
#define loginuserId @"user_id"
#define loginuserType @"user_type"
#define loginuserGender @"gender"
#define loginuseIsComplete @"is_complete"
#define loginUserToken @"token"
#define loginUser @"user"
#define isLoggedIn @"isLoggedIn"
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

//Alert Related Constant
#define Tag_For_Remove_Alert 100
#define OK_Btn @"Ok"
#define Cancel_Btn @"Cancel"
#define AlertKey @"Alert"
#define Warning_Key @"Warning"
#define No_Network @"No Network Access"

#define codeForActivatedAccount @"NP001"
//Color related

#define primary_Color @"00b1dd"
#define Primary_GreenColor @"7ac430"

//Url Related
#define firstName @"firstName"
#define lastName @"lastName"
#define emailId @"emailId"
#define mobileNo @"mobileNo"
#define recordID @"recordId"
#define isdCode @"isdCode"
#define passwordToStore @"password"


#define isValidHitNP @"NP001"
#define isValidHitOther @"SA001"
#define LoginData @"userPojo"
#define NPHeaderName @"np-usr-rest:internal@123"
#define ShreeHeaderName @"np-appusr-rest:Xy#!@#@123"
#define LocationHeaderName @"np-loc-rest:internal@123"



#define selected_Nationality @"Nationality"



#define Privacy @"Privacy"
#define TermsAndCondition @"Terms"
#define FarePolicy @"Fair"
#define ContactUS @"Contact"

#define UPCOMING @"upcoming"
#define COMPLETED @"completed"
#define CANCELED @"canceled"

//testing url


static NSString* const COLORCODE = @"#d22424";
static NSString* const COLORCODE_FOR_TEXTFIELD = @"#00b1dd";



static NSString* const API_BASE_URL = @"http://www.dataheadstudio.com/test/api/";
static NSString* const API_FETCH_DOCTOR = @"specialization";
static NSString* const API_SA_BASE_URL = @"sa-service/";
static NSString* const API_USER_URL = @"np-user-service/users/";
static NSString* const API_LOCATION_URL = @"np-location-service/locations/";

static NSString* const API_REGISTER_USER_URL = @"registerpatient";
static NSString* const API_LOGIN_URL = @"login";
static NSString* const API_ADD_PATIENT_URL = @"addpatient";
static NSString* const API_CHANGE_PASSWORD_URL = @"manage/AdminUser";
static NSString* const API_RESET_PASSWORD_URL = @"forgotPassword/AdminUser";
static NSString* const API_HISTORY = @"mybookings";
static NSString* const API_HISTORY_DETAIL = @"getBookingDetails";

static NSString* const API_COUNTRY_CODE = @"list/NpCountry";
static NSString* const API_WEATHER = @"list/Weather";

static NSString* const API_UploadDocument = @"upload";
static NSString* const API_RegisterDoctor = @"registerdoctor";
#endif /* Constant_h */ 
