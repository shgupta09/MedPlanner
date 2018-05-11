//
//  RegisterViewController.m
//  TatabApp
//
//  Created by Shagun Verma on 23/09/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()
{
    LoderView *loderObj;
    CustomAlert *alertObj;
    NSString *genderType;


}
@property (weak, nonatomic) IBOutlet UIScrollView *scrlView;
@property (weak, nonatomic) IBOutlet CustomTextField *txtName;
@property (weak, nonatomic) IBOutlet CustomTextField *txtEmail;

@property (weak, nonatomic) IBOutlet CustomTextField *txtPassword;
@property (weak, nonatomic) IBOutlet CustomTextField *txt_mobile;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    alertObj = [[CustomAlert alloc] initWithFrame:self.view.frame];

    
//    _txtPassword.text = @"Admin@123";
//    _txtName.text = @"Rahul";
//    _txtEmail.text = @"DemoPatientdfs16@yopmail.com";

    
    [self setData];

}
-(void)viewDidLayoutSubviews{
    loderObj.frame = self.view.frame;
    alertObj.frame = self.view.frame;
}
-(void)setData{

    _txtName.leftImgView.image = [UIImage imageNamed:@"b"];
    _txtPassword.leftImgView.image = [UIImage imageNamed:@"c"];
    _txtEmail.leftImgView.image = [UIImage imageNamed:@"a"];
    _txt_mobile.leftImgView.image = [UIImage imageNamed:@"Mobile"];

//    [CommonFunction setViewBackground:self.scrlView withImage:[UIImage imageNamed:@"BackgroundGeneral"]];
    [CommonFunction setResignTapGestureToView:self.view andsender:self];
    
    
 
    
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
    _lbl_create.text = [[Langauge getTextFromTheKey:@"create_account"] uppercaseString];
   
    
    [_txtName setPlaceholderWithColor:[Langauge getTextFromTheKey:@"name"]];
    [_txtEmail setPlaceholderWithColor:[Langauge getTextFromTheKey:@"email"]];
    [_txt_mobile setPlaceholderWithColor:[Langauge getTextFromTheKey:@"mobile"]];
    [_txtPassword setPlaceholderWithColor:[Langauge getTextFromTheKey:@"password"]];

    
    
    [_btn_Continue setTitle:[Langauge getTextFromTheKey:@"continue_tv"] forState:UIControlStateNormal];
    [_btnMAle setTitle:[Langauge getTextFromTheKey:@"male"] forState:UIControlStateNormal];
    [_btnFemale setTitle:[Langauge getTextFromTheKey:@"female"] forState:UIControlStateNormal];
    
}

-(void)resignResponder{
    [CommonFunction resignFirstResponderOfAView:self.view];
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

#pragma mark - Btn Action
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
- (IBAction)btnBackClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:true];
}
- (IBAction)btnContinueClicked:(id)sender {

    
    NSDictionary *dictForValidation = [self validateData];
    
    if (![[dictForValidation valueForKey:BoolValueKey] isEqualToString:@"0"]){

        
        
        NSMutableDictionary *parameterDict = [[NSMutableDictionary alloc]init];
        [parameterDict setValue:[CommonFunction trimString:_txtName.text] forKey:loginfirstname];
        [parameterDict setValue:@"" forKey:loginlastname];
        [parameterDict setValue:[CommonFunction trimString:_txtEmail.text] forKey:loginemail];
        [parameterDict setValue:[CommonFunction trimString:_txtPassword.text] forKey:@"password"];
        [parameterDict setValue:[CommonFunction trimString:_txt_mobile.text] forKey:loginmobile];
        [parameterDict setValue:@"3" forKey:loginusergroup];
        [parameterDict setValue:genderType forKey:Gender];
        RegisterCompleteViewController* vc;
        vc = [[RegisterCompleteViewController alloc] initWithNibName:@"RegisterCompleteViewController" bundle:nil];
        vc.parameterDict = parameterDict;
        [self.navigationController pushViewController:vc animated:true];
        
        
        
               
    }
    else{
        [self removeloder];
        /*UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:[dictForValidation valueForKey:AlertKey] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
         */
        [self addAlertWithTitle:[Langauge getTextFromTheKey:Warning_Key] andMessage:[dictForValidation valueForKey:AlertKey]   isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
    }
   
    
    
}
- (IBAction)btnTermsAndConditions:(id)sender {

}

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
        
    }else if(![CommonFunction validateMobileWithStartFive:[_txt_mobile.text stringByReplacingOccurrencesOfString:@"966-" withString:@""]]){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        if ([CommonFunction trimString:_txt_mobile.text].length == 0) {
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
            [self removeloder];
           // [_popUpView removeFromSuperview];
            [self removeAlert];
        }
        default:
            
            break;
    }
}


@end
