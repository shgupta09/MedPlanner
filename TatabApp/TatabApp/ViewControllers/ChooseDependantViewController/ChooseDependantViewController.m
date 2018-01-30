//
//  ChooseDependantViewController.m
//  TatabApp
//
//  Created by Shagun Verma on 27/01/18.
//  Copyright © 2018 Shagun Verma. All rights reserved.
//

#import "ChooseDependantViewController.h"

@interface ChooseDependantViewController ()
{
    LoderView *loderObj;
    NSMutableArray *dependantListArray;
    ChatPatient *patient;
    NSDate *departDate;
    NSString *departDateString;
    NSMutableArray *relationArray;
    UIPickerView *pickerObj;
    BOOL isMale;
    UIView *viewOverPicker;
    NSString *relationshipId ;
    NSInteger selectedRowForSpeciality;
     UIDatePicker* pickerForDate;
    UIToolbar *toolBar;
    RegistrationDpendency *dependencyObj ;
}
@property (weak, nonatomic) IBOutlet UIButton *addOptionBtnAction;
@property (weak, nonatomic) IBOutlet CustomTextField *txtName;
@property (weak, nonatomic) IBOutlet CustomTextField *txt_BirthDate;
@property (weak, nonatomic) IBOutlet UIButton *btnFemale;
@property (weak, nonatomic) IBOutlet UIButton *btnMAle;
@property (weak, nonatomic) IBOutlet UITableView *tbl_View;
@end

@implementation ChooseDependantViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData];

    if ( _isManageDependants) {
        [CommonFunction setResignTapGestureToView:self.view andsender:self];

    }
    else
    {
        _btnAdd.hidden = true;
    }
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidLayoutSubviews{
    loderObj.frame = self.view.frame;
}
-(void)setData{
    _txtName.leftImgView.image = [UIImage imageNamed:@"b"];
    _txt_BirthDate.leftImgView.image = [UIImage imageNamed:@"icon-calendar"];

    _addOptionBtnAction.tintColor = [CommonFunction colorWithHexString:@"45AED4"];
    UIImage * image = [UIImage imageNamed:@"Plus"];
    [_addOptionBtnAction setBackgroundImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    selectedRowForSpeciality = 0;
    isMale = true;
    relationArray = [NSMutableArray new];
    [CommonFunction setResignTapGestureToView:_popUpView andsender:self];
    patient = [ChatPatient new];
    [_tbl_View registerNib:[UINib nibWithNibName:@"SelectUserTableViewCell" bundle:nil]forCellReuseIdentifier:@"SelectUserTableViewCell"];
    _tbl_View.rowHeight = UITableViewAutomaticDimension;
    _tbl_View.estimatedRowHeight = 100;
    _tbl_View.multipleTouchEnabled = NO;
    _btnFemale.tintColor = [CommonFunction colorWithHexString:COLORCODE_FOR_TEXTFIELD];
    _btnMAle.layer.cornerRadius = 22;
    _btnFemale.layer.cornerRadius = 22;
    _btnMAle.layer.borderWidth = 3;
    _btnFemale.layer.borderWidth = 3;
    _btnFemale.layer.borderColor =[[CommonFunction colorWithHexString:COLORCODE_FOR_TEXTFIELD] CGColor];
    _btnMAle.layer.borderColor =[[CommonFunction colorWithHexString:COLORCODE_FOR_TEXTFIELD] CGColor];
    
    _btnMAle.backgroundColor = [CommonFunction colorWithHexString:COLORCODE_FOR_TEXTFIELD];
    _btnMAle.tintColor = [UIColor whiteColor];
    
    departDate = [NSDate date];
    [self hitApiForDependants];
}
-(void)resignResponder{
    [CommonFunction resignFirstResponderOfAView:self.view];
    if ([viewOverPicker isDescendantOfView:self.view]) {
        [viewOverPicker removeFromSuperview];
    }else if ([_popUpView isDescendantOfView:self.view]) {
        [_popUpView removeFromSuperview];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark- tableView delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return patient.dependants.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectUserTableViewCell *cell = [_tbl_View dequeueReusableCellWithIdentifier:@"SelectUserTableViewCell"];
    
    if (cell == nil) {
        cell = [[SelectUserTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SelectUserTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
        RegistrationDpendency* dependant = [patient.dependants objectAtIndex:indexPath.row];
    if ( _isManageDependants) {
        cell.btn_Cross.hidden = false;
        cell.sideImageView.hidden = true;
        [cell.btn_Cross addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        cell.btn_Cross.tag = indexPath.row;
        cell.btn_Cross.userInteractionEnabled = true;
        if (indexPath.row==0) {
            cell.btn_Cross.hidden = true;
            cell.btn_Cross.userInteractionEnabled = false;
        }
    }else{
        cell.btn_Cross.hidden = true;
        
        cell.sideImageView.hidden = false;
    }
    
    
        cell.lbl_name.text = [NSString stringWithFormat:@"%@",dependant.name];
        
        //    cell.profileImageView.image = [CommonFunction getImageWithUrlString:obj.photo];
        [cell.profileImageView setImage:[UIImage imageNamed:@"profile.png"]];
        cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.size.width/2;
        cell.profileImageView.clipsToBounds = true;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)btnClicked:(id)sender{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:[NSString stringWithFormat:@"Are you sure you want to delete %@ ?",((RegistrationDpendency *)[dependantListArray objectAtIndex:((UIButton *)sender).tag]).name] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self hitApiForRemoveDependants:((RegistrationDpendency *)[dependantListArray objectAtIndex:((UIButton *)sender).tag]).depedant_id];
        }];
        [alertController addAction:ok];
        UIAlertAction* no = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:no];
        //                    [CommonFunction storeValueInDefault:@"true" andKey:@"isLoggedIn"];
        [self presentViewController:alertController animated:YES completion:nil];

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    if (!_isManageDependants){
        if (indexPath.row == 0) {
            EMRHealthContainerVC* vc ;
            vc = [[EMRHealthContainerVC alloc] initWithNibName:@"EMRHealthContainerVC" bundle:nil];
            ChatPatient* pat = [ChatPatient new];
            pat.patient_id = _patientID;
            pat.name = _patientName;
            vc.patient = pat;
            vc.isdependant = false;
            [self.navigationController pushViewController:vc animated:true];
        }
        else
        {
            EMRHealthContainerVC* vc ;
            vc = [[EMRHealthContainerVC alloc] initWithNibName:@"EMRHealthContainerVC" bundle:nil];
            ChatPatient* pat = [ChatPatient new];
            pat.patient_id = _patientID;
            vc.patient = pat;
            vc.dependant = [patient.dependants objectAtIndex:indexPath.row];
            vc.isdependant = true;
            [self.navigationController pushViewController:vc animated:true];

        }

    }
    
    
}


#pragma mark - Api Related
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

-(void)hitApiForDependants{
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    [parameter setValue:_patientID forKey:@"user_id"];
    
    if ([ CommonFunction reachability]) {
        [self addLoder];
        
        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_FETCH_DEPENDANTS]  postResponse:parameter postImage:nil requestType:POST tag:nil isRequiredAuthentication:YES header:@"" completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"]) {
                    NSArray *tempArray = [NSArray new];
                    dependantListArray = [NSMutableArray new];
                    RegistrationDpendency *dependencyObj = [RegistrationDpendency new];
                   // dependencyObj.name = [[responseObj valueForKey:@"patient"] valueForKey:@"name"];
                     dependencyObj.name = @"Main Profile";
                    dependencyObj.depedant_id = [[responseObj valueForKey:@"patient"] valueForKey:@"id"];
                    dependencyObj.gender = [[responseObj valueForKey:@"patient"] valueForKey:@"gender"];
                    dependencyObj.isMainProfile = true;
                    [dependantListArray addObject: dependencyObj];
                    tempArray  = [[responseObj valueForKey:@"patient"] valueForKey:@"childrens"];
                    
                    [tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        RegistrationDpendency *dependencyObj = [RegistrationDpendency new];
                        dependencyObj.name = [obj valueForKey:@"name"];
                        dependencyObj.depedant_id = [obj valueForKey:@"id"];
                        dependencyObj.gender = [obj valueForKey:@"gender"];
                         dependencyObj.relation = [CommonFunction checkForNull:[obj valueForKey:@"relation"]];
                        dependencyObj.isMainProfile = false;
                        [dependantListArray addObject:dependencyObj];
                    }];
                    patient.dependants = dependantListArray;
                    
                    [_tbl_View reloadData];
                    
                    
                }else
                {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:[responseObj valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:ok];
                    //                    [CommonFunction storeValueInDefault:@"true" andKey:@"isLoggedIn"];
                    [self presentViewController:alertController animated:YES completion:nil];
                    [self removeloder];
                }
                [self removeloder];
                
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
-(void)hitApiForRemoveDependants:(NSString *)dependentID{
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    [parameter setValue:_patientID forKey:loginuserId];
     [parameter setValue:dependentID forKey:DEPENDANT_ID];
    
    if ([ CommonFunction reachability]) {
        [self addLoder];
        
        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_DELETE_DEPENDANTS]  postResponse:parameter postImage:nil requestType:POST tag:nil isRequiredAuthentication:YES header:@"" completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"]) {
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Dependent remove successfully." preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:ok];
                    [self removeloder];

                    [self hitApiForDependants];
                    //                    [CommonFunction storeValueInDefault:@"true" andKey:@"isLoggedIn"];
                    [self presentViewController:alertController animated:YES completion:nil];

                }else
                {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:[responseObj valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:ok];
                    //                    [CommonFunction storeValueInDefault:@"true" andKey:@"isLoggedIn"];
                    [self presentViewController:alertController animated:YES completion:nil];
                    [self removeloder];
                }
                [self removeloder];
                
            }
            [self removeloder];

            
            
        }];
    } else {
        [self removeloder];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Network Error" message:@"No Network Access" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
-(void)hitApiForAddDependants{
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    [parameter setValue:_patientID forKey:@"user_id"];
    [parameter setValue:dependencyObj.birthDay forKey:@"dob"];
    if (dependencyObj.isMale) {
        [parameter setValue:@"M" forKey:@"gender"];
    }else{
        [parameter setValue:@"F" forKey:@"gender"];
    }
    
    [parameter setValue:dependencyObj.name forKey:@"name"];
    [parameter setValue:relationshipId forKey:@"relationship_id"];
    
    
    
    if ([ CommonFunction reachability]) {
        [self addLoder];
        
        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_ADD_DEPENDANTS]  postResponse:parameter postImage:nil requestType:POST tag:nil isRequiredAuthentication:YES header:@"" completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"]) {
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Dependent added successfully." preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:ok];
                    [_popUpView removeFromSuperview];
                    [self removeloder];

                    [self hitApiForDependants];
                    
                    //                    [CommonFunction storeValueInDefault:@"true" andKey:@"isLoggedIn"];
                    [self presentViewController:alertController animated:YES completion:nil];
                    
                }else
                {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:[responseObj valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:ok];
                    //                    [CommonFunction storeValueInDefault:@"true" andKey:@"isLoggedIn"];
                    [self presentViewController:alertController animated:YES completion:nil];
                    [self removeloder];
                }
                [self removeloder];
                
            }
            [self removeloder];

            
            
        }];
    } else {
        [self removeloder];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Network Error" message:@"No Network Access" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}



#pragma mark - btn Actions
-(void)doneForPicker:(id)sender
{
    [viewOverPicker removeFromSuperview];
    
}
- (IBAction)btnActionGender:(id)sender {
    if (((UIButton *)sender).tag == 10) {
        isMale = true;
        _btnMAle.backgroundColor = [CommonFunction colorWithHexString:COLORCODE_FOR_TEXTFIELD];
        _btnMAle.tintColor = [UIColor whiteColor];
        _btnFemale.backgroundColor = [UIColor whiteColor];
        _btnFemale.tintColor = [CommonFunction colorWithHexString:COLORCODE_FOR_TEXTFIELD];
        
    }else{
        isMale = false;
        _btnFemale.backgroundColor = [CommonFunction colorWithHexString:COLORCODE_FOR_TEXTFIELD];
        _btnFemale.tintColor = [UIColor whiteColor];
        _btnMAle.backgroundColor = [UIColor whiteColor];
        _btnMAle.tintColor = [CommonFunction colorWithHexString:COLORCODE_FOR_TEXTFIELD];
    }
}

- (IBAction)btnAcion_relationShip:(id)sender {
    
    pickerObj = [[UIPickerView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 150, self.view.frame.size.width, 150)];
    pickerObj.delegate = self;
    pickerObj.dataSource = self;
    pickerObj.showsSelectionIndicator = YES;
    pickerObj.backgroundColor = [UIColor lightGrayColor];
    viewOverPicker = [[UIView alloc]initWithFrame:self.view.frame];
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:
                          CGRectMake(0, self.view.frame.size.height-
                                     pickerObj.frame.size.height-50, self.view.frame.size.width, 50)];
    [toolBar setBarStyle:UIBarStyleBlackOpaque];
    UIToolbar *toolBarForTitle;
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
    [pickerObj  selectRow:selectedRowForSpeciality inComponent:0 animated:true];
    [viewOverPicker addSubview:pickerObj];
    [self.view addSubview:viewOverPicker];
    [pickerObj reloadAllComponents];
}
- (IBAction)btnAddFileClicked:(id)sender{
    if (![CommonFunction getBoolValueFromDefaultWithKey:RelationApi]) {
        [self getData];
    }
    else{
        relationArray = [Relation sharedInstance].myDataArray;
    }
    _txtName.text = @"";
    _txt_BirthDate.text = @"";
    isMale = true;
   
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
- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
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




- (IBAction)btnActionConfirmAdd:(id)sender {
    NSDictionary *dictForValidation = [self validateData];
    
    if (![[dictForValidation valueForKey:BoolValueKey] isEqualToString:@"0"]){
        [_popUpView removeFromSuperview];
        
        dependencyObj = [RegistrationDpendency new];
        dependencyObj.name = [CommonFunction trimString:_txtName.text];
        dependencyObj.birthDay = _txt_BirthDate.text;
        dependencyObj.isMale = isMale;
        [self hitApiForAddDependants];
    }
    else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:[dictForValidation valueForKey:AlertKey] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
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
        
    }else if ([_txt_Relationship.text isEqualToString:@""]){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        if ([CommonFunction trimString:_txtName.text].length == 0){
            [validationDict setValue:@"We need a Relationship" forKey:AlertKey];
        }
    }
    else if(_txt_BirthDate.text.length == 0){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        [validationDict setValue:@"We need a birth date" forKey:AlertKey];
    }
    return validationDict.mutableCopy;
    
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
    _txt_BirthDate.text = departDateString;
   
    
}
#pragma mark - loder
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
#pragma mark - picker data Source
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component{
    
    return [relationArray count];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:
(NSInteger)row forComponent:(NSInteger)component{
    
    Relation* relationObj = [relationArray objectAtIndex:row];
    return relationObj.name;
    
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component{
    Relation* relationObj = [relationArray objectAtIndex:row];
    _txt_Relationship.text = relationObj.name;
    relationshipId= relationObj.idValue;
    selectedRowForSpeciality = row;
}
@end
