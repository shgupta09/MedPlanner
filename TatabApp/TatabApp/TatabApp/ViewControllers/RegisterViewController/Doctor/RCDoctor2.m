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
    NSMutableArray *cityArray;
    NSInteger selectedRowForCity;
    UIPickerView *pickerObj;
    UIView *viewOverPicker;

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
    selectedRowForCity = 0;
    cityArray = [[NSMutableArray new] mutableCopy];
    cityArray = [[CommonFunction getCityArray] mutableCopy];
    
    _txtPassport.leftImgView.image = [UIImage imageNamed:@"icon-id-card"];
    _txt_Residence.leftImgView.image = [UIImage imageNamed:@"b"];
    _txt_workplace.leftImgView.image = [UIImage imageNamed:@"b"];
    _txt_homeLocation.leftImgView.image = [UIImage imageNamed:@"icon-map-location"];
    _txt_Nationality.leftImgView.image = [UIImage imageNamed:@"b"];
    [self setLanguageData];
//    _txtPassport.text = @"67567708178";
//    _txt_Residence.text = @"adfaf";
//    _txt_workplace.text = @"adfaf";
//    _txt_homeLocation.text = @"adfaf";
//    _txt_Nationality.text = @"adfaf";
    
}

-(void)setLanguageData{
    _lbl_personal.text = [[Langauge getTextFromTheKey:@"personal_info"] uppercaseString];
    [_btn_Continue setTitle:[Langauge getTextFromTheKey:@"continue_tv"] forState:UIControlStateNormal];
    
    [_txtPassport setPlaceholderWithColor:[Langauge getTextFromTheKey:@"id_card_passport"]];
    [_txt_Residence setPlaceholderWithColor:[Langauge getTextFromTheKey:@"residance"]];
    [_txt_Nationality setPlaceholderWithColor:[Langauge getTextFromTheKey:@"nationalaty"]];
    [_txt_workplace setPlaceholderWithColor:[Langauge getTextFromTheKey:@"workplace"]];
    [_txt_homeLocation setPlaceholderWithColor:[Langauge getTextFromTheKey:@"city"]];

    
    
  
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
#pragma mark - picker data Source
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component{
    if (pickerView.tag ==1) {
        return [cityArray count];
    }
    return 0;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:
(NSInteger)row forComponent:(NSInteger)component{
    if (pickerView.tag ==1) {
        return [[cityArray objectAtIndex:row] valueForKey:@"Name"];
    }
    return @"";
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component{
    if (pickerView.tag == 1) {
        _txt_homeLocation.text = [[cityArray objectAtIndex:row] valueForKey:@"Name"];
        selectedRowForCity = row;
    }
    
}
-(void)resignResponder{
    [CommonFunction resignFirstResponderOfAView:self.view];
    if ([viewOverPicker isDescendantOfView:self.view]) {
        [viewOverPicker removeFromSuperview];
    }
}
#pragma mark - BtnAction

- (IBAction)btnAcion_relationShip:(id)sender {
    
    pickerObj = [[UIPickerView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 150, self.view.frame.size.width, 150)];
    pickerObj.delegate = self;
    pickerObj.dataSource = self;
    pickerObj.showsSelectionIndicator = YES;
    pickerObj.backgroundColor = [UIColor lightGrayColor];
    pickerObj.tag = ((UIButton *)sender).tag;
    viewOverPicker = [[UIView alloc]initWithFrame:self.view.frame];
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:
                          CGRectMake(0, self.view.frame.size.height-
                                     pickerObj.frame.size.height-50, self.view.frame.size.width, 50)];
    [toolBar setBarStyle:UIBarStyleBlackOpaque];
    viewOverPicker.backgroundColor = [UIColor clearColor];
    [CommonFunction setResignTapGestureToView:viewOverPicker andsender:self];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Done" style:UIBarButtonItemStyleDone
                                   target:self action:@selector(doneForPicker:)];
    doneButton.tintColor = [CommonFunction colorWithHexString:@"f7a41e"];
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    NSArray *toolbarItems = [NSArray arrayWithObjects:
                             space,doneButton, nil];
    pickerObj.hidden = false;
    [toolBar setItems:toolbarItems];
    [viewOverPicker addSubview:toolBar];
    if (pickerObj.tag == 1) {
        [pickerObj  selectRow:selectedRowForCity inComponent:0 animated:true];
        
    }
    [viewOverPicker addSubview:pickerObj];
    [self.view addSubview:viewOverPicker];
    [pickerObj reloadAllComponents];
}


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
        [CommonFunction resignFirstResponderOfAView:self.view];

        RCDoctor3* vc ;
        vc = [[RCDoctor3 alloc] initWithNibName:@"RCDoctor3" bundle:nil];
        vc.parameterDict = _parameterDict;
        [self.navigationController pushViewController:vc animated:true];
        
    }
    else{
        [self addAlertWithTitle:[Langauge getTextFromTheKey:Warning_Key] andMessage:[dictForValidation valueForKey:AlertKey]   isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];

    }
    
   
}
#pragma mark - other Methods

-(NSDictionary *)validateData{
    NSMutableDictionary *validationDict = [[NSMutableDictionary alloc] init];
    [validationDict setValue:@"1" forKey:BoolValueKey];
    if ([CommonFunction trimString:_txt_Nationality.text].length == 0){
        [validationDict setValue:@"0" forKey:BoolValueKey];
//        if ([CommonFunction trimString:_txt_Nationality.text].length == 0){
            [validationDict setValue:[Langauge getTextFromTheKey:@"nationility_required"] forKey:AlertKey];
//        }else{
//            [validationDict setValue:[Langauge getTextFromTheKey:@"Ops_nationality"] forKey:AlertKey];
//        }
        
    }  else  if ([CommonFunction trimString:_txt_Residence.text].length == 0){
        [validationDict setValue:@"0" forKey:BoolValueKey];
//        if ([CommonFunction trimString:_txt_Residence.text].length == 0){
            [validationDict setValue:[Langauge getTextFromTheKey:@"residance_required"] forKey:AlertKey];
//        }else{
//            [validationDict setValue:[Langauge getTextFromTheKey:@"Ops_Residence"] forKey:AlertKey];
//        }
        
    }
    else  if ([CommonFunction trimString:_txt_workplace.text].length == 0){
        [validationDict setValue:@"0" forKey:BoolValueKey];
//        if ([CommonFunction trimString:_txt_workplace.text].length == 0){
            [validationDict setValue:[Langauge getTextFromTheKey:@"workPlace_required"] forKey:AlertKey];
//        }else{
//            [validationDict setValue:[Langauge getTextFromTheKey:@"Ops_Workplace"] forKey:AlertKey];
//        }
        
    }
    else  if ([CommonFunction trimString:_txt_homeLocation.text].length == 0){
        [validationDict setValue:@"0" forKey:BoolValueKey];
//        if ([CommonFunction trimString:_txt_homeLocation.text].length == 0){
            [validationDict setValue:[Langauge getTextFromTheKey:@"homeLocation_required"] forKey:AlertKey];
//        }else{
//            [validationDict setValue:[Langauge getTextFromTheKey:@"Ops_Homelocation"] forKey:AlertKey];
//        }
        
    }
    else  if (![CommonFunction validatePassport:_txtPassport.text]){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        if ([CommonFunction trimString:_txtPassport.text].length == 0){
            [validationDict setValue:[Langauge getTextFromTheKey:@"idcard_required"] forKey:AlertKey];
        }else{
            [validationDict setValue:[Langauge getTextFromTheKey:@"idcard_required"] forKey:AlertKey];
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
