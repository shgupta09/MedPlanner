//
//  HomeViewController.m
//  TatabApp
//
//  Created by Shagun Verma on 23/09/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//

#import "HomeViewController.h"
#import "OTPVc.h"
@interface HomeViewController ()
{
     SWRevealViewController *revealController;
     BOOL isOpen;
     UIView *tempView;
    LoderView *loderObj;
    UITapGestureRecognizer *singleFingerTap;
    CustomAlert *alertObj;

}
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData];
   
}
-(void)viewDidLayoutSubviews{
    loderObj.frame = self.view.frame;
    alertObj.frame = self.view.frame;
}
-(void)setData{
    [self hitApiForTheQueueCount];
    alertObj = [[CustomAlert alloc] initWithFrame:self.view.frame];

    [_btn_CasesHistory setImage:[UIImage imageNamed:@"requestsHistory"] forState:UIControlStateNormal];
    [_btn_MedicalQueue setImage:[UIImage imageNamed:@"queueWhite"] forState:UIControlStateNormal];
    [_btn_ManageAwareness setImage:[UIImage imageNamed:@"mngawareness"] forState:UIControlStateNormal];
//    [_btn_CasesHistory setImage:[UIImage imageNamed:@"requestsHistory"] forState:UIControlStateNormal];
//    [_btn_MedicalQueue setImage:[UIImage imageNamed:@"queue"] forState:UIControlStateNormal];
//    [_btn_ManageAwareness setImage:[UIImage imageNamed:@"mngawareness"] forState:UIControlStateNormal];
    
    _lbl_Name.text = [NSString stringWithFormat:@"Dr. %@",[[CommonFunction getValueFromDefaultWithKey:loginfirstname] capitalizedString]];
    _lbl_Sep.text = [CommonFunction getValueFromDefaultWithKey:Specialist];
    isOpen = false;
    revealController = [self revealViewController];
    singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                              action:@selector(handleSingleTap:)];
    [_imgView sd_setImageWithURL:[NSURL URLWithString:[CommonFunction getValueFromDefaultWithKey:logInImageUrl]]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification)
                                                 name:@"LogoutNotification"
                                               object:nil];
    [self setUpLanguage];
}

-(void)setUpLanguage{
     _lbl_title.text = [Langauge getTextFromTheKey:@"doc_profile"];
    [_btn_MedicalQueue setTitle:[Langauge getTextFromTheKey:@"manage_queue"] forState:UIControlStateNormal];
    [_btn_ManageAwareness setTitle:[Langauge getTextFromTheKey:@"manage_awareness_content"] forState:UIControlStateNormal];
    [_btn_CasesHistory setTitle:[Langauge getTextFromTheKey:@"case_history"] forState:UIControlStateNormal];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:true];
    self.navigationController.navigationBar.hidden = true;
     isOpen = false;
}

//The event handling method
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer{
    self.navigationController.navigationBar.userInteractionEnabled = true;
    if (isOpen){
        [revealController revealToggle:nil];
        [tempView removeGestureRecognizer:singleFingerTap];
        [tempView removeFromSuperview];
        isOpen = false;
    }
}

#pragma mark- Btn Action
- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}
- (IBAction)btnQueue:(id)sender {
  /*  DoctorListVC* vc ;
    vc = [[DoctorListVC alloc] initWithNibName:@"DoctorListVC" bundle:nil];
    AwarenessCategory *awarenessObj = [AwarenessCategory new];
    awarenessObj.category_name = [CommonFunction getValueFromDefaultWithKey:Specialist];
    awarenessObj.category_id = [CommonFunction getIDFromClinic:awarenessObj.category_name];
    vc.awarenessObj = awarenessObj;
    [self.navigationController pushViewController:vc animated:true];
    */
    if ([[QueueDetails sharedInstance].myDataArray count]== 0) {
        //                        [[NSNotificationCenter defaultCenter]
        //                         postNotificationName:@"NONE TO CHAT"
        //                         object:self];
        
        QueueDetails *obj = [QueueDetails new];
        obj.patient_id = @"na";
        obj.queue_id = @"na";
        obj.dependentID = @"na";
        [self hitApiForStartTheChat:obj];
        
    }else{
        QueueDetails *obj = [[QueueDetails sharedInstance].myDataArray objectAtIndex:0];
        [self hitApiForStartTheChat:obj];
    }
}

- (IBAction)btn_Awareness:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}
- (IBAction)btnCaseHistory:(id)sender {
    
    ChoosePatientViewController* vc ;
    vc = [[ChoosePatientViewController alloc] initWithNibName:@"ChoosePatientViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:true];
}
#pragma mark - Api hit
-(void)hitApiForStartTheChat:(QueueDetails*)obj{
    
    
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    [parameter setValue:[CommonFunction getValueFromDefaultWithKey:loginuserId] forKey:@"doctor_id"];
    [parameter setValue:obj.patient_id forKey:@"patient_id"];
    [parameter setValue:obj.queue_id forKey:@"queue_id"];
    [parameter setValue:obj.dependentID forKey:DEPENDANT_ID];
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    [parameter setValue:[dateFormatter stringFromDate:date] forKey:@"start_datetime"];
    NSLog(@"%@",parameter);
    
    if ([ CommonFunction reachability]) {
             [self addLoder];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,@"startchat"]  postResponse:parameter postImage:nil requestType:POST tag:nil isRequiredAuthentication:YES header:@"" completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"]) {
                   
                     ChatViewController* vc = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
                    Specialization* temp = [Specialization new];
                    NSLog(@"%@ Chat With %@",[CommonFunction getValueFromDefaultWithKey:loginfirstname],obj.name);
                    temp.first_name = obj.name;
                    temp.doctor_id = obj.patient_id;
                    
                    vc.queue_id = obj.queue_id;
                    if ([obj.dependentID isEqualToString:@"0"]) {
                        temp.dependent_Name = @"";
                        temp.dependent_id = @"0";
                    }else{
                        temp.dependent_id = obj.dependentID;
                        temp.dependent_Name = obj.dependentName;
                    }
//                    temp.dependent_id = [NSString stringWithFormat:@"%@",[[[responseObj valueForKey:@"patient"] valueForKey:@"dependents"] valueForKey:@"dependent_id"]];
//                    temp.dependent_Name = [NSString stringWithFormat:@"%@",[[[responseObj valueForKey:@"patient"] valueForKey:@"dependents"] valueForKey:@"name"]];
                    //                    vc.awarenessObj = _awarenessObj;
                    vc.toId = obj.jabberId;
                    vc.objDoctor  = temp;
                    [self.navigationController pushViewController:vc animated:true];
                    
                }else if([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK002"]){
                    ChatViewController* vc = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
                    Specialization* temp = [Specialization new];
                    NSLog(@"%@ Chat With %@",[CommonFunction getValueFromDefaultWithKey:loginfirstname],[[responseObj valueForKey:@"patient"] valueForKey:@"name"]);
                    temp.first_name = [[responseObj valueForKey:@"patient"] valueForKey:@"name"];
                    temp.doctor_id = [[responseObj valueForKey:@"patient"] valueForKey:@"patient_id"];
                    temp.dependent_id = [NSString stringWithFormat:@"%@",[[[responseObj valueForKey:@"patient"] valueForKey:@"dependents"] valueForKey:@"dependent_id"]];
                    temp.dependent_Name = [NSString stringWithFormat:@"%@",[[[responseObj valueForKey:@"patient"] valueForKey:@"dependents"] valueForKey:@"name"]];
                    vc.objDoctor  = temp;
                    vc.queue_id = obj.queue_id;
                    
                    //                    vc.awarenessObj = _awarenessObj;
                    vc.toId = [NSString stringWithFormat:@"%@%@",[[[[responseObj valueForKey:@"patient"] valueForKey:@"email"] componentsSeparatedByString:@"@"] objectAtIndex:0],[[[[responseObj valueForKey:@"patient"] valueForKey:@"email"] componentsSeparatedByString:@"@"] objectAtIndex:1]];
                    [self.navigationController pushViewController:vc animated:true];
                    
                }else if([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK003"]){
                    [self addAlertWithTitle:[Langauge getTextFromTheKey:Warning_Key] andMessage:@"Queue is empty" isTwoButtonNeeded:false firstbuttonTag:Tag_For_Remove_Alert secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
                }
                else{
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

-(void)hitApiForTheQueueCount{
    [[QueueDetails sharedInstance].myDataArray removeAllObjects];
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    [parameter setValue:[CommonFunction getValueFromDefaultWithKey:loginuserId] forKey:@"doctor_id"];
    if ([ CommonFunction reachability]) {
        
        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,@"getallqueuepatient"]  postResponse:parameter postImage:nil requestType:POST tag:nil isRequiredAuthentication:YES header:@"" completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"]) {
                    NSLog(@"%@",responseObj);
                    NSArray *tempArray = [responseObj valueForKey:@"data"];
                    
                    [tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        QueueDetails *queueObj = [QueueDetails new];
                        queueObj.queue_id = [obj valueForKey:@"queue_id"];
                        queueObj.name = [obj valueForKey:@"name"];
                        queueObj.email = [obj valueForKey:@"email"];
                        queueObj.doctor_id = [obj valueForKey:@"doctor_id"];
                        queueObj.patient_id = [obj valueForKey:@"patient_id"];
                        queueObj.dependentID = [NSString stringWithFormat:@"%@",[[obj valueForKey:@"dependent"] valueForKey:@"dependent_id"]];
                        queueObj.dependentName = [NSString stringWithFormat:@"%@",[[obj valueForKey:@"dependent"] valueForKey:@"name"]];
                        queueObj.jabberId = [NSString stringWithFormat:@"%@%@",[[[obj valueForKey:@"email"] componentsSeparatedByString:@"@"] objectAtIndex:0],[[[obj valueForKey:@"email"] componentsSeparatedByString:@"@"] objectAtIndex:1]];
                        
                        [[QueueDetails sharedInstance].myDataArray addObject:queueObj];
                    }];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateCountLAbel" object:nil];
                }else{
                    //                      [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:[responseObj valueForKey:@"message"]  isTwoButtonNeeded:false firstbuttonTag:Tag_For_Remove_Alert secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
                    [[NSNotificationCenter defaultCenter]
                     postNotificationName:@"None Queue"
                     object:self];
                }
                
            }else{
                [self removeloder];
            }
        }
         ];
    }
}



#pragma mark- SWRevealViewController

- (IBAction)revealAction:(id)sender {
    //    self.view.userInteractionEnabled = false;
    self.navigationController.navigationBar.userInteractionEnabled = true;
    if (isOpen) {
        [revealController revealToggle:nil];
        [tempView removeGestureRecognizer:singleFingerTap];
        [tempView removeFromSuperview];
        isOpen = false;
    }
    else{
        
        [revealController revealToggle:nil];
        tempView.frame  =CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height);
        [tempView addGestureRecognizer:singleFingerTap];
        [self.view addSubview:tempView];
        isOpen = true;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)receiveNotification{
         /*   UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Logout Successfully" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [CommonFunction stroeBoolValueForKey:isLoggedIn withBoolValue:false];

                UserSelectViewController* vc = [[UserSelectViewController alloc] initWithNibName:@"UserSelectViewController" bundle:nil];
                vc.isRegistrationSelection = false;
                UINavigationController* navCon = [[UINavigationController alloc] initWithRootViewController:vc];
                vc.navigationController.navigationBarHidden = true;
                [self presentViewController:navCon animated:YES completion:nil];
            }];
            [alertController addAction:ok];
            [self presentViewController:alertController animated:YES completion:nil];
    */
     [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:@"Logout Successfully" isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Alert_Key_For_Image];
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
        case 101:{
            [CommonFunction stroeBoolValueForKey:isLoggedIn withBoolValue:false];
            
            UserSelectViewController* vc = [[UserSelectViewController alloc] initWithNibName:@"UserSelectViewController" bundle:nil];
            vc.isRegistrationSelection = false;
            UINavigationController* navCon = [[UINavigationController alloc] initWithRootViewController:vc];
            vc.navigationController.navigationBarHidden = true;
            [self presentViewController:navCon animated:YES completion:nil];
        }
            break;
        default:
            
            break;
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


@end
