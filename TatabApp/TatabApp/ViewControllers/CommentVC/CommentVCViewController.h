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
@end
