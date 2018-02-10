//
//  CustomButtonWithoutBorder.m
//  TatabApp
//
//  Created by Shagun Verma on 05/02/18.
//  Copyright © 2018 Shagun Verma. All rights reserved.
//

#import "CustomButtonWithoutBorder.h"

@implementation CustomButtonWithoutBorder

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = [[UIColor whiteColor] CGColor];
        self.tintColor = [CommonFunction colorWithHexString:@"7ac430"];
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = self.frame.size.height/2;
        self.layer.masksToBounds = true;
    }
    return self;
}

@end
