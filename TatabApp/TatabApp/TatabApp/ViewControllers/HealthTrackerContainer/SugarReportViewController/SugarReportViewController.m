//
//  SugarReportViewController.m
//  TatabApp
//
//  Created by Shagun Verma on 07/01/18.
//  Copyright © 2018 Shagun Verma. All rights reserved.
//

#import "SugarReportViewController.h"
#import <BEMSimpleLineGraph/BEMSimpleLineGraphView.h>

@interface SugarReportViewController ()<ChartViewDelegate,UIPickerViewDelegate>
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
    
    NSMutableArray* arrayType;
    NSMutableArray* arrayTypeFilter;
    NSInteger selectedRowForType;
    NSInteger selectedRowForTypeFilter;
    
    NSInteger ansWeight;
    NSString *ansReading;
    NSInteger selectedRowForReading;
    NSInteger selectedRowForTiming;
    CustomAlert *alertObj;
    NSMutableArray * arrayreading;
}
@end

@implementation SugarReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    alertObj = [[CustomAlert alloc] initWithFrame:self.view.frame];
    
    toDate = [NSDate date];
    ansWeight = 0;
    ansReading = @"101-111";
    arrayreading = [[NSMutableArray alloc] initWithObjects:@"101-111",@"111-121",@"121-131",@"131-141",@"141-151",@"151-161",@"161-171",@"171-181",@"181-191",@"191-201", nil];
    fromDate = [NSDate date];
    arrayType = [[NSMutableArray alloc] initWithObjects:@"Pre-meal",@"Sleep",@"Post-sleep", nil];
    arrayTypeFilter = [[NSMutableArray alloc] initWithObjects:@"All",@"Pre-meal",@"Sleep",@"Post-sleep", nil];
    selectedRowForType = 0;
    selectedRowForTypeFilter = 0;
    selectedRowForTiming = 0;
    selectedRowForReading = 0;
    //    _txtComments.text = @"comment";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    //self.myLabel.text = [dateFormatter stringFromDate:[dueDatePickerView date]];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    fromDateString = [CommonFunction setOneMonthOldGate];
    [_btnFromDate setTitle:fromDateString forState:UIControlStateNormal];
    toDateString = [dateFormatter stringFromDate:toDate];
    [_btnToDate setTitle:toDateString forState:UIControlStateNormal];
    
    [_btnWeightPopup setTitle:[arrayType objectAtIndex:0]  forState:UIControlStateNormal];
    [_btnReadingPopup setTitle:[arrayreading objectAtIndex:0] forState:UIControlStateNormal];
    [_btnSelectType setTitle:[arrayTypeFilter objectAtIndex:0] forState:UIControlStateNormal];

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
    
    if (![[CommonFunction getValueFromDefaultWithKey:loginuserType] isEqualToString:@"Patient"]) {
        _btnAdd.hidden = true;
    }
    
    
        [_lblPatientName setText:[_dependant.name capitalizedString]];
        [_lblgender setText:_dependant.gender];
        [_lblbirthDate setText:[CommonFunction ConvertDateTime2:_dependant.birthDay]];
    
    [self setData];
    [self setLanguageData];
    // Do any additional setup after loading the view from its nib.
}

-(void)setData{
    _lbl_WeightValue.text = [NSString stringWithFormat:@"%@ %@",[CommonFunction getValueFromDefaultWithKey:Selected_Patient_Weight],[Langauge getTextFromTheKey:@"Kg"]];
    _lbl_HeightValue.text = [NSString stringWithFormat:@"%@ %@",[CommonFunction getValueFromDefaultWithKey:Selected_Patient_Height],[Langauge getTextFromTheKey:@"Cm"]];
}
-(void)setLanguageData{
    _lbl_No_Data.text = [Langauge getTextFromTheKey:@"no_data"];
    [_btn_EMR setTitle:[Langauge getTextFromTheKey:@"emr"] forState:UIControlStateNormal];
    [_btn_Health setTitle:[Langauge getTextFromTheKey:@"health_tracker"] forState:UIControlStateNormal];
    [_btnToDate setTitle:[Langauge getTextFromTheKey:@"to"] forState:UIControlStateNormal];
    [_btnFromDate setTitle:[Langauge getTextFromTheKey:@"from"] forState:UIControlStateNormal];
    [_btn_Refresh setTitle:[Langauge getTextFromTheKey:@"refresh_graph"] forState:UIControlStateNormal];
    
    
    _lbl_title.text = [Langauge getTextFromTheKey:@"emr"];
    _lbl_SugarReport.text = [Langauge getTextFromTheKey:@"blood_suger_report"];
    _lbl_patient.text = [Langauge getTextFromTheKey:@"patient"];
    _lbl_GenderTitle.text = [Langauge getTextFromTheKey:@"gender"];
    _lbl_Height_Title.text = [Langauge getTextFromTheKey:@"height"];
    _lbl_BirthDate.text = [Langauge getTextFromTheKey:@"birthdate"];
    _lbl_WeightTitle.text = [Langauge getTextFromTheKey:@"weight"];
    _lbl_Chronic.text = [Langauge getTextFromTheKey:@"chornic"];
    _lbl_PreMeal_Title.text = [NSString stringWithFormat:@"%@%@",[Langauge getTextFromTheKey:@"pre"],[Langauge getTextFromTheKey:@"meal"]];
    _lbl_PostSleep_Title.text = [NSString stringWithFormat:@"%@%@",[Langauge getTextFromTheKey:@"post"],[Langauge getTextFromTheKey:@"sleep"]];
    _lbl_Sleep_Title.text = [Langauge getTextFromTheKey:@"sleep"];

    
    [_btn_Submit setTitle:[Langauge getTextFromTheKey:@"submit"] forState:UIControlStateNormal];
    [_btn_Cancel setTitle:[Langauge getTextFromTheKey:@"cancel"] forState:UIControlStateNormal];
    _txtComments.placeholder = [Langauge getTextFromTheKey:@"comment"];
    
    _lbl_Today_Sugar.text = [Langauge getTextFromTheKey:@"today_blood_suger"];
    _lbl_Reading.text = [Langauge getTextFromTheKey:@"reading_mg"];
    _lbl_Timing.text = [Langauge getTextFromTheKey:@"timings"];
    _lbl_NormalRange.text = [Langauge getTextFromTheKey:@"normal_range"];
    
}


-(void)viewDidLayoutSubviews{
    loderObj.frame = self.view.frame;
    alertObj.frame = self.view.frame;
}
-(void)viewDidAppear:(BOOL)animated{
    [self getBloodSugar];
}

-(void)resignResponder{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - btn Actions
- (IBAction)btnAction_instructions:(id)sender {
    
    [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:@"For more instructions about using TatabApp tracker please visit www.tatabapp.com" isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
}

- (IBAction)selectTypeClicked:(id)sender {
    
    
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
    pickerObj.tag = 1;
    [pickerObj  selectRow:selectedRowForType inComponent:0 animated:true];
    
    
    [viewOverPicker addSubview:pickerObj];
    [self.view addSubview:viewOverPicker];
    [pickerObj reloadAllComponents];
    
    
}
- (IBAction)btnHealthTrackerClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:false];
}
- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController dismissViewControllerAnimated:false completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PopBackNow" object:nil];
    }];}

- (IBAction)btnEMRClcked:(id)sender {
    
    [self dismissViewControllerAnimated:false completion:nil];
    
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
    [self getBloodSugar];
    
}

- (IBAction)btnBackPopUp:(id)sender {
    [_popUpView removeFromSuperview];
}


- (IBAction)btnSubmitFeverreport:(id)sender {
    [self uploadBloodSugar] ;
}
- (IBAction)btnWeightClicked:(id)sender {
    
    
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
    pickerObj.tag = 2;
    [pickerObj  selectRow:selectedRowForType inComponent:0 animated:true];
    
    
    [viewOverPicker addSubview:pickerObj];
    [self.view addSubview:viewOverPicker];
    [pickerObj reloadAllComponents];
    
    
}
- (IBAction)btnSubmitClicked:(id)sender {
    
    
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


- (IBAction)btnSelectType:(id)sender {
    
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
    pickerObj.tag = 1;
    [pickerObj  selectRow:selectedRowForType inComponent:0 animated:true];
    
    
    [viewOverPicker addSubview:pickerObj];
    [self.view addSubview:viewOverPicker];
    [pickerObj reloadAllComponents];
    
}


-(void)uploadBloodSugar{
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
    
    //    [parameterDict setValue:[CommonFunction getValueFromDefaultWithKey:loginuserId] forKey:DOCTOR_ID];
    [parameterDict setValue:[arrayType objectAtIndex:selectedRowForTiming] forKey:@"timing"];
    [parameterDict setValue:[arrayreading objectAtIndex:selectedRowForReading] forKey:@"reading"];
    if ([_txtComments.text  isEqual: @""]){
        [parameterDict setValue:@"comment" forKey:@"comment"];
        
    }
    else
    {
        [parameterDict setValue:_txtComments.text forKey:@"comment"];
        
    }
    NSDateFormatter *Formatter = [[NSDateFormatter alloc] init];
    Formatter.dateFormat = @"yyyy-MM-dd";
    NSString *stringFor = [Formatter stringFromDate:[NSDate date]];
    
    [parameterDict setValue:stringFor forKey:@"date"];
    
    if ([ CommonFunction reachability]) {
        [self addLoder];
        
        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_UPLOAD_BLOODSUGAR]  postResponse:[parameterDict mutableCopy] postImage:nil requestType:POST tag:nil isRequiredAuthentication:YES header:NPHeaderName completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"] == true){
                    /* UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:[responseObj valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
                     UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                     [alertController addAction:ok];
                     [self presentViewController:alertController animated:YES completion:nil];
                     [self removeloder];
                     [_popUpView removeFromSuperview];*/
                    [self removeloder];
                    [_popUpView removeFromSuperview];
                    [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:[responseObj valueForKey:@"message"]  isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
                    [self getBloodSugar];
                    
                }
                else
                {
                    [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:[responseObj valueForKey:@"message"] isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
                    [self removeloder];
                    [self removeloder];
                }
                
                
                
            }
            
            else {
                [self removeloder];
                [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:Sevrer_Issue_Message isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
            }
            
            
        }];
    } else {
        [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:Network_Issue_Message isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
    }
    
    
}

-(void)getBloodSugar{
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
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_GET_BLOODSUGAR]  postResponse:[parameterDict mutableCopy] postImage:nil requestType:POST tag:nil isRequiredAuthentication:YES header:NPHeaderName completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                dataArray = [NSMutableArray new];

                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"] == true){
                    NSArray *tempArray = [responseObj valueForKey:@"data"];
                    [tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        Report *bloodObj = [Report new];
                        bloodObj.doctor_id = [obj valueForKey:@"doctor_id"];
                        bloodObj.timing = [obj valueForKey:@"timing"];
                        bloodObj.comment = [obj valueForKey:@"comment"];
                        bloodObj.reading = [obj valueForKey:@"reading"];
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
                }
                else
                {
                    [self removeloder];
                    
                    [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:[responseObj valueForKey:@"message"] isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
                    [self removeloder];
                }
                
                
                
            }
            
            else {
                [self removeloder];
                [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:Sevrer_Issue_Message isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
            }
            
            [self updateChartData];

        }];
    } else {
        [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:Network_Issue_Message isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
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
    if (pickerObj.tag == 1){
        selectedRowForTypeFilter = 0;
        return [arrayTypeFilter count];
    }
    else if (pickerObj.tag == 2){
        //Weight
        return [arrayType count];
    }
    else if (pickerObj.tag == 3){
        //reading
        return 10;
    }
    
    return 0;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:
(NSInteger)row forComponent:(NSInteger)component{
    
    if (pickerObj.tag == 1){
        return [arrayTypeFilter objectAtIndex:row];
    }
    else if (pickerObj.tag == 2){
        //Weight
        return [arrayType objectAtIndex:row];
    }
    else if (pickerObj.tag == 3){
        //reading
        return [arrayreading objectAtIndex:row];
    }
    
    
    return @"";
    
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component{
    
    if (pickerObj.tag == 1){
        [_btnSelectType setTitle:[arrayTypeFilter objectAtIndex:row] forState:UIControlStateNormal];
        selectedRowForTypeFilter = row;
        
    }
    else if (pickerObj.tag == 2){
        //Weight
        [_btnWeightPopup setTitle:[arrayType objectAtIndex:row] forState:UIControlStateNormal];
        selectedRowForTiming = row;
        
    }
    else if (pickerObj.tag == 3){
        //reading
        [_btnReadingPopup setTitle:[arrayreading objectAtIndex:row] forState:UIControlStateNormal];
        selectedRowForReading = row;
        
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
        case 101:{
            [self removeloder];
            [_popUpView removeFromSuperview];
            [self removeAlert];
        }
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
    switch (selectedRowForTypeFilter) {
        case 0:
        {
            [self updateChartDataForAll];
        }
            break;
        case 1:
        {
            [self updateChartDataForPreSleep];
        }
            break;
        case 2:
        {
            [self updateChartDataForSleep];
        }
            break;
        case 3:
        {
            [self updateChartDataPostSleep];
        }
            break;
            
        default:
            break;
    }
}
- (void)updateChartDataForAll
{
    NSArray *colors = @[ChartColorTemplates.vordiplom[0], ChartColorTemplates.vordiplom[1], ChartColorTemplates.vordiplom[2]];
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    NSMutableArray *valuesPresleep = [[NSMutableArray alloc] init];
    int index = 0;

    
    [valuesPresleep addObject:[[ChartDataEntry alloc] initWithX:0 y:0]];

    for (int i = 0; i < dataArray.count; i++)
    {
        if ([[[dataArray objectAtIndex:i] valueForKey:@"timing"] isEqual:@"Pre-meal"]){
            float reading = ([[[[[dataArray objectAtIndex:i] valueForKey:@"reading"] componentsSeparatedByString:@"-" ] objectAtIndex:0] floatValue] +[[[[[dataArray objectAtIndex:i] valueForKey:@"reading"] componentsSeparatedByString:@"-" ] objectAtIndex:1] floatValue]) /2;
            
            [valuesPresleep addObject:[[ChartDataEntry alloc] initWithX:i+1 y:reading]];
            
        }
    }
    
    LineChartDataSet *d = [[LineChartDataSet alloc] initWithValues:valuesPresleep label:@"HR"];
    d.lineWidth = 3;
    d.circleRadius = 3.0;
    d.circleHoleRadius = 0.0;
    
    UIColor *color = [UIColor redColor];
    [d setColor:color];
    
    d.mode = LineChartModeCubicBezier;
    d.drawValuesEnabled =  false;
    [d setCircleColor:color];
    [dataSets addObject:d];
    
    NSMutableArray *valuesSleep = [[NSMutableArray alloc] init];
    index = 0;
    
    [valuesSleep addObject:[[ChartDataEntry alloc] initWithX:0 y:0]];
    for (int i = 0; i < dataArray.count; i++)
    {
        if ([[[dataArray objectAtIndex:i] valueForKey:@"timing"] isEqual:@"Sleep"]){
            float reading = ([[[[[dataArray objectAtIndex:i] valueForKey:@"reading"] componentsSeparatedByString:@"-" ] objectAtIndex:0] floatValue] +[[[[[dataArray objectAtIndex:i] valueForKey:@"reading"] componentsSeparatedByString:@"-" ] objectAtIndex:1] floatValue]) /2;
            
            [valuesSleep addObject:[[ChartDataEntry alloc] initWithX:i+1 y:reading]];
        }
    }
    
    LineChartDataSet *dDIA = [[LineChartDataSet alloc] initWithValues:valuesSleep label:@"DIA"];
    dDIA.lineWidth = 3;
    dDIA.circleRadius = 3.0;
    dDIA.circleHoleRadius = 0.0;

    color = [UIColor redColor];
    [dDIA setColor:color];
    
    dDIA.mode = LineChartModeCubicBezier;
    dDIA.drawValuesEnabled =  false;
    [dDIA setCircleColor:color];
    [dataSets addObject:dDIA];
    
    NSMutableArray *valuesPostSleep = [[NSMutableArray alloc] init];
    index = 0;
    [valuesPostSleep addObject:[[ChartDataEntry alloc] initWithX:0 y:0]];

    for (int i = 0; i < dataArray.count; i++)
    {
        if ([[[dataArray objectAtIndex:i] valueForKey:@"timing"] isEqual:@"Post-sleep"]){
            float reading = ([[[[[dataArray objectAtIndex:i] valueForKey:@"reading"] componentsSeparatedByString:@"-" ] objectAtIndex:0] floatValue] +[[[[[dataArray objectAtIndex:i] valueForKey:@"reading"] componentsSeparatedByString:@"-" ] objectAtIndex:1] floatValue]) /2;
            
            [valuesPostSleep addObject:[[ChartDataEntry alloc] initWithX:i+1 y:reading]];
            index++;
        }
    }
    
    if (valuesPostSleep.count == 1 && valuesSleep.count == 1 && valuesPresleep.count == 1 )  {
        _lbl_NoDataa.hidden = false;
        _graphView.hidden = true;
    }else{
        _lbl_NoDataa.hidden = true;
        _graphView.hidden = false;
    }
    LineChartDataSet *dSYS = [[LineChartDataSet alloc] initWithValues:valuesPostSleep label:@"SYS"];
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
- (void)updateChartDataForPreSleep
{
    NSArray *colors = @[ChartColorTemplates.vordiplom[0], ChartColorTemplates.vordiplom[1], ChartColorTemplates.vordiplom[2]];
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    NSMutableArray *valuesHR = [[NSMutableArray alloc] init];
    [valuesHR addObject:[[ChartDataEntry alloc] initWithX:0 y:0]];
    for (int i = 0; i < dataArray.count; i++)
    {
        if ([[[dataArray objectAtIndex:i] valueForKey:@"timing"] isEqual:@"Pre-meal"]){
            float reading = ([[[[[dataArray objectAtIndex:i] valueForKey:@"reading"] componentsSeparatedByString:@"-" ] objectAtIndex:0] floatValue] +[[[[[dataArray objectAtIndex:i] valueForKey:@"reading"] componentsSeparatedByString:@"-" ] objectAtIndex:1] floatValue]) /2;
            
            [valuesHR addObject:[[ChartDataEntry alloc] initWithX:i+1 y:reading]];
        }
        
    }
    if (valuesHR.count == 1) {
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
    
    
    
    ((LineChartDataSet *)dataSets[0]).colors = [NSArray arrayWithObject:[CommonFunction getColorFor:@"HR"]];
    ((LineChartDataSet *)dataSets[0]).circleColors = [NSArray arrayWithObject:[CommonFunction getColorFor:@"HR"]];
    
    LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:7.f]];
    _graphView.data = data;
}
- (void)updateChartDataForSleep
{
    NSArray *colors = @[ChartColorTemplates.vordiplom[0], ChartColorTemplates.vordiplom[1], ChartColorTemplates.vordiplom[2]];
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    NSMutableArray *valuesHR = [[NSMutableArray alloc] init];
    
    [valuesHR addObject:[[ChartDataEntry alloc] initWithX:0 y:0]];

    for (int i = 0; i < dataArray.count; i++)
    {
        if ([[[dataArray objectAtIndex:i] valueForKey:@"timing"] isEqual:@"Sleep"]){
            float reading = ([[[[[dataArray objectAtIndex:i] valueForKey:@"reading"] componentsSeparatedByString:@"-" ] objectAtIndex:0] floatValue] +[[[[[dataArray objectAtIndex:i] valueForKey:@"reading"] componentsSeparatedByString:@"-" ] objectAtIndex:1] floatValue]) /2;
            
            [valuesHR addObject:[[ChartDataEntry alloc] initWithX:i+1 y:reading]];
        }
        
    }
    
    if (valuesHR.count == 1) {
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

    ((LineChartDataSet *)dataSets[0]).colors = [NSArray arrayWithObject:[CommonFunction getColorFor:@"DIA"]];
    ((LineChartDataSet *)dataSets[0]).circleColors = [NSArray arrayWithObject:[CommonFunction getColorFor:@"DIA"]];
    LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:7.f]];
    _graphView.data = data;
}


- (void)updateChartDataPostSleep
{
    NSArray *colors = @[ChartColorTemplates.vordiplom[0], ChartColorTemplates.vordiplom[1], ChartColorTemplates.vordiplom[2]];
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    NSMutableArray *valuesHR = [[NSMutableArray alloc] init];
    [valuesHR addObject:[[ChartDataEntry alloc] initWithX:0 y:0]];
    for (int i = 0; i < dataArray.count; i++){
        if ([[[dataArray objectAtIndex:i] valueForKey:@"timing"] isEqual:@"Post-sleep"]){
            float reading = ([[[[[dataArray objectAtIndex:i] valueForKey:@"reading"] componentsSeparatedByString:@"-" ] objectAtIndex:0] floatValue] +[[[[[dataArray objectAtIndex:i] valueForKey:@"reading"] componentsSeparatedByString:@"-" ] objectAtIndex:1] floatValue]) /2;
            [valuesHR addObject:[[ChartDataEntry alloc] initWithX:i+1 y:reading]];
        }
    }
    
    if (valuesHR.count == 1) {
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

    
    ((LineChartDataSet *)dataSets[0]).colors = [NSArray arrayWithObject:[CommonFunction getColorFor:@"SYS"]];
    ((LineChartDataSet *)dataSets[0]).circleColors = [NSArray arrayWithObject:[CommonFunction getColorFor:@"SYS"]];
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

