//
//  RCDoctor1.h
//  TatabApp
//
//  Created by shubham gupta on 10/8/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCDoctor1 : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnFemale;
@property (weak, nonatomic) IBOutlet CustomTextField *txtName;
@property (weak, nonatomic) IBOutlet CustomTextField *txtMobile;

@property (weak, nonatomic) IBOutlet CustomTextField *txtEmail;
@property (weak, nonatomic) IBOutlet CustomTextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnMAle;
@end
