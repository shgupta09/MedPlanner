//
//  AwarenessCategoryTableViewCell.m
//  TatabApp
//
//  Created by Shagun Verma on 02/10/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//

#import "AwarenessCategoryTableViewCell.h"

@implementation AwarenessCategoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    self.overlayView.backgroundColor = [UIColor whiteColor];
    self.overlayView.layer.borderColor = [[CommonFunction colorWithHexString:@"7ac430"] CGColor];
    self.overlayView.tintColor = [CommonFunction colorWithHexString:@"7ac430"];
    self.overlayView.layer.borderWidth = 1;
    self.overlayView.layer.cornerRadius = self.overlayView.bounds.size.height/2;
    self.overlayView.layer.masksToBounds = true;
    self.lblName.adjustsFontSizeToFitWidth = true;
    self.lblName.lineBreakMode = NSLineBreakByClipping;
    if ([CommonFunction isEnglishSelected]) {
        self.lblName.textAlignment = NSTextAlignmentLeft;
    }else{
        self.lblName.textAlignment = NSTextAlignmentRight;
    }
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
