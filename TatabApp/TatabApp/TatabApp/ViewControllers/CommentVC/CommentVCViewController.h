//
//  CommentVCViewController.h
//  TatabApp
//
//  Created by NetprophetsMAC on 2/6/18.
//  Copyright © 2018 Shagun Verma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentVCViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tbl_View;
@property(strong,nonatomic) NSString *postId;
@property (weak, nonatomic) IBOutlet UILabel *lbl_NoComment;
@property (weak, nonatomic) IBOutlet UIView *noCommentSeperator;
@property(strong,nonatomic) PostData *postObj;
@property (weak, nonatomic) IBOutlet UILabel *lblLikesCount;
@property (weak, nonatomic) IBOutlet UILabel *lblCommentCount;
@property (weak, nonatomic) IBOutlet UILabel *lblShareCount;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldComment;
@property (weak, nonatomic) IBOutlet UILabel *lblPostDataContent;
@property (weak, nonatomic) IBOutlet UILabel *lblPostDataTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewPostDataUser;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewPostDataType;
@property (weak, nonatomic) IBOutlet UIButton *btnSend;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewContent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cons_imgViewHeiht;
@property (weak, nonatomic) IBOutlet UILabel *lbl_title;

@end
