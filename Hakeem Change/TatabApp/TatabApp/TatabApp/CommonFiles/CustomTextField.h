//
//  CustomTextField.h
//  ShreeAirlines
//
//  Created by NetprophetsMAC on 4/19/17.
//  Copyright © 2017 Netprophets. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTextField : UITextField<UITextFieldDelegate>
-(void)setPlaceholderWithColor:(NSString *)placeholder;
@property (strong,nonatomic) UIImageView* leftImgView;
@end
