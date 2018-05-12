//
//  CustomAlert.h
//  TatabApp
//
//  Created by shubham gupta on 10/17/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"
@interface CustomAlert : UIView
@property (strong, nonatomic) IBOutlet UIView *view;

@property (weak, nonatomic) IBOutlet UIView *roundView;
@property (weak, nonatomic) IBOutlet CustomButton *btn2;
@property (weak, nonatomic) IBOutlet CustomButton *btn1;
@property (weak, nonatomic) IBOutlet CustomButton *btn3;
@property (weak, nonatomic) IBOutlet UILabel *lbl_title;
@property (weak, nonatomic) IBOutlet UILabel *lbl_message;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@end
