//
//  CommentTableViewCell.m
//  TatabApp
//
//  Created by Shagun Verma on 06/02/18.
//  Copyright © 2018 Shagun Verma. All rights reserved.
//

#import "CommentTableViewCell.h"

@implementation CommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    if ([CommonFunction isEnglishSelected]) {
        self.lblComment.textAlignment = NSTextAlignmentLeft;
    }else{
        self.lblComment.textAlignment = NSTextAlignmentRight;
    }
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
