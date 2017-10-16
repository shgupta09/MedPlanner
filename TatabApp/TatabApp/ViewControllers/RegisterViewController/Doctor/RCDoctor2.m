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

@end

@implementation RCDoctor2

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData];
    // Do any additional setup after loading the view from its nib.
}
-(void)setData{
    
    _txtPassport.leftImgView.image = [UIImage imageNamed:@"icon-id-card"];
    _txt_Residence.leftImgView.image = [UIImage imageNamed:@"b"];
    _txt_workplace.leftImgView.image = [UIImage imageNamed:@"b"];
    _txt_homeLocation.leftImgView.image = [UIImage imageNamed:@"icon-map-location"];
    _txt_Nationality.leftImgView.image = [UIImage imageNamed:@"b"];
    
//    _txtPassport.text = @"9999708178";
//    _txt_Residence.text = @"adfaf";
//    _txt_workplace.text = @"adfaf";
//    _txt_homeLocation.text = @"adfaf";
//    _txt_Nationality.text = @"adfaf";
    
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
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:[dictForValidation valueForKey:AlertKey] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
   
}
#pragma mark - other Methods

-(NSDictionary *)validateData{
    NSMutableDictionary *validationDict = [[NSMutableDictionary alloc] init];
    [validationDict setValue:@"1" forKey:BoolValueKey];
    if (![CommonFunction validateName:_txt_Nationality.text]){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        if ([CommonFunction trimString:_txt_Nationality.text].length == 0){
            [validationDict setValue:@"We need a Nationality" forKey:AlertKey];
        }else{
            [validationDict setValue:@"Oops! It seems that this is not a valid Nationality." forKey:AlertKey];
        }
        
    }  else  if (![CommonFunction validateName:_txt_Residence.text]){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        if ([CommonFunction trimString:_txt_Residence.text].length == 0){
            [validationDict setValue:@"We need a Residence" forKey:AlertKey];
        }else{
            [validationDict setValue:@"Oops! It seems that this is not a valid Residence." forKey:AlertKey];
        }
        
    }
    else  if (![CommonFunction validateName:_txt_workplace.text]){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        if ([CommonFunction trimString:_txt_workplace.text].length == 0){
            [validationDict setValue:@"We need a Workplace" forKey:AlertKey];
        }else{
            [validationDict setValue:@"Oops! It seems that this is not a valid Workplace." forKey:AlertKey];
        }
        
    }
    else  if (![CommonFunction validateName:_txt_homeLocation.text]){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        if ([CommonFunction trimString:_txt_homeLocation.text].length == 0){
            [validationDict setValue:@"We need a Home Location" forKey:AlertKey];
        }else{
            [validationDict setValue:@"Oops! It seems that this is not a valid Home Location." forKey:AlertKey];
        }
        
    }
    else  if (![CommonFunction validateMobile:_txtPassport.text]){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        if ([CommonFunction trimString:_txtPassport.text].length == 0){
            [validationDict setValue:@"We need a Passport" forKey:AlertKey];
        }else{
            [validationDict setValue:@"Oops! It seems that this is not a valid Passport." forKey:AlertKey];
        }
        
    }
    return validationDict.mutableCopy;
    
}

@end
