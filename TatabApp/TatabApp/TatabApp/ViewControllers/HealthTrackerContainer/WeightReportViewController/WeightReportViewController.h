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
@property (weak, nonatomic) IBOutlet UILabel *lblgender;


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

@property (weak, nonatomic) IBOutlet CustomButton4 *btn_EMR;
@property (weak, nonatomic) IBOutlet UILabel *lbl_TodaysWHR;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Bmi18;
@property (weak, nonatomic) IBOutlet UILabel *lbl_NormalWeight;
@property (weak, nonatomic) IBOutlet UILabel *lbl_overWeight;
@property (weak, nonatomic) IBOutlet UILabel *lbl_obesityBMI;
@property (weak, nonatomic) IBOutlet UILabel *lbl_weightinKG;
@property (weak, nonatomic) IBOutlet UILabel *lbl_RestHr;
@property (weak, nonatomic) IBOutlet UILabel *lbl_HeightInCm;
@property (weak, nonatomic) IBOutlet CustomButton3 *btn_Submit;
@property (weak, nonatomic) IBOutlet CustomButton3 *btn_Cancel;
@property (weak, nonatomic) IBOutlet UILabel *lbl_WeightValue;
@property (weak, nonatomic) IBOutlet UILabel *lbl_HeightValue;
@property (weak, nonatomic) IBOutlet UILabel *lblbirthDate;


@end
