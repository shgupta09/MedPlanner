//
//  VideoListTableViewCell.m
//  TatabApp
//
//  Created by Shagun Verma on 03/10/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//

#import "VideoListTableViewCell.h"

@implementation VideoListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _lblVideoHeading.textColor = [CommonFunction colorWithHexString:COLORCODE_FOR_TEXTFIELD];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
