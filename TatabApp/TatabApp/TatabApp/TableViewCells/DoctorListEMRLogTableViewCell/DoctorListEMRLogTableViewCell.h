//
//  DoctorListEMRLogTableViewCell.h
//  TatabApp
//
//  Created by Shagun Verma on 28/12/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DoctorListEMRLogTableViewCellDelegate
- (void)btnPrescriptionTapped:(UIButton*)sender;
- (void)btnDetailsTapped:(UIButton*)sender;
- (void)btnFollowTapped:(UIButton*)sender;
@end


    
    
    

@interface DoctorListEMRLogTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *viewBack;
@property (weak, nonatomic) IBOutlet UIImageView *clinicImage;

@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewProfile;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblCategoryName;
@property (weak, nonatomic) IBOutlet UIButton *btnfollowUp;
@property (weak, nonatomic) IBOutlet UIButton *btnDetails;
@property (nonatomic, assign)   id<DoctorListEMRLogTableViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *btnPrescription;
@property (weak, nonatomic) IBOutlet UIButton *btn_Payment;
@property (weak, nonatomic) IBOutlet UIButton *btn_Profile;

@end
