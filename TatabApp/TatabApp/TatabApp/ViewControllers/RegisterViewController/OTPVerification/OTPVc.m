//
//  OTPVc.m
//  TatabApp
//
//  Created by NetprophetsMAC on 3/27/18.
//  Copyright © 2018 Shagun Verma. All rights reserved.
//

#import "OTPVc.h"

@interface OTPVc ()

@end

@implementation OTPVc

- (void)viewDidLoad {
    [super viewDidLoad];
    _txt_Number.leftImgView.image = [UIImage imageNamed:@"b"];
    _txt_verificationNum.leftImgView.image = [UIImage imageNamed:@"b"];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)btnBackClicked:(id)sender {
    
    [self dismissViewControllerAnimated:true completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
