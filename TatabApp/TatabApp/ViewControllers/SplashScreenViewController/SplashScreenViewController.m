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
    [self getData];
    
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
            RearViewController *rearViewController = [[RearViewController alloc]initWithNibName:@"RearViewController" bundle:nil];
            SWRevealViewController *mainRevealController;
            if ([[CommonFunction getValueFromDefaultWithKey:loginuserType] isEqualToString:@"Doctor"]) {
                HomeViewController *frontViewController = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
                mainRevealController = [[SWRevealViewController alloc]initWithRearViewController:rearViewController frontViewController:frontViewController];
            }else{
                PatientHomeVC *frontViewController = [[PatientHomeVC alloc]initWithNibName:@"PatientHomeVC" bundle:nil];
                mainRevealController = [[SWRevealViewController alloc]initWithRearViewController:rearViewController frontViewController:frontViewController];
                
            }
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
-(void) getData
{
    
    
    if ([ CommonFunction reachability]) {
        
        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,@"awareness"]  postResponse:nil postImage:nil requestType:POST tag:nil isRequiredAuthentication:NO header:NPHeaderName completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                [CommonFunction stroeBoolValueForKey:isAwarenessApiHIt withBoolValue:true];
                for (NSDictionary* sub in [responseObj objectForKey:@"awareness"]) {
                    
                    AwarenessCategory* s = [[AwarenessCategory alloc] init  ];
                    [sub enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
                        [s setValue:obj forKey:(NSString *)key];
                    }];
                    
                    [[AwarenessCategory sharedInstance].myDataArray addObject:s];
                }
                
            }
            
            
            
        }];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Network Error" message:@"No Network Access" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}






@end
