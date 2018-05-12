//
//  DProfileVC.m
//  TatabApp
//
//  Created by shubham gupta on 5/6/18.
//  Copyright © 2018 Shagun Verma. All rights reserved.
//

#import "DProfileVC.h"
#import "DProfileCellType1.h"
#import "DProfileCellType2.h"
#import "ProfileImageCell.h"
#import "Profile.h"
#import "ExperianceClass.h"
#import "Education.h"
@interface DProfileVC (){
    LoderView *loderObj;
    CustomAlert *alertObj;
   
    BOOL isEdit;
    Profile *profileObj;
    NSDate *dateForResignedSince;
    NSDate *dateForJoin;
    NSString *dateForResignedSinceString;
    NSString *dateForJoinStrng;
    UIDatePicker* pickerForDate;
    UIView *viewOverPicker;
    UIToolbar *toolBar;
    NSInteger replacableIndex;
    BOOL isEditExperience;
    NSMutableArray *cityArray;
    NSInteger selectedRowForCity;
    UIPickerView *pickerObj;
    BOOL isImageCaptured;
    UIImage *capturedImage;
    ExperianceClass *experienceToAdd;
    Education *educationToAdd;
}

@end

@implementation DProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    alertObj = [[CustomAlert alloc] initWithFrame:self.view.frame];
    profileObj = [Profile new];
    [self setData];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidLayoutSubviews{
    loderObj.frame = self.view.frame;
    alertObj.frame = self.view.frame;
    _popUpAbout.frame = self.view.frame;
    _popUpEducation.frame = self.view.frame;
    _popUpExperience.frame = self.view.frame;
}
-(void)setData{
    if (_isLofinUser) {
        _btn_Save.hidden = false;
    }else{
        _btn_Save.hidden = true;
    }
     selectedRowForCity = 0;
     cityArray = [NSMutableArray new] ;
     cityArray = [[CommonFunction getCityArray] mutableCopy];
  
    
    [CommonFunction setResignTapGestureToView:_popUpEducation andsender:self];
    [CommonFunction setResignTapGestureToView:_popUpExperience andsender:self];
    [CommonFunction setResignTapGestureToView:_popUpAbout andsender:self];
    isImageCaptured = false;
    //date
    dateForJoin = [NSDate date];
    dateForResignedSince = [NSDate date];
    _txt_hospitalName.leftImgView.image = [UIImage imageNamed:@"b"];
    _txt_UniversityName.leftImgView.image = [UIImage imageNamed:@"b"];
    _txt_description.leftImgView.image = [UIImage imageNamed:@"b"];
    _txt_Universitydescription.leftImgView.image = [UIImage imageNamed:@"b"];
    _txt_workedSince.leftImgView.image = [UIImage imageNamed:@"icon-calendar"];
    _txt_resignedSince.leftImgView.image = [UIImage imageNamed:@"icon-calendar"];
    [self setLanguageData];
    [self setUpTableData];
    [self hitDoctorApi];
}
-(void)setLanguageData{
    _lbl_Title.text = [Langauge getTextFromTheKey:@"Doctor_Profile"];
    [_btn_Save setTitle:[Langauge getTextFromTheKey:@"Edit"] forState:UIControlStateNormal];
    [_btn_ConfirmAdd setTitle:[Langauge getTextFromTheKey:@"confirm_add"] forState:UIControlStateNormal];
    [_btn_ConfirmAddEducation setTitle:[Langauge getTextFromTheKey:@"confirm_add"] forState:UIControlStateNormal];
    [_txt_workedSince setPlaceholderWithColor:[Langauge getTextFromTheKey:@"working_since"]];
    [_txt_hospitalName setPlaceholderWithColor:[Langauge getTextFromTheKey:@"hospital_name"]];
    [_txt_resignedSince setPlaceholderWithColor:[Langauge getTextFromTheKey:@"resigned_since"]];
    [_txt_description setPlaceholderWithColor:[Langauge getTextFromTheKey:@"Description"]];
    [_txt_Universitydescription setPlaceholderWithColor:[Langauge getTextFromTheKey:@"Description"]];
    [_txt_UniversityName setPlaceholderWithColor:[Langauge getTextFromTheKey:@"Unversity_Name"]];
    isEdit = false;
    isEditExperience = false;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - textField

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSMutableString * str = [textField.text mutableCopy];
    [str replaceCharactersInRange:range withString:string];
    if (textField.tag == 1009) {
        profileObj.name = [str mutableCopy];
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
        return  [[cityArray objectAtIndex:row] valueForKey:@"Name"];
    }
    return @"";
    
    
    
    
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component{
    if (pickerView.tag == 0) {
        profileObj.home_location =  [[cityArray objectAtIndex:row] valueForKey:@"Name"];;
        selectedRowForCity = row;
    }
    [_tblList reloadData];
}

#pragma mark- TextView Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:[Langauge getTextFromTheKey:@"About_Text"]]) {
        textView.text = @"";
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = [Langauge getTextFromTheKey:@"About_Text"];
    }
    [textView resignFirstResponder];
}

#pragma mark - Date
- (IBAction)btnActionBirthDay:(UIButton *)sender {
    
    [CommonFunction resignFirstResponderOfAView:self.view];
    pickerForDate = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 150, self.view.frame.size.width, 150)];
    pickerForDate.datePickerMode = UIDatePickerModeDate;
    pickerForDate.tag = ((UIButton *)sender).tag;
    if(sender.tag == 0){
        [pickerForDate setDate:dateForJoin];
        [pickerForDate setMaximumDate: [NSDate date]];
    }else{
        [pickerForDate setDate:dateForResignedSince];
        [pickerForDate setMinimumDate: dateForJoin];
        [pickerForDate setMaximumDate:[NSDate date]];
    }
    
    
    
    
    [pickerForDate addTarget:self action:@selector(dueDateChanged:)
            forControlEvents:UIControlEventValueChanged];
    viewOverPicker = [[UIView alloc]initWithFrame:self.view.frame];
    pickerForDate.backgroundColor = [UIColor darkGrayColor];
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

// value change of the date picker
-(void) dueDateChanged:(UIDatePicker *)sender {
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    //self.myLabel.text = [dateFormatter stringFromDate:[dueDatePickerView date]];
    NSLog(@"Picked the date %@", [dateFormatter stringFromDate:[sender date]]);
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    
    if (sender.tag == 0){
        dateForJoinStrng = [dateFormatter stringFromDate:[sender date]];
        dateForJoin = sender.date;
        _txt_workedSince.text = dateForJoinStrng;
    }else if (sender.tag == 1){
        dateForResignedSinceString = [dateFormatter stringFromDate:[sender date]];
        dateForResignedSince = sender.date;
        _txt_resignedSince.text = dateForResignedSinceString;
    }
    
}

-(void)doneForPicker:(id)sender{
    [viewOverPicker removeFromSuperview];
    
}
#pragma mark- tableView delegate


-(void)setUpTableData{
    [_tblList registerNib:[UINib nibWithNibName:@"DProfileCellType1" bundle:nil]forCellReuseIdentifier:@"DProfileCellType1"];
    [_tblList registerNib:[UINib nibWithNibName:@"DProfileCellType2" bundle:nil]forCellReuseIdentifier:@"DProfileCellType2"];
    [_tblList registerNib:[UINib nibWithNibName:@"ProfileImageCell" bundle:nil]forCellReuseIdentifier:@"ProfileImageCell"];
    
    _tblList.rowHeight = UITableViewAutomaticDimension;
    _tblList.estimatedRowHeight = 100;
    _tblList.multipleTouchEnabled = NO;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6+[profileObj.experianceArray count]+[profileObj.educationArray count];
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0){
        ProfileImageCell *cell = [_tblList dequeueReusableCellWithIdentifier:@"ProfileImageCell"];
        
        if (cell == nil) {
            cell = [[ProfileImageCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ProfileImageCell"];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
//        cell.img_Profile.layer.masksToBounds = true;
//        cell.img_Profile.layer.cornerRadius = 65;
//        cell.lbl_Title.text = profileObj.name;
        if (isImageCaptured) {
            cell.img_Profile.image  = capturedImage;
        }else{
        [cell.img_Profile sd_setImageWithURL:[NSURL URLWithString:profileObj.upload]];
        }
        cell.txt_Name.layer.cornerRadius = 17;
        cell.txt_Name.layer.masksToBounds = true;
        cell.txt_Name.layer.borderWidth = 1;
        cell.txt_Name.layer.masksToBounds = true;
        if(isEdit){
            cell.btn.tag = 6;
            cell.btn.hidden = false;
            [cell.btn addTarget:self action:@selector(btnActionAdd:) forControlEvents:UIControlEventTouchUpInside];
            cell.txt_Name.userInteractionEnabled = true;
            cell.txt_Name.layer.borderColor= [CommonFunction colorWithHexString:primary_Color].CGColor;
            cell.txt_Name.layer.borderWidth = 1;
            cell.txt_Name.layer.masksToBounds = true;
            cell.txt_Name.tintColor = [UIColor whiteColor];
            if([profileObj.name containsString:@"Dr."])
            {
                cell.txt_Name.text = [NSString stringWithFormat:@"%@",[profileObj.name capitalizedString]];
            }else{
                cell.txt_Name.text = [NSString stringWithFormat:@"Dr. %@",[profileObj.name capitalizedString]];
            }
        }else{
            cell.txt_Name.layer.borderColor= [UIColor whiteColor].CGColor;
            cell.txt_Name.tintColor = [CommonFunction colorWithHexString:primary_Color];
            cell.txt_Name.userInteractionEnabled = false;
            
            
            if([profileObj.name containsString:@"Dr."])
            {
                cell.txt_Name.text = [NSString stringWithFormat:@"%@",[profileObj.name capitalizedString]];
            }else{
                cell.txt_Name.text = [NSString stringWithFormat:@"Dr. %@",[profileObj.name capitalizedString]];
            }
            cell.txt_Name.tag = 1009;
            cell.txt_Name.delegate = self;
            cell.btn.hidden = true;
        }
//        cell.img_Profile.image = [UIImage imageNamed:@"Like"];
//        cell.lbl_Title.text = [Langauge getTextFromTheKey:@"About_Me"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }
   else if (indexPath.row == 1){
            DProfileCellType1 *cell = [_tblList dequeueReusableCellWithIdentifier:@"DProfileCellType1"];
            
            if (cell == nil) {
                cell = [[DProfileCellType1 alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"DProfileCellType1"];
                }
            cell.lbl2.hidden = true;
            cell.img_Icon.image = [UIImage imageNamed:@"aboutDoctor"];
            cell.lbl_titleName.text = [Langauge getTextFromTheKey:@"About_Me"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
       
            return cell;
        }
         else if (indexPath.row == 2){
            DProfileCellType2 *cell = [_tblList dequeueReusableCellWithIdentifier:@"DProfileCellType2"];
            
            if (cell == nil) {
                cell = [[DProfileCellType2 alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"DProfileCellType2"];
                
            }
            cell.lbl1.hidden = true;
            cell.lbl2.hidden = true;
            cell.lbl3_UpperConstraint.constant = -20;
             
             if ([profileObj.about_me isEqualToString:@""]) {
                 cell.lbl3.text = @"N/A";
             }else{
                 cell.lbl3.text = profileObj.about_me;
             }
             if(isEdit){
                 cell.btn.layer.borderColor = [CommonFunction colorWithHexString:primary_Color].CGColor;
                 cell.traillingConstraint.constant = 10;
                 cell.btnDelete.hidden = true;
                 cell.btn.tag = 3;
                 cell.btn.hidden = false;
                 [cell.btn addTarget:self action:@selector(btnActionEdit:) forControlEvents:UIControlEventTouchUpInside];
                              [cell.view setBackgroundColor:[UIColor clearColor]];
             }else{
               [cell.view setBackgroundColor:[UIColor whiteColor]];
                 [CommonFunction setShadowOpacity:cell.view];
                 [CommonFunction setCornerRadius:cell.view Radius:5.0];
                 cell.btn.layer.borderColor = [UIColor clearColor].CGColor;
                 cell.traillingConstraint.constant = 10;
                 cell.btnDelete.hidden = true;
                 cell.btn.layer.borderColor = [UIColor clearColor   ].CGColor;
                 cell.btn.hidden = true;
             }
             cell.selectionStyle = UITableViewCellSelectionStyleNone;

            return cell;
        }
       else  if (indexPath.row == 3){
            DProfileCellType1 *cell = [_tblList dequeueReusableCellWithIdentifier:@"DProfileCellType1"];
            
            if (cell == nil) {
                cell = [[DProfileCellType1 alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"DProfileCellType1"];
                }
           if(isEdit){
               cell.btn.tag = 0;
               cell.btn.hidden = false;
               cell.lbl2.text = @"+";
               cell.lbl2.font = [UIFont fontWithName:@"Montserrat-Regular" size:30];
               [cell.btn addTarget:self action:@selector(btnActionAdd:) forControlEvents:UIControlEventTouchUpInside];
           }else{
               cell.lbl2.text = @"";
               cell.btn.hidden = true;
           }
           cell.img_Icon.image = [UIImage imageNamed:@"education"];
           cell.lbl_titleName.text = [Langauge getTextFromTheKey:@"Education"];
           cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
       else if ( ((indexPath.row <= 3+profileObj.educationArray.count )&&profileObj.educationArray.count>0)){
           DProfileCellType2 *cell = [_tblList dequeueReusableCellWithIdentifier:@"DProfileCellType2"];
           
           if (cell == nil) {
               cell = [[DProfileCellType2 alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"DProfileCellType2"];
           }
           cell.lbl1.hidden = false;
           cell.lbl2.hidden = true;
           cell.lbl3_UpperConstraint.constant = 10;
           Education *objClass = [Education new];
           objClass = [profileObj.educationArray objectAtIndex:indexPath.row-4];
           cell.lbl1.text = objClass.university_name;
           cell.lbl3.text = objClass.descriptionObj;
           if(isEdit){
               cell.btn.layer.borderColor = [CommonFunction colorWithHexString:primary_Color].CGColor;
             cell.traillingConstraint.constant = 30;
               cell.btnDelete.hidden = false;
               cell.btn.hidden = false;
               cell.btn.tag = 100 + (indexPath.row - 4);
               cell.btnDelete.tag = 100 + (indexPath.row - 4);
               [cell.btn addTarget:self action:@selector(btnActionEdit:) forControlEvents:UIControlEventTouchUpInside];
               [cell.btnDelete addTarget:self action:@selector(btnActionDelete:) forControlEvents:UIControlEventTouchUpInside];
                            [cell.view setBackgroundColor:[UIColor clearColor]];

           }
           else{
               cell.btn.layer.borderColor = [UIColor clearColor   ].CGColor;
               cell.traillingConstraint.constant = 10;
               cell.btnDelete.hidden = true;
               cell.btn.hidden = true;
               [CommonFunction setShadowOpacity:cell.view];
               [CommonFunction setCornerRadius:cell.view Radius:5.0];
           
              [cell.view setBackgroundColor:[UIColor whiteColor]];
           }
           cell.selectionStyle = UITableViewCellSelectionStyleNone;

           return cell;
       }
       else  if (indexPath.row == 4+profileObj.educationArray.count){
           DProfileCellType1 *cell = [_tblList dequeueReusableCellWithIdentifier:@"DProfileCellType1"];
           
           if (cell == nil) {
               cell = [[DProfileCellType1 alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"DProfileCellType1"];
               
           }
           cell.lbl2.hidden = false;
           cell.lbl2.font = [UIFont fontWithName:@"Montserrat-Regular" size:13];
           cell.lbl2.text = profileObj.home_location;
           cell.img_Icon.image = [UIImage imageNamed:@"location"];
           cell.lbl_titleName.text = [Langauge getTextFromTheKey:@"city"];
           if(isEdit){
               cell.btn.layer.borderColor = [CommonFunction colorWithHexString:primary_Color].CGColor;
               cell.btn.tag = 1;
               [cell.btn addTarget:self action:@selector(btnActionAdd:) forControlEvents:UIControlEventTouchUpInside];
               cell.btn.hidden = false;
           }else{
               cell.btn.hidden = true;
               cell.btn.layer.borderColor = [UIColor clearColor   ].CGColor;
           }
           cell.selectionStyle = UITableViewCellSelectionStyleNone;

           return cell;
       }
       else  if (indexPath.row == 5+profileObj.educationArray.count){
           DProfileCellType1 *cell = [_tblList dequeueReusableCellWithIdentifier:@"DProfileCellType1"];
           
           if (cell == nil) {
               cell = [[DProfileCellType1 alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"DProfileCellType1"];
               
           }
           if (isEdit) {
               cell.btn.tag = 2;
               cell.btn.hidden = false;
               cell.lbl2.hidden = false;
               cell.lbl2.text = @"+";
               cell.lbl2.font = [UIFont fontWithName:@"Montserrat-Regular" size:30];
               cell.btn.layer.borderColor = [UIColor clearColor   ].CGColor;
               [cell.btn addTarget:self action:@selector(btnActionAdd:) forControlEvents:UIControlEventTouchUpInside];
           }
           else{
               cell.lbl2.text = @"";
               cell.btn.hidden = true;
               cell.btn.layer.borderColor = [UIColor clearColor   ].CGColor;

           }
//           cell.lbl2.text = @"Kasganj";
           cell.img_Icon.image = [UIImage imageNamed:@"experiance"];
           cell.lbl_titleName.text = [Langauge getTextFromTheKey:@"Years_Of_Experience"];
           cell.selectionStyle = UITableViewCellSelectionStyleNone;

           return cell;
       }
       else if (indexPath.row >= 6+profileObj.educationArray.count){
           DProfileCellType2 *cell = [_tblList dequeueReusableCellWithIdentifier:@"DProfileCellType2"];
           
           if (cell == nil) {
               cell = [[DProfileCellType2 alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"DProfileCellType2"];
               
           }
           ExperianceClass *objClass = [ExperianceClass new];
           objClass = [profileObj.experianceArray objectAtIndex:indexPath.row-6-profileObj.educationArray.count];
           cell.lbl1.hidden = false;
           cell.lbl2.hidden = false;
           cell.lbl3_UpperConstraint.constant = 10;
           cell.lbl1.text = objClass.hospital_name;
           cell.lbl2.font = [UIFont fontWithName:@"Montserrat-Regular" size:13];
           cell.lbl2.text = [NSString stringWithFormat:@"%@-%@",[objClass.worked_since substringToIndex:4],[objClass.resigned_since substringToIndex:4]];
           cell.lbl3.text = objClass.descriptionObj;
           if(isEdit){
               cell.btn.layer.borderColor = [CommonFunction colorWithHexString:primary_Color].CGColor;
               cell.btn.tag =
               cell.traillingConstraint.constant = 40;
               cell.btnDelete.hidden = false;
               cell.btn.hidden = false;

               cell.btn.tag = 200 + (indexPath.row - 6-profileObj.educationArray.count);
               cell.btnDelete.tag = 200 + (indexPath.row - 6-profileObj.educationArray.count);
               [cell.btn addTarget:self action:@selector(btnActionEdit:) forControlEvents:UIControlEventTouchUpInside];
               [cell.btnDelete addTarget:self action:@selector(btnActionDelete:) forControlEvents:UIControlEventTouchUpInside];
               [cell.view setBackgroundColor:[UIColor clearColor]];
           }
           else{
               [CommonFunction setShadowOpacity:cell.view];
               [CommonFunction setCornerRadius:cell.view Radius:5.0];
              [cell.view setBackgroundColor:[UIColor whiteColor]];
               cell.btn.layer.borderColor = [UIColor clearColor   ].CGColor;
               cell.traillingConstraint.constant = 10;
               cell.btnDelete.hidden = true;
               cell.btn.hidden = true;

           }
           cell.selectionStyle = UITableViewCellSelectionStyleNone;

           
           return cell;
       }
    DProfileCellType1 *cell = [_tblList dequeueReusableCellWithIdentifier:@"DProfileCellType1"];
    
    if (cell == nil) {
        cell = [[DProfileCellType1 alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"DProfileCellType1"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

#pragma mark - Btn Action

- (IBAction)btnAction_AdoutAdd:(id)sender {
    NSDictionary *dictForValidation = [self validateDataForAbout];
    if (![[dictForValidation valueForKey:BoolValueKey] isEqualToString:@"0"]){
        [_popUpAbout removeFromSuperview];
        profileObj.about_me = [CommonFunction trimString:_txt_about.text];
        [_tblList reloadData];
        [self viewDidLayoutSubviews];
    }
    else{
        [self addAlertWithTitle:[Langauge getTextFromTheKey:Warning_Key] andMessage:[dictForValidation valueForKey:AlertKey]   isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
        
    }
    
}
-(void)btnActionAdd:(UIButton *)btn{
    [CommonFunction resignFirstResponderOfAView:self.view];
    if (btn.tag == 0) {
         educationToAdd = [Education new];
        educationToAdd.edu_id = @"na";
        _txt_UniversityName.text = @"";
        _txt_Universitydescription.text = @"";
        isEditExperience = false;
        [[self popUpEducation] setAutoresizesSubviews:true];
        [[self popUpEducation] setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) ;
        frame.origin.y = 0.0f;
        self.popUpEducation.center = CGPointMake(self.view.center.x, self.view.center.y);
        [[self popUpEducation] setFrame:frame];
        [self.view addSubview:_popUpEducation];
        [CommonFunction addAnimationToview:_popUpEducation];
    }else if (btn.tag == 1){
        
        pickerObj = [[UIPickerView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 150, self.view.frame.size.width, 150)];
        pickerObj.delegate = self;
        pickerObj.dataSource = self;
        pickerObj.showsSelectionIndicator = YES;
        pickerObj.backgroundColor = [UIColor darkGrayColor];
        pickerObj.tag = 0;
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
        
    }else if (btn.tag == 2){
        experienceToAdd = [ExperianceClass new];
        experienceToAdd.exp_id = @"na";
        isEditExperience = false;
        _txt_hospitalName.text = @"";
        _txt_workedSince.text = @"";
        _txt_resignedSince.text = @"";
        _txt_description.text = @"";
        [[self popUpExperience] setAutoresizesSubviews:true];
        [[self popUpExperience] setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) ;
        frame.origin.y = 0.0f;
        self.popUpExperience.center = CGPointMake(self.view.center.x, self.view.center.y);
        [[self popUpExperience] setFrame:frame];
        [self.view addSubview:_popUpExperience];
        [CommonFunction addAnimationToview:_popUpExperience];
        
    }else if (btn.tag == 6){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
    
}



-(void)btnActionEdit:(UIButton *)btn{
    [CommonFunction resignFirstResponderOfAView:self.view];
    
    if (btn.tag/100 == 1) {
        educationToAdd = [Education new];
        isEditExperience = true;
        replacableIndex =(btn.tag%100);
        educationToAdd = [profileObj.educationArray objectAtIndex:(btn.tag%100)];
        _txt_UniversityName.text = educationToAdd.university_name;
        _txt_Universitydescription.text = educationToAdd.descriptionObj;
        [[self popUpEducation] setAutoresizesSubviews:true];
        [[self popUpEducation] setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) ;
        frame.origin.y = 0.0f;
        self.popUpEducation.center = CGPointMake(self.view.center.x, self.view.center.y);
        [[self popUpEducation] setFrame:frame];
        [self.view addSubview:_popUpEducation];
        [CommonFunction addAnimationToview:_popUpEducation];
    }else if (btn.tag/100 == 2){
         experienceToAdd = [ExperianceClass new];
        isEditExperience = true;
        replacableIndex =(btn.tag%100);
       experienceToAdd = [profileObj.experianceArray objectAtIndex:(btn.tag%100)];
        _txt_hospitalName.text = experienceToAdd.hospital_name;
        _txt_workedSince.text = experienceToAdd.worked_since;
        _txt_resignedSince.text = experienceToAdd.resigned_since;
        _txt_description.text = experienceToAdd.descriptionObj;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterLongStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        [dateFormatter setDateFormat:@"YYYY-MM-dd"];
        dateForJoin = [dateFormatter dateFromString:experienceToAdd.worked_since];
        dateForResignedSince = [dateFormatter dateFromString:experienceToAdd.resigned_since];
        [[self popUpExperience] setAutoresizesSubviews:true];
        [[self popUpExperience] setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) ;
        frame.origin.y = 0.0f;
        self.popUpExperience.center = CGPointMake(self.view.center.x, self.view.center.y);
        [[self popUpExperience] setFrame:frame];
        [self.view addSubview:_popUpExperience];
        [CommonFunction addAnimationToview:_popUpExperience];
    }else if(btn.tag ==3){
        
        if ([profileObj.about_me isEqualToString:@""]) {
            _txt_about.text = [Langauge getTextFromTheKey:@"About_Text"];
        }else{
            _txt_about.text = profileObj.about_me;
        }
        [[self popUpAbout] setAutoresizesSubviews:true];
        [[self popUpAbout] setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) ;
        frame.origin.y = 0.0f;
        self.popUpAbout.center = CGPointMake(self.view.center.x, self.view.center.y);
        [[self popUpExperience] setFrame:frame];
       
        [self.view addSubview:_popUpAbout];
        [CommonFunction addAnimationToview:_popUpAbout];
         [_popUpAbout reloadInputViews];
    }
    
}
-(void)btnActionDelete:(UIButton *)btn{
    if (btn.tag/100 == 1) {
        [profileObj.educationArray removeObjectAtIndex:(btn.tag%100)];
    }else if (btn.tag/100 == 2){
         [profileObj.experianceArray removeObjectAtIndex:(btn.tag%100)];
    }
    [_tblList reloadData];
}

- (IBAction)btnActionConfirmAdd_Education:(id)sender {
    
    NSDictionary *dictForValidation = [self validateDataForEducation];
    if (![[dictForValidation valueForKey:BoolValueKey] isEqualToString:@"0"]){
        [_popUpEducation removeFromSuperview];
        
        educationToAdd.university_name = [CommonFunction trimString:_txt_UniversityName.text];
        educationToAdd.descriptionObj = [CommonFunction trimString:_txt_Universitydescription.text];
        if (isEditExperience) {
            [profileObj.educationArray replaceObjectAtIndex:replacableIndex withObject:educationToAdd];
        }else{
            educationToAdd.edu_id = @"na";
            [profileObj.educationArray addObject:educationToAdd];
        }
        [_tblList reloadData];
        [self viewDidLayoutSubviews];
        isEditExperience = false;
        
    }
    else{
        [self addAlertWithTitle:[Langauge getTextFromTheKey:Warning_Key] andMessage:[dictForValidation valueForKey:AlertKey]   isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
        
    }
}


- (IBAction)btnAction_ConfirmAddExperiance:(id)sender {
    
    NSDictionary *dictForValidation = [self validateDataForExperience];
    
    if (![[dictForValidation valueForKey:BoolValueKey] isEqualToString:@"0"]){
        [_popUpExperience removeFromSuperview];
        
       
        experienceToAdd.hospital_name = [CommonFunction trimString:_txt_hospitalName.text];
        experienceToAdd.worked_since = [CommonFunction trimString:_txt_workedSince.text];
        experienceToAdd.resigned_since = [CommonFunction trimString:_txt_resignedSince.text];
        experienceToAdd.descriptionObj = [CommonFunction trimString:_txt_description.text];
        if (isEditExperience) {
            [profileObj.experianceArray replaceObjectAtIndex:replacableIndex withObject:experienceToAdd];
        }else{
             experienceToAdd.exp_id = @"na";
        [profileObj.experianceArray addObject:experienceToAdd];
        }
        
        [_tblList reloadData];
        [self viewDidLayoutSubviews];
        isEditExperience = false;
        
    }
    else{
        [self addAlertWithTitle:[Langauge getTextFromTheKey:Warning_Key] andMessage:[dictForValidation valueForKey:AlertKey]   isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
        
    }
}

- (IBAction)btnAction_Save:(id)sender {
    [CommonFunction resignFirstResponderOfAView:self.view];
    if (!isEdit) {
        isEdit = true;
         [_btn_Save setTitle:[Langauge getTextFromTheKey:@"save"] forState:UIControlStateNormal];
        [_tblList reloadData];
    }else{
        if ([[CommonFunction trimString:profileObj.name] isEqualToString:@""]) {
            [self addAlertWithTitle:[Langauge getTextFromTheKey:Warning_Key] andMessage:[Langauge getTextFromTheKey:@"name_required"]   isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
        }else{
            if (isImageCaptured) {
                [self hitApiForImage];
            }else{
                [self hitApiToUpload];
            }
        }
       
       
    }
    
}
- (IBAction)btnAction_Back:(id)sender {
    if (isEdit) {
         [self addAlertWithTitle:[Langauge getTextFromTheKey:Warning_Key] andMessage:[Langauge getTextFromTheKey:@"save_Message"] isTwoButtonNeeded:true firstbuttonTag:1003 secondButtonTag:1001 firstbuttonTitle:[Langauge getTextFromTheKey:@"yes"] secondButtonTitle:[Langauge getTextFromTheKey:@"no"] image:Warning_Key_For_Image];
    }else{
        [self.navigationController popViewControllerAnimated:true];
    }
}
#pragma mark - image Picker

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    capturedImage = chosenImage;
    isImageCaptured = true;
    [_tblList reloadData];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
#pragma mark - hit api


-(void)hitApiForImage{
    NSData *imageData = UIImagePNGRepresentation(capturedImage);
   
    NSMutableArray *imgArray = [NSMutableArray new];
    [imgArray addObject:imageData];
    if ([ CommonFunction reachability]) {
        [self addLoder];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_UploadDocument] postResponse:nil withImageData:nil isImageChanged:false requestType:POST requiredAuthorization:false ImageKey:@"photo" DataArray:imgArray completetion:^(BOOL status, id responseObj, NSString *tag, NSError *error, NSInteger statusCode) {
            if (error == nil) {
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"] == true){
                    profileObj.upload = [[responseObj valueForKey:@"urls"] valueForKey:@"photo"];
                     [self hitApiToUpload];
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
-(void)hitDoctorApi{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    
    
    if (_isLofinUser) {
    [dict setValue:[CommonFunction getValueFromDefaultWithKey:loginuserId] forKey:@"doctor_id"];
    }else{
         [dict setValue:_doctorObj.doctor_id forKey:@"doctor_id"];
    }
//    [dict setValue:@"26" forKey:@"doctor_id"];
    if ([ CommonFunction reachability]) {
        [self addLoder];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_Get_Doctor]  postResponse:[dict mutableCopy] postImage:nil requestType:POST tag:nil isRequiredAuthentication:NO header:NPHeaderName completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"] == true){
                    NSDictionary *dataDict = [NSDictionary new];
                    dataDict = [responseObj valueForKey:@"data"];
                    profileObj = [Profile new];
                    profileObj.about_me = [CommonFunction checkForNull:[dataDict valueForKey:@"about_me"]];
                    profileObj.home_location =  [CommonFunction checkForNull:[dataDict valueForKey:@"home_location"]];
                    profileObj.name =  [CommonFunction checkForNull:[dataDict valueForKey:@"name"]];
                    profileObj.upload =  [CommonFunction checkForNull:[dataDict valueForKey:@"upload"]];
                    NSArray *tempArray = [NSArray new];
                    NSMutableArray *tempArray2 = [NSMutableArray new];
                    tempArray =  [dataDict valueForKey:@"experience"];
                    [tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        ExperianceClass *expObj = [ExperianceClass new];
                        expObj.exp_id = [obj valueForKey:@"exp_id"];
                        expObj.descriptionObj = [CommonFunction checkForNull:[obj valueForKey:@"description"]];
                        expObj.hospital_name = [CommonFunction checkForNull:[obj valueForKey:@"hospital_name"]];
                        expObj.resigned_since = [CommonFunction checkForNull:[obj valueForKey:@"resigned_since"]];
                        expObj.worked_since = [CommonFunction checkForNull:[obj valueForKey:@"worked_since"]];
                        [tempArray2 addObject:expObj];
                    }];
                    if (tempArray.count == 0) {
                        profileObj.experianceArray = [NSMutableArray new];
                    }else{
                        profileObj.experianceArray = tempArray2;

                    }
                    tempArray =  [dataDict valueForKey:@"education"];
                    tempArray2 = [NSMutableArray new];
                    [tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        Education *eduObj = [Education new];
                        
                        eduObj.edu_id = [obj valueForKey:@"edu_id"];
                        eduObj.university_name = [CommonFunction checkForNull:[obj valueForKey:@"university_name"]];
                        eduObj.descriptionObj = [CommonFunction checkForNull:[obj valueForKey:@"description"]];
                        [tempArray2 addObject:eduObj];
                    }];
                    if (tempArray.count == 0) {
                        profileObj.educationArray = [NSMutableArray new];
                    }else{
                        profileObj.educationArray = tempArray2;

                    }
                    [_tblList reloadData];
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
                [self addAlertWithTitle:[Langauge getTextFromTheKey:Error_Key] andMessage:Sevrer_Issue_Message isTwoButtonNeeded:false firstbuttonTag:1001 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Error_Key_For_Image];
            }
            
            
        }];
    } else {
        [self addAlertWithTitle:[Langauge getTextFromTheKey:Error_Key] andMessage:Network_Issue_Message isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Error_Key_For_Image];
    }
    
    
}


-(void)hitApiToUpload{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:[CommonFunction getValueFromDefaultWithKey:loginuserId] forKey:@"doctor_id"];
        [dict setValue:profileObj.name forKey:@"fname"];
    [dict setValue:profileObj.about_me forKey:@"about_me"];
    
    NSArray *temp = [NSArray new];
    temp = profileObj.educationArray;
    NSMutableArray *tempMutable = [NSMutableArray new];
    [temp enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary *tempDict = [NSMutableDictionary new];
        Education *temp = (Education *)obj;
        [tempDict setValue:temp.edu_id  forKey:@"edu_id"];
         [tempDict setValue:temp.university_name forKey:@"university_name"];
         [tempDict setValue:temp.descriptionObj forKey:@"description"];
        [tempMutable addObject:tempDict];
    }];
    [dict setValue:[tempMutable mutableCopy] forKey:@"education"];
    temp = profileObj.experianceArray;
    [tempMutable removeAllObjects];
    [temp enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary *tempDict = [NSMutableDictionary new];
        ExperianceClass *temp = (ExperianceClass *)obj;
        [tempDict setValue:temp.exp_id forKey:@"exp_id"];
        [tempDict setValue:temp.hospital_name forKey:@"hospital_name"];
        [tempDict setValue:temp.worked_since forKey:@"joining_date"];
        [tempDict setValue:temp.resigned_since forKey:@"resigned_date"];
        [tempDict setValue:temp.descriptionObj forKey:@"description"];
        [tempMutable addObject:tempDict];
    }];
    [dict setValue:[tempMutable mutableCopy] forKey:@"experience"];
    [dict setValue:profileObj.home_location forKey:@"location"];
    [dict setValue:@" " forKey:@"lname"];

    [dict setValue:profileObj.upload forKey:@"url"];

   

    
    
    if ([ CommonFunction reachability]) {
        [self addLoder];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_Update_Doctor]  postResponse:[dict mutableCopy] postImage:nil requestType:POST tag:nil isRequiredAuthentication:NO header:NPHeaderName completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"] == true){
                    isEdit = false;
                    [_btn_Save setTitle:[Langauge getTextFromTheKey:@"Edit"] forState:UIControlStateNormal];
                    [CommonFunction storeValueInDefault:[CommonFunction trimString:profileObj.name] andKey:loginfirstname];
                    
                    [CommonFunction storeValueInDefault:[CommonFunction trimString:profileObj.upload] andKey:logInImageUrl];
                    [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:[responseObj valueForKey:@"message"] isTwoButtonNeeded:false firstbuttonTag:1002 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Alert_Key_For_Image];
                    [self removeloder];
                    [_tblList reloadData];
                }
                else
                {
                    [self addAlertWithTitle:[Langauge getTextFromTheKey:Error_Key] andMessage:[responseObj valueForKey:@"message"] isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Error_Key_For_Image];
                    [self removeloder];
                }
            }
            else {
                [self removeloder];
                [self addAlertWithTitle:[Langauge getTextFromTheKey:Error_Key] andMessage:Sevrer_Issue_Message isTwoButtonNeeded:false firstbuttonTag:1001 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Error_Key_For_Image];
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
        }break;
        case 1001:{
            [self.navigationController popViewControllerAnimated:true];
        }break;
        case 1002:{
               [self removeAlert];
            [self removeloder];
            [_btn_Save setTitle:[Langauge getTextFromTheKey:@"Edit"] forState:UIControlStateNormal];
            isEdit = false;
            [_tblList reloadData];
        }
            break;
        case 1003:{
            
            
            if (!isEdit) {
                isEdit = true;
                [_btn_Save setTitle:[Langauge getTextFromTheKey:@"save"] forState:UIControlStateNormal];
                [_tblList reloadData];
            }else{
                if ([[CommonFunction trimString:profileObj.name] isEqualToString:@""]) {
                    [self addAlertWithTitle:[Langauge getTextFromTheKey:Warning_Key] andMessage:[Langauge getTextFromTheKey:@"name_required"]   isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
                }else{
                    [self removeAlert];

                    if (isImageCaptured) {
                        [self hitApiForImage];
                    }else{
                        [self hitApiToUpload];
                    }
                }
                
                
            }
        }break;
        
        default:
            
            break;
    }
}

#pragma mark - Validation

-(NSDictionary *)validateDataForExperience{
    NSMutableDictionary *validationDict = [[NSMutableDictionary alloc] init];
    [validationDict setValue:@"1" forKey:BoolValueKey];
    if ([CommonFunction trimString:_txt_hospitalName.text].length == 0){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        //        if ([CommonFunction trimString:_txt_hospitalName.text].length == 0){
        [validationDict setValue:[Langauge getTextFromTheKey:@"hospital_name_required"] forKey:AlertKey];
        //        }else{
        //            [validationDict setValue:[Langauge getTextFromTheKey:@"hospital_name_required"] forKey:AlertKey];
        //        }
        
    }
    else if(_txt_workedSince.text.length == 0){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        [validationDict setValue:[Langauge getTextFromTheKey:@"working_since_required"] forKey:AlertKey];
    }
    else if(_txt_resignedSince.text.length == 0){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        [validationDict setValue:[Langauge getTextFromTheKey:@"resigned_since_required"] forKey:AlertKey];
    }else if(_txt_description.text.length == 0){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        [validationDict setValue:[Langauge getTextFromTheKey:@"description_required"] forKey:AlertKey];
    }
    return validationDict.mutableCopy;
    
}
-(NSDictionary *)validateDataForEducation{
    NSMutableDictionary *validationDict = [[NSMutableDictionary alloc] init];
    [validationDict setValue:@"1" forKey:BoolValueKey];
    if ([CommonFunction trimString:_txt_UniversityName.text].length == 0){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        [validationDict setValue:[Langauge getTextFromTheKey:@"University_required"] forKey:AlertKey];
    }
    else if(_txt_Universitydescription.text.length == 0){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        [validationDict setValue:[Langauge getTextFromTheKey:@"description_required"] forKey:AlertKey];
    }
    return validationDict.mutableCopy;
}

-(NSDictionary *)validateDataForAbout{
    NSMutableDictionary *validationDict = [[NSMutableDictionary alloc] init];
    [validationDict setValue:@"1" forKey:BoolValueKey];
    if ([CommonFunction trimString:_txt_about.text].length == 0){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        [validationDict setValue:[Langauge getTextFromTheKey:@"About_required"] forKey:AlertKey];
    }
    return validationDict.mutableCopy;
}

#pragma mark - other

-(void)resignResponder{
    [CommonFunction resignFirstResponderOfAView:self.view];
    if ([viewOverPicker isDescendantOfView:self.view]) {
        [viewOverPicker removeFromSuperview];
    }else if ([_popUpEducation isDescendantOfView:self.view]) {
        [_popUpEducation removeFromSuperview];
    }else if ([_popUpExperience isDescendantOfView:self.view]) {
        [_popUpExperience removeFromSuperview];
    }else if ([_popUpAbout isDescendantOfView:self.view]) {
        [_popUpAbout removeFromSuperview];
    }
}
@end
