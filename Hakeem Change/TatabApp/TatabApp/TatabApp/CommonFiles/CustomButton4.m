//
//  CustomButton4.m
//  TatabApp
//
//  Created by NetprophetsMAC on 1/19/18.
//  Copyright © 2018 Shagun Verma. All rights reserved.
//

#import "CustomButton4.h"

@implementation CustomButton4

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.tintColor = [CommonFunction colorWithHexString:@"45AED4"];
        self.layer.cornerRadius = self.frame.size.height/2;
        self.layer.masksToBounds = true;
        self.layer.borderWidth = 2;
        self.layer.borderColor = [CommonFunction colorWithHexString:@"45AED4"].CGColor;
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
