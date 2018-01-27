//
//  LoginViewController.m
//  TatabApp
//
//  Created by Shagun Verma on 20/09/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet CustomTextField *txtUsername;
@property (weak, nonatomic) IBOutlet CustomTextField *txtPassword;

@end

@implementation LoginViewController{

    LoderView *loderObj;
    CustomAlert *alertObj;
}

- (void)viewDidLoad {
    [super viewDidLoad];
      [CommonFunction setResignTapGestureToView:self.view andsender:self];
    _txtUsername.leftImgView.image = [UIImage imageNamed:@"d"];
    _txtPassword.leftImgView.image = [UIImage imageNamed:@"c"];
    _txtPassword.text = @"Admin@123";
//    _txtUsername.text = @"qwerty@yopmail.com";
    _txtUsername.text = @"rahul@gmail.com";
    _txtUsername.text = @"shagun@gmail.com";
    // Do any additional setup after loading the view from its nib.
}

-(void) viewDidLayoutSubviews {
        [CommonFunction setViewBackground:self.scrlView withImage:[UIImage imageNamed:@"BackgroundGeneral"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)resignResponder{
    [CommonFunction resignFirstResponderOfAView:self.view];
}

#pragma mark - btn Actions
- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}
- (IBAction)btnRegisterClicked:(id)sender {
  
    
    UserSelectViewController* vc = [[UserSelectViewController alloc] initWithNibName:@"UserSelectViewController" bundle:nil];
    vc.isRegistrationSelection = true;
    [self.navigationController pushViewController:vc animated:true];
    
}
- (IBAction)btnAction_Login:(id)sender {
    
    NSDictionary *dictForValidation = [self validateData];
    
    if (![[dictForValidation valueForKey:BoolValueKey] isEqualToString:@"0"]){
        [self loginFunction];
    }
    else{
        [self removeloder];
        [self addAlertWithTitle:Warning_Key andMessage:[dictForValidation valueForKey:AlertKey] isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:OK_Btn secondButtonTitle:nil];
        
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message: preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
//        [alertController addAction:ok];
//        [self presentViewController:alertController animated:YES completion:nil];
    }
}

-(void) loginFunction {
    NSMutableDictionary *parameterDict = [[NSMutableDictionary alloc]init];
    [parameterDict setValue:[CommonFunction trimString:_txtUsername.text] forKey:loginemail];
    [parameterDict setValue:_txtPassword.text forKey:loginPassword];
    
    if ([ CommonFunction reachability]) {
        [self addLoder];
        
        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_LOGIN_URL]  postResponse:[parameterDict mutableCopy] postImage:nil requestType:POST tag:nil isRequiredAuthentication:NO header:NPHeaderName completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"] == true){
                   
                    
                    [self performBlock:^{
                        
                        
                        [CommonFunction stroeBoolValueForKey:isLoggedIn withBoolValue:true];
                        
                        [CommonFunction storeValueInDefault:[CommonFunction trimString:_txtUsername.text] andKey:loginfirstname];
                        [CommonFunction storeValueInDefault:[[responseObj objectForKey:loginUser] valueForKey:loginuserId] andKey:loginuserId];
                        [CommonFunction storeValueInDefault:[[responseObj objectForKey:loginUser] valueForKey:loginuserType] andKey:loginuserType];
                        [CommonFunction storeValueInDefault:[[responseObj objectForKey:loginUser] valueForKey:loginuserGender] andKey:loginuserGender];
                        [CommonFunction storeValueInDefault:[[responseObj objectForKey:loginUser] valueForKey:loginuseIsComplete] andKey:loginuseIsComplete];
                        [CommonFunction storeValueInDefault:[[responseObj objectForKey:loginUser] valueForKey:loginemail] andKey:loginemail];
                        [CommonFunction storeValueInDefault:[[responseObj objectForKey:loginUser] valueForKey:loginUserToken] andKey:loginUserToken];
                        [CommonFunction storeValueInDefault:[[responseObj objectForKey:loginUser] valueForKey:loginfirstname] andKey:loginfirstname];
                        [CommonFunction storeValueInDefault:[[responseObj objectForKey:loginUser] valueForKey:logInImageUrl] andKey:logInImageUrl];
                        [CommonFunction storeValueInDefault:[[responseObj objectForKey:loginUser] valueForKey:Specialist] andKey:Specialist];
                        
                        [CommonFunction storeValueInDefault:_txtPassword.text andKey:loginPassword];
                        RearViewController *rearViewController = [[RearViewController alloc]initWithNibName:@"RearViewController" bundle:nil];
                        SWRevealViewController *mainRevealController;
                        NewAwareVC *frontViewController = [[NewAwareVC alloc]initWithNibName:@"NewAwareVC" bundle:nil];
                        mainRevealController = [[SWRevealViewController alloc]initWithRearViewController:rearViewController frontViewController:frontViewController];
                        
                        mainRevealController.delegate = self;
                        mainRevealController.view.backgroundColor = [UIColor blackColor];
                        //            [frontViewController.view addSubview:[CommonFunction setStatusBarColor]];
                        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:mainRevealController];
                        ((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.rootViewController = nav;
                        [self resignResponder];                        
                    } afterDelay:.2];
                    
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

- (void)performBlock:(void(^)())block afterDelay:(NSTimeInterval)delay {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
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

#pragma mark - add loder

-(void)addLoder{
    self.view.userInteractionEnabled = NO;
    //  loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
    loderObj = [[LoderView alloc] initWithFrame:self.view.frame];
    loderObj.lbl_title.text = @"Logging In...";
    [self.view addSubview:loderObj];
}

-(void)removeloder{
    //loderObj = nil;
    [loderObj removeFromSuperview];
    //[loaderView removeFromSuperview];
    self.view.userInteractionEnabled = YES;
}
-(NSDictionary *)validateData{
    NSMutableDictionary *validationDict = [[NSMutableDictionary alloc] init];
    [validationDict setValue:@"1" forKey:BoolValueKey];
    if (![CommonFunction validateEmailWithString:[CommonFunction trimString:_txtUsername.text]]){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        if ([CommonFunction trimString:_txtUsername.text].length == 0){
            [validationDict setValue:@"We need an Email ID" forKey:AlertKey];
        }else{
            [validationDict setValue:@"Oops! It seems that this is not a valid Email ID." forKey:AlertKey];
        }
    }
    else if([CommonFunction trimString:_txtPassword.text].length == 0){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        [validationDict setValue:@"We need a Password" forKey:AlertKey];
    }
    return validationDict.mutableCopy;
}
#pragma mark- Custom Loder

-(void)addAlertWithTitle:(NSString *)titleString andMessage:(NSString *)messageString isTwoButtonNeeded:(BOOL)isTwoBUtoonNeeded firstbuttonTag:(NSInteger)firstButtonTag secondButtonTag:(NSInteger)secondButtonTag firstbuttonTitle:(NSString *)firstButtonTitle secondButtonTitle:(NSString *)secondButtonTitle{

    alertObj = [[CustomAlert alloc] initWithFrame:self.view.frame];
    alertObj.lbl_title.text = titleString;
    alertObj.lbl_message.text = messageString;
    if (isTwoBUtoonNeeded) {
        alertObj.btn1.hidden = true;
        [alertObj.btn2 setTitle:firstButtonTitle forState:UIControlStateNormal];
        [alertObj.btn3 setTitle:secondButtonTitle forState:UIControlStateNormal];
        alertObj.btn2.tag = firstButtonTag;
        alertObj.btn3.tag = secondButtonTag;
        [alertObj.btn2 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [alertObj.btn3 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
        alertObj.btn2.hidden = true;
        alertObj.btn3.hidden = true;
        alertObj.btn1.tag = firstButtonTag;
        [alertObj.btn1 setTitle:firstButtonTitle forState:UIControlStateNormal];
        [alertObj.btn1 addTarget:self
                          action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.view addSubview:alertObj];

}
-(void)removeAlert{
    if ([alertObj isDescendantOfView:self.view]) {
        [alertObj removeFromSuperview];
    }
}

-(IBAction)btnAction:(id)sender{
    switch (((UIButton *)sender).tag) {
        case Tag_For_Remove_Alert:
            [self removeAlert]; 
            break;
            
        default:
           
            break;
    }
}

@end
