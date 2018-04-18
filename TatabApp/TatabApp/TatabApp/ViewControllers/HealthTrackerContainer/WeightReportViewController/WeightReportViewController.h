//
//  WeightReportViewController.h
//  TatabApp
//
//  Created by Shagun Verma on 07/01/18.
//  Copyright © 2018 Shagun Verma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Charts/Charts-Swift.h>
#import "CustomButton3.h"
@interface WeightReportViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *popUpView;
@property (weak, nonatomic) IBOutlet UIButton *btnFromDate;
@property (weak, nonatomic) IBOutlet UIButton *btnToDate;
@property (weak, nonatomic) IBOutlet LineChartView *graphView;
@property (weak, nonatomic) IBOutlet CustomButton3 *btnWeight;
@property (weak, nonatomic) IBOutlet CustomButton3 *btnHeight;
@property (weak, nonatomic) IBOutlet CustomButton3 *btnHeartRate;
@property (weak, nonatomic) IBOutlet CustomTextField *txt_Comment;
@property (weak, nonatomic) IBOutlet UILabel *lbl_NoDataa;

@property (nonatomic,strong) ChatPatient* patient;
@property (nonatomic,strong) RegistrationDpendency* dependant;
@property bool isdependant;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;

@property (weak, nonatomic) IBOutlet UILabel *lblPatientName;
@property (weak, nonatomic) IBOutlet UILabel *lblbirthDate;
@property (weak, nonatomic) IBOutlet UILabel *lblgender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cons__bmi_underWeightCentre;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cons__bmi_obesityCentre;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cons__bmi_normalWeightCentre;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cons__bmi_overWeightCentre;
@property (weak, nonatomic) IBOutlet UIImageView *imgPointer;


//Language
@property (weak, nonatomic) IBOutlet UILabel *lbl_GenderTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Height_Title;
@property (weak, nonatomic) IBOutlet UILabel *lbl_WeightReport;

@property (weak, nonatomic) IBOutlet UILabel *lbl_title;
@property (weak, nonatomic) IBOutlet CustomButton3 *btn_Health;
@property (weak, nonatomic) IBOutlet UILabel *lbl_patient;
@property (weak, nonatomic) IBOutlet UILabel *lbl_BirthDate;
@property (weak, nonatomic) IBOutlet UILabel *lbl_WeightTitle;

@property (weak, nonatomic) IBOutlet UILabel *lbl_Chronic;


@property (weak, nonatomic) IBOutlet UILabel *lbl_No_Data;
@property (weak, nonatomic) IBOutlet UILabel *lbl_HR_Title;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Weight_Title2;
@property (weak, nonatomic) IBOutlet CustomButton3 *btn_Refresh;
@property (weak, nonatomic) IBOutlet CustomButton3 *btn_From;
@property (weak, nonatomic) IBOutlet CustomButton3 *btn_To;
@property (weak, nonatomic) IBOutlet CustomButton4 *btn_EMR;


@end
