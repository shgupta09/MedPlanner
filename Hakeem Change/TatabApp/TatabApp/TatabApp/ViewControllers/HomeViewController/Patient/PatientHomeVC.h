//
//  PatientHomeVC.h
//  TatabApp
//
//  Created by shubham gupta on 10/14/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PatientHomeVC : UIViewController
@property (weak, nonatomic) IBOutlet CustomButton2 *btn_MedicalConsultant;

@property (weak, nonatomic) IBOutlet CustomButton2 *btn_registerSubRegords;
@property (weak, nonatomic) IBOutlet CustomButton2 *btn_ElectronicMR;
@property (weak, nonatomic) IBOutlet CustomButton2 *btn_RecordHistory;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Name;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *lbl_title;
@end
