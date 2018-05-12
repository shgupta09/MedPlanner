//
//  DoctorListEMRLogTableViewCell.m
//  TatabApp
//
//  Created by Shagun Verma on 28/12/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//

#import "DoctorListEMRLogTableViewCell.h"

@implementation DoctorListEMRLogTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    if ([CommonFunction isEnglishSelected]) {
        self.lblName.textAlignment = NSTextAlignmentLeft;
        self.lblCategoryName.textAlignment = NSTextAlignmentLeft;
    }else{
        self.lblName.textAlignment = NSTextAlignmentRight;
        self.lblCategoryName.textAlignment = NSTextAlignmentRight;

    }
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)btnDetailsClicked:(id)sender {
    [_delegate btnDetailsTapped:sender];
}
- (IBAction)btnFollowClicked:(id)sender {
   // [_delegate btnFollowTapped:sender];
//    if (_btnfollowUp.isSelected == false) {
//        [_btnfollowUp setSelected:true];
//    }else{
//        [_btnfollowUp setSelected:false];
//    }
   
}
- (IBAction)btnPrescriptionClicked:(id)sender {
    [_delegate btnPrescriptionTapped:sender];
}

@end
