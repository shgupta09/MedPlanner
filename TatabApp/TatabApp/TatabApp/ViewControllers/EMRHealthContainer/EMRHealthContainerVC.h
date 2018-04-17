//
//  EMRHealthContainerVC.h
//  TatabApp
//
//  Created by Shagun Verma on 28/12/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EMRHealthContainerVC : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblPatientName;
@property (weak, nonatomic) IBOutlet UILabel *lblbirthDate;
@property (weak, nonatomic) IBOutlet UILabel *lblgender;
@property (weak, nonatomic) IBOutlet UILabel *lblChronic;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Nodata;

@property (nonatomic,strong) ChatPatient* patient;
@property (nonatomic,strong) RegistrationDpendency* dependant;
@property bool isdependant;

@end
