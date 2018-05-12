//
//  CommentTableViewCell.h
//  TatabApp
//
//  Created by Shagun Verma on 06/02/18.
//  Copyright © 2018 Shagun Verma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblComment;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewUser;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewType;
@property (weak, nonatomic) IBOutlet UIView *lowerSeperatorView;

@end
