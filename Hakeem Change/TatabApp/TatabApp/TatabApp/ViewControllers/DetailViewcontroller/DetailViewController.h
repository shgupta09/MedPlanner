//
//  DetailViewController.h
//  TatabApp
//
//  Created by Shagun Verma on 30/12/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *lblDetail;
@property (weak,nonatomic) NSMutableArray* detailArray;
@property (weak,nonatomic) NSString* detailType;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Title;

@end
