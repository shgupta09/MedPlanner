//
//  OTPVc.h
//  TatabApp
//
//  Created by NetprophetsMAC on 3/27/18.
//  Copyright © 2018 Shagun Verma. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol OTPDelegate <NSObject>
@optional
- (void)otpDelegateMethodWithnumber:(NSString *)number;
// ... other methods here
@end
@interface OTPVc : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet CustomTextField *txt_Number;
@property (weak, nonatomic) IBOutlet CustomTextField *txt_verificationNum;
@property (strong ,nonatomic)NSMutableDictionary *parameterDict;
@property (nonatomic, weak) id <OTPDelegate> delegateProperty;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Title;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Theory;
@property (weak, nonatomic) IBOutlet CustomButton *btnResend;
@property (weak, nonatomic) IBOutlet CustomButton *btn_Send;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Default;

@end
