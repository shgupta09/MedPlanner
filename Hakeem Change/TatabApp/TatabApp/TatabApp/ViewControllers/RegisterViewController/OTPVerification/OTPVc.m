//
//  OTPVc.m
//  TatabApp
//
//  Created by NetprophetsMAC on 3/27/18.
//  Copyright © 2018 Shagun Verma. All rights reserved.
//

#import "OTPVc.h"

@interface OTPVc ()
{
    LoderView *loderObj;
    CustomAlert *alertObj;

}
@end

@implementation OTPVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
  
    [self setUpData];
    // Do any additional setup after loading the view from its nib.
}
-(void)setUpLanguage{
    
    
    if ([[CommonFunction getValueFromDefaultWithKey:Selected_Language] isEqualToString:Selected_Language_English]) {
        _lbl_Default.textAlignment = NSTextAlignmentLeft;
    }else{
        _lbl_Default.textAlignment = NSTextAlignmentRight;
    }
    
    _txt_Number.leftImgView.image = [UIImage imageNamed:@"b"];
    _txt_verificationNum.leftImgView.image = [UIImage imageNamed:@"b"];
    [_txt_Number setPlaceholderWithColor:[Langauge getTextFromTheKey:@"mobile"]];
    [_txt_verificationNum setPlaceholderWithColor:[Langauge getTextFromTheKey:@"sms_verification_number"]];

    _lbl_Title.text = [Langauge getTextFromTheKey:@"sms_verification"];
     [_btn_Send setTitle:[Langauge getTextFromTheKey:@"send"] forState:UIControlStateNormal];
     [_btnResend setTitle:[Langauge getTextFromTheKey:@"resend"] forState:UIControlStateNormal];
    _lbl_Theory.text = [Langauge getTextFromTheKey:@"please_enter_sms_activation"];
}

-(void)setUpData{
    NSString *mobile = [CommonFunction getValueFromDefaultWithKey:mobileNo];
    if ([[mobile substringToIndex:3] isEqualToString:@"966"]) {
        NSMutableString *str =  [[mobile substringWithRange:NSMakeRange(3, mobile.length-3)] mutableCopy];
        NSLog(@"%@",str);
        _txt_Number.text = [NSString stringWithFormat:@"966-%@",str];
    }else{
        _txt_Number.text  =[CommonFunction getValueFromDefaultWithKey:mobileNo];
    }
    alertObj = [[CustomAlert alloc] initWithFrame:self.view.frame];
    [CommonFunction setResignTapGestureToView:self.view andsender:self];
    [self setUpLanguage];
      [self hitApiToSendOtp];
}

-(void)resignResponder{
    [CommonFunction resignFirstResponderOfAView:self.view];
}

-(void)viewDidLayoutSubviews{
    loderObj.frame = self.view.frame;
    alertObj.frame = self.view.frame;
}
- (IBAction)btnBackClicked:(id)sender {
    
    [self dismissViewControllerAnimated:true completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Btn Action
- (IBAction)btnAction_Resend:(id)sender {
    NSDictionary *dictForValidation = [self validateMobile];
    
    if (![[dictForValidation valueForKey:BoolValueKey] isEqualToString:@"0"]){
        [self hitApiToSendOtp];
    } else{
        [self addAlertWithTitle:Warning_Key andMessage:[dictForValidation valueForKey:AlertKey] isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
    }
}





- (IBAction)btnActionSend:(id)sender {
//    [_delegateProperty otpDelegateMethodWithnumber:_txt_Number.text];
//    [self dismissViewControllerAnimated:true completion:nil];
      NSDictionary *dictForValidation = [self validateData];
    if (![[dictForValidation valueForKey:BoolValueKey] isEqualToString:@"0"]) {
        [self hitApiToVerifyOtp];
    }else{
        [self addAlertWithTitle:Warning_Key andMessage:[dictForValidation valueForKey:AlertKey] isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
    }
    
}
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
    
    if (textField.tag == 0) {
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
    
    return true;
}
#pragma mark- Hit Api
-(void)hitApiToSendOtp{
    
    
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    

    [parameter setValue:[CommonFunction getValueFromDefaultWithKey:loginuserId] forKey:@"user_id"];
    [parameter setValue:[_txt_Number.text stringByReplacingOccurrencesOfString:@"-" withString:@""] forKey:@"mobile_no"];
    
    NSLog(@"%@",parameter);
    
    if ([ CommonFunction reachability]) {
                [self addLoder];
        
        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_GETOTP]  postResponse:parameter postImage:nil requestType:POST tag:nil isRequiredAuthentication:YES header:@"" completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"]) {

                                        [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:[responseObj valueForKey:@"message"] isTwoButtonNeeded:false firstbuttonTag:Tag_For_Remove_Alert secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Alert_Key_For_Image];
                    }
                else if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK002"]){
                    [self addAlertWithTitle:[Langauge getTextFromTheKey:Warning_Key] andMessage:[responseObj valueForKey:@"message"] isTwoButtonNeeded:false firstbuttonTag:Tag_For_Remove_Alert secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
                }
                else
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

-(void)hitApiToVerifyOtp{
    
    
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    [parameter setValue:_txt_verificationNum.text forKey:@"otp"];
    [parameter setValue:[_txt_Number.text stringByReplacingOccurrencesOfString:@"-" withString:@""]  forKey:@"mobile_no"];
    
    NSLog(@"%@",parameter);
    
    if ([ CommonFunction reachability]) {
        [self addLoder];
        
        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_VERIFY_OTP]  postResponse:parameter postImage:nil requestType:POST tag:nil isRequiredAuthentication:YES header:@"" completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"]) {
                    [CommonFunction stroeBoolValueForKey:isLoggedIn withBoolValue:true];

                                       [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:[responseObj valueForKey:@"message"] isTwoButtonNeeded:false firstbuttonTag:Tag_For_Remove_Alert secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Alert_Key_For_Image];
                    
                    [self dismissViewControllerAnimated:true completion:nil];
                }
                else
                {
                    [self addAlertWithTitle:[Langauge getTextFromTheKey:Error_Key] andMessage:[responseObj valueForKey:@"message"] isTwoButtonNeeded:false firstbuttonTag:Tag_For_Remove_Alert secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Error_Key_For_Image];
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
        alertObj.btn2.hidden = false;
        alertObj.btn3.hidden = false;
        [alertObj.btn2 setTitle:firstButtonTitle forState:UIControlStateNormal];
        [alertObj.btn3 setTitle:secondButtonTitle forState:UIControlStateNormal];
        alertObj.btn2.tag = firstButtonTag;
        alertObj.btn3.tag = secondButtonTag;
        [alertObj.btn2 addTarget:self action:@selector(btnActionForCustomAlert:) forControlEvents:UIControlEventTouchUpInside];
        [alertObj.btn3 addTarget:self action:@selector(btnActionForCustomAlert:) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
        alertObj.btn1.hidden = false;
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
      
        }
}
-(NSDictionary *)validateMobile{
    NSMutableDictionary *validationDict= [NSMutableDictionary new];
    if(![CommonFunction validateMobileWithStartFive:[_txt_Number.text stringByReplacingOccurrencesOfString:@"966-" withString:@""]]){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        if ([CommonFunction trimString:_txt_Number.text].length == 0) {
            [validationDict setValue:[Langauge getTextFromTheKey:@"Mobile_required"] forKey:AlertKey];
        }
        else{
            [validationDict setValue:[Langauge getTextFromTheKey:@"mobile_no_is_required"] forKey:AlertKey];
        }
    }
    return validationDict;
}
-(NSDictionary *)validateData{
    NSMutableDictionary *validationDict= [NSMutableDictionary new];
    if(![CommonFunction validateMobileWithStartFive:[_txt_Number.text stringByReplacingOccurrencesOfString:@"966-" withString:@""]]){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        if ([CommonFunction trimString:_txt_Number.text].length == 0) {
            [validationDict setValue:[Langauge getTextFromTheKey:@"Mobile_required"] forKey:AlertKey];
        }
        else{
            [validationDict setValue:[Langauge getTextFromTheKey:@"mobile_no_is_required"] forKey:AlertKey];
        }
    }else if (_txt_verificationNum.text.length==0) {
        [validationDict setValue:@"0" forKey:BoolValueKey];
            [validationDict setValue:[Langauge getTextFromTheKey:@"otp_required"] forKey:AlertKey];
      
    }
    return validationDict;
}
@end
