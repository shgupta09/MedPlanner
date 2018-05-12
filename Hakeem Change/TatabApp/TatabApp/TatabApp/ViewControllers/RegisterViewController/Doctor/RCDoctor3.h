//
//  RCDoctor3.h
//  TatabApp
//
//  Created by NetprophetsMAC on 10/9/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCDoctor3 : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet CustomTextField *txt_Sepciality;
@property (weak, nonatomic) IBOutlet CustomTextField *txt_currentGrade;
@property (weak, nonatomic) IBOutlet CustomTextField *txt_subSpeciality;
@property (weak, nonatomic) IBOutlet CustomTextField *txtClassification;
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (strong, nonatomic) IBOutlet UIView *popUpView;
@property (weak, nonatomic) IBOutlet CustomTextField *txt_hospitalName;
@property (weak, nonatomic) IBOutlet CustomTextField *txt_workedSince;
@property (weak, nonatomic) IBOutlet CustomTextField *txt_resignedSince;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tbl_Height;
@property (strong ,nonatomic)NSMutableDictionary *parameterDict;



//Language
@property (weak, nonatomic) IBOutlet UILabel *lbl_CV;
@property (weak, nonatomic) IBOutlet CustomButton *btn_Experience;
@property (weak, nonatomic) IBOutlet CustomButton *btn_Continue;
@property (weak, nonatomic) IBOutlet CustomButton *btn_ConfirmAdd;

@end
