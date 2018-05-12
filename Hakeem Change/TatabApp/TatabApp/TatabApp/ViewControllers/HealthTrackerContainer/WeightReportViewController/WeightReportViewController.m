//
//  WeightReportViewController.m
//  TatabApp
//
//  Created by Shagun Verma on 07/01/18.
//  Copyright © 2018 Shagun Verma. All rights reserved.
//

#import "WeightReportViewController.h"
#import <BEMSimpleLineGraph/BEMSimpleLineGraphView.h>

@interface WeightReportViewController ()<ChartViewDelegate,UIPickerViewDelegate>
{
    LoderView *loderObj;
    NSMutableArray *dataArray;
    UIView *viewOverPicker;
    NSString *fromDateString;
    
    NSString *toDateString;
    
    UIPickerView *pickerObj;
    UIDatePicker* pickerForDate;
    NSDate *toDate;
    NSDate *fromDate;
    UIToolbar *toolBar;
     NSInteger selectedRowForType;
    NSInteger selectedRowForWeight;
    NSInteger selectedRowForheight;
    NSInteger selectedRowForHeartRate;
    CustomAlert *alertObj;
}
@end

@implementation WeightReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    dataArray = [NSMutableArray new];
   
    alertObj = [[CustomAlert alloc] initWithFrame:self.view.frame];

    selectedRowForType = 0;
    selectedRowForWeight = 0;
    selectedRowForheight = 0;
    selectedRowForHeartRate = 0;
    [_btnWeight setTitle:[NSString stringWithFormat:@"%d",1] forState:UIControlStateNormal];
    [_btnHeartRate setTitle:[NSString stringWithFormat:@"%d",40] forState:UIControlStateNormal];
    [_btnHeight setTitle:[NSString stringWithFormat:@"%d",30] forState:UIControlStateNormal];
//    _txt_Comment.text = @"comment";
   
    [self setDate];
    
    float bmi = (float)(selectedRowForWeight+20) / (float)(((float)(selectedRowForheight+30)/(float)100)*((float)(selectedRowForheight+30)/(float)100));
    NSLog(@"%f", bmi);
    
    

    // Enable and disable various graph properties and axis displays
    
    self.title = @"Multiple Lines Chart";
    
    _graphView.delegate = self;
    _graphView.userInteractionEnabled  = false;
    _graphView.chartDescription.enabled = NO;
    _graphView.leftAxis.enabled = YES;
    _graphView.rightAxis.enabled = NO;
    
    
    
    _graphView.rightAxis.drawAxisLineEnabled = false;
    _graphView.rightAxis.drawGridLinesEnabled = false;
    
    _graphView.xAxis.drawAxisLineEnabled = false;
    _graphView.xAxis.drawGridLinesEnabled = false;
    
    _graphView.xAxis.labelTextColor = [UIColor clearColor];
    _graphView.drawGridBackgroundEnabled = NO;
    _graphView.drawBordersEnabled = NO;
    _graphView.dragEnabled = NO;
    [_graphView setScaleEnabled:NO];
    _graphView.pinchZoomEnabled = NO;
    _graphView.legend.enabled = NO;
    
    //    ChartLegend *l = _graphView.legend;
    //    l.horizontalAlignment = ChartLegendHorizontalAlignmentRight;
    //    l.verticalAlignment = ChartLegendVerticalAlignmentTop;
    //    l.orientation = ChartLegendOrientationVertical;
    //    l.drawInside = NO;
    
    [self slidersValueChanged:nil];
    if (![[CommonFunction getValueFromDefaultWithKey:loginuserType] isEqualToString:@"Patient"]) {
        _btnAdd.hidden = true;
    }

    
   
        [_lblPatientName setText:[_dependant.name capitalizedString]];
        [_lblgender setText:_dependant.gender];
        [_lblbirthDate setText:[CommonFunction ConvertDateTime2:_dependant.birthDay]];
   
    [self setLanguageData];
    [self setData];
    // Do any additional setup after loading the view from its nib.
}

-(void)setData{
     if (![[CommonFunction getValueFromDefaultWithKey:Selected_Patient_Weight] isEqualToString:@"-"]) {
    _lbl_WeightValue.text = [NSString stringWithFormat:@"%@ %@",[CommonFunction getValueFromDefaultWithKey:Selected_Patient_Weight],[Langauge getTextFromTheKey:@"Kg"]];
    _lbl_HeightValue.text = [NSString stringWithFormat:@"%@ %@",[CommonFunction getValueFromDefaultWithKey:Selected_Patient_Height],[Langauge getTextFromTheKey:@"Cm"]];
     }
}
-(void)setDate{
    fromDate = [NSDate date];
    toDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    //self.myLabel.text = [dateFormatter stringFromDate:[dueDatePickerView date]];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    fromDateString = [CommonFunction setOneMonthOldGate];
    [_btnFromDate setTitle:fromDateString forState:UIControlStateNormal];
    toDateString = [dateFormatter stringFromDate:toDate];
    [_btnToDate setTitle:toDateString forState:UIControlStateNormal];
}

-(void)setLanguageData{
    _lbl_No_Data.text = [Langauge getTextFromTheKey:@"no_data"];
    [_btn_EMR setTitle:[Langauge getTextFromTheKey:@"emr"] forState:UIControlStateNormal];
    [_btn_Health setTitle:[Langauge getTextFromTheKey:@"health_tracker"] forState:UIControlStateNormal];
    [_btnToDate setTitle:[Langauge getTextFromTheKey:@"to"] forState:UIControlStateNormal];
    [_btnFromDate setTitle:[Langauge getTextFromTheKey:@"from"] forState:UIControlStateNormal];
    [_btn_Refresh setTitle:[Langauge getTextFromTheKey:@"refresh_graph"] forState:UIControlStateNormal];

    
    _lbl_title.text = [Langauge getTextFromTheKey:@"emr"];
    _lbl_WeightReport.text = [Langauge getTextFromTheKey:@"weight_report"];
    _lbl_patient.text = [Langauge getTextFromTheKey:@"patient"];
    _lbl_GenderTitle.text = [Langauge getTextFromTheKey:@"gender"];
    _lbl_Height_Title.text = [Langauge getTextFromTheKey:@"height"];
    _lbl_BirthDate.text = [Langauge getTextFromTheKey:@"birthdate"];
    _lbl_WeightTitle.text = [Langauge getTextFromTheKey:@"weight"];
    _lbl_Weight_Title2.text = [Langauge getTextFromTheKey:@"weight"];
    _lbl_Chronic.text = [Langauge getTextFromTheKey:@"chornic"];
    _lbl_HR_Title.text = [Langauge getTextFromTheKey:@"hr"];
    
   _lbl_TodaysWHR.text = [Langauge getTextFromTheKey:@"today_weight"];
   _lbl_Bmi18.text = [Langauge getTextFromTheKey:@"under_weight"];
   _lbl_NormalWeight.text = [Langauge getTextFromTheKey:@"normal_weight"];
   _lbl_overWeight.text = [Langauge getTextFromTheKey:@"over_weight"];
   _lbl_obesityBMI.text = [Langauge getTextFromTheKey:@"obesity"];
   _lbl_weightinKG.text = [Langauge getTextFromTheKey:@"weight_in_kg"];
   _lbl_RestHr.text = [Langauge getTextFromTheKey:@"rest_hr"];
   _lbl_HeightInCm.text = [Langauge getTextFromTheKey:@"height_in_cm"];
    [_btn_Submit setTitle:[Langauge getTextFromTheKey:@"submit"] forState:UIControlStateNormal];
    [_btn_Cancel setTitle:[Langauge getTextFromTheKey:@"cancel"] forState:UIControlStateNormal];
    [_txt_Comment setPlaceholderWithColor:[Langauge getTextFromTheKey:@"comment"]];

}
-(void)viewDidLayoutSubviews{
    loderObj.frame = self.view.frame;
    alertObj.frame = self.view.frame;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [self getWeight];
}


#pragma mark - btn Actions
- (IBAction)btnAction_instructions:(id)sender {
    
    [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:@"For more instructions about using TatabApp tracker please visit www.tatabapp.com" isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Alert_Key_For_Image];
}

- (IBAction)btnHealthTrackerClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:false];
}
- (IBAction)btnActionEnterData:(id)sender {
    switch (((UIButton *)sender).tag) {
        case 0:
            selectedRowForType = selectedRowForWeight;
             [self showPicker:0];
            break;
        case 1:
            selectedRowForType = selectedRowForHeartRate;
             [self showPicker:1];
            break;
        case 2:
            selectedRowForType = selectedRowForheight;
             [self showPicker:2];
            break;
            
        default:
            break;
    }
   
}


- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController dismissViewControllerAnimated:false completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PopBackNow" object:nil];
    }];}

- (IBAction)btnEMRClcked:(id)sender {
    
    [self dismissViewControllerAnimated:false completion:nil];
    
}

-(void)resignResponder{
    
}

- (IBAction)btnAddPressureClicked:(id)sender {
    
    [[self popUpView] setAutoresizesSubviews:true];
    [[self popUpView] setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) ;
    frame.origin.y = 0.0f;
    self.popUpView.center = CGPointMake(self.view.center.x, self.view.center.y);
    [[self popUpView] setFrame:frame];
    [self.view addSubview:_popUpView];
    [CommonFunction addAnimationToview:_popUpView];
    
}
- (IBAction)btnSelectYearClicked:(id)sender {
    [self getWeight];
    
}

- (IBAction)btnBackPopUp:(id)sender {
    [_popUpView removeFromSuperview];
}

- (IBAction)btnSubmitFeverreport:(id)sender {
    [self uploadWeight] ;
}


- (IBAction)btnSelectFromDateClicked:(id)sender {
    
    [CommonFunction resignFirstResponderOfAView:self.view];
    pickerForDate = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 150, self.view.frame.size.width, 150)];
    pickerForDate.datePickerMode = UIDatePickerModeDate;
    pickerForDate.tag = 0;
    
    [pickerForDate setDate:fromDate];
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
- (IBAction)btnSelectToDateClciked:(id)sender {
    
    [CommonFunction resignFirstResponderOfAView:self.view];
    pickerForDate = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 150, self.view.frame.size.width, 150)];
    pickerForDate.datePickerMode = UIDatePickerModeDate;
    pickerForDate.tag = 1;
    
    [pickerForDate setDate:toDate];
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

-(void)doneForPicker:(id)sender{
    [self updateChartData];

    [viewOverPicker removeFromSuperview];
    [self.popUpView layoutIfNeeded];
    [self.imgPointer layoutIfNeeded];
    [self.view layoutIfNeeded];
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
        fromDateString = [dateFormatter stringFromDate:[sender date]];
        fromDate = sender.date;
        [_btnFromDate setTitle:fromDateString forState:UIControlStateNormal];
    }else if (sender.tag == 1){
        toDateString = [dateFormatter stringFromDate:[sender date]];
        toDate = sender.date;
        [_btnToDate setTitle:toDateString forState:UIControlStateNormal];
    }
    
}






-(void)uploadWeight{
    NSMutableDictionary *parameterDict = [[NSMutableDictionary alloc]init];

    if (!_isdependant){
        [parameterDict setValue:_patient.patient_id forKey:PATIENT_ID];
        [parameterDict setValue:@"na" forKey:DEPENDANT_ID];
  }
    else
    {
        [parameterDict setValue:_patient.patient_id forKey:PATIENT_ID];
        [parameterDict setValue:_dependant.depedant_id forKey:DEPENDANT_ID];
    }
    
    [parameterDict setValue:_btnWeight.titleLabel.text forKey:@"weight"];
    
    [parameterDict setValue:_btnHeartRate.titleLabel.text forKey:@"rest_hr"];
    [parameterDict setValue:_btnHeight.titleLabel.text forKey:@"height"];
    
    if ([_txt_Comment.text  isEqual: @""]){
        [parameterDict setValue:@"comment" forKey:@"comment"];

    }
    else
    {
        [parameterDict setValue:_txt_Comment.text forKey:@"comment"];

    }
    NSDateFormatter *Formatter = [[NSDateFormatter alloc] init];
    Formatter.dateFormat = @"yyyy-MM-dd";
    NSString *stringFor = [Formatter stringFromDate:[NSDate date]];
    [parameterDict setValue:stringFor forKey:@"date"];
    
    if ([ CommonFunction reachability]) {
        [self addLoder];
        
        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_UPLOAD_WEIGHT]  postResponse:[parameterDict mutableCopy] postImage:nil requestType:POST tag:nil isRequiredAuthentication:YES header:NPHeaderName completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"] == true){
                    /*UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:[responseObj valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:ok];
                    [self presentViewController:alertController animated:YES completion:nil];
                   */
                    
                    [CommonFunction storeValueInDefault:_btnHeight.titleLabel.text andKey:Selected_Patient_Height];
                     [CommonFunction storeValueInDefault:_btnWeight.titleLabel.text andKey:Selected_Patient_Weight];
                    [self setData];
                    [self removeloder];
                    [_popUpView removeFromSuperview];
                    [self getWeight];
                     [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:[responseObj valueForKey:@"message"]  isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Alert_Key_For_Image];

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

-(void)getWeight{
    NSMutableDictionary *parameterDict = [[NSMutableDictionary alloc]init];
    
    
    if (!_isdependant){
        [parameterDict setValue:_patient.patient_id forKey:PATIENT_ID];
        [parameterDict setValue:@"na" forKey:DEPENDANT_ID];

    }
    else
    {
        [parameterDict setValue:_patient.patient_id forKey:PATIENT_ID];
        [parameterDict setValue:_dependant.depedant_id forKey:DEPENDANT_ID];
    }
    
    
    [parameterDict setValue:fromDateString forKey:@"from"];
    [parameterDict setValue:toDateString forKey:@"to"];
    
    if ([ CommonFunction reachability]) {
        [self addLoder];
        
        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_GET_WEIGHT]  postResponse:[parameterDict mutableCopy] postImage:nil requestType:POST tag:nil isRequiredAuthentication:YES header:NPHeaderName completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                dataArray = [NSMutableArray new];

                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"] == true){
                    NSArray *tempArray = [responseObj valueForKey:@"data"];
                   
                    [tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        Report *bloodObj = [Report new];
                        bloodObj.doctor_id = [obj valueForKey:@"doctor_id"];
                        bloodObj.weight = [obj valueForKey:@"weight"];
                        bloodObj.rest_hr = [obj valueForKey:@"rest_hr"];
                        bloodObj.height = [obj valueForKey:@"height"];
                        bloodObj.comment = [obj valueForKey:@"comment"];
                        bloodObj.date = [obj valueForKey:@"date"];
                        [dataArray addObject:bloodObj];
                    }];
                    [self removeloder];
                    [self updateChartData];
                    if (tempArray.count == 0) {
                        _graphView.hidden = true;
                        _lbl_NoDataa.hidden = false;
                    }else{
                        _graphView.hidden = false;
                        _lbl_NoDataa.hidden = true;
//                        [CommonFunction addBottomLineIngraph:_graphView];
                    }
                    
                }else{
                    [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:[responseObj valueForKey:@"message"] isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
                    [self removeloder];
                    [self removeloder];
                }
            }else {
                [self removeloder];
                [self addAlertWithTitle:[Langauge getTextFromTheKey:Error_Key] andMessage:Sevrer_Issue_Message isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Error_Key_For_Image];
            }
            [self updateChartData];
        }];
    } else {
        [self addAlertWithTitle:[Langauge getTextFromTheKey:Error_Key] andMessage:Network_Issue_Message isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Error_Key_For_Image];
    }
}


#pragma mark - add loder

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

#pragma mark - picker data Source
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component{
    if (pickerObj.tag == 0){
        return 210;
    }
    else if (pickerObj.tag == 1){
        //Weight
        return 201;
    }
    else if (pickerObj.tag == 2){
        //reading
        return 207;
    }
    return 0;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:
(NSInteger)row forComponent:(NSInteger)component{
    
    if (pickerObj.tag == 0){
       
        return [NSString stringWithFormat:@"%d",row+1];
    }
    else if (pickerObj.tag == 1){
        //Weight
        return [NSString stringWithFormat:@"%d",row+40];
    }
    else if (pickerObj.tag == 2){
        if (row == 0){
            return [NSString stringWithFormat:@"%d",30];
        }
        return [NSString stringWithFormat:@"%d",30+row];
    }
    return @"";
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component{
    if (pickerObj.tag == 0){
        [_btnWeight setTitle:[NSString stringWithFormat:@"%d",row+1] forState:UIControlStateNormal];
        selectedRowForWeight = row;
    }
    else if (pickerObj.tag == 1){
        //Weight
        [_btnHeartRate setTitle:[NSString stringWithFormat:@"%d",40+row] forState:UIControlStateNormal];
        selectedRowForHeartRate = row;
        
    }
    else if (pickerObj.tag == 2){
        //reading
        [_btnHeight setTitle:[NSString stringWithFormat:@"%d",30+row] forState:UIControlStateNormal];
        selectedRowForheight = row;
        
    }
    


    
    float bmi = (float)(selectedRowForWeight+20) / (float)(((float)(selectedRowForheight+30)/(float)100)*((float)(selectedRowForheight+30)/(float)100));
    NSLog(@"%f", bmi);
    

    
    if (bmi<18.5){
        _imgPointer.center = CGPointMake(_lbl_Bmi18.center.x, _imgPointer.center.y);

    }
    else if (bmi>=18.5 && bmi<25)
    {
        _imgPointer.center = CGPointMake(_lbl_NormalWeight.center.x, _imgPointer.center.y);


    }
    else if (bmi>=25 && bmi<30)
    {
        _imgPointer.center = CGPointMake(_lbl_overWeight.center.x, _imgPointer.center.y);

    }
    else if (bmi>30)
    {
        _imgPointer.center = CGPointMake(_lbl_obesityBMI.center.x, _imgPointer.center.y);

    }
    [self.imgPointer layoutIfNeeded];
}

-(void)showPicker:(int)tag{
    pickerObj = [[UIPickerView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 150, self.view.frame.size.width, 150)];
    pickerObj.delegate = self;
    pickerObj.dataSource = self;
    pickerObj.showsSelectionIndicator = YES;
    pickerObj.backgroundColor = [UIColor lightGrayColor];
    viewOverPicker = [[UIView alloc]initWithFrame:self.view.frame];
    pickerObj.tag = tag;
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
    [pickerObj  selectRow:selectedRowForType inComponent:0 animated:true];
    
    
    [viewOverPicker addSubview:pickerObj];
    [self.view addSubview:viewOverPicker];
    [pickerObj reloadAllComponents];
    
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
            [_popUpView removeFromSuperview];
            [self removeAlert];
        }
            break;
        default:
            
            break;
    }
}



#pragma mark MultipleLinesChartViewController

- (IBAction)slidersValueChanged:(id)sender
{
    
    [self updateChartData];
}

#pragma mark - ChartViewDelegate
- (void)updateChartData
{
    NSArray *colors = @[ChartColorTemplates.vordiplom[0], ChartColorTemplates.vordiplom[1], ChartColorTemplates.vordiplom[2]];
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    NSMutableArray *valuesHR = [[NSMutableArray alloc] init];
    
    
    
    
        float val = 0.0;
        [valuesHR addObject:[[ChartDataEntry alloc] initWithX:0 y:val]];
    
  
        for (int i = 0; i < dataArray.count; i++)
        {
            float val = [[[dataArray objectAtIndex:i] valueForKey:@"rest_hr"] floatValue];
            [valuesHR addObject:[[ChartDataEntry alloc] initWithX:i+1 y:val]];
        }
    
    if (valuesHR.count == 1 )  {
        _lbl_NoDataa.hidden = false;
        _graphView.hidden = true;
    }else{
        _lbl_NoDataa.hidden = true;
        _graphView.hidden = false;
    }
    
   
    
    LineChartDataSet *d = [[LineChartDataSet alloc] initWithValues:valuesHR label:@"HR"];
    d.lineWidth = 3;
    d.circleRadius = 3.0;
    d.circleHoleRadius = 0.0;
    
    UIColor *color = [UIColor redColor];
    [d setColor:color];
    
    d.mode = LineChartModeCubicBezier;
    d.drawValuesEnabled =  false;
    [d setCircleColor:color];
    [dataSets addObject:d];
    
    
    
        NSMutableArray *valuesSYS = [[NSMutableArray alloc] init];
        [valuesSYS addObject:[[ChartDataEntry alloc] initWithX:0 y:val]];
    

        for (int i = 0; i < dataArray.count; i++)
        {
            float val = [[[dataArray objectAtIndex:i] valueForKey:@"weight"] floatValue];
            [valuesSYS addObject:[[ChartDataEntry alloc] initWithX:i+1 y:val]];
        }

    
   
    
    LineChartDataSet *dSYS = [[LineChartDataSet alloc] initWithValues:valuesSYS label:@"weight"];
    dSYS.lineWidth = 3;
    dSYS.circleRadius = 3.0;
    dSYS.circleHoleRadius = 0.0;
    
    
    color = [UIColor redColor];
    [dSYS setColor:color];
    
    dSYS.mode = LineChartModeCubicBezier;
    dSYS.drawValuesEnabled =  false;
    [dSYS setCircleColor:color];
    [dataSets addObject:dSYS];
    
    
    ((LineChartDataSet *)dataSets[0]).colors = [NSArray arrayWithObject:[CommonFunction getColorFor:@"HR"]];
    ((LineChartDataSet *)dataSets[0]).circleColors = [NSArray arrayWithObject:[CommonFunction getColorFor:@"HR"]];
    //    ((LineChartDataSet *)dataSets[0]).circleColors = ChartColorTemplates.vordiplom;
    ((LineChartDataSet *)dataSets[1]).colors = [NSArray arrayWithObject:[CommonFunction getColorFor:@"SYS"]];
    ((LineChartDataSet *)dataSets[1]).circleColors = [NSArray arrayWithObject:[CommonFunction getColorFor:@"SYS"]];
    //    ((LineChartDataSet *)dataSets[0]).circleColors = ChartColorTemplates.vordiplom;
    
    LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:7.f]];
    _graphView.data = data;
}


- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight
{
    NSLog(@"chartValueSelected");
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    NSLog(@"chartValueNothingSelected");
}



@end
