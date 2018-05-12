//
//  RegisterViewController.h
//  TatabApp
//
//  Created by Shagun Verma on 23/09/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController<UITextFieldDelegate>
//Language
@property (weak, nonatomic) IBOutlet UILabel *lbl_create;
@property (weak, nonatomic) IBOutlet CustomButton *btn_Continue;
@property (weak, nonatomic) IBOutlet UIButton *btnFemale;
@property (weak, nonatomic) IBOutlet UIButton *btnMAle;
@end
