//
//  CustomTabBar.h
//  TatabApp
//
//  Created by shubham gupta on 2/10/18.
//  Copyright © 2018 Shagun Verma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTabBar : UIView
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIButton *btnHealthTracker;
@property (weak, nonatomic) IBOutlet UIButton *btnMedicalRecord;
@property (weak, nonatomic) IBOutlet UIButton *btnAwareness;
@property (weak, nonatomic) IBOutlet UILabel *lbl_EMR;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Consultation;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Awareness;
@property (weak, nonatomic) IBOutlet UIImageView *imgTracker;
@property (weak, nonatomic) IBOutlet UIImageView *img_Cunsultation;
@property (weak, nonatomic) IBOutlet UIImageView *imgAwareness;

@end
