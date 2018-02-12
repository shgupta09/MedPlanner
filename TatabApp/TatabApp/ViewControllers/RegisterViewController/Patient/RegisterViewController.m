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

}
@property (weak, nonatomic) IBOutlet UIScrollView *scrlView;
@property (weak, nonatomic) IBOutlet CustomTextField *txtName;
@property (weak, nonatomic) IBOutlet CustomTextField *txtEmail;
@property (weak, nonatomic) IBOutlet UIButton *btnPatient;
@property (weak, nonatomic) IBOutlet UIButton *btnDoctor;
@property (weak, nonatomic) IBOutlet CustomTextField *txtPassword;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    _txtPassword.text = @"Admin@123";
//    _txtName.text = @"Rahul";
//    _txtEmail.text = @"DemoPatient16@yopmail.com";
//
    
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
    [CommonFunction setViewBackground:self.scrlView withImage:[UIImage imageNamed:@"BackgroundGeneral"]];
    [CommonFunction setResignTapGestureToView:self.view andsender:self];
    
    
    _btnPatient.tintColor = [CommonFunction colorWithHexString:COLORCODE_FOR_TEXTFIELD];
    _btnDoctor.layer.cornerRadius = 22;
    _btnPatient.layer.cornerRadius = 22;
    _btnDoctor.layer.borderWidth = 3;
    _btnPatient.layer.borderWidth = 3;
    _btnPatient.layer.borderColor =[[CommonFunction colorWithHexString:COLORCODE_FOR_TEXTFIELD] CGColor];
    _btnDoctor.layer.borderColor =[[CommonFunction colorWithHexString:COLORCODE_FOR_TEXTFIELD] CGColor];
    
    _btnDoctor.backgroundColor = [CommonFunction colorWithHexString:COLORCODE_FOR_TEXTFIELD];
    _btnDoctor.tintColor = [UIColor whiteColor];

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

#pragma mark - Btn Action

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
        [parameterDict setValue:@"0123456789" forKey:loginmobile];
        [parameterDict setValue:@"3" forKey:loginusergroup];
      
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
        [self addAlertWithTitle:AlertKey andMessage:[dictForValidation valueForKey:AlertKey]   isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:OK_Btn secondButtonTitle:nil image:Warning_Key_For_Image];
    }
   
    
    
}
- (IBAction)btnTermsAndConditions:(id)sender {

}


- (IBAction)btnActionUserType:(id)sender {
    if (((UIButton *)sender).tag == 10) {
        _btnDoctor.backgroundColor = [CommonFunction colorWithHexString:COLORCODE_FOR_TEXTFIELD];
        _btnDoctor.tintColor = [UIColor whiteColor];
        _btnPatient.backgroundColor = [UIColor whiteColor];
        _btnPatient.tintColor = [CommonFunction colorWithHexString:COLORCODE_FOR_TEXTFIELD];
        
    }else{
        _btnPatient.backgroundColor = [CommonFunction colorWithHexString:COLORCODE_FOR_TEXTFIELD];
        _btnPatient.tintColor = [UIColor whiteColor];
        _btnDoctor.backgroundColor = [UIColor whiteColor];
        _btnDoctor.tintColor = [CommonFunction colorWithHexString:COLORCODE_FOR_TEXTFIELD];
    }
}



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
#pragma mark- Custom Loder
-(void)addAlertWithTitle:(NSString *)titleString andMessage:(NSString *)messageString isTwoButtonNeeded:(BOOL)isTwoBUtoonNeeded firstbuttonTag:(NSInteger)firstButtonTag secondButtonTag:(NSInteger)secondButtonTag firstbuttonTitle:(NSString *)firstButtonTitle secondButtonTitle:(NSString *)secondButtonTitle image:(NSString *)imageName{
    [CommonFunction resignFirstResponderOfAView:self.view];
    alertObj = [[CustomAlert alloc] initWithFrame:self.view.frame];
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
    [self.view addSubview:alertObj];
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
