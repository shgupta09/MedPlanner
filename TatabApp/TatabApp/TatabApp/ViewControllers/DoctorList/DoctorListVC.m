//
//  DoctorListVC.m
//  TatabApp
//
//  Created by shubham gupta on 10/14/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//

#import "DoctorListVC.h"
#import "PaymentVC.h"
@interface DoctorListVC ()
{
    LoderView *loderObj;
    NSMutableArray *doctorListArray;
    NSMutableArray *patientListArray;
    CustomAlert *alertObj;
    Specialization *objTemp;
}
@end

@implementation DoctorListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    alertObj = [[CustomAlert alloc] initWithFrame:self.view.frame];

    [self setData];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidLayoutSubviews{
    loderObj.frame = self.view.frame;
    alertObj.frame = self.view.frame;
}
-(void)setData{
    doctorListArray = [NSMutableArray new];
    _lbl_title.text = [_awarenessObj.category_name uppercaseString];
    [_tbl_View registerNib:[UINib nibWithNibName:@"HomeCell" bundle:nil]forCellReuseIdentifier:@"HomeCell"];
    _tbl_View.rowHeight = UITableViewAutomaticDimension;
    _tbl_View.estimatedRowHeight = 100;
    _tbl_View.multipleTouchEnabled = NO;
    _imgView.image = [UIImage imageNamed:_awarenessObj.category_name];
    
    if ([[CommonFunction getValueFromDefaultWithKey:loginuserType] isEqualToString:@"Patient"]) {
        [self hitApiForSpeciality];
    }
    else
    {
        [self hitApiForPatientList];
    }
    [self setLanguageData];
}
-(void)setLanguageData{
    _lbl_title.text = [Langauge getTextFromTheKey:[_awarenessObj.category_name stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
    _lbl_No_Data.text = [Langauge getTextFromTheKey:@"no_data"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark- tableView delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([[CommonFunction getValueFromDefaultWithKey:loginuserType] isEqualToString:@"Patient"]) {
        if (doctorListArray.count == 0) {
            _lbl_No_Data.hidden = false;
        }else{
            _lbl_No_Data.hidden = true;
        }
        return doctorListArray.count;

    }
    else
    {
        if (patientListArray.count == 0) {
            _lbl_No_Data.hidden = false;
        }else{
        _lbl_No_Data.hidden = true;
        }
        return patientListArray.count;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeCell *cell = [_tbl_View dequeueReusableCellWithIdentifier:@"HomeCell"];
    
    if (cell == nil) {
        cell = [[HomeCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"HomeCell"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if ([[CommonFunction getValueFromDefaultWithKey:loginuserType] isEqualToString:@"Patient"]) {
        Specialization *obj = [doctorListArray objectAtIndex:indexPath.row];
        cell.lbl_name.text = [NSString stringWithFormat:@"Dr. %@",obj.first_name];
        cell.lbl_specialization.text = obj.sub_specialist;
        cell.lbl_sub_specialization.text = obj.classificationOfDoctor;
        //    cell.profileImageView.image = [CommonFunction getImageWithUrlString:obj.photo];
        [cell.profileImageView sd_setImageWithURL:[NSURL URLWithString:obj.photo] placeholderImage:[UIImage imageNamed:@"doctor.png"]];
        
        cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.size.width/2;
        cell.profileImageView.clipsToBounds = true;
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        ChatPatient *obj = [patientListArray objectAtIndex:indexPath.row];
        cell.lbl_name.text = [NSString stringWithFormat:@"Mr. %@",obj.name];
        cell.lbl_specialization.text = @"Patient";
        if ([obj.gender  isEqual: @"M"]){
            cell.lbl_sub_specialization.text = @"Male";

        }
        else{
            cell.lbl_sub_specialization.text = @"Female";
  
        }
        //    cell.profileImageView.image = [CommonFunction getImageWithUrlString:obj.photo];
        [cell.profileImageView setImage:[UIImage imageNamed:@"profile.png"]];
        
        cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.size.width/2;
        cell.profileImageView.clipsToBounds = true;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[CommonFunction getValueFromDefaultWithKey:loginuserType] isEqualToString:@"Patient"]) {
        
        objTemp = [doctorListArray objectAtIndex:indexPath.row];
        NSString *str1 =[CommonFunction getValueFromDefaultWithKey:NOTIFICATION_DOCTOR_ID];
        NSString *str2 =[NSString stringWithFormat:@"%@",objTemp.doctor_id];
       
        if ([CommonFunction getBoolValueFromDefaultWithKey:NOTIFICATION_BOOl] && [str1 isEqualToString:str2]) {
            ChatViewController* vc = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
            vc.objDoctor = objTemp;
            objTemp.dependent_id = _selectedDependent.depedant_id;
            objTemp.dependent_Name = _selectedDependent.name;
            vc.awarenessObj = _awarenessObj;
            vc.toId = objTemp.jabberId;
            [self.navigationController pushViewController:vc animated:true];
        }else{
            
            [self hitApiForAddInTheQueue:objTemp.doctor_id];

        }
    }
    else
    {
        ChatViewController* vc = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
        vc.isDependent = _isDependent;
        ChatPatient *obj = [patientListArray objectAtIndex:indexPath.row];
        Specialization* temp = [Specialization new];
        temp.first_name = obj.name;
        temp.doctor_id = obj.patient_id ;
        temp.dependent_id = _selectedDependent.depedant_id;
        temp.dependent_Name = _selectedDependent.name;
        vc.objDoctor  = temp;
        
        vc.awarenessObj = _awarenessObj;
        vc.toId = obj.jabberId;
        [self.navigationController pushViewController:vc animated:true];
    }
    
}

#pragma mark - btn Actions
- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - Api Related
-(void)hitApiForSpeciality{
    
    
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    [parameter setValue:_awarenessObj.category_id forKey:@"specialist_id"];
    
    if ([ CommonFunction reachability]) {
        [self addLoder];
        
        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_FETCH_DOCTOR]  postResponse:parameter postImage:nil requestType:POST tag:nil isRequiredAuthentication:YES header:@"" completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"]) {
                    doctorListArray = [NSMutableArray new];
                    NSArray *tempArray = [NSArray new];
                    tempArray  = [responseObj valueForKey:@"specialization"];
                    [tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        Specialization *specializationObj = [Specialization new];
                        specializationObj.classificationOfDoctor = [obj valueForKey:@"classification"];
                        specializationObj.created_at = [obj valueForKey:@"created_at"];
                        specializationObj.current_grade = [obj valueForKey:@"current_grade"];
                        specializationObj.doctor_id = [obj valueForKey:@"doctor_id"];
                        specializationObj.first_name = [obj valueForKey:@"first_name"];
                        specializationObj.gender = [obj valueForKey:@"gender"];
                        specializationObj.last_name = [obj valueForKey:@"last_name"];
                        specializationObj.photo = [obj valueForKey:@"photo"];
                        specializationObj.sub_specialist = [obj valueForKey:@"sub_specialist"];
                        specializationObj.workplace = [obj valueForKey:@"workplace"];
                        specializationObj.jabberId = [NSString stringWithFormat:@"%@%@",[[[obj valueForKey:@"email"] componentsSeparatedByString:@"@"] objectAtIndex:0],[[[obj valueForKey:@"email"] componentsSeparatedByString:@"@"] objectAtIndex:1]];
                        
                        [doctorListArray addObject:specializationObj];
                    }];
                    [_tbl_View reloadData];
                }else
                {
                    [self addAlertWithTitle:AlertKey andMessage:[responseObj valueForKey:@"message"] isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:OK_Btn secondButtonTitle:nil image:Warning_Key_For_Image];
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
        [self addAlertWithTitle:AlertKey andMessage:Network_Issue_Message isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:OK_Btn secondButtonTitle:nil image:Warning_Key_For_Image];
    }
}


-(void)hitApiForPatientList{
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    [parameter setValue:[CommonFunction getValueFromDefaultWithKey:loginuserId] forKey:@"doctor_id"];

    if ([ CommonFunction reachability]) {
        [self addLoder];
        
        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_FETCH_PATIENTS]  postResponse:parameter postImage:nil requestType:POST tag:nil isRequiredAuthentication:YES header:@"" completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"]) {
                    patientListArray = [NSMutableArray new];
                    NSArray *tempArray = [NSArray new];
                    tempArray  = [responseObj valueForKey:@"data"];
                    [tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        ChatPatient *specializationObj = [ChatPatient new];
                        specializationObj.gender = [obj valueForKey:@"gender"];
                        specializationObj.patient_id = [obj valueForKey:@"patient_id"];
                        specializationObj.name = [NSString stringWithFormat:@"%@ %@",[obj valueForKey:@"first_name"],[obj valueForKey:@"last_name"]];
                        specializationObj.dob = [obj valueForKey:@"date_of_birth"];
                        specializationObj.jabberId = [NSString stringWithFormat:@"%@%@",[[[obj valueForKey:@"email"] componentsSeparatedByString:@"@"] objectAtIndex:0],[[[obj valueForKey:@"email"] componentsSeparatedByString:@"@"] objectAtIndex:1]];
                        
                        [patientListArray addObject:specializationObj];
                    }];
                    [_tbl_View reloadData];
                }else
                {
                    [self addAlertWithTitle:AlertKey andMessage:[responseObj valueForKey:@"message"] isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:OK_Btn secondButtonTitle:nil image:Warning_Key_For_Image];
                    [self removeloder];
                }
                [self removeloder];
            }else{
                [self removeloder];
            }
        }];
    } else {
        [self removeloder];
        [self addAlertWithTitle:AlertKey andMessage:Network_Issue_Message isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:OK_Btn secondButtonTitle:nil image:Warning_Key_For_Image];
    }
}



-(void)hitApiForAddInTheQueue:(NSString *)doctorId{
    
    
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    [parameter setValue:doctorId forKey:@"doctor_id"];
    [parameter setValue:[CommonFunction getValueFromDefaultWithKey:loginuserId] forKey:@"patient_id"];
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    [parameter setValue:[dateFormatter stringFromDate:date] forKey:@"date"];
    if (!_isDependent) {
        [parameter setValue:@"na" forKey:DEPENDANT_ID];
    }else{
        [parameter setValue:_selectedDependent.depedant_id forKey:DEPENDANT_ID];
    }
    if ([ CommonFunction reachability]) {
        [self addLoder];
        
        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,@"patientqueue"]  postResponse:parameter postImage:nil requestType:POST tag:nil isRequiredAuthentication:YES header:@"" completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"]) {
                    [self addAlertWithTitle:AlertKey andMessage:[responseObj valueForKey:@"message"] isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:OK_Btn secondButtonTitle:nil image:Warning_Key_For_Image];
                }else if([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK005"]){
                    [self removeloder];
                    [self hitApiForPayment:doctorId];
                }else if([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK004"]){
                ChatViewController* vc = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
                vc.objDoctor = objTemp;
                objTemp.dependent_id = _selectedDependent.depedant_id;
                objTemp.dependent_Name = _selectedDependent.name;
                vc.awarenessObj = _awarenessObj;
                vc.toId = objTemp.jabberId;
                [self.navigationController pushViewController:vc animated:true];
                    
                }
                else
                {
                    [self addAlertWithTitle:AlertKey andMessage:[responseObj valueForKey:@"message"] isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:OK_Btn secondButtonTitle:nil image:Warning_Key_For_Image];
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
        [self addAlertWithTitle:AlertKey andMessage:Network_Issue_Message isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:OK_Btn secondButtonTitle:nil image:Warning_Key_For_Image];
    }
}


-(void)hitApiForPayment:(NSString *)doctorId{
    
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    [parameter setValue:doctorId forKey:DOCTOR_ID];
    [parameter setValue:[CommonFunction getValueFromDefaultWithKey:loginuserId] forKey:@"patient_id"];
    [parameter setValue:@"20.0" forKey:@"amount"];
    
    if (!_isDependent) {
        [parameter setValue:@"na" forKey:DEPENDANT_ID];
    }else{
        [parameter setValue:_selectedDependent.depedant_id forKey:DEPENDANT_ID];
    }
    
    if ([ CommonFunction reachability]) {
        [self addLoder];
        
        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_FOR_PAYMENT]  postResponse:parameter postImage:nil requestType:POST tag:nil isRequiredAuthentication:YES header:@"" completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"]) {
                    [self removeloder];
                    PaymentVC *paymentVC = [[PaymentVC alloc]initWithNibName:@"PaymentVC" bundle:nil];
                    paymentVC.urlString = [responseObj valueForKey:@"approval_url"];
                    paymentVC.doctorId = doctorId;
                    paymentVC.delegateProperty = self;
                    [self.navigationController pushViewController:paymentVC animated:true];
//                    [self addAlertWithTitle:AlertKey andMessage:[responseObj valueForKey:@"message"] isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:OK_Btn secondButtonTitle:nil image:Warning_Key_For_Image];
                    
                    
                    
                }else
                {
                    [self addAlertWithTitle:AlertKey andMessage:[responseObj valueForKey:@"message"] isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:OK_Btn secondButtonTitle:nil image:Warning_Key_For_Image];
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
        [self addAlertWithTitle:AlertKey andMessage:Network_Issue_Message isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:OK_Btn secondButtonTitle:nil image:Warning_Key_For_Image];
    }
}


#pragma mark- Loder Related
-(void)addLoder{
    self.view.userInteractionEnabled = NO;
    //  loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
    loderObj = [[LoderView alloc] initWithFrame:self.view.frame];
    loderObj.lbl_title.text = @"Please wait...";
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
        [alertObj.btn2 setTitle:firstButtonTitle forState:UIControlStateNormal];
        [alertObj.btn3 setTitle:secondButtonTitle forState:UIControlStateNormal];
        alertObj.btn2.tag = firstButtonTag;
        alertObj.btn3.tag = secondButtonTag;
        [alertObj.btn2 addTarget:self action:@selector(btnActionForCustomAlert:) forControlEvents:UIControlEventTouchUpInside];
        [alertObj.btn3 addTarget:self action:@selector(btnActionForCustomAlert:) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
        alertObj.btn2.hidden = true;
        alertObj.btn3.hidden = true;
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

#pragma mark- Payment Delegate

-(void)paymentStatusMethod:(BOOL)status doctor:(NSString*)doctorID{
    if (status) {
        [self hitApiForAddInTheQueue:doctorID];
    }
    else{
        [self addAlertWithTitle:@"Failure" andMessage:@"Payment Declined" isTwoButtonNeeded:false firstbuttonTag:Tag_For_Remove_Alert secondButtonTag:0 firstbuttonTitle:@"Ok" secondButtonTitle:nil image:Warning_Key_For_Image];
    }
    
}

@end
