//
//  VideoListTableViewCell.h
//  TatabApp
//
//  Created by Shagun Verma on 03/10/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *lblVideoHeading;
@property (weak, nonatomic) IBOutlet UILabel *lblVideoContent;

@end
