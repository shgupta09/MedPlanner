//
//  RCDoctor2.h
//  TatabApp
//
//  Created by shubham gupta on 10/8/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCDoctor2 : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet CustomTextField *txt_Nationality;
@property (weak, nonatomic) IBOutlet CustomTextField *txt_Residence;
@property (weak, nonatomic) IBOutlet CustomTextField *txt_workplace;
@property (weak, nonatomic) IBOutlet CustomTextField *txt_homeLocation;
@property (weak, nonatomic) IBOutlet CustomTextField *txtPassport;
@property (strong ,nonatomic)NSMutableDictionary *parameterDict;
@end
