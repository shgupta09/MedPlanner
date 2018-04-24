//
//  CustomButtonWithImage.m
//  TatabApp
//
//  Created by NetprophetsMAC on 4/24/18.
//  Copyright © 2018 Shagun Verma. All rights reserved.
//

#import "CustomButtonWithImage.h"

@implementation CustomButtonWithImage{
    CGFloat spacing ;
    CGFloat insetAmount  ;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.backgroundColor = [CommonFunction colorWithHexString:@"#00b1dd"];
        self.layer.borderColor = [[UIColor whiteColor] CGColor];
        self.tintColor = [UIColor whiteColor];
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = self.frame.size.height/2;
        self.layer.masksToBounds = true;
         spacing          = 3;
         insetAmount      = 0.5 * spacing;
        self.contentHorizontalAlignment  = UIControlContentHorizontalAlignmentLeft;
        self.contentEdgeInsets = UIEdgeInsetsMake(0, insetAmount, 0, insetAmount);
        [self sizeToFit];

        if ([[CommonFunction getValueFromDefaultWithKey:Selected_Language] isEqualToString:Selected_Language_English]) {
            self.titleEdgeInsets   = UIEdgeInsetsMake(0,  - insetAmount, 0,  self.imageView.frame.size.width  + insetAmount);
            self.imageEdgeInsets   = UIEdgeInsetsMake(12, self.frame.size.width+15, 12,0);
        }else{
            self.titleEdgeInsets   = UIEdgeInsetsMake(0,  - insetAmount, 0,  self.imageView.frame.size.width  + insetAmount);
               self.imageEdgeInsets   = UIEdgeInsetsMake(12, self.frame.size.width+15, 12,0);
        }
       
    }
    return self;
}




@end
