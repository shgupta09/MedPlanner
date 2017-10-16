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
    [_btn_Pationts setImage:[UIImage imageNamed:@"sec-family"] forState:UIControlStateNormal];
    [_btn_CasesHistory setImage:[UIImage imageNamed:@"sec-family"] forState:UIControlStateNormal];
    [_btn_MedicalCases setImage:[UIImage imageNamed:@"sec-family"] forState:UIControlStateNormal];
    [_btn_ManageAwareness setImage:[UIImage imageNamed:@"sec-family"] forState:UIControlStateNormal];
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
