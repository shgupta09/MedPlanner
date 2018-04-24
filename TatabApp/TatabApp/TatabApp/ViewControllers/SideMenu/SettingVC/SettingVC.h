//
//  SettingVC.h
//  TatabApp
//
//  Created by NetprophetsMAC on 3/20/18.
//  Copyright © 2018 Shagun Verma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingVC : UIViewController
@property (weak, nonatomic) IBOutlet UISwitch *mySwitch;


//LocalizationString
@property (weak, nonatomic) IBOutlet UILabel *lbl_Title;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Notification;


@end
