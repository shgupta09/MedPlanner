//
//  HealthTrackerContainerVC.m
//  TatabApp
//
//  Created by Shagun Verma on 07/01/18.
//  Copyright © 2018 Shagun Verma. All rights reserved.
//

#import "HealthTrackerContainerVC.h"

@interface HealthTrackerContainerVC (){
      CustomAlert *alertObj;
    
  
}
@end

@implementation HealthTrackerContainerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    alertObj = [[CustomAlert alloc] initWithFrame:self.view.frame];
   
   
        [_lblPatientName setText:[_dependant.name capitalizedString]];
        [_lblgender setText:_dependant.gender];
        [_lblbirthDate setText:[CommonFunction ConvertDateTime2:_dependant.birthDay]];
    
   
    [self setLanguageData];
    [self setData];
    // Do any additional setup after loading the view from its nib.
}

-(void)setData{
     if (![[CommonFunction getValueFromDefaultWithKey:Selected_Patient_Weight] isEqualToString:@"-"]) {
    _lbl_WeightValue.text = [NSString stringWithFormat:@"%@ %@",[CommonFunction getValueFromDefaultWithKey:Selected_Patient_Weight],[Langauge getTextFromTheKey:@"Kg"]];
    _lbl_HeightValue.text = [NSString stringWithFormat:@"%@ %@",[CommonFunction getValueFromDefaultWithKey:Selected_Patient_Height],[Langauge getTextFromTheKey:@"Cm"]];
     }
}

-(void)setLanguageData{
    
    [_btn_EMR setTitle:[Langauge getTextFromTheKey:@"emr"] forState:UIControlStateNormal];
    [_btn_Health setTitle:[Langauge getTextFromTheKey:@"health_tracker"] forState:UIControlStateNormal];
  
    
    
    _lbl_title.text = [Langauge getTextFromTheKey:@"health_tracker"];
    _lbl_Weight_Report.text = [Langauge getTextFromTheKey:@"weight_report"];
    _lbl_patient.text = [Langauge getTextFromTheKey:@"patient"];
    _lbl_GenderTitle.text = [Langauge getTextFromTheKey:@"gender"];
    _lbl_Height_Title.text = [Langauge getTextFromTheKey:@"height"];
    _lbl_BirthDate.text = [Langauge getTextFromTheKey:@"birthdate"];
    _lbl_WeightTitle.text = [Langauge getTextFromTheKey:@"weight"];
    _lbl_Chronic.text = [Langauge getTextFromTheKey:@"chornic"];
    _lbl_HealthTracker.text = [Langauge getTextFromTheKey:@"health_tracker"];
    _lbl_Fever_Report.text = [Langauge getTextFromTheKey:@"fever_report"];
    _lbl_Blood_Pressure.text = [Langauge getTextFromTheKey:@"blood_pressor_report"];
    _lbl_BloodSugar.text = [Langauge getTextFromTheKey:@"blood_suger_report"];
    
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
    
    [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:@"For more instructions about using TatabApp tracker please visit www.tatabapp.com" isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Alert_Key_For_Image];
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
    
    vc.isdependant = _isdependant;
    
  
    vc.patient = _patient;
    vc.dependant = _dependant;
 
    
    [self.navigationController pushViewController:vc animated:false];
    
}
- (IBAction)btnBloodPressureClicked:(id)sender {

    PressureReportViewController* vc = [[PressureReportViewController alloc] initWithNibName:@"PressureReportViewController" bundle:nil];
   
        vc.isdependant = _isdependant;
        vc.patient = _patient;
        vc.dependant = _dependant;
  
    [self.navigationController pushViewController:vc animated:false];

}
- (IBAction)btnFeverClicked:(id)sender {
    FeverReportViewController* vc = [[FeverReportViewController alloc] initWithNibName:@"FeverReportViewController" bundle:nil];
  
        vc.isdependant = _isdependant;
        vc.patient = _patient;
        vc.dependant = _dependant;
   
    [self.navigationController pushViewController:vc animated:false];

}
- (IBAction)btnBloodSugar:(id)sender {

    SugarReportViewController* vc = [[SugarReportViewController alloc] initWithNibName:@"SugarReportViewController" bundle:nil];
   
        vc.isdependant = _isdependant;
        vc.patient = _patient;
        vc.dependant = _dependant;
  
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
        alertObj.btn2.hidden = false;
        alertObj.btn3.hidden = false;
        [alertObj.btn2 setTitle:firstButtonTitle forState:UIControlStateNormal];
        [alertObj.btn3 setTitle:secondButtonTitle forState:UIControlStateNormal];
        alertObj.btn2.tag = firstButtonTag;
        alertObj.btn3.tag = secondButtonTag;
        [alertObj.btn2 addTarget:self action:@selector(btnActionForCustomAlert:) forControlEvents:UIControlEventTouchUpInside];
        [alertObj.btn3 addTarget:self action:@selector(btnActionForCustomAlert:) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
         alertObj.btn2.hidden = true;
        alertObj.btn3.hidden = true;
        alertObj.btn1.hidden = false;
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
