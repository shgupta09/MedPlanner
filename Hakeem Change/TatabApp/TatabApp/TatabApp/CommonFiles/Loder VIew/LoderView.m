//
//  LoderView.m
//  ShreeAirlines
//
//  Created by NetprophetsMAC on 4/23/17.
//  Copyright © 2017 Netprophets. All rights reserved.
//

#import "LoderView.h"

@implementation LoderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"LoderView" owner:self options:nil] objectAtIndex:0];
        view.frame = frame;
        view.userInteractionEnabled = true;
        [_activityIndicator startAnimating];
        [self addSubview:view];
      
        return self;
    }
    
    return self;
}


@end
