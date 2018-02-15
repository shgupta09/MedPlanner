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
}
@property (weak, nonatomic) IBOutlet UITableView *tblView;

@end

@implementation EMRHealthContainerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    doctorListArray = [NSMutableArray new];
    [_tblView registerNib:[UINib nibWithNibName:@"DoctorListEMRLogTableViewCell" bundle:nil]forCellReuseIdentifier:@"DoctorListEMRLogTableViewCell"];
    _tblView.rowHeight = UITableViewAutomaticDimension;
    _tblView.estimatedRowHeight = 100;
    _tblView.multipleTouchEnabled = NO;
    alertObj = [[CustomAlert alloc] initWithFrame:self.view.frame];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notficationRecieved:) name:@"PopBackNow" object:nil];

//    [CommonFunction storeValueInDefault:[CommonFunction trimString:_txtUsername.text] andKey:loginfirstname];
//    [CommonFunction storeValueInDefault:[[responseObj objectForKey:loginUser] valueForKey:loginuserId] andKey:loginuserId];
//    [CommonFunction storeValueInDefault:[[responseObj objectForKey:loginUser] valueForKey:loginuserType] andKey:loginuserType];
//    [CommonFunction storeValueInDefault:[[responseObj objectForKey:loginUser] valueForKey:loginuserGender] andKey:loginuserGender];
//    [CommonFunction storeValueInDefault:[[responseObj objectForKey:loginUser] valueForKey:loginuseIsComplete] andKey:loginuseIsComplete];
//    [CommonFunction storeValueInDefault:[[responseObj objectForKey:loginUser] valueForKey:loginemail] andKey:loginemail];
//    [CommonFunction storeValueInDefault:[[responseObj objectForKey:loginUser] valueForKey:loginUserToken] andKey:loginUserToken];
//    [CommonFunction storeValueInDefault:[[responseObj objectForKey:loginUser] valueForKey:loginfirstname] andKey:loginfirstname];
//    [CommonFunction storeValueInDefault:_txtPassword.text andKey:loginPassword];

    [_lblPatientName setText:_dependant.name];
    
    if ([_dependant.gender isEqualToString:@"M"]) {
        [_lblgender setText:@"Male"];
    }else{
        [_lblgender setText:@"Feale"];
    }
    [_lblbirthDate setText:_dependant.birthDay];
    
    [self hitApiForSpeciality];
    // Do any additional setup after loading the view from its nib.
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
   
    if (!_isdependant){
        vc.isdependant = _isdependant;
        vc.patient = _patient;
    }
    else
    {
        vc.patient = _patient;
        vc.dependant = _dependant;
        vc.isdependant = _isdependant;
    }

    UINavigationController* navVC = [[UINavigationController alloc ] initWithRootViewController:vc];
    navVC.navigationBarHidden = true;
    [self.navigationController presentViewController:navVC animated:false completion:nil];
    
}


-(void) notficationRecieved:(NSNotification*) notification{
    [self.navigationController popViewControllerAnimated:true];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return doctorListArray.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    DoctorListEMRLogTableViewCell *cell = [_tblView dequeueReusableCellWithIdentifier:@"DoctorListEMRLogTableViewCell"];
    
    if (cell == nil) {
        cell = [[DoctorListEMRLogTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"DoctorListEMRLogTableViewCell"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    Specialization *obj = [doctorListArray objectAtIndex:indexPath.row];
        cell.lblName.text = [NSString stringWithFormat:@"Dr. %@",obj.first_name];
        cell.lblCategoryName.text = obj.sub_specialist;
        //    cell.profileImageView.image = [CommonFunction getImageWithUrlString:obj.photo];
        [cell.imgViewProfile sd_setImageWithURL:[NSURL URLWithString:obj.photo] placeholderImage:[UIImage imageNamed:@"doctor.png"]];
    cell.lblDate.text = obj.created_at;
        cell.imgViewProfile.layer.cornerRadius = 8;
        cell.imgViewProfile.clipsToBounds = true;
    
    [cell.btnDetails setTag:indexPath.row];
    [cell.btnfollowUp setTag:indexPath.row];
    [cell.btnPrescription setTag:indexPath.row];
    cell.delegate = self;
    
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
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
    Specialization* obj = [doctorListArray objectAtIndex:btn.tag];
    NSLog(@"%@", obj.first_name);
    
    [self hitApiForDetails:obj.doctor_id];
}
-(void)btnFollowTapped:(UIButton *)sender{
    UIButton* btn = sender;
    Specialization* obj = [doctorListArray objectAtIndex:btn.tag];
    NSLog(@"%@", obj.first_name);
    
    [self hitApiForFollowUp:obj.doctor_id];
}

-(void)btnPrescriptionTapped:(UIButton *)sender{
    UIButton* btn = sender;
    Specialization* obj = [doctorListArray objectAtIndex:btn.tag];
    NSLog(@"%@", obj.first_name);
    
    [self hitApiForPrescription:obj.doctor_id];
}


#pragma mark - btn Actions
- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}


#pragma mark - Api Related


-(void)hitApiForDetails:(NSString *)doctorId{
    
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    [parameter setValue:_patient.patient_id forKey:@"patient_id"];
    [parameter setValue: doctorId forKey:@"doctor_id"];
    if (_isdependant) {
        [parameter setValue: _dependant.depedant_id forKey:@"doctor_id"];

    }
    NSLog(@"%@",parameter);
    if ([ CommonFunction reachability]) {
        [self addLoder];
        
        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_GET_PRES_FOLLOW_UP_DETAILS]  postResponse:parameter postImage:nil requestType:POST tag:nil isRequiredAuthentication:YES header:@"" completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"]) {
                    
                    
                    NSMutableArray* array = [NSMutableArray new];
                    NSArray *tempArray = [NSArray new];
                    tempArray  = [[responseObj valueForKey:@"data"] valueForKey:@"diagnosis"];;
                    [tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        CommonInfoPatient *object = [CommonInfoPatient new];
                        object.identifier = [obj valueForKey:@"id"];
                        object.created_at = [obj valueForKey:@"created_at"];
                        object.type = [obj valueForKey:@"type"];
                        object.details = [obj valueForKey:@"details"];
                        
                        [array addObject:object];
                    }];
                    DetailViewController* vc = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
                    vc.detailType = @"Diagnosis";
                    vc.detailArray = array;
                    [self presentViewController:vc animated:false completion:^{
                        [self removeloder];
                        
                    }];
                    
                    
                }else
                {
                    [self addAlertWithTitle:AlertKey andMessage:[responseObj valueForKey:@"message"] isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:OK_Btn secondButtonTitle:nil image:Warning_Key_For_Image];
                    [self removeloder];
                    [self removeloder];
                }
                [self removeloder];
                
            }
            
            
            
        }];
    } else {
        [self removeloder];
        [self addAlertWithTitle:AlertKey andMessage:Network_Issue_Message isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:OK_Btn secondButtonTitle:nil image:Warning_Key_For_Image];
    }
    
}
-(void)hitApiForPrescription:(int)doctorId{
    
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    [parameter setValue:_patient.patient_id forKey:@"patient_id"];
    [parameter setValue:[NSString stringWithFormat:@"%d", doctorId] forKey:@"doctor_id"];
    
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
                    [self addAlertWithTitle:AlertKey andMessage:[responseObj valueForKey:@"message"] isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:OK_Btn secondButtonTitle:nil image:Warning_Key_For_Image];
                    [self removeloder];
                    [self removeloder];
                }
                [self removeloder];
                
            }
            
            
            
        }];
    } else {
        [self removeloder];
        [self addAlertWithTitle:AlertKey andMessage:Network_Issue_Message isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:OK_Btn secondButtonTitle:nil image:Warning_Key_For_Image];
    }
    
}

-(void)hitApiForFollowUp:(int)doctorId{
    
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    [parameter setValue:_patient.patient_id forKey:@"patient_id"];
    [parameter setValue:[NSString stringWithFormat:@"%d", doctorId] forKey:@"doctor_id"];

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
                    [self addAlertWithTitle:AlertKey andMessage:[responseObj valueForKey:@"message"] isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:OK_Btn secondButtonTitle:nil image:Warning_Key_For_Image];
                    [self removeloder];
                    [self removeloder];
                }
                [self removeloder];
                
            }
            
            
            
        }];
    } else {
        [self removeloder];
        [self addAlertWithTitle:AlertKey andMessage:Network_Issue_Message isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:OK_Btn secondButtonTitle:nil image:Warning_Key_For_Image];
    }

}


-(void)hitApiForSpeciality{
    
    
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    [parameter setValue:_patient.patient_id forKey:@"patient_id"];
    
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
                    [self addAlertWithTitle:AlertKey andMessage:[responseObj valueForKey:@"message"] isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:OK_Btn secondButtonTitle:nil image:Warning_Key_For_Image];
                    [self removeloder];
                    [self removeloder];
                }
                [self removeloder];
                
            }
            
            
            
        }];
    } else {
        [self removeloder];
        [self addAlertWithTitle:AlertKey andMessage:Network_Issue_Message isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:OK_Btn secondButtonTitle:nil image:Warning_Key_For_Image];
    }
}


#pragma mark - add loder

-(void)addLoder{
    self.view.userInteractionEnabled = NO;
    //  loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
    loderObj = [[LoderView alloc] initWithFrame:self.view.frame];
    loderObj.lbl_title.text = @"Fetching doctors...";
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




            
@end
