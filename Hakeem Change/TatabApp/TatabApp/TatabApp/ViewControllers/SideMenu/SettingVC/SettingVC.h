//
//  SettingVC.h
//  TatabApp
//
//  Created by NetprophetsMAC on 3/20/18.
//  Copyright © 2018 Shagun Verma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButtonWithImage.h"
@interface SettingVC : UIViewController<UIPopoverPresentationControllerDelegate>
@property (weak, nonatomic) IBOutlet UISwitch *mySwitch;


//LocalizationString
@property (weak, nonatomic) IBOutlet UILabel *lbl_Title;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Notification;

@property (weak, nonatomic) IBOutlet CustomButtonWithImage *btn_Language;

@end
