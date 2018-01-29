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
    
    NSMutableArray* arrayToShowOnGraph;

}
@end

@implementation PressureReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    toDate = [NSDate date];
    _txtComments.text = @"comment";
    heartRate = 0;
    
    fromDate = [NSDate date];
    
    CGAffineTransform trans = CGAffineTransformMakeRotation(-M_PI * 0.5);
    _sliderView.transform = trans;
    _lblDIAValue.text = [NSString stringWithFormat:@"%.f",roundf(_sliderView.value)];
    _lblSYSValue.text = [NSString stringWithFormat:@"%.f",roundf(_sliderView.value+60)];
    [_sliderView addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    _sliderView.maximumValue = 120.0;
    _sliderView.minimumValue = 65.0;
    [_btnHeartRate setTitle:@"0" forState:UIControlStateNormal];
    hertRateValue = 0;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    //self.myLabel.text = [dateFormatter stringFromDate:[dueDatePickerView date]];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    fromDateString = [dateFormatter stringFromDate:fromDate];
    [_btnFromDate setTitle:fromDateString forState:UIControlStateNormal];
    toDateString = [dateFormatter stringFromDate:toDate];
    [_btnToDate setTitle:toDateString forState:UIControlStateNormal];
    
    arrayToShowOnGraph = [[NSMutableArray alloc] init];

    arrayType = [[NSMutableArray alloc] initWithObjects:@"HR",@"DIA",@"SYS", nil];
    selectedRowForType = 0;
    
    
    // Enable and disable various graph properties and axis displays
    
    _graphView.enableTouchReport = YES;
    _graphView.enablePopUpReport = YES;
    _graphView.enableYAxisLabel = YES;
    _graphView.autoScaleYAxis = YES;
    _graphView.alwaysDisplayDots = NO;
    _graphView.enableReferenceXAxisLines = YES;
    _graphView.enableReferenceYAxisLines = YES;
    _graphView.enableReferenceAxisFrame = YES;
    
    
    UIImage * white = [[UIImage imageNamed:@"blood-pressure-slider"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [_sliderView setMinimumTrackImage:[white stretchableImageWithLeftCapWidth:3.0 topCapHeight:0.0] forState:UIControlStateNormal];
    
    [_sliderView setMaximumTrackImage:[white stretchableImageWithLeftCapWidth:3.0 topCapHeight:0.0] forState:UIControlStateNormal];
    
    [_sliderView setThumbImage:[UIImage imageNamed:@"slider_small"] forState:UIControlStateNormal];
    
    [_sliderView trackRectForBounds:_sliderView.bounds];

    if (![[CommonFunction getValueFromDefaultWithKey:loginuserType] isEqualToString:@"Patient"]) {
        _btnAdd.hidden = true;
    }

    // Do any additional setup after loading the view from its nib.
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
    }
    else
    {
        [parameterDict setValue:_patient.patient_id forKey:PATIENT_ID];
        [parameterDict setValue:_dependant.depedant_id forKey:DEPENDANT_ID];
    }
    
    [parameterDict setValue:[NSString stringWithFormat:@"%d",hertRateValue] forKey:@"heart_rate"];
    [parameterDict setValue:[NSString stringWithFormat:@"%.1f",_sliderView.value+60] forKey:@"sys"];
    [parameterDict setValue:[NSString stringWithFormat:@"%.1f",_sliderView.value] forKey:@"dia"];
    [parameterDict setValue:_txtComments.text forKey:@"comment"];
    NSDateFormatter *Formatter = [[NSDateFormatter alloc] init];
    Formatter.dateFormat = @"yyyy-MM-dd";
    NSString *stringFor = [Formatter stringFromDate:[NSDate date]];
    [parameterDict setValue:stringFor forKey:@"date"];
    
    if ([ CommonFunction reachability]) {
        [self addLoder];
        
        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_UPLOAD_BLOODPRESSURE]  postResponse:[parameterDict mutableCopy] postImage:nil requestType:POST tag:nil isRequiredAuthentication:YES header:NPHeaderName completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"] == true){
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:[responseObj valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:ok];
                    [self presentViewController:alertController animated:YES completion:nil];
                    [self removeloder];
                    [_popUpView removeFromSuperview];

                }
                else
                {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:[responseObj valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:ok];
                    //                    [CommonFunction storeValueInDefault:@"true" andKey:@"isLoggedIn"];
                    [self presentViewController:alertController animated:YES completion:nil];
                    [self removeloder];
                }
                
                
                
            }
            
            else {
                [self removeloder];
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:[error description] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:ok];
                [self presentViewController:alertController animated:YES completion:nil];
            }
            
            
        }];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Network Error" message:@"No Network Access" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    
}

- (IBAction)btnBackPopUp:(id)sender {
    [_popUpView removeFromSuperview];
}


-(void)getBloodPressure{
    NSMutableDictionary *parameterDict = [[NSMutableDictionary alloc]init];
    
    if (!_isdependant){
        [parameterDict setValue:_patient.patient_id forKey:PATIENT_ID];
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
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"] == true){
                    dataArray = [NSMutableArray new];
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
                    [self.graphView reloadGraph];
                }
                else
                {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:[responseObj valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:ok];
                    //                    [CommonFunction storeValueInDefault:@"true" andKey:@"isLoggedIn"];
                    [self presentViewController:alertController animated:YES completion:nil];
                    [self removeloder];
                }
                
                
                
            }
            
            else {
                [self removeloder];
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:[error description] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:ok];
                [self presentViewController:alertController animated:YES completion:nil];
            }
            
            
        }];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Network Error" message:@"No Network Access" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    
}

- (IBAction)btnSelectGraphTypeClcked:(id)sender {
}

#pragma mark - btn Actions
- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController dismissViewControllerAnimated:false completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PopBackNow" object:nil];
    }];}
#pragma mark - btn Actions
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
    pickerObj.tag = 2;
    [pickerObj  selectRow:selectedRowForType inComponent:0 animated:true];
    
    
    [viewOverPicker addSubview:pickerObj];
    [self.view addSubview:viewOverPicker];
    [pickerObj reloadAllComponents];
    
    
}

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
   
    if ([dataArray count] == 1) {
        return 2;
    }
    else
    {
        return [dataArray count]; // Number of points in the graph.
        
    }
         // Number of points in the graph.
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    
    if ([dataArray count] == 1) {
        if (index == 0) {
            
            if (selectedRowForType == 0)
            {
                return 0; // The value of the point on the Y-Axis for the index.
            }
            else if (selectedRowForType == 1){
                return 65.0; // The value of the point on the Y-Axis for the index.
            }
            else if (selectedRowForType == 2){
                return 125.0; // The value of the point on the Y-Axis for the index.
            }
            return 0;
        }
        else
        {
            if (selectedRowForType == 0)
            {
                return [[[dataArray objectAtIndex:index-1] valueForKey:@"heart_rate"] floatValue]; // The value of the point on the Y-Axis for the index.
            }
            else if (selectedRowForType == 1){
                return [[[dataArray objectAtIndex:index-1] valueForKey:@"dis"] floatValue]; // The value of the point on the Y-Axis for the index.
            }
            else if (selectedRowForType == 2){
                return [[[dataArray objectAtIndex:index-1] valueForKey:@"sys"] floatValue]; // The value of the point on the Y-Axis for the index.
            }
            return 0;
            
        }
    }
    else
    {
        if (selectedRowForType == 0)
        {
            return [[[dataArray objectAtIndex:index] valueForKey:@"heart_rate"] floatValue]; // The value of the point on the Y-Axis for the index.
        }
        else if (selectedRowForType == 1){
            return [[[dataArray objectAtIndex:index] valueForKey:@"dis"] floatValue]; // The value of the point on the Y-Axis for the index.
        }
        else if (selectedRowForType == 2){
            return [[[dataArray objectAtIndex:index] valueForKey:@"sys"] floatValue]; // The value of the point on the Y-Axis for the index.
        }
        return 0;
    
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
        return 3;

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
return [NSString stringWithFormat:@"%ld",(long)row];    }
    return @"";
    
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component{
    
    if (pickerObj.tag == 2){
        [_btnSelectType setTitle:[arrayType objectAtIndex:row] forState:UIControlStateNormal];
        selectedRowForType = row;
        switch (row) {
            case 0:
                _graphView.colorLine = [CommonFunction getColorFor:@"HR"];
                
                break;
            case 1:
                _graphView.colorLine = [CommonFunction getColorFor:@"DIA"];
                
                break;
            case 2:
                _graphView.colorLine = [CommonFunction getColorFor:@"SYS"];
                
                break;
                
            default:
                break;
        }
        [self.graphView reloadGraph];
    }
    
    if (pickerObj.tag == 3){
        [_btnHeartRate setTitle:[NSString stringWithFormat:@"%d",row] forState:UIControlStateNormal];
        hertRateValue = row;
    }
    
    
    else{
        [_btnHeartRate setTitle:[NSString stringWithFormat:@"%ld",(long)row] forState:UIControlStateNormal];
        heartRate = row;
    }
    
    
        
    
    
    
}


@end
