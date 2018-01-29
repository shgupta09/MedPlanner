//
//  UserSelectViewController.h
//  TatabApp
//
//  Created by Shagun Verma on 23/09/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"
@interface UserSelectViewController : UIViewController
@property (weak, nonatomic) IBOutlet CustomButton *firsrBtn;
@property (weak, nonatomic) IBOutlet CustomButton *secondBtn;
@property (weak, nonatomic) IBOutlet CustomButton *btn_Back;
@property(nonatomic) BOOL isRegistrationSelection;
@end
