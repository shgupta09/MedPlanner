//
//  LoginViewController.h
//  TatabApp
//
//  Created by Shagun Verma on 20/09/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButtonWithoutBorder.h"
@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrlView;
@property (weak, nonatomic) IBOutlet CustomButtonWithoutBorder *btnLogin;
@property (weak, nonatomic) IBOutlet CustomButtonWithoutBorder *btn_CreateAccount;
@property (weak, nonatomic) IBOutlet CustomButtonWithoutBorder *btn_NeedHelp;

@end
