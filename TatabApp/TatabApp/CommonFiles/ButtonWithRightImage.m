//
//  ButtonWithRightImage.m
//  TatabApp
//
//  Created by NetprophetsMAC on 2/9/18.
//  Copyright © 2018 Shagun Verma. All rights reserved.
//

#import "ButtonWithRightImage.h"

@implementation ButtonWithRightImage

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
       [self setImage: [UIImage imageNamed:@"queue"] forState:UIControlStateNormal];
        [self setImageEdgeInsets:UIEdgeInsetsMake(10, 90, 10,10)];
         [self setTitleEdgeInsets:UIEdgeInsetsMake(0,-110,0,0)];
        [self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    }
    return self;
}

-(void)setImageNamed:(NSString *)imageName{
[self setImage: [UIImage imageNamed:@"queue"] forState:UIControlStateNormal];
}
@end
