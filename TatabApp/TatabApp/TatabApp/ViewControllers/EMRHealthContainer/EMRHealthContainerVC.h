//
//  EMRHealthContainerVC.h
//  TatabApp
//
//  Created by Shagun Verma on 28/12/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton4.h"
#import "CustomButton3.h"
@interface EMRHealthContainerVC : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblPatientName;
@property (weak, nonatomic) IBOutlet UILabel *lblbirthDate;
@property (weak, nonatomic) IBOutlet UILabel *lblgender;
@property (weak, nonatomic) IBOutlet UILabel *lblChronic;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Nodata;

@property (nonatomic,strong) ChatPatient* patient;
@property (nonatomic,strong) RegistrationDpendency* dependant;
@property bool isdependant;


//Language
@property (weak, nonatomic) IBOutlet UILabel *lbl_GenderTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Height_Title;
@property (weak, nonatomic) IBOutlet UILabel *lbl_EmrLog;

@property (weak, nonatomic) IBOutlet UILabel *lbl_title;
@property (weak, nonatomic) IBOutlet CustomButton4 *btn_Health;
@property (weak, nonatomic) IBOutlet UILabel *lbl_patient;
@property (weak, nonatomic) IBOutlet UILabel *lbl_BirthDate;
@property (weak, nonatomic) IBOutlet UILabel *lbl_WeightTitle;

@property (weak, nonatomic) IBOutlet UILabel *lbl_Chronic;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Date_Title;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Details_Title;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Doctor_Title;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Followup_Title;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Prescription_Title;
@property (weak, nonatomic) IBOutlet CustomButton3 *btn_EMR;
@property (weak, nonatomic) IBOutlet UILabel *lbl_No_Data;
@property (weak, nonatomic) IBOutlet UILabel *lbl_WeightValue;
@property (weak, nonatomic) IBOutlet UILabel *lbl_HeightValue;
@end
