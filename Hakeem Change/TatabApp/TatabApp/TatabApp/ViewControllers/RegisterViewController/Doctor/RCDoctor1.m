//
//  RCDoctor1.m
//  TatabApp
//
//  Created by shubham gupta on 10/8/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//

#import "RCDoctor1.h"
#import "RCDoctor2.h"

@interface RCDoctor1 ()
{
    NSString *genderType;
    LoderView *loderObj;
    CustomAlert *alertObj;
    
}
@end

@implementation RCDoctor1

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setData];
    alertObj = [[CustomAlert alloc] initWithFrame:self.view.frame];

    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [CommonFunction resignFirstResponderOfAView:self.view];

}
-(void)viewDidLayoutSubviews{
    loderObj.frame = self.view.frame;
    alertObj.frame = self.view.frame;
}

-(void)setData{
//    
//    _txtName.text = @"dsadasd";
//    _txtPassword.text = @"Admin@123";
//    _txtEmail.text = @"123456@yopmail.com";
//    _txtMobile.text = @"9999708178";
//
    _txtName.leftImgView.image = [UIImage imageNamed:@"b"];
    _txtPassword.leftImgView.image = [UIImage imageNamed:@"c"];
    _txtEmail.leftImgView.image = [UIImage imageNamed:@"a"];
    _txtMobile.leftImgView.image = [UIImage imageNamed:@"Mobile"];

    
    _btnMAle.tintColor = [CommonFunction colorWithHexString:COLORCODE_FOR_TEXTFIELD];
    _btnFemale.layer.cornerRadius = 22;
    _btnMAle.layer.cornerRadius = 22;
    _btnFemale.layer.borderWidth = 3;
    _btnMAle.layer.borderWidth = 3;
    _btnMAle.layer.borderColor =[[CommonFunction colorWithHexString:COLORCODE_FOR_TEXTFIELD] CGColor];
    _btnFemale.layer.borderColor =[[CommonFunction colorWithHexString:COLORCODE_FOR_TEXTFIELD] CGColor];
    
    _btnFemale.backgroundColor = [CommonFunction colorWithHexString:COLORCODE_FOR_TEXTFIELD];
    _btnFemale.tintColor = [UIColor whiteColor];
    [self maleSelected];
    [self setLanguageData];
}
-(void)setLanguageData{
    _lbl_create.text = [[Langauge getTextFromTheKey:@"create_a_doctor_account"] uppercaseString];
    [_btn_Continue setTitle:[Langauge getTextFromTheKey:@"continue_tv"] forState:UIControlStateNormal];
    [_btnMAle setTitle:[Langauge getTextFromTheKey:@"male"] forState:UIControlStateNormal];
    [_btnFemale setTitle:[Langauge getTextFromTheKey:@"female"] forState:UIControlStateNormal];
    
    [_txtName setPlaceholderWithColor:[Langauge getTextFromTheKey:@"name"]];
    [_txtEmail setPlaceholderWithColor:[Langauge getTextFromTheKey:@"email"]];
    [_txtMobile setPlaceholderWithColor:[Langauge getTextFromTheKey:@"mobile"]];
    [_txtPassword setPlaceholderWithColor:[Langauge getTextFromTheKey:@"password"]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [CommonFunction resignFirstResponderOfAView:self.view];
}

#pragma mark - TextField Delegate


//! for change the current first responder
//! @param: TextField
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    UIResponder *nextResponder = [self.view viewWithTag:textField.tag+1];
    if(nextResponder){
        [nextResponder becomeFirstResponder];   //next responder found
    } else {
        [CommonFunction resignFirstResponderOfAView:self.view];
    }
    return NO;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
   
    if (textField.tag == 1) {
        if (textField.text.length == 0 && ![string isEqualToString:@""]) {
            textField.text = @"966-";
        }else if(textField.text.length == 5 && [string isEqualToString:@""])
        {
            textField.text = @"";
        }
        
    }
    if ((textField.tag == 0) && ![string isEqualToString:@""] && (textField.text.length + string.length)>18) {
        return false;
    }
    if ((textField.tag == 1) && ![string isEqualToString:@""] && (textField.text.length + string.length)>18) {
        return false;
    }
    
    return true;
}

#pragma mark - Btn Actions

- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}


- (IBAction)btnActionContinue:(id)sender {

    
    NSDictionary *dictForValidation = [self validateData];
    
    if (![[dictForValidation valueForKey:BoolValueKey] isEqualToString:@"0"]){
        NSMutableDictionary *parameterDict = [[NSMutableDictionary alloc]init];
        [parameterDict setValue:[CommonFunction trimString:_txtName.text] forKey:loginfirstname];
        [parameterDict setValue:@"" forKey:loginlastname];
        [parameterDict setValue:[CommonFunction trimString:_txtEmail.text] forKey:loginemail];
        [parameterDict setValue:[CommonFunction trimString:_txtPassword.text] forKey:@"password"];
        [parameterDict setValue:[CommonFunction trimString:_txtMobile.text] forKey:loginmobile];
        [parameterDict setValue:@"2" forKey:loginusergroup];
        [parameterDict setValue:genderType forKey:Gender];
        [CommonFunction resignFirstResponderOfAView:self.view];

        
        RCDoctor2* vc ;
        vc = [[RCDoctor2 alloc] initWithNibName:@"RCDoctor2" bundle:nil];
        vc.parameterDict = parameterDict;
        [self.navigationController pushViewController:vc animated:true];
        
    }
    else{
        [self addAlertWithTitle:[Langauge getTextFromTheKey:Warning_Key] andMessage:[dictForValidation valueForKey:AlertKey]   isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];

    }
    
    
    
    
    
//    RCDoctor2* vc ;
//    vc = [[RCDoctor2 alloc] initWithNibName:@"RCDoctor2" bundle:nil];
//    [self.navigationController pushViewController:vc animated:true];
    
}
-(void) loginFunction {
    NSMutableDictionary *parameterDict = [[NSMutableDictionary alloc]init];
    [parameterDict setValue:[CommonFunction trimString:_txtEmail.text] forKey:loginemail];
    [parameterDict setValue:_txtPassword.text forKey:loginPassword];
    
    if ([ CommonFunction reachability]) {
        [self addLoder];
        
        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_LOGIN_URL]  postResponse:[parameterDict mutableCopy] postImage:nil requestType:POST tag:nil isRequiredAuthentication:NO header:NPHeaderName completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"] == true){
                     [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:[responseObj valueForKey:@"message"]  isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Alert_Key_For_Image];
                    [self performBlock:^{
                        [CommonFunction stroeBoolValueForKey:isLoggedIn withBoolValue:true];
                        RegisterCompleteViewController* vc;
                        vc = [[RegisterCompleteViewController alloc] initWithNibName:@"RegisterCompleteViewController" bundle:nil];
                        [CommonFunction storeValueInDefault:[CommonFunction trimString:_txtName.text] andKey:@"firstName"];
                        [CommonFunction storeValueInDefault:[[responseObj objectForKey:@"user"] valueForKey:@"user_id"] andKey:@"userId"];
                        [CommonFunction storeValueInDefault:[[responseObj objectForKey:@"user"] valueForKey:@"user_type"] andKey:@"userType"];
                        [CommonFunction storeValueInDefault:[[responseObj objectForKey:@"user"] valueForKey:@"gender"] andKey:@"gender"];
                        [CommonFunction storeValueInDefault:[[responseObj objectForKey:@"user"] valueForKey:@"is_complete"] andKey:@"isComplete"];
                        [CommonFunction storeValueInDefault:[[responseObj objectForKey:@"user"] valueForKey:@"email"] andKey:@"email"];
                        [CommonFunction storeValueInDefault:[[responseObj objectForKey:@"user"] valueForKey:@"token"] andKey:@"token"];
                        
                        [CommonFunction storeValueInDefault:[CommonFunction trimString:_txtName.text] andKey:@"firstName"];
                     
                        [self.navigationController pushViewController:vc animated:true];
                        
                    } afterDelay:1.5];
                    
                    [self removeloder];
                }
                else
                {
                    [self addAlertWithTitle:[Langauge getTextFromTheKey:Error_Key] andMessage:[responseObj valueForKey:@"message"] isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Error_Key_For_Image];
                    [self removeloder];
                    [self removeloder];
                }
                
                
                
            }
            
            else {
                [self removeloder];
           [self addAlertWithTitle:[Langauge getTextFromTheKey:Error_Key] andMessage:Sevrer_Issue_Message isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Error_Key_For_Image];
            }
            
            
        }];
    } else {
        [self addAlertWithTitle:[Langauge getTextFromTheKey:Error_Key] andMessage:Network_Issue_Message isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Error_Key_For_Image];
    }
    
    
}



- (IBAction)btnActionUserType:(id)sender {
    if (((UIButton *)sender).tag == 10) {
        [self maleSelected];
        
    }else{
        [self femaleselected];
    }
}

-(void)maleSelected{
    _btnMAle.backgroundColor = [CommonFunction colorWithHexString:COLORCODE_FOR_TEXTFIELD];
    _btnMAle.tintColor = [UIColor whiteColor];
    _btnFemale.backgroundColor = [UIColor whiteColor];
    _btnFemale.tintColor = [CommonFunction colorWithHexString:COLORCODE_FOR_TEXTFIELD];
    genderType = @"M";
}
-(void)femaleselected{
    _btnFemale.backgroundColor = [CommonFunction colorWithHexString:COLORCODE_FOR_TEXTFIELD];
    _btnFemale.tintColor = [UIColor whiteColor];
    _btnMAle.backgroundColor = [UIColor whiteColor];
    _btnMAle.tintColor = [CommonFunction colorWithHexString:COLORCODE_FOR_TEXTFIELD];
    genderType = @"F";
    
}
#pragma mark - hit api

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

#pragma mark - other Methods

-(NSDictionary *)validateData{
    NSMutableDictionary *validationDict = [[NSMutableDictionary alloc] init];
    [validationDict setValue:@"1" forKey:BoolValueKey];
    if (![CommonFunction validateName:_txtName.text]){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        if ([CommonFunction trimString:_txtName.text].length == 0){
            [validationDict setValue:[Langauge getTextFromTheKey:@"first_name_required"] forKey:AlertKey];
        }else{
            [validationDict setValue:[Langauge getTextFromTheKey:@"Ops_Firstname"] forKey:AlertKey];
        }
        
    }  else if(![CommonFunction validateMobileWithStartFive:[_txtMobile.text stringByReplacingOccurrencesOfString:@"966-" withString:@""]]){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        if ([CommonFunction trimString:_txtMobile.text].length == 0) {
            [validationDict setValue:[Langauge getTextFromTheKey:@"Mobile_required"] forKey:AlertKey];
        }
        else{
            [validationDict setValue:[Langauge getTextFromTheKey:@"mobile_no_is_required"] forKey:AlertKey];
        }
    }
    else if(![CommonFunction validateEmailWithString:_txtEmail.text]){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        if ([CommonFunction trimString:_txtEmail.text].length == 0) {
            [validationDict setValue:[Langauge getTextFromTheKey:@"email_is_required"] forKey:AlertKey];
        }
        else{
            [validationDict setValue:[Langauge getTextFromTheKey:@"please_enter_valid_email"] forKey:AlertKey];
        }
    }
    
    
    else if(![CommonFunction isValidPassword:[CommonFunction trimString:_txtPassword.text]] ){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        if ([CommonFunction trimString:_txtPassword.text].length == 0) {
            [validationDict setValue:[Langauge getTextFromTheKey:@"Password_required"] forKey:AlertKey];
        }
        else{
            [validationDict setValue:[Langauge getTextFromTheKey:@"password_should_be_8_12_characters_with_at_least_1_nummeric"] forKey:AlertKey];
        }
        
        
    }
    return validationDict.mutableCopy;
    
}

- (void)performBlock:(void(^)())block afterDelay:(NSTimeInterval)delay {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
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

@end
