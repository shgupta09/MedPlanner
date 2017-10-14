//
//  DependantDetailTableViewCell.m
//  TatabApp
//
//  Created by Shagun Verma on 23/09/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//

#import "DependantDetailTableViewCell.h"

@implementation DependantDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _lblName.backgroundColor = [UIColor clearColor];
    _lblGender.backgroundColor = [UIColor clearColor];
    _lblBirthday.backgroundColor = [UIColor clearColor];
    _lblSerialNumber.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
