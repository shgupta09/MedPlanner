//
//  HomeCell.h
//  TatabApp
//
//  Created by shubham gupta on 10/11/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *lbl_name;
@property (weak, nonatomic) IBOutlet UILabel *lbl_specialization;
@property (weak, nonatomic) IBOutlet UILabel *lbl_sub_specialization;
@property (weak, nonatomic) IBOutlet UIButton *btn_Profile;

@property (weak, nonatomic) IBOutlet UIButton *btn_Payment;

@end
