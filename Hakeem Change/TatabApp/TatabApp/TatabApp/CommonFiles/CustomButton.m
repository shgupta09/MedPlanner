  //
//  CustomButton.m
//  TatabApp
//
//  Created by Shagun Verma on 23/09/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = [[CommonFunction colorWithHexString:@"7ac430"] CGColor];
        self.tintColor = [CommonFunction colorWithHexString:@"7ac430"];
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = self.frame.size.height/2;
        self.layer.masksToBounds = true;
    }
    return self;
}


@end

