//
//  PressureReportViewController.m
//  TatabApp
//
//  Created by Shagun Verma on 07/01/18.
//  Copyright © 2018 Shagun Verma. All rights reserved.
//

#import "PressureReportViewController.h"
#import <BEMSimpleLineGraph/BEMSimpleLineGraphView.h>

@interface PressureReportViewController ()<BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate,UIPickerViewDelegate>
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
    NSInteger heartRate;
    NSInteger hertRateValue;

    NSMutableArray* arrayType;
    CustomAlert *alertObj;
    NSMutableArray* arrayToShowOnGraph;

}
@end

@implementation PressureReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    toDate = [NSDate date];
//    _txtComments.text = @"comment";
    heartRate = 40;
    alertObj = [[CustomAlert alloc] initWithFrame:self.view.frame];

    
    fromDate = [NSDate date];
    
    CGAffineTransform trans = CGAffineTransformMakeRotation(-M_PI * 0.5);
    _sliderView.transform = trans;
    _lblDIAValue.text = [NSString stringWithFormat:@"%.f",roundf(_sliderView.value)];
    _lblSYSValue.text = [NSString stringWithFormat:@"%.f",roundf(_sliderView.value+60)];
    [_sliderView addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    _sliderView.maximumValue = 120.0;
    _sliderView.minimumValue = 65.0;
    [_btnHeartRate setTitle:@"40" forState:UIControlStateNormal];
    hertRateValue = 40;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    //self.myLabel.text = [dateFormatter stringFromDate:[dueDatePickerView date]];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    fromDateString = [CommonFunction setOneMonthOldGate];
    [_btnFromDate setTitle:fromDateString forState:UIControlStateNormal];
    toDateString = [dateFormatter stringFromDate:toDate];
    [_btnToDate setTitle:toDateString forState:UIControlStateNormal];
    
    arrayToShowOnGraph = [[NSMutableArray alloc] init];

    arrayType = [[NSMutableArray alloc] initWithObjects:@"HR",@"DIA",@"SYS", nil];
    selectedRowForType = 0;
    
    
    // Enable and disable various graph properties and axis displays
    
    
    self.title = @"Multiple Lines Chart";
    
    _graphView.delegate = self;
    
    _graphView.chartDescription.enabled = NO;
    _graphView.leftAxis.enabled = YES;
    _graphView.rightAxis.enabled = NO;
    _graphView.rightAxis.drawAxisLineEnabled = NO;
    _graphView.rightAxis.drawGridLinesEnabled = NO;
    _graphView.xAxis.drawAxisLineEnabled = NO;
    _graphView.xAxis.drawGridLinesEnabled = NO;
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

    
    UIImage * white = [[UIImage imageNamed:@"blood-pressure-slider"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [_sliderView setMinimumTrackImage:[white stretchableImageWithLeftCapWidth:3.0 topCapHeight:0.0] forState:UIControlStateNormal];
    
    [_sliderView setMaximumTrackImage:[white stretchableImageWithLeftCapWidth:3.0 topCapHeight:0.0] forState:UIControlStateNormal];
    
    [_sliderView setThumbImage:[UIImage imageNamed:@"slider_small"] forState:UIControlStateNormal];
    
    [_sliderView trackRectForBounds:_sliderView.bounds];

    if (![[CommonFunction getValueFromDefaultWithKey:loginuserType] isEqualToString:@"Patient"]) {
        _btnAdd.hidden = true;
    }

    if (_isdependant) {
        [_lblPatientName setText:[_dependant.name capitalizedString]];
        [_lblgender setText:_dependant.gender];
        [_lblbirthDate setText:[CommonFunction ConvertDateTime2:_dependant.birthDay]];
    }else{
        [_lblPatientName setText:[_patient.name capitalizedString]];
        [_lblgender setText:_patient.gender];
        [_lblbirthDate setText:[CommonFunction ConvertDateTime2:_patient.dob]];
        
    }
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidLayoutSubviews{
    loderObj.frame = self.view.frame;
    alertObj.frame = self.view.frame;
}
-(void)viewDidAppear:(BOOL)animated{
    [self getBloodPressure];
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
    NSLog(@"slider value = %f", sender.value);
    _lblDIAValue.text = [NSString stringWithFormat:@"%.f",roundf(_sliderView.value)];
    _lblSYSValue.text = [NSString stringWithFormat:@"%.f",roundf(_sliderView.value+60)];
    
    if (_sliderView.value>=120 ) {
        _cons_imageviewDIA.constant = -140;
    }
    else if (_sliderView.value>=90 && _sliderView.value<=120) {
        _cons_imageviewDIA.constant = -70;
        
    }
    else if (_sliderView.value>=80 && _sliderView.value<=89) {
        _cons_imageviewDIA.constant = 0;
        
    }
    else if (_sliderView.value>=70 && _sliderView.value<=79) {
        _cons_imageviewDIA.constant = 70;
        
    }
    else if (_sliderView.value<=70) {
        _cons_imageviewDIA.constant = 140;
        
    }
  
    
    if (_sliderView.value+60>=170 ) {
        _cons_imgViewSYS.constant = -140;
    }
    else if (_sliderView.value+60>=140 && _sliderView.value+60<=169) {
        _cons_imgViewSYS.constant = -70;
        
    }
    else if (_sliderView.value+60>=130 && _sliderView.value+60<=139) {
        _cons_imgViewSYS.constant = 0;
        
    }
    else if (_sliderView.value+60>=120 && _sliderView.value+60<=129) {
        _cons_imgViewSYS.constant = 70;
        
    }
    else if (_sliderView.value+60<=120) {
        _cons_imgViewSYS.constant = 140;
        
    }
  
    
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

- (IBAction)btnSubmitFeverreport:(id)sender {
    [self uploadBloodPressure] ;
}

- (IBAction)btnSelectTypeGraphClicked:(id)sender {
    
}

-(void)uploadBloodPressure{
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
    
    [parameterDict setValue:[NSString stringWithFormat:@"%d",hertRateValue] forKey:@"heart_rate"];
    [parameterDict setValue:[NSString stringWithFormat:@"%.1f",_sliderView.value+60] forKey:@"sys"];
    [parameterDict setValue:[NSString stringWithFormat:@"%.1f",_sliderView.value] forKey:@"dia"];
    if ([_txtComments.text  isEqual: @""]){
        [parameterDict setValue:@"comment" forKey:@"comment"];
        
    }
    else
    {
        [parameterDict setValue:_txtComments.text forKey:@"comment"];
        
    }    NSDateFormatter *Formatter = [[NSDateFormatter alloc] init];
    Formatter.dateFormat = @"yyyy-MM-dd";
    NSString *stringFor = [Formatter stringFromDate:[NSDate date]];
    [parameterDict setValue:stringFor forKey:@"date"];
    
    if ([ CommonFunction reachability]) {
        [self addLoder];
        
        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_UPLOAD_BLOODPRESSURE]  postResponse:[parameterDict mutableCopy] postImage:nil requestType:POST tag:nil isRequiredAuthentication:YES header:NPHeaderName completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"] == true){
                    [self removeloder];
                    [_popUpView removeFromSuperview];
                    [self getBloodPressure];
                    [self addAlertWithTitle:AlertKey andMessage:[responseObj valueForKey:@"message"]  isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:OK_Btn secondButtonTitle:nil image:Warning_Key_For_Image];
                   

                }
                else
                {
                    [self addAlertWithTitle:AlertKey andMessage:[responseObj valueForKey:@"message"] isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:OK_Btn secondButtonTitle:nil image:Warning_Key_For_Image];
                    [self removeloder];
                    [self removeloder];
                }
                
                
                
            }
            
            else {
                [self removeloder];
           [self addAlertWithTitle:AlertKey andMessage:Sevrer_Issue_Message isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:OK_Btn secondButtonTitle:nil image:Warning_Key_For_Image];
            }
            
            
        }];
    } else {
        [self addAlertWithTitle:AlertKey andMessage:Network_Issue_Message isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:OK_Btn secondButtonTitle:nil image:Warning_Key_For_Image];
    }
    
    
}

- (IBAction)btnBackPopUp:(id)sender {
    [_popUpView removeFromSuperview];
}


-(void)getBloodPressure{
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
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_GET_BLOODPRESSURE]  postResponse:[parameterDict mutableCopy] postImage:nil requestType:POST tag:nil isRequiredAuthentication:YES header:NPHeaderName completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                dataArray = [NSMutableArray new];

                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"] == true){
                    NSArray *tempArray = [responseObj valueForKey:@"data"];
                    [tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        Report *bloodObj = [Report new];
                        bloodObj.doctor_id = [obj valueForKey:@"doctor_id"];
                        bloodObj.heart_rate = [obj valueForKey:@"heart_rate"];
                        bloodObj.comment = [obj valueForKey:@"comment"];
                        bloodObj.sys = [obj valueForKey:@"sys"];
                        bloodObj.dis = [obj valueForKey:@"dis"];
                        bloodObj.date = [obj valueForKey:@"date"];
                        [dataArray addObject:bloodObj];
                    }];
                    [self removeloder];
                    [self updateChartData];
                }
                else
                {
                    [self addAlertWithTitle:AlertKey andMessage:[responseObj valueForKey:@"message"] isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:OK_Btn secondButtonTitle:nil image:Warning_Key_For_Image];
                    [self removeloder];
                    [self removeloder];
                }
                
                
                
            }
            
            else {
                [self removeloder];
           [self addAlertWithTitle:AlertKey andMessage:Sevrer_Issue_Message isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:OK_Btn secondButtonTitle:nil image:Warning_Key_For_Image];
            }
            [self updateChartData];

            
        }];
    } else {
        [self addAlertWithTitle:AlertKey andMessage:Network_Issue_Message isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:OK_Btn secondButtonTitle:nil image:Warning_Key_For_Image];
    }
    
    
}

- (IBAction)btnSelectGraphTypeClcked:(id)sender {
}

#pragma mark - btn Actions
- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController dismissViewControllerAnimated:false completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PopBackNow" object:nil];
    }];}

- (IBAction)btnAction_instructions:(id)sender {
    
    [self addAlertWithTitle:AlertKey andMessage:@"For more instructions about using TatabApp tracker please visit www.tatabapp.com" isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:OK_Btn secondButtonTitle:nil image:Warning_Key_For_Image];
}

- (IBAction)btnHealthTrackerClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:false];
}

- (IBAction)btnEMRClcked:(id)sender {
    
    [self dismissViewControllerAnimated:false completion:nil];
    
}
- (IBAction)btnSelectHeartRateClicked:(id)sender {
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
    [self getBloodPressure];
    
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
    
}
- (IBAction)btnHeartRateSelect:(id)sender {
    
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
    pickerObj.tag = 3;
    [pickerObj  selectRow:selectedRowForType inComponent:0 animated:true];
    
    
    [viewOverPicker addSubview:pickerObj];
    [self.view addSubview:viewOverPicker];
    [pickerObj reloadAllComponents];
    

    
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



#pragma mark - add loder

-(void)addLoder{
    self.view.userInteractionEnabled = NO;
    //  loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
    loderObj = [[LoderView alloc] initWithFrame:self.view.frame];
    loderObj.lbl_title.text = @"Fetching data...";
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
    if (pickerObj.tag == 2){
        return arrayType.count;

    }
    else{
        return 200;
    }
    return 1;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:
(NSInteger)row forComponent:(NSInteger)component{
    if (pickerObj.tag == 2){
return [arrayType objectAtIndex:row];
    }
    else{
return [NSString stringWithFormat:@"%ld",(long)row+40];    }
    return @"";
    
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component{
    
    if (pickerObj.tag == 2){
       
    }
    
    if (pickerObj.tag == 3){
        [_btnHeartRate setTitle:[NSString stringWithFormat:@"%d",row+40] forState:UIControlStateNormal];
        hertRateValue = row+40;
    }
    
    
    else{
        [_btnHeartRate setTitle:[NSString stringWithFormat:@"%ld",(long)row+40] forState:UIControlStateNormal];
        heartRate = row+40;
    }
    
}


#pragma mark- Custom Loder
-(void)addAlertWithTitle:(NSString *)titleString andMessage:(NSString *)messageString isTwoButtonNeeded:(BOOL)isTwoBUtoonNeeded firstbuttonTag:(NSInteger)firstButtonTag secondButtonTag:(NSInteger)secondButtonTag firstbuttonTitle:(NSString *)firstButtonTitle secondButtonTitle:(NSString *)secondButtonTitle image:(NSString *)imageName{
    [CommonFunction resignFirstResponderOfAView:self.view];
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

selectedRowForType = 0;
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
    
    for (int i = 0; i < dataArray.count; i++)
    {
        float val = [[[dataArray objectAtIndex:i] valueForKey:@"heart_rate"] floatValue];
        [valuesHR addObject:[[ChartDataEntry alloc] initWithX:i y:val]];
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
    
    NSMutableArray *valuesDIA = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < dataArray.count; i++)
    {
        float val = [[[dataArray objectAtIndex:i] valueForKey:@"dis"] floatValue];
        [valuesDIA addObject:[[ChartDataEntry alloc] initWithX:i y:val]];
    }
    
    LineChartDataSet *dDIA = [[LineChartDataSet alloc] initWithValues:valuesDIA label:@"DIA"];
    dDIA.lineWidth = 3;
    dDIA.circleRadius = 3.0;
    dDIA.circleHoleRadius = 0.0;

    color = [UIColor redColor];
    [dDIA setColor:color];
    
    dDIA.mode = LineChartModeCubicBezier;
    dDIA.drawValuesEnabled =  false;
    [dDIA setCircleColor:color];
    [dataSets addObject:dDIA];
    
    NSMutableArray *valuesSYS = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < dataArray.count; i++)
    {
        float val = [[[dataArray objectAtIndex:i] valueForKey:@"sys"] floatValue];
        [valuesSYS addObject:[[ChartDataEntry alloc] initWithX:i y:val]];
    }
    
    LineChartDataSet *dSYS = [[LineChartDataSet alloc] initWithValues:valuesSYS label:@"SYS"];
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
    ((LineChartDataSet *)dataSets[1]).colors = [NSArray arrayWithObject:[CommonFunction getColorFor:@"DIA"]];
    ((LineChartDataSet *)dataSets[1]).circleColors = [NSArray arrayWithObject:[CommonFunction getColorFor:@"DIA"]];
    //    ((LineChartDataSet *)dataSets[0]).circleColors = ChartColorTemplates.vordiplom;
    ((LineChartDataSet *)dataSets[2]).colors = [NSArray arrayWithObject:[CommonFunction getColorFor:@"SYS"]];
    ((LineChartDataSet *)dataSets[2]).circleColors = [NSArray arrayWithObject:[CommonFunction getColorFor:@"SYS"]];
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
