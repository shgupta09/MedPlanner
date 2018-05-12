//
//  CustomTextField.m
//  ShreeAirlines
//
//  Created by NetprophetsMAC on 4/19/17.
//  Copyright © 2017 Netprophets. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        
        self.delegate = self;
        self.layer.cornerRadius = self.bounds.size.height/2;
        self.clipsToBounds = YES;
       self.leftViewMode = UITextFieldViewModeAlways;
        UIView* paddingView = [[UIView alloc] initWithFrame:CGRectMake(0,0,50,45)];
                                                                       
        self.leftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(12.5, 10, 25, 25)]; // Set frame as per space required around icon
        self.leftImgView.contentMode =UIViewContentModeScaleAspectFit;
        [paddingView addSubview:self.leftImgView];
        self.leftView = paddingView;

        self.backgroundColor = [CommonFunction colorWithHexString:@"#00b1dd"];
         self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
        self.textColor = [UIColor whiteColor];
        self.tintColor = [UIColor whiteColor];
        if ([CommonFunction isEnglishSelected]) {
            self.textAlignment = NSTextAlignmentLeft;
        }else{
            self.textAlignment = NSTextAlignmentRight;
        }
        
    }
    return self;
}

-(void)setPlaceholderWithColor:(NSString *)placeholder{
        self.placeholder = placeholder;
      self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
}



@end
