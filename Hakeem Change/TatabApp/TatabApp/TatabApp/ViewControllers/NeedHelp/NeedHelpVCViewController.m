//
//  NeedHelpVCViewController.m
//  TatabApp
//
//  Created by shubham gupta on 5/5/18.
//  Copyright © 2018 Shagun Verma. All rights reserved.
//

#import "NeedHelpVCViewController.h"

@interface NeedHelpVCViewController (){
    LoderView *loderObj;
    CustomAlert *alertObj;
    NSMutableArray *cityArray;
    NSInteger selectedRowForCity;
    UIPickerView *pickerObj;
    UIView *viewOverPicker;


}
@end

@implementation NeedHelpVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    selectedRowForCity = 0;
    alertObj = [[CustomAlert alloc] initWithFrame:self.view.frame];
    cityArray = [NSMutableArray new] ;
    [cityArray addObject:[Langauge getTextFromTheKey:@"Technical_issue"]];
    [cityArray addObject:[Langauge getTextFromTheKey:@"Payments_issue"]];
    [cityArray addObject:[Langauge getTextFromTheKey:@"Other"]];
    [self setData];
    // Do any additional setup after loading the view from its nib.
}
-(void)setData{
    _txt_Type.leftImgView.image = [UIImage imageNamed:@"icon-drop-down"];
    _txt_Title.leftImgView.image = [UIImage imageNamed:@"Icon---Name-x1"];
    _txt_Email.leftImgView.image = [UIImage imageNamed:@"a"];
    _txt_Mobile.leftImgView.image = [UIImage imageNamed:@"Mobile"];
    _txt_Description.tintColor = [UIColor whiteColor];
    _txt_Description.textContainerInset = UIEdgeInsetsMake(5, 50, 5, 50);
//    [CommonFunction setViewBackground:self.scrlView withImage:[UIImage imageNamed:@"BackgroundGeneral"]];
    [CommonFunction setResignTapGestureToView:self.view andsender:self];
    [self setLanguageData];
}
-(void)resignResponder{
    [CommonFunction resignFirstResponderOfAView:self.view];
}

-(void)setLanguageData{
    
    _lbl_Title.text = [Langauge getTextFromTheKey:@"Technical_support_request"];
    [_txt_Email setPlaceholderWithColor:[Langauge getTextFromTheKey:@"email"]];
    [_txt_Mobile setPlaceholderWithColor:[Langauge getTextFromTheKey:@"mobile"]];
    [_txt_Type setPlaceholderWithColor:[Langauge getTextFromTheKey:@"Problem_Type"]];
    [_txt_Title setPlaceholderWithColor:[Langauge getTextFromTheKey:@"Problem_Title"]];
    _txt_Description.text = [Langauge getTextFromTheKey:@"Problem_Decription"];
    [_txt_Send setTitle:[Langauge getTextFromTheKey:@"send"] forState:UIControlStateNormal];
    
}

-(void)viewDidLayoutSubviews{
    loderObj.frame = self.view.frame;
    alertObj.frame = self.view.frame;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- TextView Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:[Langauge getTextFromTheKey:@"Problem_Decription"]]) {
        textView.text = @"";
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = [Langauge getTextFromTheKey:@"Problem_Decription"];
    }
    [textView resignFirstResponder];
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

    
    return true;
}

#pragma mark - picker data Source
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component{
    if (pickerView.tag ==0) {
        return [cityArray count];
    }
    return 0;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:
(NSInteger)row forComponent:(NSInteger)component{
    if (pickerView.tag ==0) {
        return [cityArray objectAtIndex:row] ;
    }
    return @"";
    
    
    
    
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component{
    if (pickerView.tag == 0) {
        _txt_Type.text = [cityArray objectAtIndex:row];
        selectedRowForCity = row;
    }
    
}
#pragma mark - btnActions

- (IBAction)btnAction_Back:(id)sender {
    if (_isPushed) {
        [self.navigationController popViewControllerAnimated:true];
    }else{
        [self dismissViewControllerAnimated:true completion:nil];
    }
    
}


- (IBAction)btnAction_ShowTerms:(id)sender {
    TermVC *obj = [[TermVC alloc]initWithNibName:@"TermVC" bundle:nil];
    [self presentViewController:obj animated:true completion:nil];
}
- (IBAction)btnAction_Picker:(id)sender {
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

-(void)doneForPicker:(id)sender
{
    [viewOverPicker removeFromSuperview];
    
}

- (IBAction)btnContinueClicked:(id)sender {
    
    
    NSDictionary *dictForValidation = [self validateData];
    
    if (![[dictForValidation valueForKey:BoolValueKey] isEqualToString:@"0"]){
        
        
        
        NSMutableDictionary *parameterDict = [[NSMutableDictionary alloc]init];
        
        if ([CommonFunction getBoolValueFromDefaultWithKey:isLoggedIn]){
            [parameterDict setValue:[CommonFunction getValueFromDefaultWithKey:loginuserId] forKey:@"user_id"];
        }else{
            [parameterDict setValue:@"" forKey:@"user_id"];
        }
        [parameterDict setValue:[CommonFunction trimString:_txt_Email.text] forKey:loginemail];
      
        [parameterDict setValue:[CommonFunction trimString:_txt_Mobile.text] forKey:@"phone"];
        [parameterDict setValue:_txt_Type.text forKey:@"problem_type"];
        [parameterDict setValue:_txt_Title.text forKey:@"problem_title"];
        [parameterDict setValue:_txt_Description.text forKey:@"problem_description"];
        [self hitSupportApi:[parameterDict mutableCopy]];
        
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

-(NSDictionary *)validateData{
    NSMutableDictionary *validationDict = [[NSMutableDictionary alloc] init];
    [validationDict setValue:@"1" forKey:BoolValueKey];
    
    if(![CommonFunction validateEmailWithString:_txt_Email.text]){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        if ([CommonFunction trimString:_txt_Email.text].length == 0) {
            [validationDict setValue:[Langauge getTextFromTheKey:@"email_is_required"] forKey:AlertKey];
        }
        else{
            [validationDict setValue:[Langauge getTextFromTheKey:@"please_enter_valid_email"] forKey:AlertKey];
        }
    }
    
    else if(![CommonFunction validateMobileWithStartFive:[_txt_Mobile.text stringByReplacingOccurrencesOfString:@"966-" withString:@""]]){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        if ([CommonFunction trimString:_txt_Mobile.text].length == 0) {
            [validationDict setValue:[Langauge getTextFromTheKey:@"Mobile_required"] forKey:AlertKey];
        }
        else{
            [validationDict setValue:[Langauge getTextFromTheKey:@"mobile_no_is_required"] forKey:AlertKey];
        }
    }
    else if([_txt_Type.text isEqualToString:@""]){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        [validationDict setValue:[Langauge getTextFromTheKey:@"Problem_Type_required"] forKey:AlertKey];
        
    }else if([_txt_Title.text isEqualToString:@""]){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        [validationDict setValue:[Langauge getTextFromTheKey:@"Problem_Title_required"] forKey:AlertKey];
        
    }
    else if([_txt_Description.text isEqualToString:@""]){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        [validationDict setValue:[Langauge getTextFromTheKey:@"Problem_Description_required"] forKey:AlertKey];
        
    }
    return validationDict.mutableCopy;
    
}




#pragma mark - hit api
-(void)hitSupportApi:(NSDictionary *)dict {
    
    if ([ CommonFunction reachability]) {
        [self addLoder];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_SUPPORT]  postResponse:[dict mutableCopy] postImage:nil requestType:POST tag:nil isRequiredAuthentication:NO header:NPHeaderName completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"] == true){
                    [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:[responseObj valueForKey:@"message"] isTwoButtonNeeded:false firstbuttonTag:1001 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Alert_Key_For_Image];
                    
                    
                    [self removeloder];
                }
                else
                {
                    [self addAlertWithTitle:[Langauge getTextFromTheKey:Error_Key] andMessage:[responseObj valueForKey:@"message"] isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Error_Key_For_Image];
                    [self removeloder];
                }
            }
            else {
                [self removeloder];
                [self addAlertWithTitle:[Langauge getTextFromTheKey:Error_Key] andMessage:Sevrer_Issue_Message isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Error_Key_For_Image];
            }
            
            
        }];
    } else {
        [self addAlertWithTitle:[Langauge getTextFromTheKey:Error_Key] andMessage:Network_Issue_Message isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Error_Key_For_Image];
    }
    
    
}
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
        case 1001:{
            if (_isPushed) {
                [self.navigationController popViewControllerAnimated:true];
            }else{
                [self dismissViewControllerAnimated:true completion:nil];
            }
        }
        default:
            
            break;
    }
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
