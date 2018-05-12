//
//  FeverReportViewController.h
//  TatabApp
//
//  Created by Shagun Verma on 07/01/18.
//  Copyright © 2018 Shagun Verma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BEMSimpleLineGraph/BEMSimpleLineGraphView.h>
#import <Charts/Charts-Swift.h>

@interface FeverReportViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *popUpView;
@property (weak, nonatomic) IBOutlet UIButton *btnFromDate;
@property (weak, nonatomic) IBOutlet UIButton *btnToDate;
@property (weak, nonatomic) IBOutlet LineChartView *graphView;
@property (weak, nonatomic) IBOutlet UISlider *sliderView;
@property (weak, nonatomic) IBOutlet UILabel *sliderValue;
@property (weak, nonatomic) IBOutlet CustomTextField *txtComments;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cons_imgView;
@property (weak, nonatomic) IBOutlet UILabel *lbl_NoDataa;

@property (nonatomic,strong) ChatPatient* patient;
@property (nonatomic,strong) RegistrationDpendency* dependant;
@property bool isdependant;

@property (weak, nonatomic) IBOutlet UIButton *btnAdd;


@property (weak, nonatomic) IBOutlet UILabel *lblPatientName;
@property (weak, nonatomic) IBOutlet UILabel *lblbirthDate;
@property (weak, nonatomic) IBOutlet UILabel *lblgender;

//Language
@property (weak, nonatomic) IBOutlet UILabel *lbl_GenderTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Height_Title;
@property (weak, nonatomic) IBOutlet UILabel *lbl_FeverReport;

@property (weak, nonatomic) IBOutlet UILabel *lbl_title;
@property (weak, nonatomic) IBOutlet CustomButton3 *btn_Health;
@property (weak, nonatomic) IBOutlet UILabel *lbl_patient;
@property (weak, nonatomic) IBOutlet UILabel *lbl_BirthDate;
@property (weak, nonatomic) IBOutlet UILabel *lbl_WeightTitle;

@property (weak, nonatomic) IBOutlet UILabel *lbl_Chronic;


@property (weak, nonatomic) IBOutlet UILabel *lbl_No_Data;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Temp_Title;

@property (weak, nonatomic) IBOutlet CustomButton3 *btn_Refresh;
@property (weak, nonatomic) IBOutlet CustomButton3 *btn_Submit;
@property (weak, nonatomic) IBOutlet CustomButton3 *btn_Cancel;
@property (weak, nonatomic) IBOutlet CustomButton4 *btn_EMR;
@property (weak, nonatomic) IBOutlet UILabel *lbl_TodaysTemp;
@property (weak, nonatomic) IBOutlet UILabel *lbl_VeryHot;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Hot;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Normal;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Cold;
@property (weak, nonatomic) IBOutlet UILabel *lbl_VeryCold;
@property (weak, nonatomic) IBOutlet UILabel *lbl_WeightValue;
@property (weak, nonatomic) IBOutlet UILabel *lbl_HeightValue;

@end
