//
//  SugarReportViewController.h
//  TatabApp
//
//  Created by Shagun Verma on 07/01/18.
//  Copyright © 2018 Shagun Verma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BEMSimpleLineGraph/BEMSimpleLineGraphView.h>

@interface SugarReportViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *popUpView;
@property (weak, nonatomic) IBOutlet UIButton *btnFromDate;
@property (weak, nonatomic) IBOutlet UIButton *btnToDate;
@property (weak, nonatomic) IBOutlet BEMSimpleLineGraphView *graphView;
<<<<<<< HEAD
@property (weak, nonatomic) IBOutlet UIButton *btnSelectType;
@property (weak, nonatomic) IBOutlet CustomTextField *txtComments;
@property (weak, nonatomic) IBOutlet CustomButton *btnWeightPopup;
@property (weak, nonatomic) IBOutlet CustomButton *btnReadingPopup;
=======
//property (weak, nonatomic) IBOutlet CustomTextField *txtComments;
>>>>>>> db6e988e7ea5cc6efd1ad6e32cf86e88e45b1a36

@end
