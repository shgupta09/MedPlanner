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
}
@end

@implementation RCDoctor1

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)setData{
    
//    _txtName.text = @"Shubham";
//    _txtPassword.text = @"Admin@123";
//    _txtEmail.text = @"zcxvzxcvxzcv@yopmail.com";
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
    genderType = @"M";

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


#pragma mark - Btn Actions

- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}


- (IBAction)btnActionContinue:(id)sender {

    
    NSDictionary *dictForValidation = [self validateData];
    
    if (![[dictForValidation valueForKey:BoolValueKey] isEqualToString:@"0"]){
        NSMutableDictionary *parameterDict = [[NSMutableDictionary alloc]init];
        [parameterDict setValue:[CommonFunction trimString:_txtName.text] forKey:loginfirstname];
        [parameterDict setValue:@"LastName" forKey:loginlastname];
        [parameterDict setValue:[CommonFunction trimString:_txtEmail.text] forKey:loginemail];
        [parameterDict setValue:[CommonFunction trimString:_txtPassword.text] forKey:@"password"];
        [parameterDict setValue:[CommonFunction trimString:_txtMobile.text] forKey:loginmobile];
        [parameterDict setValue:@"2" forKey:loginusergroup];
        [parameterDict setValue:genderType forKey:Gender];
        
        
        RCDoctor2* vc ;
        vc = [[RCDoctor2 alloc] initWithNibName:@"RCDoctor2" bundle:nil];
        vc.parameterDict = parameterDict;
        [self.navigationController pushViewController:vc animated:true];
        
    }
    else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:[dictForValidation valueForKey:AlertKey] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
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
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:[responseObj valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:ok];
                    //                    [CommonFunction storeValueInDefault:@"true" andKey:@"isLoggedIn"];
                    [self presentViewController:alertController animated:YES completion:^{
                    }];
                    
                    [self performBlock:^{
                        [alertController dismissViewControllerAnimated:true completion:nil];
                        
                        
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
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:[responseObj valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:ok];
                    //                    [CommonFunction storeValueInDefault:@"true" andKey:@"isLoggedIn"];
                    [self presentViewController:alertController animated:YES completion:nil];
                    [self removeloder];
                }
                
                
                
            }
            
            else {
                [self removeloder];
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:[error description] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:ok];
                [self presentViewController:alertController animated:YES completion:nil];
            }
            
            
        }];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Network Error" message:@"No Network Access" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    
}



- (IBAction)btnActionUserType:(id)sender {
    if (((UIButton *)sender).tag == 10) {
        _btnFemale.backgroundColor = [CommonFunction colorWithHexString:COLORCODE_FOR_TEXTFIELD];
        _btnFemale.tintColor = [UIColor whiteColor];
        _btnMAle.backgroundColor = [UIColor whiteColor];
        _btnMAle.tintColor = [CommonFunction colorWithHexString:COLORCODE_FOR_TEXTFIELD];
        genderType = @"M";
        
    }else{
        _btnMAle.backgroundColor = [CommonFunction colorWithHexString:COLORCODE_FOR_TEXTFIELD];
        _btnMAle.tintColor = [UIColor whiteColor];
        _btnFemale.backgroundColor = [UIColor whiteColor];
        _btnFemale.tintColor = [CommonFunction colorWithHexString:COLORCODE_FOR_TEXTFIELD];
        genderType = @"F";
    }
}
#pragma mark - hit api

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

#pragma mark - other Methods

-(NSDictionary *)validateData{
    NSMutableDictionary *validationDict = [[NSMutableDictionary alloc] init];
    [validationDict setValue:@"1" forKey:BoolValueKey];
    if (![CommonFunction validateName:_txtName.text]){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        if ([CommonFunction trimString:_txtName.text].length == 0){
            [validationDict setValue:@"We need a First Name" forKey:AlertKey];
        }else{
            [validationDict setValue:@"Oops! It seems that this is not a valid First Name." forKey:AlertKey];
        }
        
    }  else if(![CommonFunction validateMobile:_txtMobile.text]){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        if ([CommonFunction trimString:_txtMobile.text].length == 0) {
            [validationDict setValue:@"We need an Mobile Number" forKey:AlertKey];
        }
        else{
            [validationDict setValue:@"Oops! It seems that this is not a valid Mobile Number." forKey:AlertKey];
        }
    }
    else if(![CommonFunction validateEmailWithString:_txtEmail.text]){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        if ([CommonFunction trimString:_txtEmail.text].length == 0) {
            [validationDict setValue:@"We need an Email ID" forKey:AlertKey];
        }
        else{
            [validationDict setValue:@"Oops! It seems that this is not a valid Email ID." forKey:AlertKey];
        }
    }
    
    
    else if(![CommonFunction isValidPassword:[CommonFunction trimString:_txtPassword.text]] ){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        if ([CommonFunction trimString:_txtPassword.text].length == 0) {
            [validationDict setValue:@"We need a Password" forKey:AlertKey];
        }
        else{
            [validationDict setValue:@"Incorrect Password. The correct password must have a minimum of 8 characters; with at least one character in upper case and at least one special character or number." forKey:AlertKey];
        }
        
        
    }
    return validationDict.mutableCopy;
    
}

- (void)performBlock:(void(^)())block afterDelay:(NSTimeInterval)delay {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}


@end
