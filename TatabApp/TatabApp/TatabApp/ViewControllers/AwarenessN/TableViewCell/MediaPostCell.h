//
//  MediaPostCell.h
//  TatabApp
//
//  Created by NetprophetsMAC on 1/12/18.
//  Copyright © 2018 Shagun Verma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MediaPostCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *profileBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imgView_Content;
@property (weak, nonatomic) IBOutlet UIView *viewForImage;
@property (weak, nonatomic) IBOutlet UIImageView *doctorImageView;
@property (weak, nonatomic) IBOutlet UIImageView *clinicImageView;
@property (weak, nonatomic) IBOutlet UILabel *lbl_DoctorName;
@property (weak, nonatomic) IBOutlet UIButton *btn_Comment;
@property (weak, nonatomic) IBOutlet UIButton *btn_Share;
@property (weak, nonatomic) IBOutlet UIButton *btn_Like;
@property (weak, nonatomic) IBOutlet UILabel *lbl_ShareCount;
@property (weak, nonatomic) IBOutlet UILabel *lbl_CommentCount;
@property (weak, nonatomic) IBOutlet UIButton *contentBtn;
@property (weak, nonatomic) IBOutlet UILabel *lbl_LikeCount;
@property (weak, nonatomic) IBOutlet UIView *imgViewContentContainer;
@end
