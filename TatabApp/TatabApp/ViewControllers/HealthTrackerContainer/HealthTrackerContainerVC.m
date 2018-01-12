//
//  HealthTrackerContainerVC.m
//  TatabApp
//
//  Created by Shagun Verma on 07/01/18.
//  Copyright © 2018 Shagun Verma. All rights reserved.
//

#import "HealthTrackerContainerVC.h"

@interface HealthTrackerContainerVC ()

@end

@implementation HealthTrackerContainerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - btn Actions
- (IBAction)btnBackClicked:(id)sender {
    
        [self.navigationController dismissViewControllerAnimated:false completion:nil];
}
- (IBAction)btnEMRClcked:(id)sender {
    
    [self dismissViewControllerAnimated:false completion:nil];
    
}

- (IBAction)btnWeightClicked:(id)sender {

    WeightReportViewController* vc = [[WeightReportViewController alloc] initWithNibName:@"WeightReportViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:false];
    
}
- (IBAction)btnBloodPressureClicked:(id)sender {

    PressureReportViewController* vc = [[PressureReportViewController alloc] initWithNibName:@"PressureReportViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:false];

}
- (IBAction)btnFeverClicked:(id)sender {
    FeverReportViewController* vc = [[FeverReportViewController alloc] initWithNibName:@"FeverReportViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:false];

}
- (IBAction)btnBloodSugar:(id)sender {

    SugarReportViewController* vc = [[SugarReportViewController alloc] initWithNibName:@"SugarReportViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:false];
}


@end
