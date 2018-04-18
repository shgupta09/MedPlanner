//
//  HomeViewController.h
//  TatabApp
//
//  Created by Shagun Verma on 23/09/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton2.h"
@interface HomeViewController : UIViewController
@property (weak, nonatomic) IBOutlet CustomButton2 *btn_MedicalQueue;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Sep;

@property (weak, nonatomic) IBOutlet CustomButton2 *btn_ManageAwareness;
@property (weak, nonatomic) IBOutlet CustomButton2 *btn_CasesHistory;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Name;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *lbl_title;

@end
