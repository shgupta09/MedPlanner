//
//  CustomTFWithLeftRight.h
//  TatabApp
//
//  Created by NetprophetsMAC on 1/31/18.
//  Copyright © 2018 Shagun Verma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTFWithLeftRight : UITextField
@property (strong,nonatomic) UIImageView* leftImgView;
@property (strong,nonatomic) UIImageView* rightImgView;
-(void)setPlaceholderWithColor:(NSString *)placeholder;
@end
