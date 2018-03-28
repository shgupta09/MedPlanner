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
@interface OTPVc : UIViewController
@property (weak, nonatomic) IBOutlet CustomTextField *txt_Number;
@property (weak, nonatomic) IBOutlet CustomTextField *txt_verificationNum;
@property (strong ,nonatomic)NSMutableDictionary *parameterDict;
@property (nonatomic, weak) id <OTPDelegate> delegateProperty;
@end
