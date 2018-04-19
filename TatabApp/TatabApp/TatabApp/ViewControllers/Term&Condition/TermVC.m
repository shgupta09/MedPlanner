//
//  TermVC.m
//  TatabApp
//
//  Created by NetprophetsMAC on 4/3/18.
//  Copyright © 2018 Shagun Verma. All rights reserved.
//

#import "TermVC.h"

@interface TermVC ()

@end

@implementation TermVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _lbl_title.text = [Langauge getTextFromTheKey:@"terms_and_condition"];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnBackClicked:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
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
