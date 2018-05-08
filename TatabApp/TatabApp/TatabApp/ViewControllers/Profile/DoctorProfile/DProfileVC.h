//
//  DProfileVC.h
//  TatabApp
//
//  Created by shubham gupta on 5/6/18.
//  Copyright © 2018 Shagun Verma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DProfileVC : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lbl_Title;
@property (weak, nonatomic) IBOutlet UITableView *tblList;
@property (weak, nonatomic) IBOutlet UIButton *btn_Save;
@property (strong, nonatomic) IBOutlet UIView *popUpExperience;
@property (strong, nonatomic) IBOutlet UIView *popUpEducation;
@property (strong, nonatomic) IBOutlet UIView *popUpAbout;
@property (weak, nonatomic) IBOutlet CustomTextField *txt_hospitalName;
@property (weak, nonatomic) IBOutlet CustomTextField *txt_workedSince;
@property (weak, nonatomic) IBOutlet CustomTextField *txt_resignedSince;
@property (weak, nonatomic) IBOutlet CustomTextField *txt_description;
@property (weak, nonatomic) IBOutlet CustomButton *btn_ConfirmAdd;
@property (weak, nonatomic) IBOutlet CustomTextField *txt_UniversityName;
@property (weak, nonatomic) IBOutlet CustomTextField *txt_Universitydescription;
@property (weak, nonatomic) IBOutlet UITextView *txt_about;

@property (weak, nonatomic) IBOutlet CustomButton *btn_ConfirmAddEducation;
@property (weak, nonatomic) IBOutlet CustomButton *btn_ConfirmAddAbout;
@property(nonatomic) BOOL isLofinUser;
@property (strong, nonatomic)Specialization *doctorObj;

@end
