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
    [_btn_MedicalConsultant setImage:[UIImage imageNamed:@"sec-family"] forState:UIControlStateNormal];
    [_btn_ElectronicMR setImage:[UIImage imageNamed:@"sec-family"] forState:UIControlStateNormal];
    [_btn_registerSubRegords setImage:[UIImage imageNamed:@"sec-family"] forState:UIControlStateNormal];
    [_btn_RecordHistory setImage:[UIImage imageNamed:@"sec-family"] forState:UIControlStateNormal];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
