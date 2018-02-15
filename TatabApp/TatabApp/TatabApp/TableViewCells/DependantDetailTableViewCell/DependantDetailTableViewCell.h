//
//  DependantDetailTableViewCell.h
//  TatabApp
//
//  Created by Shagun Verma on 23/09/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DependantDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblSerialNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblGender;
@property (weak, nonatomic) IBOutlet UILabel *lblBirthday;

@end
