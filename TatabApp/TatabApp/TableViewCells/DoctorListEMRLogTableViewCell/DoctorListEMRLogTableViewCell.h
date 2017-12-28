//
//  DoctorListEMRLogTableViewCell.h
//  TatabApp
//
//  Created by Shagun Verma on 28/12/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoctorListEMRLogTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewProfile;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblCategoryName;
@property (weak, nonatomic) IBOutlet UIButton *btnfollowUp;
@property (weak, nonatomic) IBOutlet UIButton *btnDetails;

@end
