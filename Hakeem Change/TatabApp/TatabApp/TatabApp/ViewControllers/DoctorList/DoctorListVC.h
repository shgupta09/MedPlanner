//
//  DoctorListVC.h
//  TatabApp
//
//  Created by shubham gupta on 10/14/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoctorListVC : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tbl_View;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *lbl_title;
@property (nonatomic,strong)AwarenessCategory *awarenessObj;
@property (nonatomic,strong)RegistrationDpendency *selectedDependent;
@property (nonatomic) BOOL isDependent;
@property (weak, nonatomic) IBOutlet UILabel *lbl_No_Data;

@end
