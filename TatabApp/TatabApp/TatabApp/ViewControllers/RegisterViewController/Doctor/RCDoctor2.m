//
//  RCDoctor2.m
//  TatabApp
//
//  Created by shubham gupta on 10/8/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//

#import "RCDoctor2.h"
#import "RCDoctor3.h"
@interface RCDoctor2 ()
{
    CustomAlert *alertObj;

}
@end

@implementation RCDoctor2

- (void)viewDidLoad {
    [super viewDidLoad];
    alertObj = [[CustomAlert alloc] initWithFrame:self.view.frame];

    [self setData];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidLayoutSubviews{
    alertObj.frame = self.view.frame;
}
-(void)setData{
    
    _txtPassport.leftImgView.image = [UIImage imageNamed:@"icon-id-card"];
    _txt_Residence.leftImgView.image = [UIImage imageNamed:@"b"];
    _txt_workplace.leftImgView.image = [UIImage imageNamed:@"b"];
    _txt_homeLocation.leftImgView.image = [UIImage imageNamed:@"icon-map-location"];
    _txt_Nationality.leftImgView.image = [UIImage imageNamed:@"b"];
    [self setLanguageData];
//    _txtPassport.text = @"9999708178";
//    _txt_Residence.text = @"adfaf";
//    _txt_workplace.text = @"adfaf";
//    _txt_homeLocation.text = @"adfaf";
//    _txt_Nationality.text = @"adfaf";
    
}

-(void)setLanguageData{
    _lbl_personal.text = [Langauge getTextFromTheKey:@"personal_info"];
    [_btn_Continue setTitle:@"continue_tv" forState:UIControlStateNormal];
    _txtPassport.placeholder = [Langauge getTextFromTheKey:@"id_card_passport"];
    _txt_Residence.placeholder = [Langauge getTextFromTheKey:@"residance"];
    _txt_Nationality.placeholder = [Langauge getTextFromTheKey:@"nationalaty"];
    _txt_workplace.placeholder = [Langauge getTextFromTheKey:@"workplace"];
    _txt_homeLocation.placeholder = [Langauge getTextFromTheKey:@"home_location"];
  
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

#pragma mark - BtnAction


- (IBAction)btnBackClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnAction_Continue:(id)sender {
      NSDictionary *dictForValidation = [self validateData];
    if (![[dictForValidation valueForKey:BoolValueKey] isEqualToString:@"0"]){
        [_parameterDict setValue:[CommonFunction trimString:_txt_Nationality.text] forKey:Nationality];
        [_parameterDict setValue:[CommonFunction trimString:_txt_Residence.text] forKey:Residence];
        [_parameterDict setValue:[CommonFunction trimString:_txt_workplace.text] forKey:WorkPlace];
        [_parameterDict setValue:[CommonFunction trimString:_txt_homeLocation.text] forKey:HomeLocation];
        [_parameterDict setValue:[CommonFunction trimString:_txtPassport.text] forKey:Passport];
        
        RCDoctor3* vc ;
        vc = [[RCDoctor3 alloc] initWithNibName:@"RCDoctor3" bundle:nil];
        vc.parameterDict = _parameterDict;
        [self.navigationController pushViewController:vc animated:true];
        
    }
    else{
        [self addAlertWithTitle:AlertKey andMessage:[dictForValidation valueForKey:AlertKey]   isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:OK_Btn secondButtonTitle:nil image:Warning_Key_For_Image];

    }
    
   
}
#pragma mark - other Methods

-(NSDictionary *)validateData{
    NSMutableDictionary *validationDict = [[NSMutableDictionary alloc] init];
    [validationDict setValue:@"1" forKey:BoolValueKey];
    if (![CommonFunction validateName:_txt_Nationality.text]){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        if ([CommonFunction trimString:_txt_Nationality.text].length == 0){
            [validationDict setValue:[Langauge getTextFromTheKey:@"nationility_required"] forKey:AlertKey];
        }else{
            [validationDict setValue:[Langauge getTextFromTheKey:@"Ops_nationality"] forKey:AlertKey];
        }
        
    }  else  if (![CommonFunction validateName:_txt_Residence.text]){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        if ([CommonFunction trimString:_txt_Residence.text].length == 0){
            [validationDict setValue:[Langauge getTextFromTheKey:@"residance_required"] forKey:AlertKey];
        }else{
            [validationDict setValue:[Langauge getTextFromTheKey:@"Ops_Residence"] forKey:AlertKey];
        }
        
    }
    else  if (![CommonFunction validateName:_txt_workplace.text]){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        if ([CommonFunction trimString:_txt_workplace.text].length == 0){
            [validationDict setValue:[Langauge getTextFromTheKey:@"workPlace_required"] forKey:AlertKey];
        }else{
            [validationDict setValue:[Langauge getTextFromTheKey:@"Ops_Workplace"] forKey:AlertKey];
        }
        
    }
    else  if (![CommonFunction validateName:_txt_homeLocation.text]){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        if ([CommonFunction trimString:_txt_homeLocation.text].length == 0){
            [validationDict setValue:[Langauge getTextFromTheKey:@"homeLocation_required"] forKey:AlertKey];
        }else{
            [validationDict setValue:[Langauge getTextFromTheKey:@"Ops_Homelocation"] forKey:AlertKey];
        }
        
    }
    else  if (![CommonFunction validateMobile:_txtPassport.text]){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        if ([CommonFunction trimString:_txtPassport.text].length == 0){
            [validationDict setValue:[Langauge getTextFromTheKey:@"idcard_required"] forKey:AlertKey];
        }else{
            [validationDict setValue:[Langauge getTextFromTheKey:@"hospital_name_required"] forKey:AlertKey];
        }
        
    }
    return validationDict.mutableCopy;
    
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
