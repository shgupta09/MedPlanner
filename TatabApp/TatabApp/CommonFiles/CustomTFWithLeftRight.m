//
//  CustomTFWithLeftRight.m
//  TatabApp
//
//  Created by NetprophetsMAC on 1/31/18.
//  Copyright © 2018 Shagun Verma. All rights reserved.
//

#import "CustomTFWithLeftRight.h"

@implementation CustomTFWithLeftRight

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        
        self.delegate = self;
        self.tintColor = [UIColor whiteColor];
        self.layer.cornerRadius = self.bounds.size.height/2;
        self.clipsToBounds = YES;
        self.leftViewMode = UITextFieldViewModeAlways;
        UIView* paddingView = [[UIView alloc] initWithFrame:CGRectMake(0,0,50,45)];
        
        self.leftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(12.5, 10, 25, 25)]; // Set frame as per space required around icon
        self.leftImgView.contentMode =UIViewContentModeScaleAspectFit;
        [paddingView addSubview:self.leftImgView];
        self.leftView = paddingView;
        self.rightImgView = [[UIImageView alloc] initWithFrame:CGRectMake(12.5, 10, 25, 25)]; // Set frame as per space required around icon
        self.rightImgView.contentMode =UIViewContentModeScaleAspectFit;
        [paddingView addSubview:self.rightImgView];
        self.rightView = paddingView;
        
        self.backgroundColor = [CommonFunction colorWithHexString:@"#00b1dd"];
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
        self.textColor = [UIColor whiteColor];
        
        
    }
    return self;
}


@end
