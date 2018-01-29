//
//  FeverReportViewController.h
//  TatabApp
//
//  Created by Shagun Verma on 07/01/18.
//  Copyright © 2018 Shagun Verma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BEMSimpleLineGraph/BEMSimpleLineGraphView.h>

@interface FeverReportViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *popUpView;
@property (weak, nonatomic) IBOutlet UIButton *btnFromDate;
@property (weak, nonatomic) IBOutlet UIButton *btnToDate;
@property (weak, nonatomic) IBOutlet BEMSimpleLineGraphView *graphView;
@property (weak, nonatomic) IBOutlet UISlider *sliderView;
@property (weak, nonatomic) IBOutlet UILabel *sliderValue;
@property (weak, nonatomic) IBOutlet CustomTextField *txtComments;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cons_imgView;

@property (nonatomic,strong) ChatPatient* patient;
@property (nonatomic,strong) RegistrationDpendency* dependant;
@property bool isdependant;

@property (weak, nonatomic) IBOutlet UIButton *btnAdd;

@end
