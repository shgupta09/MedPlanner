//
//  UserSelectViewController.m
//  TatabApp
//
//  Created by Shagun Verma on 23/09/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//

#import "UserSelectViewController.h"
#import "Constant.h"



@interface UserSelectViewController ()

@end

@implementation UserSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)setData{

    if (_isRegistrationSelection) {
        
        [_firsrBtn setTitle:[Langauge getTextFromTheKey:@"patient"] forState:UIControlStateNormal];
        [_secondBtn setTitle:[Langauge getTextFromTheKey:@"doctor"] forState:UIControlStateNormal];
        _btn_Back.hidden = false;
    }else{
        _btn_Back.hidden = true;
        [_firsrBtn setTitle:@"Consulting" forState:UIControlStateNormal];
        [_secondBtn setTitle:@"Awareness" forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - btn actions
- (IBAction)btnBackClicked:(id)sender {
    if (_isRegistrationSelection) {
        [self.navigationController popViewControllerAnimated:true];
    }else{
    [self dismissViewControllerAnimated:true completion:nil];
    }
    
}

- (IBAction)btnUserType_tapped:(id)sender {

    UIButton * bt = sender;
    if (_isRegistrationSelection) {
        if (bt.tag == TAG_USERTYPE_CONSULTING){
                RegisterViewController* vc ;
                vc = [[RegisterViewController alloc ] initWithNibName:@"RegisterViewController" bundle:nil];
                 [self.navigationController pushViewController:vc animated:true];
        }
        else if (bt.tag == TAG_USERTYPE_AWARENESS)
        {
            RCDoctor1* vc ;
            vc = [[RCDoctor1 alloc] initWithNibName:@"RCDoctor1" bundle:nil];
            [self.navigationController pushViewController:vc animated:true];
        }
    }else{
        if (bt.tag == TAG_USERTYPE_CONSULTING){
                        LoginViewController* vc ;
            vc = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
            UINavigationController* navVC = [[UINavigationController alloc] initWithRootViewController:vc];
            vc.navigationController.navigationBarHidden = true;
              [self presentViewController:navVC animated:true completion:nil];
            
        }
        else if (bt.tag == TAG_USERTYPE_AWARENESS)
        {
            AwarenessCategoryViewController* vc ;
            vc = [[AwarenessCategoryViewController alloc] initWithNibName:@"AwarenessCategoryViewController" bundle:nil];
            UINavigationController* navVC = [[UINavigationController alloc] initWithRootViewController:vc];
            vc.navigationController.navigationBarHidden = true;
            [self presentViewController:navVC animated:true completion:nil];
            
        }
    }
}


@end
