//
//  PressureReportViewController.h
//  TatabApp
//
//  Created by Shagun Verma on 07/01/18.
//  Copyright © 2018 Shagun Verma. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Charts/Charts-Swift.h>

@interface PressureReportViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *popUpView;
@property (weak, nonatomic) IBOutlet UIButton *btnFromDate;
@property (weak, nonatomic) IBOutlet UIButton *btnToDate;
@property (weak, nonatomic) IBOutlet LineChartView *graphView;
@property (weak, nonatomic) IBOutlet UISlider *sliderView;
@property (weak, nonatomic) IBOutlet UILabel *sliderValue;
@property (weak, nonatomic) IBOutlet CustomTextField *txtComments;
@property (weak, nonatomic) IBOutlet UILabel *lblSYSValue;
@property (weak, nonatomic) IBOutlet UILabel *lblDIAValue;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cons_imgViewSYS;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cons_imageviewDIA;
@property (weak, nonatomic) IBOutlet UIButton *btnHeartRate;

@property (nonatomic,strong) ChatPatient* patient;
@property (nonatomic,strong) RegistrationDpendency* dependant;
@property bool isdependant;

@property (weak, nonatomic) IBOutlet UIButton *btnAdd;

@property (weak, nonatomic) IBOutlet UILabel *lblPatientName;
@property (weak, nonatomic) IBOutlet UILabel *lblbirthDate;
@property (weak, nonatomic) IBOutlet UILabel *lblgender;
@property (weak, nonatomic) IBOutlet UIView *supportView;


@end
