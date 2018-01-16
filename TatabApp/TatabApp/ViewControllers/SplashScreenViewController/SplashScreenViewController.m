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
    
    AwarenessCategory* s = [[AwarenessCategory alloc] init  ];
    
    s.category_id = @"1";
    s.category_name  = @"Family and Community Clinic";
    s.icon_url = @"menu-family";
    [[AwarenessCategory sharedInstance].myDataArray addObject:s];
    
    s = [[AwarenessCategory alloc] init  ];
    
    s.category_id = @"2";
    s.category_name  = @"Psychological Clinic";
    s.icon_url = @"menu-psy";
    [[AwarenessCategory sharedInstance].myDataArray addObject:s];
    
    s = [[AwarenessCategory alloc] init  ];
    
    s.category_id = @"3";
    s.category_name  = @"Abdominal Clinic";
    s.icon_url = @"menu-stomach";
    [[AwarenessCategory sharedInstance].myDataArray addObject:s];
    
    s = [[AwarenessCategory alloc] init  ];
    
    s.category_id = @"4";
    s.category_name  = @"Obgyne Clinic";
    s.icon_url = @"menu-fetus";
    [[AwarenessCategory sharedInstance].myDataArray addObject:s];
    
    s = [[AwarenessCategory alloc] init  ];
    
    s.category_id = @"5";
    s.category_name  = @"Pediatrics Clinic";
    s.icon_url = @"menu-children";
    [[AwarenessCategory sharedInstance].myDataArray addObject:s];
    
    [CommonFunction stroeBoolValueForKey:isAwarenessApiHIt withBoolValue:true];

    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidLoad];
    
//        sleep(1);
    
    RearViewController *rearViewController = [[RearViewController alloc]initWithNibName:@"RearViewController" bundle:nil];
    SWRevealViewController *mainRevealController;
    NewAwareVC *frontViewController = [[NewAwareVC alloc]initWithNibName:@"NewAwareVC" bundle:nil];
        mainRevealController = [[SWRevealViewController alloc]initWithRearViewController:rearViewController frontViewController:frontViewController];
   
    mainRevealController.delegate = self;
    mainRevealController.view.backgroundColor = [UIColor blackColor];
    //            [frontViewController.view addSubview:[CommonFunction setStatusBarColor]];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:mainRevealController];
    ((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.rootViewController = nav;

    
    
}





@end
