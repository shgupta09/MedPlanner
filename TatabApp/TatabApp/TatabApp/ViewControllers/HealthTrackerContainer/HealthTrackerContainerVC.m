//
//  HealthTrackerContainerVC.m
//  TatabApp
//
//  Created by Shagun Verma on 07/01/18.
//  Copyright © 2018 Shagun Verma. All rights reserved.
//

#import "HealthTrackerContainerVC.h"

@interface HealthTrackerContainerVC ()
{
      CustomAlert *alertObj;
    
}
@end

@implementation HealthTrackerContainerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    alertObj = [[CustomAlert alloc] initWithFrame:self.view.frame];
   
    if (_isdependant) {
        [_lblPatientName setText:[_dependant.name capitalizedString]];
        [_lblgender setText:_dependant.gender];
        [_lblbirthDate setText:_dependant.birthDay];
    }else{
        [_lblPatientName setText:[_patient.name capitalizedString]];
        [_lblgender setText:_patient.gender];
        [_lblbirthDate setText:_patient.dob];
        
    }
   
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidLayoutSubviews{
    alertObj.frame = self.view.frame;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - btn Actions
- (IBAction)btnAction_instructions:(id)sender {
    
    [self addAlertWithTitle:AlertKey andMessage:@"For more instructions about using TatabApp tracker please visit www.tatabapp.com" isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:OK_Btn secondButtonTitle:nil image:Warning_Key_For_Image];
}

- (IBAction)btnBackClicked:(id)sender {
    
    [self.navigationController dismissViewControllerAnimated:false completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PopBackNow" object:nil];
    }];}
- (IBAction)btnEMRClcked:(id)sender {
    
    [self dismissViewControllerAnimated:false completion:nil];
    
}

- (IBAction)btnWeightClicked:(id)sender {

    WeightReportViewController* vc = [[WeightReportViewController alloc] initWithNibName:@"WeightReportViewController" bundle:nil];
    
    if (!_isdependant){
        vc.isdependant = false;
        vc.patient = _patient;
    }
    else
    {
        vc.isdependant = true;
        vc.patient = _patient;
        vc.dependant = _dependant;
    }
    
    [self.navigationController pushViewController:vc animated:false];
    
}
- (IBAction)btnBloodPressureClicked:(id)sender {

    PressureReportViewController* vc = [[PressureReportViewController alloc] initWithNibName:@"PressureReportViewController" bundle:nil];
    if (!_isdependant){
        vc.isdependant = false;
        vc.patient = _patient;
    }
    else
    {
        vc.isdependant = true;
        vc.patient = _patient;
        vc.dependant = _dependant;
    }
    [self.navigationController pushViewController:vc animated:false];

}
- (IBAction)btnFeverClicked:(id)sender {
    FeverReportViewController* vc = [[FeverReportViewController alloc] initWithNibName:@"FeverReportViewController" bundle:nil];
    if (!_isdependant){
        vc.isdependant = false;
        vc.patient = _patient;
    }
    else
    {
        vc.isdependant = true;
        vc.patient = _patient;
        vc.dependant = _dependant;
    }
    [self.navigationController pushViewController:vc animated:false];

}
- (IBAction)btnBloodSugar:(id)sender {

    SugarReportViewController* vc = [[SugarReportViewController alloc] initWithNibName:@"SugarReportViewController" bundle:nil];
    if (!_isdependant){
        vc.isdependant = false;
        vc.patient = _patient;
    }
    else
    {
        vc.isdependant = true;
        vc.patient = _patient;
        vc.dependant = _dependant;
    }
    [self.navigationController pushViewController:vc animated:false];
}
#pragma mark- Custom Loder
-(void)addAlertWithTitle:(NSString *)titleString andMessage:(NSString *)messageString isTwoButtonNeeded:(BOOL)isTwoBUtoonNeeded firstbuttonTag:(NSInteger)firstButtonTag secondButtonTag:(NSInteger)secondButtonTag firstbuttonTitle:(NSString *)firstButtonTitle secondButtonTitle:(NSString *)secondButtonTitle image:(NSString *)imageName{
    [CommonFunction resignFirstResponderOfAView:self.view];
    alertObj.lbl_title.text = titleString;
    alertObj.lbl_message.text = messageString;
    alertObj.iconImage.image = [UIImage imageNamed:imageName];
    if (isTwoBUtoonNeeded) {
        alertObj.btn1.hidden = true;
        [alertObj.btn2 setTitle:firstButtonTitle forState:UIControlStateNormal];
        [alertObj.btn3 setTitle:secondButtonTitle forState:UIControlStateNormal];
        alertObj.btn2.tag = firstButtonTag;
        alertObj.btn3.tag = secondButtonTag;
        [alertObj.btn2 addTarget:self action:@selector(btnActionForCustomAlert:) forControlEvents:UIControlEventTouchUpInside];
        [alertObj.btn3 addTarget:self action:@selector(btnActionForCustomAlert:) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
        alertObj.btn2.hidden = true;
        alertObj.btn3.hidden = true;
        alertObj.btn1.tag = firstButtonTag;
        [alertObj.btn1 setTitle:firstButtonTitle forState:UIControlStateNormal];
        [alertObj.btn1 addTarget:self
                          action:@selector(btnActionForCustomAlert:) forControlEvents:UIControlEventTouchUpInside];
    }
    alertObj.transform = CGAffineTransformMakeScale(0.01, 0.01);
    if (![alertObj isDescendantOfView:self.view]) {
        [self.view addSubview:alertObj];
    }
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        // animate it to the identity transform (100% scale)
        alertObj.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        // if you want to do something once the animation finishes, put it here
    }];
    
    
}
-(void)removeAlert{
    if ([alertObj isDescendantOfView:self.view]) {
        [alertObj removeFromSuperview];
    }
    
}

-(IBAction)btnActionForCustomAlert:(id)sender{
    switch (((UIButton *)sender).tag) {
        case Tag_For_Remove_Alert:
            [self removeAlert];
            break;
            
        default:
            
            break;
    }
}


@end
