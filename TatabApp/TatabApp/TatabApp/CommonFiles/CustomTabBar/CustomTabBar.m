//
//  CustomTabBar.m
//  TatabApp
//
//  Created by shubham gupta on 2/10/18.
//  Copyright © 2018 Shagun Verma. All rights reserved.
//

#import "CustomTabBar.h"

@implementation CustomTabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"CustomTabBar" owner:self options:nil] objectAtIndex:0];
        view.frame = CGRectMake(0, self.view.frame.size.height-49, self.view.frame.size.width, 49);
        view.userInteractionEnabled = true;
        [self addSubview:view];
        return self;
    }
    
    return self;
}

@end
