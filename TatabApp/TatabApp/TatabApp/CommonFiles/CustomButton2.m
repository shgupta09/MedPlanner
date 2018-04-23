//
//  CustomButton2.m
//  TatabApp
//
//  Created by shubham gupta on 10/14/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//

#import "CustomButton2.h"

@implementation CustomButton2

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = [[CommonFunction colorWithHexString:Primary_GreenColor] CGColor];
        self.tintColor = [CommonFunction colorWithHexString:Primary_GreenColor];
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = self.frame.size.height/2;
        self.layer.masksToBounds = true;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
        self.titleLabel.numberOfLines = 0;
        [self setImageEdgeInsets:UIEdgeInsetsMake(17, 0, 17,20)];
        if ([[CommonFunction getValueFromDefaultWithKey:Selected_Language] isEqualToString:Selected_Language_English]) {
            [self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];

        }else{
            [self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];

        }
        
    }
    return self;
}

@end
