//
//  DProfileCellType2.h
//  TatabApp
//
//  Created by shubham gupta on 5/6/18.
//  Copyright © 2018 Shagun Verma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DProfileCellType2 : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbl1;
@property (weak, nonatomic) IBOutlet UILabel *lbl2;
@property (weak, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UILabel *lbl3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lbl3_UpperConstraint;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *traillingConstraint;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;

@end
