//
//  RCDoctor4.h
//  TatabApp
//
//  Created by NetprophetsMAC on 10/9/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCDoctor4 : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *captureBtn;
@property (weak, nonatomic) IBOutlet CustomTextField *txt_IBAN;
@property (weak, nonatomic) IBOutlet CustomTextField *txt_ConfirmIban
;
@property (weak, nonatomic) IBOutlet CustomTextField *txt_photo;

@property (weak, nonatomic) IBOutlet UIButton *btn_Terms;
@property (strong ,nonatomic)NSMutableDictionary *parameterDict;

//Language

@property (weak, nonatomic) IBOutlet UILabel *lbl_Payment;
@property (weak, nonatomic) IBOutlet UIButton *btn_TesmSelection;
@property (weak, nonatomic) IBOutlet CustomButton *btn_CompleteRegistration;
//Language

@end
