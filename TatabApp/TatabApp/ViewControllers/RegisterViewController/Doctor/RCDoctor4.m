//
//  RCDoctor4.m
//  TatabApp
//
//  Created by NetprophetsMAC on 10/9/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//

#import "RCDoctor4.h"

@interface RCDoctor4 ()
{
    BOOL iscaptured;
    LoderView *loderObj;
    CustomAlert *alertObj;
    
}
@end

@implementation RCDoctor4

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData];
    // Do any additional setup after loading the view from its nib.
}

-(void)setData{
    iscaptured = false;
    _imgView.layer.borderWidth= 3;
    _imgView.layer.borderColor = [[CommonFunction colorWithHexString:Primary_GreenColor] CGColor];
    
//    _txt_ConfirmIban.text = @"aaaaa";
//    _txt_IBAN.text = @"aaaaa";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
- (IBAction)btnBackClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnActionCompleteRegistration:(id)sender {
    NSDictionary *dictForValidation = [self validateData];
    if (![[dictForValidation valueForKey:BoolValueKey] isEqualToString:@"0"]){
        [_parameterDict setValue:[CommonFunction trimString:_txt_IBAN.text] forKey:IBAN];
        [_parameterDict setValue:[CommonFunction trimString:_txt_ConfirmIban.text] forKey:IBAN];
        
        
        [self hitApiForImage];
    }
    else{
       [self addAlertWithTitle:Warning_Key andMessage:[dictForValidation valueForKey:AlertKey] isTwoButtonNeeded:false firstbuttonTag:Tag_For_Remove_Alert secondButtonTag:0 firstbuttonTitle:OK_Btn secondButtonTitle:nil imgName:Warning_Key];
    }
    

    
}

#pragma mark - other Methods

-(NSDictionary *)validateData{
    NSMutableDictionary *validationDict = [[NSMutableDictionary alloc] init];
    [validationDict setValue:@"1" forKey:BoolValueKey];
    if (![CommonFunction validateMobile:_txt_IBAN.text]){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        if ([CommonFunction trimString:_txt_IBAN.text].length == 0){
            [validationDict setValue:@"We need a IBAN" forKey:AlertKey];
        }else{
            [validationDict setValue:@"Oops! It seems that this is not a valid IBAN." forKey:AlertKey];
        }
        
    }  else  if (![CommonFunction validateMobile:_txt_ConfirmIban.text]){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        if ([CommonFunction trimString:_txt_ConfirmIban.text].length == 0){
            [validationDict setValue:@"We need a Confirm IBAN" forKey:AlertKey];
        }else{
            [validationDict setValue:@"Oops! It seems that this is not a valid Confirm IBAN." forKey:AlertKey];
        }
        
    }
    else  if (![_txt_IBAN.text isEqualToString:_txt_ConfirmIban.text]){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        [validationDict setValue:@"IBAN and Confirm IBAN should be same." forKey:AlertKey];
    
    }
    else  if (!iscaptured){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        [validationDict setValue:@"We need an Image" forKey:AlertKey];
    }
    return validationDict.mutableCopy;
    
}

#pragma mark - apiRelatedMethods

-(void)hitApiForImage{
    NSData *imageData = UIImagePNGRepresentation(_imgView.image);
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
      [self addAlertWithTitle:Warning_Key andMessage:No_Network isTwoButtonNeeded:false firstbuttonTag:Tag_For_Remove_Alert secondButtonTag:0 firstbuttonTitle:OK_Btn secondButtonTitle:nil imgName:Warning_Key];
    }
    

 }

-(void)hitApiForRegister{
    
        if ([ CommonFunction reachability]) {
            [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_RegisterDoctor]  postResponse:[_parameterDict mutableCopy] postImage:nil requestType:POST tag:nil isRequiredAuthentication:NO header:NPHeaderName completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
                if (error == nil) {
                    
                    if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"] == true){
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:[responseObj valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                        
                        //                        [alertController addAction:ok];
                        //                    [CommonFunction storeValueInDefault:@"true" andKey:@"isLoggedIn"];
                        [self presentViewController:alertController animated:YES completion:^{
                            
                        }];
                        [self performBlock:^{
                            [alertController dismissViewControllerAnimated:true completion:nil];
                            
                            [self loginFunction];
                            
                        } afterDelay:1.5];
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
            [self removeloder];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Network Error" message:@"No Network Access" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            [self presentViewController:alertController animated:YES completion:nil];
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
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:[responseObj valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:ok];
                    //                    [CommonFunction storeValueInDefault:@"true" andKey:@"isLoggedIn"];
                    [self presentViewController:alertController animated:YES completion:^{
                    }];
                    
                    [self performBlock:^{
                        [alertController dismissViewControllerAnimated:true completion:nil];
                        
                        [CommonFunction stroeBoolValueForKey:isLoggedIn withBoolValue:true];
                        [CommonFunction storeValueInDefault:[[responseObj objectForKey:@"user"] valueForKey:loginemail]  andKey:loginemail];
                        [CommonFunction storeValueInDefault:[[responseObj objectForKey:@"user"] valueForKey:loginfirstname] andKey:loginfirstname];
                        [CommonFunction storeValueInDefault:[[responseObj objectForKey:@"user"] valueForKey:loginUserToken] andKey:loginUserToken];
                        [CommonFunction storeValueInDefault:[[responseObj objectForKey:@"user"] valueForKey:loginuserId] andKey:loginuserId];
                        [CommonFunction storeValueInDefault:[[responseObj objectForKey:@"user"] valueForKey:loginuserType] andKey:loginuserType];
                        

                        HomeViewController *frontViewController = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
                        RearViewController *rearViewController = [[RearViewController alloc]initWithNibName:@"RearViewController" bundle:nil];
                        
                        
                        SWRevealViewController *mainRevealController = [[SWRevealViewController alloc]initWithRearViewController:rearViewController frontViewController:frontViewController];
                        mainRevealController.delegate = self;
                        mainRevealController.view.backgroundColor = [UIColor blackColor];
                        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:mainRevealController];
                       ((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.rootViewController = nav;
                        
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
       [self addAlertWithTitle:Warning_Key andMessage:No_Network isTwoButtonNeeded:false firstbuttonTag:Tag_For_Remove_Alert secondButtonTag:0 firstbuttonTitle:OK_Btn secondButtonTitle:nil imgName:Warning_Key];
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

-(void)addAlertWithTitle:(NSString *)titleString andMessage:(NSString *)messageString isTwoButtonNeeded:(BOOL)isTwoBUtoonNeeded firstbuttonTag:(NSInteger)firstButtonTag secondButtonTag:(NSInteger)secondButtonTag firstbuttonTitle:(NSString *)firstButtonTitle secondButtonTitle:(NSString *)secondButtonTitle imgName:(NSString *)imgNaame{
    alertObj = [[CustomAlert alloc] initWithFrame:self.view.frame];
    alertObj.lbl_title.text = titleString;
    alertObj.lbl_message.text = messageString;
    alertObj.iconImage.image = [UIImage imageNamed:imgNaame];
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
    [UIView transitionWithView:self.view duration:0.3
                       options:UIViewAnimationOptionTransitionCurlUp //change to whatever animation you like
                    animations:^ { [self.view addSubview:alertObj];
                    }
                    completion:nil];
    
}
-(void)removeAlert{
    if ([alertObj isDescendantOfView:self.view]) {
        [UIView transitionWithView:self.view duration:0.3
                           options:UIViewAnimationOptionTransitionCurlDown //change to whatever animation you like
                        animations:^ { [alertObj removeFromSuperview];
                        }
                        completion:nil];
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
