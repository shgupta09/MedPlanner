//
//  EMRHealthContainerVC.m
//  TatabApp
//
//  Created by Shagun Verma on 28/12/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//

#import "EMRHealthContainerVC.h"
#import "DoctorListEMRLogTableViewCell.h"
#import "DetailViewController.h"
@interface EMRHealthContainerVC ()<UITableViewDataSource,UITableViewDelegate,DoctorListEMRLogTableViewCellDelegate>
{
    LoderView *loderObj;
    NSMutableArray *doctorListArray;
    CustomAlert *alertObj;
    NSMutableArray *prescriptionArray;
    NSMutableArray *diagnosysArray;
    NSMutableArray *followUPArray;
    NSMutableArray *dataArray;
    NSString *fromDateString;
    NSString *toDateString;
    NSDate *toDate;
    NSDate *fromDate;
}
@property (weak, nonatomic) IBOutlet UITableView *tblView;

@end

@implementation EMRHealthContainerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [CommonFunction storeValueInDefault:@"-" andKey:Selected_Patient_Weight];
    [CommonFunction storeValueInDefault:@"-" andKey:Selected_Patient_Height];
    doctorListArray = [NSMutableArray new];
    [_tblView registerNib:[UINib nibWithNibName:@"DoctorListEMRLogTableViewCell" bundle:nil]forCellReuseIdentifier:@"DoctorListEMRLogTableViewCell"];
    _tblView.rowHeight = UITableViewAutomaticDimension;
    _tblView.estimatedRowHeight = 100;
    _tblView.multipleTouchEnabled = NO;
    alertObj = [[CustomAlert alloc] initWithFrame:self.view.frame];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notficationRecieved:) name:@"PopBackNow" object:nil];

    
        [_lblPatientName setText:[_dependant.name capitalizedString]];
        [_lblgender setText:_dependant.gender];
        [_lblbirthDate setText:[CommonFunction ConvertDateTime2:_dependant.birthDay]];
   
    
    
    
    [self hitApiForSpeciality];
    [self setLanguageData];
    [self setDate];
    [self getWeight];
    // Do any additional setup after loading the view from its nib.
}
-(void)setDate{
    dataArray = [NSMutableArray new];
    fromDate = [NSDate date];
    toDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    //self.myLabel.text = [dateFormatter stringFromDate:[dueDatePickerView date]];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    fromDateString = [CommonFunction setOneMonthOldGate];
    toDateString = [dateFormatter stringFromDate:toDate];
}
-(void)setLanguageData{
    _lbl_No_Data.text = [Langauge getTextFromTheKey:@"no_data"];
    [_btn_EMR setTitle:[Langauge getTextFromTheKey:@"emr"] forState:UIControlStateNormal];
    [_btn_Health setTitle:[Langauge getTextFromTheKey:@"health_tracker"] forState:UIControlStateNormal];
    
    _lbl_title.text = [Langauge getTextFromTheKey:@"emr"];
    _lbl_EmrLog.text = [Langauge getTextFromTheKey:@"emr_log"];
    _lbl_patient.text = [Langauge getTextFromTheKey:@"patient"];
    _lbl_GenderTitle.text = [Langauge getTextFromTheKey:@"gender"];
    _lbl_Height_Title.text = [Langauge getTextFromTheKey:@"height"];
    _lbl_BirthDate.text = [Langauge getTextFromTheKey:@"birthdate"];
    _lbl_WeightTitle.text = [Langauge getTextFromTheKey:@"weight"];
    _lbl_Chronic.text = [Langauge getTextFromTheKey:@"chornic"];
    _lbl_Date_Title.text = [Langauge getTextFromTheKey:@"date"];
    _lbl_Details_Title.text = [Langauge getTextFromTheKey:@"details"];
    _lbl_Doctor_Title.text = [Langauge getTextFromTheKey:@"doctor"];
    _lbl_Followup_Title.text = [Langauge getTextFromTheKey:@"follow_up"];
    _lbl_Prescription_Title.text = [Langauge getTextFromTheKey:@"prescription"];
}

-(void)viewDidLayoutSubviews{
    loderObj.frame = self.view.frame;
    alertObj.frame = self.view.frame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//
- (IBAction)btnHealthTrackerClicked:(id)sender {
    HealthTrackerContainerVC* vc ;
    vc = [[HealthTrackerContainerVC alloc] initWithNibName:@"HealthTrackerContainerVC" bundle:nil];
   
  
        vc.isdependant = _isdependant;
        vc.patient = _patient;
        vc.dependant = _dependant;
   
        
   

    UINavigationController* navVC = [[UINavigationController alloc ] initWithRootViewController:vc];
    navVC.navigationBarHidden = true;
    [self.navigationController presentViewController:navVC animated:false completion:nil];
    
}


-(void) notficationRecieved:(NSNotification*) notification{
    [self.navigationController popViewControllerAnimated:true];

}


#pragma mark- tbl methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (doctorListArray.count == 0) {
        _lbl_Nodata.hidden = false;
    }else{
        _lbl_Nodata.hidden = true;
    }
    return doctorListArray.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    DoctorListEMRLogTableViewCell *cell = [_tblView dequeueReusableCellWithIdentifier:@"DoctorListEMRLogTableViewCell"];
    
    if (cell == nil) {
        cell = [[DoctorListEMRLogTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"DoctorListEMRLogTableViewCell"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row%2==0) {
        cell.viewBack.backgroundColor = [UIColor whiteColor];
    }else{
        
        cell.viewBack.backgroundColor = [UIColor colorWithRed:245.0/255.0f green:245.0/255.0f blue:245.0/255.0f alpha:1];
    }
    Specialization *obj = [doctorListArray objectAtIndex:indexPath.row];
        cell.lblName.text = [NSString stringWithFormat:@"Dr. %@",obj.first_name];
        cell.lblCategoryName.text = obj.sub_specialist;
        //    cell.profileImageView.image = [CommonFunction getImageWithUrlString:obj.photo];
        [cell.imgViewProfile sd_setImageWithURL:[NSURL URLWithString:obj.photo] placeholderImage:[UIImage imageNamed:@"doctor.png"]];
    cell.lblDate.text = [CommonFunction ConvertDateTime:obj.created_at]  ;
        cell.imgViewProfile.layer.cornerRadius = 8;
        cell.imgViewProfile.clipsToBounds = true;
     [cell.clinicImage setImage:[self setImageFor:obj.sub_specialist]];
    [cell.btnDetails setTag:1000+indexPath.row];
    [cell.btnfollowUp setTag:3000+indexPath.row];
    [cell.btnPrescription setTag:2000+indexPath.row];
    cell.imgViewProfile.layer.borderColor = [CommonFunction colorWithHexString:Primary_GreenColor].CGColor;
    cell.imgViewProfile.layer.borderWidth = 1;
    cell.clinicImage.layer.borderColor = [CommonFunction colorWithHexString:Primary_GreenColor].CGColor;
    cell.clinicImage.layer.borderWidth = 1;
    cell.delegate = self;
    if ([obj.is_follow isEqualToString:@"true"]) {
//        [cell.btnfollowUp setImage:[UIImage imageNamed:@"check_active"] forState:UIControlStateNormal];
        [cell.btnfollowUp setBackgroundImage:[UIImage imageNamed:@"check_active"] forState:UIControlStateNormal];
    }else{
        [cell.btnfollowUp setBackgroundImage:[UIImage imageNamed:@"check-passive"] forState:UIControlStateNormal];
    }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
        
}
-(UIImage*) setImageFor:(NSString*) clinicName{
    
    if ([clinicName isEqualToString:@"Abdominal Clinic"]) {
        return [UIImage imageNamed:@"sec-abdomen-1"];
    }
    else if ([clinicName isEqualToString:@"Psychological Clinic"]) {
        return [UIImage imageNamed:@"sec-psy-1"];
    }
    else if ([clinicName isEqualToString:@"Family and Community Clinic"]) {
        return [UIImage imageNamed:@"sec-family-1"];
    }
    else if ([clinicName isEqualToString:@"Obgyne Clinic"]) {
        return [UIImage imageNamed:@"sec-obgyen-1"];
    }
    else if ([clinicName isEqualToString:@"Pediatrics Clinic"]) {
        return [UIImage imageNamed:@"section-children"];
    }
    
    return [UIImage imageNamed:@""];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    ChatViewController* vc = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
//        Specialization *obj = [doctorListArray objectAtIndex:indexPath.row];
//        vc.objDoctor = obj;
//        vc.awarenessObj = _awarenessObj;
//        vc.toId = obj.jabberId;
//        [self.navigationController pushViewController:vc animated:true];
   
}

#pragma maek - cell buttons actions

-(void)btnDetailsTapped:(UIButton *)sender{
    UIButton* btn = sender;
    Specialization* obj = [doctorListArray objectAtIndex:(btn.tag)%1000];
    NSLog(@"%@", obj.first_name);
    NSLog(@"%@", obj.doctor_id);
    [self hitApiForDetails:obj.doctor_id :1];
}
-(void)btnFollowTapped:(UIButton *)sender{
    UIButton* btn = sender;
    Specialization* obj = [doctorListArray objectAtIndex:(btn.tag)%1000];
    NSLog(@"%@", obj.first_name);
     NSLog(@"%@", obj.doctor_id);
    [self hitApiForDetails:obj.doctor_id :2];
}

-(void)btnPrescriptionTapped:(UIButton *)sender{
    UIButton* btn = sender;
    Specialization* obj = [doctorListArray objectAtIndex:(btn.tag)%1000];
    NSLog(@"%@", obj.first_name);
     NSLog(@"%@", obj.doctor_id);
    [self hitApiForDetails:obj.doctor_id :3];
}


#pragma mark - btn Actions

- (IBAction)btnAction_instructions:(id)sender {
    
    [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:@"For more instructions about using TatabApp tracker please visit www.tatabapp.com" isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Alert_Key_For_Image];
}


- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}


#pragma mark - Api Related


-(void)hitApiForDetails:(NSString *)doctorId :(int)switchINt{
    
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    [parameter setValue:_patient.patient_id forKey:@"patient_id"];
    [parameter setValue: doctorId forKey:@"doctor_id"];
    if (_isdependant) {
        [parameter setValue: _dependant.depedant_id forKey:@"dependent_id"];

    }else{
        [parameter setValue: @"na" forKey:@"dependent_id"];

    }

    
    
    if ([ CommonFunction reachability]) {
        [self addLoder];
        
        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_GET_PRES_FOLLOW_UP_DETAILS]  postResponse:parameter postImage:nil requestType:POST tag:nil isRequiredAuthentication:YES header:@"" completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"]) {
                    
                    
                    prescriptionArray= [NSMutableArray new];
                    followUPArray= [NSMutableArray new];
                    diagnosysArray= [NSMutableArray new];
                    NSArray *tempArray = [NSArray new];
                    tempArray  = [[responseObj valueForKey:@"data"] valueForKey:@"diagnosis"];;
                    [tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        CommonInfoPatient *object = [CommonInfoPatient new];
                        object.identifier = [obj valueForKey:@"id"];
                        object.created_at = [obj valueForKey:@"created_at"];
                        object.type = [obj valueForKey:@"type"];
                        object.details = [obj valueForKey:@"details"];
                        
                        [diagnosysArray addObject:object];
                    }];
                    tempArray = [NSArray new];
                    tempArray  = [[responseObj valueForKey:@"data"] valueForKey:@"prescription"];;
                    [tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        CommonInfoPatient *object = [CommonInfoPatient new];
                        object.identifier = [obj valueForKey:@"id"];
                        object.created_at = [obj valueForKey:@"created_at"];
                        object.type = [obj valueForKey:@"type"];
                        object.details = [obj valueForKey:@"details"];
                        
                        [prescriptionArray addObject:object];
                    }];
                    tempArray = [NSArray new];
                    tempArray  = [[responseObj valueForKey:@"data"] valueForKey:@"followup"];;
                    [tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        CommonInfoPatient *object = [CommonInfoPatient new];
                        object.identifier = [obj valueForKey:@"id"];
                        object.created_at = [obj valueForKey:@"created_at"];
                        object.type = [obj valueForKey:@"type"];
                        object.details = [obj valueForKey:@"details"];
                        
                        [followUPArray addObject:object];
                    }];
                    DetailViewController* vc = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
                    switch (switchINt) {
                        case 3:{
                            vc.detailType = @"prescription";
                            vc.detailArray = prescriptionArray;
                        }
                            break;
                        case 2:{
                            vc.detailType = @"follow_up";
                            vc.detailArray = followUPArray;
                        }break;
                        case 1:{
                            vc.detailType = @"diagnosis";
                            vc.detailArray = diagnosysArray;
                        }
                            break;
                            break;
                        default:
                            break;
                    }
                        [self presentViewController:vc animated:false completion:^{
                        [self removeloder];
                        
                    }];
                    
                    
                }else
                {
                    [self addAlertWithTitle:[Langauge getTextFromTheKey:Error_Key] andMessage:[responseObj valueForKey:@"message"] isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Error_Key_For_Image];
                    [self removeloder];
                    [self removeloder];
                }
                [self removeloder];
                
            }else{
                [self removeloder];
            }
            
            
            
        }];
    } else {
        [self removeloder];
        [self addAlertWithTitle:[Langauge getTextFromTheKey:Error_Key] andMessage:Network_Issue_Message isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Error_Key_For_Image];
    }
    
}
/*
-(void)hitApiForPrescription:(NSString *)doctorId{
    
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    [parameter setValue:_patient.patient_id forKey:@"patient_id"];
    [parameter setValue:doctorId forKey:@"doctor_id"];
    [parameter setValue:@"" forKey:@"dependent_id"];
    if ([ CommonFunction reachability]) {
        [self addLoder];
        
        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_GET_PRES_FOLLOW_UP_DETAILS]  postResponse:parameter postImage:nil requestType:POST tag:nil isRequiredAuthentication:YES header:@"" completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"]) {
                    
                    
                    NSMutableArray* array = [NSMutableArray new];
                    NSArray *tempArray = [NSArray new];
                    tempArray  = [[responseObj valueForKey:@"data"] valueForKey:@"prescription"];;
                    [tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        CommonInfoPatient *object = [CommonInfoPatient new];
                        object.identifier = [obj valueForKey:@"id"];
                        object.created_at = [obj valueForKey:@"created_at"];
                        object.type = [obj valueForKey:@"type"];
                        object.details = [obj valueForKey:@"details"];
                        
                        [array addObject:object];
                    }];
                    DetailViewController* vc = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
                    vc.detailType = @"Prescription";
                    vc.detailArray = array;
                    [self presentViewController:vc animated:false completion:^{
                        [self removeloder];
                        
                    }];
                    
                    
                }else
                {
                    [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:[responseObj valueForKey:@"message"] isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
                    [self removeloder];
                    [self removeloder];
                }
                [self removeloder];
                
            }
            
            
            
        }];
    } else {
        [self removeloder];
        [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:Network_Issue_Message isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
    }
    
}

-(void)hitApiForFollowUp:(NSString *)doctorId{
    
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    [parameter setValue:_patient.patient_id forKey:@"patient_id"];
    [parameter setValue:doctorId forKey:@"doctor_id"];

    if ([ CommonFunction reachability]) {
        [self addLoder];
        
        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_GET_PRES_FOLLOW_UP_DETAILS]  postResponse:parameter postImage:nil requestType:POST tag:nil isRequiredAuthentication:YES header:@"" completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"]) {
                    NSMutableArray* array = [NSMutableArray new];
                    NSArray *tempArray = [NSArray new];
                    tempArray  = [[responseObj valueForKey:@"data"] valueForKey:@"followup"];;
                    [tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        CommonInfoPatient *object = [CommonInfoPatient new];
                        object.identifier = [obj valueForKey:@"id"];
                        object.created_at = [obj valueForKey:@"created_at"];
                        object.type = [obj valueForKey:@"type"];
                        object.details = [obj valueForKey:@"details"];
                        
                        [array addObject:object];
                    }];
                    DetailViewController* vc = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
                    vc.detailType = @"Follow Up";
                    vc.detailArray = array;
                    [self presentViewController:vc animated:false completion:^{
                        [self removeloder];

                    }];
                    
                    
                }else
                {
                    [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:[responseObj valueForKey:@"message"] isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
                    [self removeloder];
                    [self removeloder];
                }
                [self removeloder];
                
            }
            
            
            
        }];
    } else {
        [self removeloder];
        [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:Network_Issue_Message isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
    }

}

*/
-(void)hitApiForSpeciality{
    
    
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    [parameter setValue:_patient.patient_id forKey:@"patient_id"];
    if (!_isdependant) {
        [parameter setValue:@"na" forKey:DEPENDANT_ID];
    }else{
        [parameter setValue:_dependant.depedant_id forKey:DEPENDANT_ID];
    }
    if ([ CommonFunction reachability]) {
        [self addLoder];
        
        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_GET_CHAT_GROUP]  postResponse:parameter postImage:nil requestType:POST tag:nil isRequiredAuthentication:YES header:@"" completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"]) {
                    
                    
                    doctorListArray = [NSMutableArray new];
                    NSArray *tempArray = [NSArray new];
                    tempArray  = [responseObj valueForKey:@"data"];
                    [tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        Specialization *specializationObj = [Specialization new];
                        specializationObj.classificationOfDoctor = [obj valueForKey:@"classification"];
                        specializationObj.created_at = [obj valueForKey:@"created_at"];
                        specializationObj.current_grade = [obj valueForKey:@"current_grade"];
                        specializationObj.doctor_id = [obj valueForKey:@"doctor_id"];
                        specializationObj.first_name = [obj valueForKey:@"first_name"];
                        specializationObj.is_follow = [obj valueForKey:@"is_follow"];
                        specializationObj.gender = [obj valueForKey:@"gender"];
                        specializationObj.last_name = [obj valueForKey:@"last_name"];
                        specializationObj.photo = [obj valueForKey:@"photo"];
                        specializationObj.sub_specialist = [obj valueForKey:@"sub_specialist"];
                        specializationObj.workplace = [obj valueForKey:@"workplace"];
                        specializationObj.jabberId = [NSString stringWithFormat:@"%@%@",[[[obj valueForKey:@"email"] componentsSeparatedByString:@"@"] objectAtIndex:0],[[[obj valueForKey:@"email"] componentsSeparatedByString:@"@"] objectAtIndex:1]];
                        
                        [doctorListArray addObject:specializationObj];
                    }];
                    [_tblView reloadData];
                
                }else
                {
                    [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:[responseObj valueForKey:@"message"] isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
                    [self removeloder];
                    [self removeloder];
                }
                [self removeloder];
                
            }else{
                [self removeloder];
            }
            
            
            
        }];
    } else {
        [self removeloder];
        [self addAlertWithTitle:[Langauge getTextFromTheKey:Error_Key] andMessage:Network_Issue_Message isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Error_Key_For_Image];
    }
}


#pragma mark - add loder

-(void)addLoder{
    self.view.userInteractionEnabled = NO;
    //  loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
    loderObj = [[LoderView alloc] initWithFrame:self.view.frame];
    loderObj.lbl_title.text = [Langauge getTextFromTheKey:@"please_wait"];
    [self.view addSubview:loderObj];
}

-(void)removeloder{
    //loderObj = nil;
    [loderObj removeFromSuperview];
    //[loaderView removeFromSuperview];
    self.view.userInteractionEnabled = YES;
}

#pragma mark- Custom Loder
-(void)addAlertWithTitle:(NSString *)titleString andMessage:(NSString *)messageString isTwoButtonNeeded:(BOOL)isTwoBUtoonNeeded firstbuttonTag:(NSInteger)firstButtonTag secondButtonTag:(NSInteger)secondButtonTag firstbuttonTitle:(NSString *)firstButtonTitle secondButtonTitle:(NSString *)secondButtonTitle image:(NSString *)imageName{
    [CommonFunction resignFirstResponderOfAView:self.view];
    alertObj.lbl_title.text = titleString;
    alertObj.lbl_message.text = messageString;
    alertObj.iconImage.image = [UIImage imageNamed:imageName];
    if (isTwoBUtoonNeeded) {
        alertObj.btn1.hidden = true;
        alertObj.btn2.hidden = false;
        alertObj.btn3.hidden = false;
        [alertObj.btn2 setTitle:firstButtonTitle forState:UIControlStateNormal];
        [alertObj.btn3 setTitle:secondButtonTitle forState:UIControlStateNormal];
        alertObj.btn2.tag = firstButtonTag;
        alertObj.btn3.tag = secondButtonTag;
        [alertObj.btn2 addTarget:self action:@selector(btnActionForCustomAlert:) forControlEvents:UIControlEventTouchUpInside];
        [alertObj.btn3 addTarget:self action:@selector(btnActionForCustomAlert:) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
         alertObj.btn2.hidden = true;
        alertObj.btn3.hidden = true;
        alertObj.btn1.hidden = false;
        alertObj.btn1.tag = firstButtonTag;
        [alertObj.btn1 setTitle:firstButtonTitle forState:UIControlStateNormal];
        [alertObj.btn1 addTarget:self
                          action:@selector(btnActionForCustomAlert:) forControlEvents:UIControlEventTouchUpInside];
    }
    alertObj.transform = CGAffineTransformMakeScale(0.01, 0.01);
   if (![alertObj isDescendantOfView:self.view]) {
        [self.view addSubview:alertObj];
    }
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        // animate it to the identity transform (100% scale)
        alertObj.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        // if you want to do something once the animation finishes, put it here
    }];
    
    
}
-(void)removeAlert{
    if ([alertObj isDescendantOfView:self.view]) {
        [alertObj removeFromSuperview];
    }
    
}

-(IBAction)btnActionForCustomAlert:(id)sender{
    switch (((UIButton *)sender).tag) {
        case Tag_For_Remove_Alert:
            [self removeAlert];
            break;
            
        default:
            
            break;
    }
}


-(void)getWeight{
    NSMutableDictionary *parameterDict = [[NSMutableDictionary alloc]init];
    
    
    if (!_isdependant){
        [parameterDict setValue:_patient.patient_id forKey:PATIENT_ID];
        [parameterDict setValue:@"na" forKey:DEPENDANT_ID];
        
    }
    else
    {
        [parameterDict setValue:_patient.patient_id forKey:PATIENT_ID];
        [parameterDict setValue:_dependant.depedant_id forKey:DEPENDANT_ID];
    }
    
    
    [parameterDict setValue:fromDateString forKey:@"from"];
    [parameterDict setValue:toDateString forKey:@"to"];
    
    if ([ CommonFunction reachability]) {
        
        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_GET_WEIGHT]  postResponse:[parameterDict mutableCopy] postImage:nil requestType:POST tag:nil isRequiredAuthentication:YES header:NPHeaderName completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                dataArray = [NSMutableArray new];
                
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"] == true){
                    NSArray *tempArray = [responseObj valueForKey:@"data"];
                    
                    [tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        Report *bloodObj = [Report new];
                        bloodObj.doctor_id = [obj valueForKey:@"doctor_id"];
                        bloodObj.weight = [obj valueForKey:@"weight"];
                        bloodObj.rest_hr = [obj valueForKey:@"rest_hr"];
                        bloodObj.height = [obj valueForKey:@"height"];
                        bloodObj.comment = [obj valueForKey:@"comment"];
                        bloodObj.date = [obj valueForKey:@"date"];
                        [dataArray addObject:bloodObj];
                    }];
                    Report *bloodObj = ((Report *)[dataArray lastObject]);
                    
                    [CommonFunction storeValueInDefault:bloodObj.weight andKey:Selected_Patient_Weight];
                    [CommonFunction storeValueInDefault:bloodObj.height andKey:Selected_Patient_Height];
                    
                    
                    [self setData];
                }else{
                    [self setData];
                }
            }else {
                [self setData];
            }
            
        }];
    } else {
        [self setData];
    }
}
-(void)setData{
    if (![[CommonFunction getValueFromDefaultWithKey:Selected_Patient_Weight] isEqualToString:@"-"]) {
        _lbl_WeightValue.text = [NSString stringWithFormat:@"%@ %@",[CommonFunction getValueFromDefaultWithKey:Selected_Patient_Weight],[Langauge getTextFromTheKey:@"Kg"]];
        _lbl_HeightValue.text = [NSString stringWithFormat:@"%@ %@",[CommonFunction getValueFromDefaultWithKey:Selected_Patient_Height],[Langauge getTextFromTheKey:@"Cm"]];
    }
    
}

            
@end
