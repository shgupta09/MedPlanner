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
@property (weak, nonatomic) IBOutlet UIButton *btnSelectType;
@property (weak, nonatomic) IBOutlet CustomTextField *txtComments;
@property (weak, nonatomic) IBOutlet CustomButton *btnWeightPopup;
@property (weak, nonatomic) IBOutlet CustomButton *btnReadingPopup;
<<<<<<< HEAD
=======
//@property (weak, nonatomic) IBOutlet CustomTextField *txtComments;
>>>>>>> cf43df7af86cc2086feaffa85bb3a0d496884b16

@end
