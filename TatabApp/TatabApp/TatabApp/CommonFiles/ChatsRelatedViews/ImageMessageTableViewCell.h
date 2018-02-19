//
//  ImageMessageTableViewCell.h
//  TatabApp
//
//  Created by Shagun Verma on 20/11/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"
@interface ImageMessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *lbTime;
@property (retain, nonatomic) NSURL* url;
@property (strong, nonatomic) Message *message;

@end
