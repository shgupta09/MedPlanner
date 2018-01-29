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

@end
