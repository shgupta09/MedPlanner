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

@property (weak, nonatomic) IBOutlet UITextField *txt_Search;
@property (weak, nonatomic) IBOutlet UITableView *tbl_View;
@property (weak, nonatomic) IBOutlet UIButton *btn_Post;
@property (strong, nonatomic) IBOutlet UIView *popUpView;
@property (strong, nonatomic) IBOutlet UIView *popUpView2;
@end