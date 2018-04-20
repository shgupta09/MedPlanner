//
//  HealthTrackerContainerVC.h
//  TatabApp
//
//  Created by Shagun Verma on 07/01/18.
//  Copyright © 2018 Shagun Verma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HealthTrackerContainerVC : UIViewController

@property (nonatomic,strong) ChatPatient* patient;
@property (nonatomic,strong) RegistrationDpendency* dependant;
@property bool isdependant;


@property (weak, nonatomic) IBOutlet UILabel *lblPatientName;
@property (weak, nonatomic) IBOutlet UILabel *lblbirthDate;
@property (weak, nonatomic) IBOutlet UILabel *lblgender;
//Language
@property (weak, nonatomic) IBOutlet UILabel *lbl_GenderTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Height_Title;
@property (weak, nonatomic) IBOutlet UILabel *lbl_HealthTracker;

@property (weak, nonatomic) IBOutlet UILabel *lbl_title;
@property (weak, nonatomic) IBOutlet CustomButton3 *btn_Health;
@property (weak, nonatomic) IBOutlet UILabel *lbl_patient;
@property (weak, nonatomic) IBOutlet UILabel *lbl_BirthDate;
@property (weak, nonatomic) IBOutlet UILabel *lbl_WeightTitle;

@property (weak, nonatomic) IBOutlet UILabel *lbl_Chronic;


@property (weak, nonatomic) IBOutlet UILabel *lbl_Weight_Report;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Fever_Report;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Blood_Pressure;
@property (weak, nonatomic) IBOutlet UILabel *lbl_BloodSugar;
@property (weak, nonatomic) IBOutlet CustomButton4 *btn_EMR;
@property (weak, nonatomic) IBOutlet UILabel *lbl_WeightValue;
@property (weak, nonatomic) IBOutlet UILabel *lbl_HeightValue;

@end
