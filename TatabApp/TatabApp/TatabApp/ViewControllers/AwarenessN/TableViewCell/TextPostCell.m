//
//  TextPostCell.m
//  TatabApp
//
//  Created by NetprophetsMAC on 1/12/18.
//  Copyright © 2018 Shagun Verma. All rights reserved.
//

#import "TextPostCell.h"

@implementation TextPostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    if ([CommonFunction isEnglishSelected]) {
        self.lbl_Content.textAlignment = NSTextAlignmentLeft;
    }else{
         self.lbl_Content.textAlignment = NSTextAlignmentRight;
    }
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
