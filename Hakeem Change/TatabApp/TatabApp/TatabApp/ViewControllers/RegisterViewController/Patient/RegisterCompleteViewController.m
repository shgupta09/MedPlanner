//
//  RegisterCompleteViewController.m
//  TatabApp
//
//  Created by Shagun Verma on 23/09/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//
#import "RegisterCompleteViewController.h"
#import "AppDelegate.h"
#import "XMPPHandler.h"

@interface RegisterCompleteViewController ()<SWRevealViewControllerDelegate>
@property (weak, nonatomic) IBOutlet CustomTextField *txtBirthday;
@property (weak, nonatomic) IBOutlet CustomTextField *txtCity;
@property (weak, nonatomic) IBOutlet UIScrollView *scrlView;
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (strong, nonatomic) IBOutlet UIView *popUpView;
@property (weak, nonatomic) IBOutlet CustomTextField *txtName;
@property (weak, nonatomic) IBOutlet CustomTextField *txt_BirthDate;



@end

@implementation RegisterCompleteViewController{
    BOOL isMale;
    UIView *viewOverPicker;
    UIDatePicker* pickerForDate;
     UIToolbar *toolBar;
    NSDate *departDate;
    NSString *departDateString;
    NSMutableArray *dependencyArray;
    LoderView *loderObj;
    XMPPHandler* hm;
    UIPickerView *pickerObj;
    NSInteger selectedRowForSpeciality;
    NSInteger selectedRowForCity;
    NSMutableArray *relationArray;
    NSMutableArray *cityArray;
    NSString *relationshipId ;
    CustomAlert *alertObj;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpdata];
       // Do any additional setup after loading the view from its nib.
}

-(void)setUpdata{
    selectedRowForSpeciality = 0;
    selectedRowForCity = 0;
    relationArray = [NSMutableArray new];
    cityArray = [[NSMutableArray new] mutableCopy];
    cityArray = [[CommonFunction getCityArray] mutableCopy];
    [CommonFunction setResignTapGestureToView:self.view andsender:self];
    [CommonFunction setResignTapGestureToView:_popUpView andsender:self];
    isMale = true;
    dependencyArray = [NSMutableArray new];
    _txtBirthday.leftImgView.image = [UIImage imageNamed:@"icon-calendar"];
    _txt_Relationship.rightImgView.image = [UIImage imageNamed:@"icon-drop-down"];
    _txtCity.leftImgView.image = [UIImage imageNamed:@"b"];
    _txtName.leftImgView.image = [UIImage imageNamed:@"b"];
    _txt_BirthDate.leftImgView.image = [UIImage imageNamed:@"icon-calendar"];
    
    alertObj = [[CustomAlert alloc] initWithFrame:self.view.frame];
    
//    [CommonFunction setViewBackground:self.scrlView withImage:[UIImage imageNamed:@"BackgroundGeneral"]];
    [_tblView registerNib:[UINib nibWithNibName:@"DependantDetailTableViewCell" bundle:nil]forCellReuseIdentifier:@"DependantDetailTableViewCell"];
    _tblView.rowHeight = UITableViewAutomaticDimension;
    _tblView.estimatedRowHeight = 35;
    _tblView.backgroundColor = [UIColor clearColor];
    
    _btn_Female.tintColor = [CommonFunction colorWithHexString:COLORCODE_FOR_TEXTFIELD];
    _btn_Male.layer.cornerRadius = 22;
    _btn_Female.layer.cornerRadius = 22;
    _btn_Male.layer.borderWidth = 3;
    _btn_Female.layer.borderWidth = 3;
    _btn_Female.layer.borderColor =[[CommonFunction colorWithHexString:COLORCODE_FOR_TEXTFIELD] CGColor];
    _btn_Male.layer.borderColor =[[CommonFunction colorWithHexString:COLORCODE_FOR_TEXTFIELD] CGColor];
    
    _btn_Male.backgroundColor = [CommonFunction colorWithHexString:COLORCODE_FOR_TEXTFIELD];
    _btn_Male.tintColor = [UIColor whiteColor];
    
    departDate = [NSDate date];
    
    [self setUpRegisterUser];
    if (![CommonFunction getBoolValueFromDefaultWithKey:RelationApi]) {
        [self getData];
    }
    else{
        relationArray = [Relation sharedInstance].myDataArray;
    }
    [self setLanguageData];
    
}

-(void)setLanguageData{
    _lbl_PersonalDetails.text = [[Langauge getTextFromTheKey:@"personal_details"] uppercaseString];
    [_btn_Terms setTitle:[Langauge getTextFromTheKey:@"Terms_Condition"] forState:UIControlStateNormal];
    [_btn_CompleteRegistration setTitle:[Langauge getTextFromTheKey:@"complete_registration"] forState:UIControlStateNormal];
     [_btn_ConfirmAdd setTitle:[Langauge getTextFromTheKey:@"confirm_add"] forState:UIControlStateNormal];
    [_btnAddDependent setTitle:[Langauge getTextFromTheKey:@"add_dependents"] forState:UIControlStateNormal];
    [_btn_Male setTitle:[Langauge getTextFromTheKey:@"male"] forState:UIControlStateNormal];
    [_btn_Female setTitle:[Langauge getTextFromTheKey:@"female"] forState:UIControlStateNormal];
    
    [_txt_Relationship setPlaceholderWithColor:[Langauge getTextFromTheKey:@"relationship"]];
    [_txtBirthday setPlaceholderWithColor:[Langauge getTextFromTheKey:@"bithdate"]];
    [_txtCity setPlaceholderWithColor:[Langauge getTextFromTheKey:@"city"]];
    [_txt_BirthDate setPlaceholderWithColor:[Langauge getTextFromTheKey:@"bithdate"]];
    [_txtName setPlaceholderWithColor:[Langauge getTextFromTheKey:@"name"]];

    
}
-(void)viewDidLayoutSubviews{
    loderObj.frame = self.view.frame;
    alertObj.frame = self.view.frame;
}

-(void)viewDidDisappear:(BOOL)animated{
    [hm disconnectFromXMPPServer];
    [hm clearXMPPStream];
}


-(void)setUpRegisterUser{
    hm = [[XMPPHandler alloc] init];
    hm.userId = @"asdffsadfcccc";
    hm.userPassword = @"willpower";
    hm.hostName =EjabbrdIP;
    [hm.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    hm.hostPort = [NSNumber numberWithInteger:5222];
    [hm registerUser];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)resignResponder{
    [CommonFunction resignFirstResponderOfAView:self.view];
    if ([viewOverPicker isDescendantOfView:self.view]) {
        [viewOverPicker removeFromSuperview];
    }else if ([_popUpView isDescendantOfView:self.view]) {
        [_popUpView removeFromSuperview];
    }
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
#pragma mark- tableView delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (dependencyArray.count>0) {
        _tblView.hidden = false;
     return dependencyArray.count+1;
    }
    _tblView.hidden = true;
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    DependantDetailTableViewCell *cell = [_tblView dequeueReusableCellWithIdentifier:@"DependantDetailTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
   
        
    
    
    if((indexPath.row-1)%2 == 0){
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    else
    {
        cell.contentView.backgroundColor = [UIColor lightGrayColor];
    }
    
    if (indexPath.row == 0){
        cell.contentView.backgroundColor = [CommonFunction colorWithHexString:COLORCODE_FOR_TEXTFIELD];
        cell.lblBirthday.textColor = [UIColor whiteColor];
        cell.lblGender.textColor = [UIColor whiteColor];
        cell.lblName.textColor = [UIColor whiteColor];
        cell.lblSerialNumber.textColor = [UIColor whiteColor];
        cell.lblSerialNumber.text = @"Sn.";
        [cell.lblName setText:@"Name"];
        [cell.lblGender setText:@"Gender"];
        [cell.lblBirthday setText:@"Birthday"];
        
    }
    else{
         RegistrationDpendency *obj = [dependencyArray objectAtIndex:indexPath.row-1];
        cell.lblSerialNumber.text = [NSString stringWithFormat:@"%d",(int)indexPath.row];
        if((indexPath.row-1)%2 == 0){
            cell.contentView.backgroundColor = [UIColor whiteColor];
        }
        else
        {
            cell.contentView.backgroundColor = [UIColor whiteColor];
        }        [cell.lblName setText:obj.name];
        if (obj.isMale) {
            [cell.lblGender setText:@"Male"];
        }
        else{
            [cell.lblGender setText:@"Female"];
        }
        [cell.lblBirthday setText:obj.birthDay];
    }
   
        
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}


// value change of the date picker
-(void) dueDateChanged:(UIDatePicker *)sender {
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    //self.myLabel.text = [dateFormatter stringFromDate:[dueDatePickerView date]];
    NSLog(@"Picked the date %@", [dateFormatter stringFromDate:[sender date]]);
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    departDateString = [dateFormatter stringFromDate:[sender date]];
    departDate = sender.date;
    if (sender.tag == 0){
       
        _txtBirthday.text = departDateString;
    }else if (sender.tag == 1){
        _txt_BirthDate.text = departDateString;
    }
    
}

-(void)doneForPicker:(id)sender
{
    [viewOverPicker removeFromSuperview];
    
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
    return [relationArray count];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:
(NSInteger)row forComponent:(NSInteger)component{
    if (pickerView.tag ==1) {
        return [[cityArray objectAtIndex:row] valueForKey:@"Name"];
    }
        Relation* relationObj = [relationArray objectAtIndex:row];
        return relationObj.name;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component{
    if (pickerView.tag == 1) {
        _txtCity.text = [[cityArray objectAtIndex:row] valueForKey:@"Name"];
        selectedRowForCity = row;
    }else{
        Relation* relationObj = [relationArray objectAtIndex:row];
        _txt_Relationship.text = relationObj.name;
        relationshipId= relationObj.idValue;
        selectedRowForSpeciality = row;
    }
    
}
#pragma mark- Btn Actions


- (IBAction)btnAction_ShowTerms:(id)sender {
    TermVC *obj = [[TermVC alloc]initWithNibName:@"TermVC" bundle:nil];
    [self presentViewController:obj animated:true completion:nil];
}
- (IBAction)btnAction_Terms:(id)sender {
    if (_btn_Terms.isSelected) {
        [_btn_Terms setSelected:false];
    }else{
        [_btn_Terms setSelected:true];
    }
}
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

    }else{
        [pickerObj  selectRow:selectedRowForSpeciality inComponent:0 animated:true];

    }
    [viewOverPicker addSubview:pickerObj];
    [self.view addSubview:viewOverPicker];
    [pickerObj reloadAllComponents];
}




- (IBAction)btnActionConfirmAdd:(id)sender {
    NSDictionary *dictForValidation = [self validateData];
    
    if (![[dictForValidation valueForKey:BoolValueKey] isEqualToString:@"0"]){
        [_popUpView removeFromSuperview];
        
        RegistrationDpendency *dependencyObj = [RegistrationDpendency new];
        dependencyObj.name = [CommonFunction trimString:_txtName.text];
        dependencyObj.birthDay = _txt_BirthDate.text;
        dependencyObj.isMale = isMale;
        dependencyObj.depedant_id =relationshipId;
        [dependencyArray addObject:dependencyObj];
        [_tblView reloadData];

    }
    else{
        [self addAlertWithTitle:[Langauge getTextFromTheKey:Warning_Key] andMessage:[dictForValidation valueForKey:AlertKey]   isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
    }
}



- (IBAction)btnActionBirthDay:(id)sender {
    
    [CommonFunction resignFirstResponderOfAView:self.view];
       pickerForDate = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 150, self.view.frame.size.width, 150)];
    pickerForDate.datePickerMode = UIDatePickerModeDate;
    pickerForDate.tag = ((UIButton *)sender).tag;
    
        [pickerForDate setDate:departDate];
    [pickerForDate setMaximumDate: [NSDate date]];
    
 
   
    [pickerForDate addTarget:self action:@selector(dueDateChanged:)
            forControlEvents:UIControlEventValueChanged];
    viewOverPicker = [[UIView alloc]initWithFrame:self.view.frame];
    pickerForDate.backgroundColor = [UIColor lightGrayColor];
    viewOverPicker.backgroundColor = [UIColor clearColor];
    [CommonFunction setResignTapGestureToView:viewOverPicker andsender:self];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Done" style:UIBarButtonItemStyleDone
                                   target:self action:@selector(doneForPicker:)];
    doneButton.tintColor = [CommonFunction colorWithHexString:@"f7a41e"];
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    toolBar = [[UIToolbar alloc]initWithFrame:
               CGRectMake(0, self.view.frame.size.height-
                          pickerForDate.frame.size.height-50, self.view.frame.size.width, 50)];
    //    [toolBar setBarTintColor:[UIColor redColor]];
    UIBarButtonItem *doneButton2 = [[UIBarButtonItem alloc]
                                    initWithTitle:@"" style:UIBarButtonItemStyleDone
                                    target:nil action:nil];
    //    doneButton2.tintColor = [CommonFunction colorWithHexString:@"f7a41e"];
    NSDictionary *barButtonAppearanceDict = @{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0], NSForegroundColorAttributeName: [CommonFunction colorWithHexString:@"f7a41e"]};
    [doneButton2 setTitleTextAttributes:barButtonAppearanceDict forState:UIControlStateNormal];
    [toolBar setBarStyle:UIBarStyleBlackOpaque];
    NSArray *toolbarItems = [NSArray arrayWithObjects:space,doneButton2,
                             space,doneButton, nil];
    [toolBar setItems:toolbarItems];
    [viewOverPicker addSubview:pickerForDate];
    [viewOverPicker addSubview:toolBar];
    [self.view addSubview:viewOverPicker];
}
- (IBAction)btnAction_Cities:(id)sender {

}


- (IBAction)btnActionGender:(id)sender {
    if (((UIButton *)sender).tag == 10) {
        isMale = true;
        [self maleSelected];

    }else{
        isMale = false;
        [self femaleselected];
    }
}

-(void)maleSelected{
    _btn_Male.backgroundColor = [CommonFunction colorWithHexString:COLORCODE_FOR_TEXTFIELD];
    _btn_Male.tintColor = [UIColor whiteColor];
    _btn_Female.backgroundColor = [UIColor whiteColor];
    _btn_Female.tintColor = [CommonFunction colorWithHexString:COLORCODE_FOR_TEXTFIELD];
}

-(void)femaleselected{
    _btn_Female.backgroundColor = [CommonFunction colorWithHexString:COLORCODE_FOR_TEXTFIELD];
    _btn_Female.tintColor = [UIColor whiteColor];
    _btn_Male.backgroundColor = [UIColor whiteColor];
    _btn_Male.tintColor = [CommonFunction colorWithHexString:COLORCODE_FOR_TEXTFIELD];
}


- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}
-(void)xmppStreamDidConnect:(XMPPStream *)sender{


}
- (IBAction)btnCompleteRegistrationClicked:(id)sender {
    NSDictionary *dictForValidation = [self validateData2];
    
    


    if (![[dictForValidation valueForKey:BoolValueKey] isEqualToString:@"0"]){
        
       
        NSString *mobile = [_parameterDict valueForKey:loginmobile];
        mobile = [mobile stringByReplacingOccurrencesOfString:@"-" withString:@""];
        [_parameterDict setValue:mobile forKey:loginmobile];
        
        [_parameterDict setValue:[CommonFunction trimString:@"INR"] forKey:@"country_code"];
        NSError* error;
        //    [parameterDict setObject:dependencyArray forKey:@"children"];
        NSMutableDictionary *tempDict = [NSMutableDictionary new];
        NSMutableArray *tempArray = [NSMutableArray new];
        for (int i= 0;i<dependencyArray.count ; i++) {
            [tempDict removeAllObjects];
            
            RegistrationDpendency *obj = [dependencyArray objectAtIndex:i];
            [tempDict setValue:obj.name forKey:@"name"];
            
            if (obj.isMale) {
                [tempDict setValue:@"M" forKey:loginuserGender];
            }
            else{
                [tempDict setValue:@"F" forKey:loginuserGender];
            }
            [tempDict setValue:obj.birthDay forKey:@"dob"];
            [tempDict setValue:obj.depedant_id forKey:@"relationship_id"];
            
            [tempArray addObject:tempDict];
        }
        
        [_parameterDict setValue:tempArray forKey:@"children"];
        
        [_parameterDict setValue:@"M" forKey:loginuserGender];
        [_parameterDict setValue:[CommonFunction trimString:_txtBirthday.text] forKey:@"dob"];
        if ([ CommonFunction reachability]) {
            [self addLoder];
            
            [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_REGISTER_USER_URL]  postResponse:[_parameterDict mutableCopy] postImage:nil requestType:POST tag:nil isRequiredAuthentication:NO header:NPHeaderName completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
                if (error == nil) {
                    
                    if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"] == true){
                        
                        NSString* foo = [NSString stringWithFormat:@"%@%@",[[[_parameterDict valueForKey:@"email"] componentsSeparatedByString:@"@"] objectAtIndex:0],[[[_parameterDict valueForKey:@"email"] componentsSeparatedByString:@"@"] objectAtIndex:1]];
                        NSString* userID = foo;
                        hm.userId = userID;
                        hm.userPassword = @"Admin@123";
                        hm.hostName = EjabbrdIP;
                        hm.hostPort = [NSNumber numberWithInteger:5222];
                        [hm setupXMPPStream];
                        [hm registerUser];
                         //[self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:[responseObj valueForKey:@"message"]  isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
                        [self performBlock:^{
                            [self loginFunction];
                            
                        } afterDelay:1.5];
                        
                        [self removeloder];
                    }
                    else
                    {
                        [self addAlertWithTitle:[Langauge getTextFromTheKey:Error_Key] andMessage:[responseObj valueForKey:@"message"]  isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Error_Key_For_Image];
                        [self removeloder];
                    }
                }
                else {
                    [self removeloder];
                     [self addAlertWithTitle:[Langauge getTextFromTheKey:Error_Key] andMessage:Network_Issue_Message isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Error_Key_For_Image];
                }
                
                
            }];
        } else {
            [self removeloder];
            [self addAlertWithTitle:Error_Key andMessage:Network_Issue_Message isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Error_Key_For_Image];
        }

    }
    else{
        [self addAlertWithTitle:[Langauge getTextFromTheKey:Error_Key] andMessage:[dictForValidation valueForKey:AlertKey]   isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Error_Key_For_Image];
    }

    
}

- (IBAction)btnTermsClicked:(id)sender {
}

- (IBAction)btnAddDependentsClciked:(id)sender {
    _txtName.text = @"";
    _txt_BirthDate.text = @"";
    isMale = true;
    [self maleSelected];
    [[self popUpView] setAutoresizesSubviews:true];
    [[self popUpView] setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) ;
    frame.origin.y = 0.0f;
    self.popUpView.center = CGPointMake(self.view.center.x, self.view.center.y);
    [[self popUpView] setFrame:frame];
    [self.view addSubview:_popUpView];
    [CommonFunction addAnimationToview:_popUpView];
    [_txtName becomeFirstResponder];
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
        
    }else if ([_txt_Relationship.text isEqualToString:@""]){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        if ([CommonFunction trimString:_txt_Relationship.text].length == 0){
            [validationDict setValue:[Langauge getTextFromTheKey:@"please_enter_relationship"] forKey:AlertKey];
        }
    }
    else if(_txt_BirthDate.text.length == 0){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        [validationDict setValue:[Langauge getTextFromTheKey:@"please_enter_date_of_birth"] forKey:AlertKey];
    }
    return validationDict.mutableCopy;
    
}
-(NSDictionary *)validateData2{
    NSMutableDictionary *validationDict = [[NSMutableDictionary alloc] init];
    [validationDict setValue:@"1" forKey:BoolValueKey];
    if(_txtBirthday.text.length == 0){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        [validationDict setValue:[Langauge getTextFromTheKey:@"please_enter_date_of_birth"] forKey:AlertKey];
    }
    else if(_txtCity.text.length == 0){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        [validationDict setValue:[Langauge getTextFromTheKey:@"please_enter_city"] forKey:AlertKey];
    }else  if (!_btn_Terms.isSelected){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        [validationDict setValue:[Langauge getTextFromTheKey:@"please_select_terms_and_condition"] forKey:AlertKey];
    }
    /*
    else  if (dependencyArray.count<1){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        [validationDict setValue:@"We need a Dependent" forKey:AlertKey];
        
        
    }
     */
    return validationDict.mutableCopy;
    
}

#pragma mark - hit api

-(void) getData
{
    if ([ CommonFunction reachability]) {
        
        //      loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_FOR_GET_RELATIONSHIP]  postResponse:nil postImage:nil requestType:POST tag:nil isRequiredAuthentication:NO header:NPHeaderName completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"] == true){
                    [CommonFunction stroeBoolValueForKey:RelationApi withBoolValue:true];
                    NSMutableArray *dataArray = [responseObj objectForKey:@"data"];
                    [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        Relation* s = [[Relation alloc] init];
                        s.idValue = [obj valueForKey:@"id"];
                        s.name = [obj valueForKey:@"name"];
                        [[Relation sharedInstance].myDataArray addObject:s];
                    }];
                    relationArray = [Relation sharedInstance].myDataArray;
                }
            }
        }];
    }
}

-(void) loginFunction {
    NSMutableDictionary *parameterDicts = [[NSMutableDictionary alloc]init];
    [parameterDicts setValue:[_parameterDict valueForKey:loginemail] forKey:loginemail];
    [parameterDicts setValue:[_parameterDict valueForKey:loginPassword] forKey:loginPassword];
    
    if ([ CommonFunction reachability]) {
        [self addLoder];
        loderObj.lbl_title.text = [Langauge getTextFromTheKey:@"please_wait"];
        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_LOGIN_URL]  postResponse:[parameterDicts mutableCopy] postImage:nil requestType:POST tag:nil isRequiredAuthentication:NO header:NPHeaderName completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"] == true){
                    /*UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:[responseObj valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:ok];
                    //                    [CommonFunction storeValueInDefault:@"true" andKey:@"isLoggedIn"];
                    [self presentViewController:alertController animated:YES completion:^{
                    }];
                    */
                    
                    // [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:[responseObj valueForKey:@"message"]  isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
                    [self performBlock:^{
                        //[alertController dismissViewControllerAnimated:true completion:nil];
                        NSString *mobilStr = [NSString stringWithFormat:@"%@",[[responseObj valueForKey:loginUser]valueForKey:LOGIN_IS_MOBILE_VERIFY]];
                          if ([mobilStr isEqualToString:@"1"] ){
                            [CommonFunction stroeBoolValueForKey:isLoggedIn withBoolValue:true];
                        }else{
                            [CommonFunction stroeBoolValueForKey:isLoggedInHit withBoolValue:true];
                        }
                        
                        
                        [CommonFunction storeValueInDefault:[[responseObj objectForKey:loginUser] valueForKey:loginuserId] andKey:loginuserId];
                        [CommonFunction storeValueInDefault:[[responseObj objectForKey:loginUser] valueForKey:loginuserType] andKey:loginuserType];
                        [CommonFunction storeValueInDefault:[[responseObj objectForKey:loginUser] valueForKey:loginuserGender] andKey:loginuserGender];
                        [CommonFunction storeValueInDefault:[[responseObj objectForKey:loginUser] valueForKey:loginuseIsComplete] andKey:loginuseIsComplete];
                        [CommonFunction storeValueInDefault:[[responseObj objectForKey:loginUser] valueForKey:loginemail] andKey:loginemail];
                        [CommonFunction storeValueInDefault:[[responseObj objectForKey:loginUser] valueForKey:loginUserToken] andKey:loginUserToken];
                        [CommonFunction storeValueInDefault:[[responseObj objectForKey:loginUser] valueForKey:loginfirstname] andKey:loginfirstname];
                        [CommonFunction storeValueInDefault:[CommonFunction checkForNull:[[responseObj objectForKey:loginUser] valueForKey:loginDOB]] andKey:loginDOB];
                        [CommonFunction stroeBoolValueForKey:Notification_Related withBoolValue:true];
                        [CommonFunction storeValueInDefault:[[responseObj valueForKey:loginUser] valueForKey:LOGIN_IS_MOBILE_VERIFY] andKey:LOGIN_IS_MOBILE_VERIFY];
                          [CommonFunction storeValueInDefault:[[responseObj objectForKey:loginUser] valueForKey:mobileNo] andKey:mobileNo];
                       
                        [self hitApiForaddingTheDeviceID];
                        RearViewController *rearViewController = [[RearViewController alloc]initWithNibName:@"RearViewController" bundle:nil];
                          RearViewController *rightViewController = [[RearViewController alloc]initWithNibName:@"RearViewController" bundle:nil];
                        SWRevealViewController *mainRevealController;
                        NewAwareVC *frontViewController = [[NewAwareVC alloc]initWithNibName:@"NewAwareVC" bundle:nil];
                        mainRevealController = [[SWRevealViewController alloc]initWithRearViewController:rearViewController frontViewController:frontViewController];
                        mainRevealController.rightViewController = rightViewController;
                        mainRevealController.delegate = self;
                        mainRevealController.view.backgroundColor = [UIColor blackColor];
                        //            [frontViewController.view addSubview:[CommonFunction setStatusBarColor]];
                        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:mainRevealController];
                        ((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.rootViewController = nav;
                        
                    } afterDelay:1.5];
                    
                    [self removeloder];
                }
                else
                {
                    [self addAlertWithTitle:[Langauge getTextFromTheKey:Error_Key] andMessage:[responseObj valueForKey:@"message"] isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Error_Key_For_Image];
                    [self removeloder];
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
- (void)performBlock:(void(^)())block afterDelay:(NSTimeInterval)delay {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}

-(void)hitApiForaddingTheDeviceID{
    
    
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    [parameter setValue:[CommonFunction getValueFromDefaultWithKey:DEVICE_ID] forKey:DEVICE_ID];
    [parameter setValue:[CommonFunction getValueFromDefaultWithKey:loginuserId] forKey:loginuserId];
    
   
    
    if ([ CommonFunction reachability]) {
        //        [self addLoder];
        
        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,@"registration_ids"]  postResponse:parameter postImage:nil requestType:POST tag:nil isRequiredAuthentication:YES header:@"" completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"]) {
                    [CommonFunction storeValueInDefault:[CommonFunction getValueFromDefaultWithKey:DEVICE_ID] andKey:DEVICE_ID_LoginUSer];
                    //                    [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:[responseObj valueForKey:@"message"] isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
                }else
                {
                    //                    [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:[responseObj valueForKey:@"message"] isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
                    //                    [self removeloder];
                    //                    [self removeloder];
                }
                //                [self removeloder];
            }
        }];
    } else {
        //        [self removeloder];
        //        [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:Network_Issue_Message isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
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
            
        default:
            
            break;
    }
}

@end
