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
    CustomAlert *alertObj;
}

@end

@implementation PatientHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData];
    alertObj = [[CustomAlert alloc] initWithFrame:self.view.frame];

    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidLayoutSubviews{
    alertObj.frame = self.view.frame;
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
    _lbl_Name.text = [[CommonFunction getValueFromDefaultWithKey:loginfirstname] capitalizedString];
    isOpen = false;
    revealController = [self revealViewController];
    singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                              action:@selector(handleSingleTap:)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification)
                                                 name:@"LogoutNotification"
                                               object:nil];
    [self setUpLanguage];
}
-(void)setUpLanguage{
    _lbl_title.text = [Langauge getTextFromTheKey:@"patient_profile"];
    [_btn_ElectronicMR setTitle:[Langauge getTextFromTheKey:@"electronic_medical_report"] forState:UIControlStateNormal];
    [_btn_registerSubRegords setTitle:[Langauge getTextFromTheKey:@"manage_dependents"] forState:UIControlStateNormal];
    [_btn_MedicalConsultant setTitle:[Langauge getTextFromTheKey:@"medical_consultation"] forState:UIControlStateNormal];
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
    /*UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Logout Successfully" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UserSelectViewController* vc = [[UserSelectViewController alloc] initWithNibName:@"UserSelectViewController" bundle:nil];
        vc.isRegistrationSelection = false;
        UINavigationController* navCon = [[UINavigationController alloc] initWithRootViewController:vc];
        vc.navigationController.navigationBarHidden = true;
        [self presentViewController:navCon animated:YES completion:nil];
    }];
    [alertController addAction:ok];
    [self presentViewController:alertController animated:YES completion:nil];

    */
     [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:@"Logout Successfully"  isTwoButtonNeeded:false firstbuttonTag:1001 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Alert_Key_For_Image];
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
        case 1001:{
            UserSelectViewController* vc = [[UserSelectViewController alloc] initWithNibName:@"UserSelectViewController" bundle:nil];
            vc.isRegistrationSelection = false;
            UINavigationController* navCon = [[UINavigationController alloc] initWithRootViewController:vc];
            vc.navigationController.navigationBarHidden = true;
            [self presentViewController:navCon animated:YES completion:nil];
            [self removeAlert];
        }
            break;
        default:
            
            break;
    }
}

@end
