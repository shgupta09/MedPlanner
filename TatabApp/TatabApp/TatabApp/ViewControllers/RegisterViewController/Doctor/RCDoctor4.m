//
//  RCDoctor4.m
//  TatabApp
//
//  Created by NetprophetsMAC on 10/9/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//

#import "RCDoctor4.h"
#import "XMPPHandler.h"
#import "OTPVc.h"



@interface RCDoctor4 ()<SWRevealViewControllerDelegate,OTPDelegate>
{
    BOOL iscaptured;
    LoderView *loderObj;
    XMPPHandler* hm;
    CustomAlert *alertObj;
    
}
@end

@implementation RCDoctor4

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData];
    [self setUpRegisterUser];
    alertObj = [[CustomAlert alloc] initWithFrame:self.view.frame];


    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidLayoutSubviews{
    loderObj.frame = self.view.frame;
    alertObj.frame = self.view.frame;
}
-(void)viewDidDisappear:(BOOL)animated{
    
}
-(void)setUpRegisterUser{
    hm = [[XMPPHandler alloc] init];
    hm.userId = @"asdffsadfcccc";
    hm.userPassword = @"willpower";
    
    hm.hostName = EjabbrdIP;
    hm.hostPort = [NSNumber numberWithInteger:5222];
    [hm.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [hm registerUser];
    
    
}
-(void)setData{
    iscaptured = false;
    _imgView.layer.borderWidth= 3;
    _imgView.layer.borderColor = [[CommonFunction colorWithHexString:Primary_GreenColor] CGColor];
//    _txt_ConfirmIban.text = @"1212121212";
//    _txt_IBAN.text = @"1212121212";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - TextField Delegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.tag == 0||textField.tag == 1) {
        if (textField.text.length == 0 && ![string isEqualToString:@""]) {
            textField.text = @"SA";
        }else if(textField.text.length == 3 && [string isEqualToString:@""])
        {
            textField.text = @"";
        }
        
    }
    if ((textField.tag == 0||textField.tag == 1) && ![string isEqualToString:@""] && (textField.text.length + string.length)>15) {
        return false;
    }
    return true;
}

#pragma mark - image Picker
- (IBAction)captireBtnAction:(id)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    _imgView.image = chosenImage;
    iscaptured = true;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}



#pragma mark - Btn Actions

- (IBAction)btnAction_ShowTerms:(id)sender {
    TermVC *obj = [[TermVC alloc]initWithNibName:@"TermVC" bundle:nil];
    [self presentViewController:obj animated:true completion:nil];
}
- (IBAction)btnAction_Terms:(id)sender {
    if (_btn_Terms.isSelected) {
        [_btn_Terms setSelected:false];
    }else{
        [_btn_Terms setSelected:true];
    }
}


- (IBAction)btnBackClicked:(id)sender {
    [hm disconnectFromXMPPServer];
    [hm clearXMPPStream];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnActionCompleteRegistration:(id)sender {
    NSDictionary *dictForValidation = [self validateData];
    if (![[dictForValidation valueForKey:BoolValueKey] isEqualToString:@"0"]){
        [self hitApi];
    }
    else{
        [self addAlertWithTitle:AlertKey andMessage:[dictForValidation valueForKey:AlertKey]   isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:OK_Btn secondButtonTitle:nil image:Warning_Key_For_Image];
    }
    

    
}

#pragma mark - other Methods

-(NSDictionary *)validateData{
    NSMutableDictionary *validationDict = [[NSMutableDictionary alloc] init];
    [validationDict setValue:@"1" forKey:BoolValueKey];
    NSString *iBan = _txt_IBAN.text;
    iBan =[iBan substringFromIndex:2];
    NSString *confirmIban = _txt_ConfirmIban.text;
    confirmIban =[confirmIban substringFromIndex:2];
    if (![CommonFunction validateMobile:iBan]){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        if ([CommonFunction trimString:iBan].length == 0){
            [validationDict setValue:@"We need a IBAN" forKey:AlertKey];
        }else{
            [validationDict setValue:@"Oops! It seems that this is not a valid IBAN." forKey:AlertKey];
        }
        
    }  else  if (![CommonFunction validateMobile:confirmIban]){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        if ([CommonFunction trimString:confirmIban].length == 0){
            [validationDict setValue:@"We need a Confirm IBAN" forKey:AlertKey];
        }else{
            [validationDict setValue:@"Oops! It seems that this is not a valid Confirm IBAN." forKey:AlertKey];
        }
        
    }
    else  if (![iBan isEqualToString:confirmIban]){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        [validationDict setValue:@"IBAN and Confirm IBAN should be same." forKey:AlertKey];
    
    }
    else  if (!iscaptured){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        [validationDict setValue:@"We need an Image" forKey:AlertKey];
    }
    else  if (!_btn_Terms.isSelected){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        [validationDict setValue:@"Please select the terms and condition" forKey:AlertKey];
    }
    return validationDict.mutableCopy;
    
}

#pragma mark - apiRelatedMethods
-(void)hitApi{
    [_parameterDict setValue:[CommonFunction trimString:_txt_IBAN.text] forKey:IBAN];
    [_parameterDict setValue:[CommonFunction trimString:_txt_ConfirmIban.text] forKey:IBAN];
    [self hitApiForImage];
}

-(void)hitApiForImage{
    NSData *imageData = UIImagePNGRepresentation(_imgView.image);
//    uint8_t *bytesg = (uint8_t *)[imageData bytes];
//    NSMutableArray *btyeArray  =  [NSMutableArray new];
//    for (int i = 0; i<imageData.length;i++ ) {
//        [btyeArray addObject:[NSNumber numberWithInt:bytesg[i]]];
//    }
    
//    NSMutableDictionary *dict = [NSMutableDictionary new];
//    [dict setObject:_imgView.image
//             forKey:@"photo"];
//     [dict setObject:_imgView.image forKey:@"document"];
    NSMutableArray *imgArray = [NSMutableArray new];
    [imgArray addObject:imageData];
    if ([ CommonFunction reachability]) {
        [self addLoder];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_UploadDocument] postResponse:nil withImageData:nil isImageChanged:false requestType:POST requiredAuthorization:false ImageKey:@"photo" DataArray:imgArray completetion:^(BOOL status, id responseObj, NSString *tag, NSError *error, NSInteger statusCode) {
            if (error == nil) {
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"] == true){
                    [_parameterDict setValue:[[responseObj valueForKey:@"urls"] valueForKey:@"photo"]  forKey:Photo];
                     [_parameterDict setValue:[[responseObj valueForKey:@"urls"] valueForKey:@"photo"]  forKey:Document];
                    [self hitApiForRegister];
                }
                else
                {
                    [self addAlertWithTitle:AlertKey andMessage:[responseObj valueForKey:@"message"] isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:OK_Btn secondButtonTitle:nil image:Warning_Key_For_Image];
                    [self removeloder];
                    [self removeloder];
                }
                
                
                
            }
            
            else {
                [self removeloder];
           [self addAlertWithTitle:AlertKey andMessage:Sevrer_Issue_Message isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:OK_Btn secondButtonTitle:nil image:Warning_Key_For_Image];
            }
            
            
        }];
    } else {
        [self addAlertWithTitle:AlertKey andMessage:Network_Issue_Message isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:OK_Btn secondButtonTitle:nil image:Warning_Key_For_Image];
    }
    

 }

-(void)hitApiForRegister{
    
        if ([ CommonFunction reachability]) {
         
            
            [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_RegisterDoctor]  postResponse:[_parameterDict mutableCopy] postImage:nil requestType:POST tag:nil isRequiredAuthentication:NO header:NPHeaderName completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
                if (error == nil) {
                    
                    if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"] == true){
    
                       
//[NSString stringWithFormat:@"%@%@",[[[obj valueForKey:@"email"] componentsSeparatedByString:@"@"] objectAtIndex:0],[[[obj valueForKey:@"email"] componentsSeparatedByString:@"@"] objectAtIndex:1]]
                        NSString* foo = [NSString stringWithFormat:@"%@%@",[[[_parameterDict valueForKey:@"email"] componentsSeparatedByString:@"@"] objectAtIndex:0],[[[_parameterDict valueForKey:@"email"] componentsSeparatedByString:@"@"] objectAtIndex:1]];
                        NSString* userID = foo;
                        hm.userId = userID;
                        hm.userPassword = @"Admin@123";
                        hm.hostName = EjabbrdIP;
                        hm.hostPort = [NSNumber numberWithInteger:5222];
                        [hm.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
                        [hm registerUser];
                        
                        
                       // [self addAlertWithTitle:AlertKey andMessage:[responseObj valueForKey:@"message"]  isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:OK_Btn secondButtonTitle:nil image:Warning_Key_For_Image];
                        [self performBlock:^{
                            
                            [self loginFunction];
                            
                        } afterDelay:1.5];
                    }
                    else
                    {
                        [self addAlertWithTitle:AlertKey andMessage:[responseObj valueForKey:@"message"]  isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:OK_Btn secondButtonTitle:nil image:Warning_Key_For_Image];
                        [self removeloder];
                    }
                    
                    
                    
                }
                
                else {
                    [self removeloder];
                     [self addAlertWithTitle:AlertKey andMessage:Network_Issue_Message isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:OK_Btn secondButtonTitle:nil image:Warning_Key_For_Image];
                }
                
                
            }];
        } else {
            [self removeloder];
            [self addAlertWithTitle:AlertKey andMessage:Network_Issue_Message isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:OK_Btn secondButtonTitle:nil image:Warning_Key_For_Image];
        }
        
    
}
-(void) loginFunction {
    NSMutableDictionary *parameterDict = [[NSMutableDictionary alloc]init];
    [parameterDict setValue:[_parameterDict valueForKey:loginemail] forKey:loginemail];
    [parameterDict setValue:[_parameterDict valueForKey:loginPassword] forKey:loginPassword];
    loderObj.lbl_title.text = @"Logging In...";
    if ([ CommonFunction reachability]) {
      
        
        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_LOGIN_URL]  postResponse:[parameterDict mutableCopy] postImage:nil requestType:POST tag:nil isRequiredAuthentication:NO header:NPHeaderName completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"] == true){
                  // [self addAlertWithTitle:AlertKey andMessage:[responseObj valueForKey:@"message"]  isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:OK_Btn secondButtonTitle:nil image:Warning_Key_For_Image];
                    [self performBlock:^{
                       // [alertController dismissViewControllerAnimated:true completion:nil];
                        [hm disconnectFromXMPPServer];
                        [hm clearXMPPStream];
                        
                        [CommonFunction stroeBoolValueForKey:isLoggedIn withBoolValue:true];
                        
                        [CommonFunction storeValueInDefault:[[responseObj objectForKey:loginUser] valueForKey:loginuserId] andKey:loginuserId];
                        [CommonFunction storeValueInDefault:[[responseObj objectForKey:loginUser] valueForKey:loginuserType] andKey:loginuserType];
                        [CommonFunction storeValueInDefault:[[responseObj objectForKey:loginUser] valueForKey:loginuserGender] andKey:loginuserGender];
                        [CommonFunction storeValueInDefault:[[responseObj objectForKey:loginUser] valueForKey:loginuseIsComplete] andKey:loginuseIsComplete];
                        [CommonFunction storeValueInDefault:[[responseObj objectForKey:loginUser] valueForKey:loginemail] andKey:loginemail];
                        [CommonFunction storeValueInDefault:[[responseObj objectForKey:loginUser] valueForKey:loginUserToken] andKey:loginUserToken];
                        [CommonFunction storeValueInDefault:[[responseObj objectForKey:loginUser] valueForKey:loginfirstname] andKey:loginfirstname];
                        [CommonFunction storeValueInDefault:[[responseObj objectForKey:loginUser] valueForKey:logInImageUrl] andKey:logInImageUrl];
                         [CommonFunction storeValueInDefault:[[responseObj objectForKey:loginUser] valueForKey:Specialist] andKey:Specialist];
                        [CommonFunction storeValueInDefault:[CommonFunction checkForNull:[[responseObj objectForKey:loginUser] valueForKey:loginDOB]]
                                                     andKey:loginDOB];
                          [CommonFunction storeValueInDefault:[[responseObj objectForKey:loginUser] valueForKey:mobileNo] andKey:mobileNo];
                        [CommonFunction stroeBoolValueForKey:Notification_Related withBoolValue:true];
                        [CommonFunction storeValueInDefault:[[responseObj valueForKey:loginUser] valueForKey:LOGIN_IS_MOBILE_VERIFY] andKey:LOGIN_IS_MOBILE_VERIFY];
                        [CommonFunction stroeBoolValueForKey:ISVerifiedFromUserEnd withBoolValue:false];
                        
                        [self hitApiForDoctorToBeOnline];
                        [self hitApiForaddingTheDeviceID];
                        RearViewController *rearViewController = [[RearViewController alloc]initWithNibName:@"RearViewController" bundle:nil];
                        SWRevealViewController *mainRevealController;
                        NewAwareVC *frontViewController = [[NewAwareVC alloc]initWithNibName:@"NewAwareVC" bundle:nil];
                        mainRevealController = [[SWRevealViewController alloc]initWithRearViewController:rearViewController frontViewController:frontViewController];
                        
                        mainRevealController.delegate = self;
                        mainRevealController.view.backgroundColor = [UIColor blackColor];
                        //            [frontViewController.view addSubview:[CommonFunction setStatusBarColor]];
                        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:mainRevealController];
                        ((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.rootViewController = nav;
                        
                    } afterDelay:1.5];
                    
                    [self removeloder];
                }
                else
                {
                    [self addAlertWithTitle:AlertKey andMessage:[responseObj valueForKey:@"message"] isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:OK_Btn secondButtonTitle:nil image:Warning_Key_For_Image];
                    [self removeloder];
                    [self removeloder];
                }
                
                
                
            }
            
            else {
                [self removeloder];
           [self addAlertWithTitle:AlertKey andMessage:Sevrer_Issue_Message isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:OK_Btn secondButtonTitle:nil image:Warning_Key_For_Image];
            }
            
            
        }];
    } else {
        [self addAlertWithTitle:AlertKey andMessage:Network_Issue_Message isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:OK_Btn secondButtonTitle:nil image:Warning_Key_For_Image];
    }
    
    
}
-(void)hitApiForDoctorToBeOnline{
    
    
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    [parameter setValue:[CommonFunction getValueFromDefaultWithKey:loginuserId] forKey:@"doctor_id"];
    [parameter setValue:@"1" forKey:@"status_id"];
    
    
    if ([ CommonFunction reachability]) {
        [self addLoder];
        
        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,@"godoctor_online"]  postResponse:parameter postImage:nil requestType:POST tag:nil isRequiredAuthentication:YES header:@"" completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"]) {
                   
                    
                    
                    
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

-(void)hitApiForaddingTheDeviceID{
    
    
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    [parameter setValue:[CommonFunction getValueFromDefaultWithKey:DEVICE_ID] forKey:DEVICE_ID];
    [parameter setValue:[CommonFunction getValueFromDefaultWithKey:loginuserId] forKey:loginuserId];
    
    
    if ([ CommonFunction reachability]) {
        //        [self addLoder];
        
        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,@"registration_ids"]  postResponse:parameter postImage:nil requestType:POST tag:nil isRequiredAuthentication:YES header:@"" completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"]) {
                    [CommonFunction storeValueInDefault:[CommonFunction getValueFromDefaultWithKey:DEVICE_ID] andKey:DEVICE_ID_LoginUSer];
                    //                    [self addAlertWithTitle:AlertKey andMessage:[responseObj valueForKey:@"message"] isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:OK_Btn secondButtonTitle:nil image:Warning_Key_For_Image];
                }else
                {
                    //                    [self addAlertWithTitle:AlertKey andMessage:[responseObj valueForKey:@"message"] isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:OK_Btn secondButtonTitle:nil image:Warning_Key_For_Image];
                    //                    [self removeloder];
                    //                    [self removeloder];
                }
                //                [self removeloder];
            }
        }];
    } else {
        //        [self removeloder];
        //        [self addAlertWithTitle:AlertKey andMessage:Network_Issue_Message isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:OK_Btn secondButtonTitle:nil image:Warning_Key_For_Image];
    }
}


- (void)performBlock:(void(^)())block afterDelay:(NSTimeInterval)delay {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}



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




@end
