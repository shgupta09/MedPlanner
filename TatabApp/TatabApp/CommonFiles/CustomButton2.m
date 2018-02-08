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
//        self.titleLabel.adjustsFontSizeToFitWidth = true;
//        self.titleLabel.lineBreakMode = NSLineBreakByClipping;
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = self.frame.size.height/2;
        self.layer.masksToBounds = true;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
//        [self setImage: [UIImage imageNamed:@"icon-map-location"] forState:UIControlStateNormal];
        [self setImageEdgeInsets:UIEdgeInsetsMake(10, -10, 10,30)];
//        [self setTitleEdgeInsets:UIEdgeInsetsMake(0
//                                                  ,-100,0,0)];
        [self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    }
    return self;
}

@end
