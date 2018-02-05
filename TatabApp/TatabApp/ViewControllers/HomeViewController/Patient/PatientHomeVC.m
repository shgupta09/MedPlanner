//
//  PatientHomeVC.m
//  TatabApp
//
//  Created by shubham gupta on 10/14/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//

#import "PatientHomeVC.h"

@interface PatientHomeVC (){
    SWRevealViewController *revealController;
    BOOL isOpen;
    UIView *tempView;
    UITapGestureRecognizer *singleFingerTap;
}

@end

@implementation PatientHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData];
    // Do any additional setup after loading the view from its nib.
}
-(void)setData{
//    [_btn_MedicalConsultant setImage:[UIImage imageNamed:@"medicalConsultation"] forState:UIControlStateNormal];
//    [_btn_ElectronicMR setImage:[UIImage imageNamed:@"EMR-Icons"] forState:UIControlStateNormal];
//    [_btn_registerSubRegords setImage:[UIImage imageNamed:@"section-children"] forState:UIControlStateNormal];
//    [_btn_RecordHistory setImage:[UIImage imageNamed:@"queue"] forState:UIControlStateNormal];
    [_btn_MedicalConsultant setImage:[UIImage imageNamed:@"medicalConsultation"] forState:UIControlStateNormal];
    [_btn_ElectronicMR setImage:[UIImage imageNamed:@"EMR-Icons"] forState:UIControlStateNormal];
    [_btn_registerSubRegords setImage:[UIImage imageNamed:@"mndDependants"] forState:UIControlStateNormal];
    [_btn_RecordHistory setImage:[UIImage imageNamed:@"requestsHistory"] forState:UIControlStateNormal];
    _lbl_Name.text = [CommonFunction getValueFromDefaultWithKey:loginfirstname];
    isOpen = false;
    revealController = [self revealViewController];
    singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                              action:@selector(handleSingleTap:)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification)
                                                 name:@"LogoutNotification"
                                               object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:true];
    self.navigationController.navigationBar.hidden = true;
    isOpen = false;
}
//The event handling method
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    self.navigationController.navigationBar.userInteractionEnabled = true;
    if (isOpen){
        [revealController revealToggle:nil];
        [tempView removeGestureRecognizer:singleFingerTap];
        [tempView removeFromSuperview];
        isOpen = false;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark- SWRevealViewController

- (IBAction)revealAction:(id)sender {
    //    self.view.userInteractionEnabled = false;
    self.navigationController.navigationBar.userInteractionEnabled = true;
    
    
    if (isOpen) {
        
        [revealController revealToggle:nil];
        
        [tempView removeGestureRecognizer:singleFingerTap];
        [tempView removeFromSuperview];
        isOpen = false;
    }
    else{
        
        [revealController revealToggle:nil];
        tempView.frame  =CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height);
        [tempView addGestureRecognizer:singleFingerTap];
        [self.view addSubview:tempView];
        isOpen = true;
    }
    
}
-(void)receiveNotification{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Logout Successfully" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UserSelectViewController* vc = [[UserSelectViewController alloc] initWithNibName:@"UserSelectViewController" bundle:nil];
        vc.isRegistrationSelection = false;
        UINavigationController* navCon = [[UINavigationController alloc] initWithRootViewController:vc];
        vc.navigationController.navigationBarHidden = true;
        [self presentViewController:navCon animated:YES completion:nil];
    }];
    [alertController addAction:ok];
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark- Btn Action
- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}
- (IBAction)btn_MedicalConsultaionAction:(id)sender {
    AwarenessCategoryViewController *vc = [[AwarenessCategoryViewController alloc]initWithNibName:@"AwarenessCategoryViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:true];
    
    
}
- (IBAction)btnAction_manageDependents:(id)sender {
    
    ChooseDependantViewController* vc ;
    vc = [[ChooseDependantViewController alloc] initWithNibName:@"ChooseDependantViewController" bundle:nil];
    vc.patientID = [CommonFunction getValueFromDefaultWithKey:loginuserId];
    vc.classObj = self;
    vc.isManageDependants = true;
    [self.navigationController pushViewController:vc animated:true];
    
    
}
- (IBAction)btnAction_MedicalReports:(id)sender {
    ChooseDependantViewController* vc ;
    vc = [[ChooseDependantViewController alloc] initWithNibName:@"ChooseDependantViewController" bundle:nil];
    vc.patientID = [CommonFunction getValueFromDefaultWithKey:loginuserId];
    vc.classObj = self;
    vc.isManageDependants = false;

    [self.navigationController pushViewController:vc animated:true];
    
    
}
- (IBAction)btnAction_CaseHistory:(id)sender {
    
    
}

@end
