//
//  SelectUserTableViewCell.h
//  TatabApp
//
//  Created by Shagun Verma on 27/01/18.
//  Copyright © 2018 Shagun Verma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectUserTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbl_name;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sideImageView;
@property (weak, nonatomic) IBOutlet UIButton *btn_Cross;

@end
