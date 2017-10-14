//
//  SplashScreenViewController.m
//  TatabApp
//
//  Created by Shagun Verma on 23/09/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//

#import "SplashScreenViewController.h"
#import "AppDelegate.h"
@interface SplashScreenViewController ()

@end

@implementation SplashScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidLoad];
    
    
    
        sleep(1);
    
    if ([CommonFunction getBoolValueFromDefaultWithKey:isLoggedIn]) {
        
        
        if ([[CommonFunction getValueFromDefaultWithKey:loginuseIsComplete] integerValue] ==1)
        {
            RegisterCompleteViewController* vc;
            vc = [[RegisterCompleteViewController alloc] initWithNibName:@"RegisterCompleteViewController" bundle:nil];
//                        [CommonFunction storeValueInDefault:[CommonFunction trimString:_txtName.text] andKey:@"firstName"];
           
            [self presentViewController:vc animated:true completion:nil];
        
        }
        else
        {
            HomeViewController *frontViewController = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
            RearViewController *rearViewController = [[RearViewController alloc]initWithNibName:@"RearViewController" bundle:nil];
            
            
            SWRevealViewController *mainRevealController = [[SWRevealViewController alloc]initWithRearViewController:rearViewController frontViewController:frontViewController];
            mainRevealController.delegate = self;
            mainRevealController.view.backgroundColor = [UIColor blackColor];
//            [frontViewController.view addSubview:[CommonFunction setStatusBarColor]];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:mainRevealController];
            ((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.rootViewController = nav;

        }
    }
    else
    {
        UserSelectViewController* vc = [[UserSelectViewController alloc] initWithNibName:@"UserSelectViewController" bundle:nil];
        vc.isRegistrationSelection = false;
//        UINavigationController* navCon = [[UINavigationController alloc] initWithRootViewController:vc];
//        vc.navigationController.navigationBarHidden = true;
        [self presentViewController:vc animated:YES completion:nil];
    }
    
    
}


@end
