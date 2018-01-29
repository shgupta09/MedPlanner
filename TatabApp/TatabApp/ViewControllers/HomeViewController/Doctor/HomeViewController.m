//
//  HomeViewController.m
//  TatabApp
//
//  Created by Shagun Verma on 23/09/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()
{
     SWRevealViewController *revealController;
     BOOL isOpen;
     UIView *tempView;
    UITapGestureRecognizer *singleFingerTap;
}
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData];
}

-(void)setData{
    
    [_btn_CasesHistory setImage:[UIImage imageNamed:@"queue"] forState:UIControlStateNormal];
    [_btn_MedicalQueue setImage:[UIImage imageNamed:@"queue"] forState:UIControlStateNormal];
    [_btn_ManageAwareness setImage:[UIImage imageNamed:@"queue"] forState:UIControlStateNormal];
    
    _lbl_Name.text = [CommonFunction getValueFromDefaultWithKey:loginfirstname];
    _lbl_Sep.text = [CommonFunction getValueFromDefaultWithKey:Specialist];
    isOpen = false;
    revealController = [self revealViewController];
    singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                              action:@selector(handleSingleTap:)];
    [_imgView sd_setImageWithURL:[NSURL URLWithString:[CommonFunction getValueFromDefaultWithKey:logInImageUrl]]];
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
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer{
    self.navigationController.navigationBar.userInteractionEnabled = true;
    if (isOpen){
        [revealController revealToggle:nil];
        [tempView removeGestureRecognizer:singleFingerTap];
        [tempView removeFromSuperview];
        isOpen = false;
    }
}

#pragma mark- Btn Action
- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}
- (IBAction)btnQueue:(id)sender {
    DoctorListVC* vc ;
    vc = [[DoctorListVC alloc] initWithNibName:@"DoctorListVC" bundle:nil];
    AwarenessCategory *awarenessObj = [AwarenessCategory new];
    awarenessObj.category_name = [CommonFunction getValueFromDefaultWithKey:Specialist];
    awarenessObj.category_id = [CommonFunction getIDFromClinic:awarenessObj.category_name];
    vc.awarenessObj = awarenessObj;
    [self.navigationController pushViewController:vc animated:true];
}

- (IBAction)btn_Awareness:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}
- (IBAction)btnCaseHistory:(id)sender {
    
    ChoosePatientViewController* vc ;
    vc = [[ChoosePatientViewController alloc] initWithNibName:@"ChoosePatientViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:true];

    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)receiveNotification{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Logout Successfully" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [CommonFunction stroeBoolValueForKey:isLoggedIn withBoolValue:false];

                UserSelectViewController* vc = [[UserSelectViewController alloc] initWithNibName:@"UserSelectViewController" bundle:nil];
                vc.isRegistrationSelection = false;
                UINavigationController* navCon = [[UINavigationController alloc] initWithRootViewController:vc];
                vc.navigationController.navigationBarHidden = true;
                [self presentViewController:navCon animated:YES completion:nil];
            }];
            [alertController addAction:ok];
            [self presentViewController:alertController animated:YES completion:nil];
}

@end
