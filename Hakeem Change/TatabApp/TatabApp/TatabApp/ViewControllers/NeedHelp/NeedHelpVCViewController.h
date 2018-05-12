
//  NeedHelpVCViewController.h
//  TatabApp
//
//  Created by shubham gupta on 5/5/18.
//  Copyright © 2018 Shagun Verma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTextField.h"
#import "CustomButton.h"
@interface NeedHelpVCViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *lbl_Title;
@property (weak, nonatomic) IBOutlet CustomTextField *txt_Email;
@property (weak, nonatomic) IBOutlet CustomTextField *txt_Mobile;
@property (weak, nonatomic) IBOutlet CustomTextField *txt_Type;
@property (weak, nonatomic) IBOutlet CustomTextField *txt_Title;
@property (weak, nonatomic) IBOutlet UITextView *txt_Description;
@property (weak, nonatomic) IBOutlet UIScrollView *scrlView;
@property (weak, nonatomic) IBOutlet CustomButton *txt_Send;
@property (nonatomic)BOOL isPushed;

@end
