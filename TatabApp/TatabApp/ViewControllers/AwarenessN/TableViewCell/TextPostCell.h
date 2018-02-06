//
//  TextPostCell.h
//  TatabApp
//
//  Created by NetprophetsMAC on 1/12/18.
//  Copyright © 2018 Shagun Verma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextPostCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *viewForImage;
@property (weak, nonatomic) IBOutlet UIImageView *doctorImageView;
@property (weak, nonatomic) IBOutlet UIImageView *clinicImageView;
@property (weak, nonatomic) IBOutlet UILabel *lbl_DoctorName;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Content;
@property (weak, nonatomic) IBOutlet UIButton *btn_Comment;
@property (weak, nonatomic) IBOutlet UIButton *btn_Share;
@property (weak, nonatomic) IBOutlet UIButton *btn_Like;
@property (weak, nonatomic) IBOutlet UILabel *lbl_ShareCount;
@property (weak, nonatomic) IBOutlet UILabel *lbl_CommentCount;
@property (weak, nonatomic) IBOutlet UILabel *lbl_LikeCount;
@property (weak, nonatomic) IBOutlet UIButton *profileContent;
@property (weak, nonatomic) IBOutlet UIView *seperator_View1;

@end
