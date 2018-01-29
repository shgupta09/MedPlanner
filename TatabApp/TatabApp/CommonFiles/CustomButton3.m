//
//  CustomButton3.m
//  TatabApp
//
//  Created by NetprophetsMAC on 1/12/18.
//  Copyright © 2018 Shagun Verma. All rights reserved.
//

#import "CustomButton3.h"

@implementation CustomButton3
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.backgroundColor = [CommonFunction colorWithHexString:@"45AED4"];
        self.tintColor = [UIColor whiteColor];
        self.layer.cornerRadius = self.frame.size.height/2;
        self.layer.masksToBounds = true;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        //        [self setImage: [UIImage imageNamed:@"icon-map-location"] forState:UIControlStateNormal];
        [self setImageEdgeInsets:UIEdgeInsetsMake(10, -10, 10,100)];
        //        [self setTitleEdgeInsets:UIEdgeInsetsMake(0
        //                                                  ,-100,0,0)];
        [self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    }
    return self;
}

@end
