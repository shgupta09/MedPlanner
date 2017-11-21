//
//  ImageMessageCell.h
//  TatabApp
//
//  Created by Shagun Verma on 21/11/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageMessageCell : UITableViewCell

@property (strong, nonatomic) Message *message;
@property (strong, nonatomic) UIButton *resendButton;
@property (strong, nonatomic) UIImageView *imgView;
-(void)updateMessageStatus;

//Estimate BubbleCell Height
-(CGFloat)height;


@end
