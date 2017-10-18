//
//  LoderView.h
//  ShreeAirlines
//
//  Created by NetprophetsMAC on 4/23/17.
//  Copyright © 2017 Netprophets. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoderView : UIView
@property (strong, nonatomic) IBOutlet UIView *view;

@property (weak, nonatomic) IBOutlet UILabel *lbl_title;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


@end
