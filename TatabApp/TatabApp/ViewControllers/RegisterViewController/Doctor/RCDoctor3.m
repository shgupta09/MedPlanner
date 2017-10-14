//
//  RCDoctor3.m
//  TatabApp
//
//  Created by NetprophetsMAC on 10/9/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//

#import "RCDoctor3.h"
#import "RCDoctor4.h"
@interface RCDoctor3 ()
{
    NSMutableArray *dependencyArray;
    UIDatePicker* pickerForDate;
    NSDate *departDate;
    NSString *departDateString;
    UIView *viewOverPicker;
    UIToolbar *toolBar;
}

@end

@implementation RCDoctor3

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)setData{
    
        _txt_resignedSince.leftImgView.image = [UIImage imageNamed:@"icon-calendar"];
        _txt_subSpeciality.leftImgView.image = [UIImage imageNamed:@"b"];
        _txtClassification.leftImgView.image = [UIImage imageNamed:@"b"];
        _txt_hospitalName.leftImgView.image = [UIImage imageNamed:@"b"];
        _txt_workedSince.leftImgView.image = [UIImage imageNamed:@"icon-calendar"];
        
    _txt_Sepciality.text = @"adfaf";
    _txt_currentGrade.text = @"adfaf";
    _txtClassification.text = @"adfaf";
    _txt_subSpeciality.text = @"adfaf";
    _txt_hospitalName.text = @"adfaf";
    [CommonFunction setResignTapGestureToView:_popUpView andsender:self];
    [_tblView registerNib:[UINib nibWithNibName:@"DependantDetailTableViewCell" bundle:nil]forCellReuseIdentifier:@"DependantDetailTableViewCell"];
    _tblView.rowHeight = UITableViewAutomaticDimension;
    _tblView.estimatedRowHeight = 35;
    _tblView.backgroundColor = [UIColor clearColor];
    dependencyArray = [NSMutableArray new];
    departDate = [NSDate date];
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
#pragma mark- tableView delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (dependencyArray.count>0) {
        _tblView.hidden = false;
        _tbl_Height.constant = (dependencyArray.count+1)*35;
        return dependencyArray.count+1;
    }
    _tblView.hidden = true;
    _tbl_Height.constant = 0;
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
        [cell.lblName setText:@"WORKPLACE"];
        [cell.lblGender setText:@"SINCE"];
        [cell.lblBirthday setText:@"To"];
        
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
        }        [cell.lblName setText:obj.Hospitalname];
        [cell.lblGender setText:obj.workedSince];
        [cell.lblBirthday setText:obj.resignedSince];
    }
    
    
    return cell;
}

#pragma mark- btn actions
- (IBAction)btnBackClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
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
        
        _txt_workedSince.text = departDateString;
    }else if (sender.tag == 1){
        _txt_resignedSince.text = departDateString;
    }
    
}

-(void)doneForPicker:(id)sender{
    [viewOverPicker removeFromSuperview];
    
}

- (IBAction)btnAction_AddExperience:(id)sender {
    
    _txt_hospitalName.text = @"";
    _txt_workedSince.text = @"";
    _txt_resignedSince.text = @"";
    [[self popUpView] setAutoresizesSubviews:true];
    [[self popUpView] setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) ;
    frame.origin.y = 0.0f;
    self.popUpView.center = CGPointMake(self.view.center.x, self.view.center.y);
    [[self popUpView] setFrame:frame];
    [self.view addSubview:_popUpView];
    
}


- (IBAction)btnAction_Continue:(id)sender {
   
    NSDictionary *dictForValidation = [self validateData2];
    if (![[dictForValidation valueForKey:BoolValueKey] isEqualToString:@"0"]){
        [_parameterDict setValue:[CommonFunction trimString:_txt_Sepciality.text] forKey:Specialist];
        [_parameterDict setValue:[CommonFunction trimString:_txt_currentGrade.text] forKey:currentGrade];
        [_parameterDict setValue:[CommonFunction trimString:_txt_subSpeciality.text] forKey:SubSpecialist];
        [_parameterDict setValue:[CommonFunction trimString:_txtClassification.text] forKey:classification];
        
        
        
        NSMutableDictionary *tempDict = [NSMutableDictionary new];
        NSMutableArray *tempArray = [NSMutableArray new];
        for (int i= 0;i<dependencyArray.count ; i++) {
            [tempDict removeAllObjects];
            
            RegistrationDpendency *obj = [dependencyArray objectAtIndex:i];
            [tempDict setValue:obj.Hospitalname forKey:HospitalName];
            [tempDict setValue:obj.workedSince forKey:WorkedSince];
            [tempDict setValue:obj.resignedSince forKey:ResignedSince];
            [tempArray addObject:tempDict];
        }
        
            [_parameterDict setValue:tempArray forKey:Experience];
        
       
        RCDoctor4* vc ;
        vc = [[RCDoctor4 alloc] initWithNibName:@"RCDoctor4" bundle:nil];
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
- (IBAction)btnAction_ConfirmAdd:(id)sender {
    
    NSDictionary *dictForValidation = [self validateData];
    
    if (![[dictForValidation valueForKey:BoolValueKey] isEqualToString:@"0"]){
        [_popUpView removeFromSuperview];
        
        RegistrationDpendency *dependencyObj = [RegistrationDpendency new];
        dependencyObj.Hospitalname = [CommonFunction trimString:_txt_hospitalName.text];
        dependencyObj.workedSince = [CommonFunction trimString:_txt_workedSince.text];
        dependencyObj.resignedSince = [CommonFunction trimString:_txt_resignedSince.text];
        [dependencyArray addObject:dependencyObj];
        [_tblView reloadData];
        [self viewDidLayoutSubviews];
        
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
    if (![CommonFunction validateName:_txt_hospitalName.text]){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        if ([CommonFunction trimString:_txt_hospitalName.text].length == 0){
            [validationDict setValue:@"We need a Hospital Name" forKey:AlertKey];
        }else{
            [validationDict setValue:@"Oops! It seems that this is not a valid First Name." forKey:AlertKey];
        }
        
    }
    else if(_txt_workedSince.text.length == 0){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        [validationDict setValue:@"We need a date from which you started working" forKey:AlertKey];
    }
    return validationDict.mutableCopy;
    
}
-(void)resignResponder{
    [CommonFunction resignFirstResponderOfAView:self.view];
    if ([viewOverPicker isDescendantOfView:self.view]) {
        [viewOverPicker removeFromSuperview];
    }else if ([_popUpView isDescendantOfView:self.view]) {
        [_popUpView removeFromSuperview];
    }
}

#pragma mark - other Methods

-(NSDictionary *)validateData2{
    NSMutableDictionary *validationDict = [[NSMutableDictionary alloc] init];
    [validationDict setValue:@"1" forKey:BoolValueKey];
    if (![CommonFunction validateName:_txt_Sepciality.text]){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        if ([CommonFunction trimString:_txt_Sepciality.text].length == 0){
            [validationDict setValue:@"We need a Speciality" forKey:AlertKey];
        }else{
            [validationDict setValue:@"Oops! It seems that this is not a valid Speciality." forKey:AlertKey];
        }
        
    }  else  if (![CommonFunction validateName:_txt_currentGrade.text]){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        if ([CommonFunction trimString:_txt_currentGrade.text].length == 0){
            [validationDict setValue:@"We need a Current Grade" forKey:AlertKey];
        }else{
            [validationDict setValue:@"Oops! It seems that this is not a valid Current Grade." forKey:AlertKey];
        }
        
    }
    else  if (![CommonFunction validateName:_txt_subSpeciality.text]){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        if ([CommonFunction trimString:_txt_subSpeciality.text].length == 0){
            [validationDict setValue:@"We need a Sub-speciality" forKey:AlertKey];
        }else{
            [validationDict setValue:@"Oops! It seems that this is not a valid Sub-speciality." forKey:AlertKey];
        }
        
    }
    else  if (![CommonFunction validateName:_txtClassification.text]){
        [validationDict setValue:@"0" forKey:BoolValueKey];
        if ([CommonFunction trimString:_txtClassification.text].length == 0){
            [validationDict setValue:@"We need a Classification" forKey:AlertKey];
        }else{
            [validationDict setValue:@"Oops! It seems that this is not a valid Classification." forKey:AlertKey];
        }
        
    } else  if (dependencyArray.count<1){
        [validationDict setValue:@"0" forKey:BoolValueKey];
            [validationDict setValue:@"We need a Experience" forKey:AlertKey];
       
        
    }
    return validationDict.mutableCopy;
    
}


@end
