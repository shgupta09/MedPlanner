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
        NSLog(@"%d",_btnMedicalRecord.frame.size.width);
        if((_btnAwareness.frame.size.width/2-20)<53){
            _btnAwareness.imageEdgeInsets = UIEdgeInsetsMake(9, _btnAwareness.frame.size.width/2-20, 20, _btnAwareness.frame.size.width/2-20);
            _btnHealthTracker.imageEdgeInsets = UIEdgeInsetsMake(9, _btnHealthTracker.frame.size.width/2-20, 20, _btnHealthTracker.frame.size.width/2-20);
            _btnMedicalRecord.imageEdgeInsets = UIEdgeInsetsMake(9, _btnMedicalRecord.frame.size.width/2-20, 20, _btnMedicalRecord.frame.size.width/2-20);
            [_btnAwareness setContentMode:UIViewContentModeCenter];
            [_btnMedicalRecord setContentMode:UIViewContentModeCenter];
            [_btnHealthTracker setContentMode:UIViewContentModeCenter];
        }
        

        [self addSubview:view];
        return self;
    }
    
    return self;
}

@end
