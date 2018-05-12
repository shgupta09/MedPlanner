//
//  RegisterCompleteViewController.h
//  TatabApp
//
//  Created by Shagun Verma on 23/09/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPHandler.h"
#import "CustomTFWithLeftRight.h"

@interface RegisterCompleteViewController : UIViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,XMPPStreamDelegate>
@property (weak, nonatomic) IBOutlet CustomTFWithLeftRight *txt_Relationship;
@property(nonatomic,strong)NSMutableDictionary *parameterDict;
@property (weak, nonatomic) IBOutlet UIButton *btn_Terms;

//Language

@property (weak, nonatomic) IBOutlet UILabel *lbl_PersonalDetails;
@property (weak, nonatomic) IBOutlet CustomButton *btnAddDependent;
@property (weak, nonatomic) IBOutlet UIButton *btn_Term;
@property (weak, nonatomic) IBOutlet CustomButton *btn_CompleteRegistration;
@property (weak, nonatomic) IBOutlet UIButton *btn_Male;
@property (weak, nonatomic) IBOutlet UIButton *btn_Female;

@property (weak, nonatomic) IBOutlet CustomButton *btn_ConfirmAdd;

@end
