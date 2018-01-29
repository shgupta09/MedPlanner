//
//  NewAwareVC.h
//  TatabApp
//
//  Created by shubham gupta on 1/11/18.
//  Copyright © 2018 Shagun Verma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextPostCell.h"
@interface NewAwareVC : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *viewToClip;
@property (weak, nonatomic) IBOutlet UIView *viewToClip2;
@property (weak, nonatomic) IBOutlet UIImageView *imgView_Profile;
@property (weak, nonatomic) IBOutlet UILabel *lbl_NoData;

@property (weak, nonatomic) IBOutlet UITextView *txt_txtView;
@property (weak, nonatomic) IBOutlet UITextField *txt_Search;
@property (weak, nonatomic) IBOutlet UITableView *tbl_View;
@property (weak, nonatomic) IBOutlet UIButton *btn_Post;
@property (strong, nonatomic) IBOutlet UIView *popUpView;
@property (strong, nonatomic) IBOutlet UIView *popUpView2;
@property (weak, nonatomic) IBOutlet UIButton *btnClearSearch;
@property (weak, nonatomic) IBOutlet UILabel *lbl_SearchedText;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tbl_Constraint;

@end
