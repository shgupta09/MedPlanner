//
//  SettingVC.m
//  TatabApp
//
//  Created by NetprophetsMAC on 3/20/18.
//  Copyright © 2018 Shagun Verma. All rights reserved.
//

#import "SettingVC.h"
@interface SettingVC (){
    LoderView *loderObj;
    CustomAlert *alertObj;
}

@end

@implementation SettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSwitchButton];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _lbl_Title.text = [Langauge getTextFromTheKey:@"action_settings"];
    _lbl_Notification.text = [Langauge getTextFromTheKey:@"notification"];
    alertObj = [[CustomAlert alloc] initWithFrame:self.view.frame];

    [self setTitleForButton];

}

-(void)setTitleForButton{
    
    if ([[CommonFunction getValueFromDefaultWithKey:Selected_Language] isEqualToString:Selected_Language_English]) {
        [_btn_Language setTitle:@"English" forState:UIControlStateNormal];
      
    }else{
        [_btn_Language setTitle:@"Arabic" forState:UIControlStateNormal];
        
    }
    
}
-(void)setSwitchButton{
    
    if ([CommonFunction getBoolValueFromDefaultWithKey:Notification_Related]) {
        [_mySwitch setOn:true animated:YES];
    }else{
        [_mySwitch setOn:false animated:YES];
    }
}
-(void)viewDidLayoutSubviews{
    alertObj.frame = self.view.frame;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)switch_btn:(id)sender {
    [self hitApiForaddingTheDeviceID];
}
- (IBAction)btn_Language:(id)sender {
    
    [self addAlertWithTitle:[Langauge getTextFromTheKey:Warning_Key] andMessage:[Langauge getTextFromTheKey:@"Language_Change"] isTwoButtonNeeded:true firstbuttonTag:105 secondButtonTag:Tag_For_Remove_Alert firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:[Langauge getTextFromTheKey:Cancel_Btn] image:Warning_Key_For_Image];
    
    
    
}



- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

-(void)showLanguageOption{
  
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                   message:@"Preferred_Language"
                                            preferredStyle:UIAlertControllerStyleActionSheet];
     [alert setModalPresentationStyle:UIModalPresentationPopover];
    alert.preferredContentSize = CGSizeMake(150, 300);

    UIAlertAction*  englishAction= [UIAlertAction actionWithTitle:@"English" style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            [CommonFunction storeValueInDefault:Selected_Language_English andKey:Selected_Language];
                                                            [self viewWillAppear:true];
                                                            [self killManually];

                                                        }];
    UIAlertAction* arabicAction = [UIAlertAction actionWithTitle:@"Arabic" style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                              [CommonFunction storeValueInDefault:Selected_Language_Arebic andKey:Selected_Language];
                                                            [self viewWillAppear:true];
                                                            [self killManually];
                                                        }];
    UIAlertAction* Cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                   }];
    [alert addAction:englishAction];
    [alert addAction:arabicAction];
    [alert addAction:Cancel];
    UIPopoverPresentationController *popPresenter = [alert
                                                     popoverPresentationController];
    

   
    popPresenter.delegate = self;
    popPresenter.sourceView = _btn_Language;
    popPresenter.sourceRect = _btn_Language.bounds;
    popPresenter.sourceRect = CGRectMake(150,300,1,1);
    popPresenter.permittedArrowDirections = UIPopoverArrowDirectionUp;
    [self presentViewController:alert animated:YES completion:nil];
    
}

-(void)killManually{
    
    
    [[AppDelegate getDelegate] switchLanguage];
    
//    SplashScreenViewController *sp = [[SplashScreenViewController alloc]initWithNibName:@"SplashScreenViewController" bundle:nil];
//     [AppDelegate getDelegate].window.rootViewController = sp;
    //home button press programmatically
    
//    UIApplication *app = [UIApplication sharedApplication];
//    [app performSelector:@selector(suspend)];
//    //wait 2 seconds while app is going background
//    [NSThread sleepForTimeInterval:2.0];
//    //exit app when app is in background
//    NSLog(@"exit(0)");
//    exit(0);
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
{
    return UIModalPresentationNone;
}


#pragma mark - Api Related

-(void)hitApiForaddingTheDeviceID{
    
    
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    if (!_mySwitch.isOn) {
         [parameter setValue:@"gjhhj" forKey:DEVICE_ID];
    }else{
          [parameter setValue:[CommonFunction getValueFromDefaultWithKey:DEVICE_ID] forKey:DEVICE_ID];
    }
    [parameter setValue:[CommonFunction getValueFromDefaultWithKey:loginuserId] forKey:loginuserId];
    
    
    if ([ CommonFunction reachability]) {
                [self addLoder];
        
        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,@"registration_ids"]  postResponse:parameter postImage:nil requestType:POST tag:nil isRequiredAuthentication:YES header:@"" completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"]) {
                    if (!_mySwitch.isOn) {
                        [CommonFunction stroeBoolValueForKey:Notification_Related withBoolValue:false];
                        [self setSwitchButton];
                    }
                    [CommonFunction storeValueInDefault:[CommonFunction getValueFromDefaultWithKey:DEVICE_ID] andKey:DEVICE_ID_LoginUSer];
                    [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:[responseObj valueForKey:@"message"] isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Alert_Key_For_Image];
                }else
                {
                    [self setSwitchButton];
                    [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:[responseObj valueForKey:@"message"] isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Alert_Key_For_Image];
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
         alertObj.btn2.hidden = true;
        alertObj.btn3.hidden = true;
        alertObj.btn1.hidden = false;
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
        case 101:
        {
            [self removeAlert];
        }
            break;
        case 105:
        {
             [self removeAlert];
            [self showLanguageOption];
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
    loderObj.lbl_title.text = @"Please wait...";
    [self.view addSubview:loderObj];
}

-(void)removeloder{
    //loderObj = nil;
    [loderObj removeFromSuperview];
    //[loaderView removeFromSuperview];
    self.view.userInteractionEnabled = YES;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
