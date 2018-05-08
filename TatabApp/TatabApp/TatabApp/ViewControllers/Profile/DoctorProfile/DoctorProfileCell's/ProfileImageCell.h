//
//  ProfileImageCell.h
//  TatabApp
//
//  Created by shubham gupta on 5/6/18.
//  Copyright © 2018 Shagun Verma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileImageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *txt_Name;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Title;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UIImageView *img_Profile;
@end
