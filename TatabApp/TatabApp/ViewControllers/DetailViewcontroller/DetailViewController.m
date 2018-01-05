//
//  DetailViewController.m
//  TatabApp
//
//  Created by Shagun Verma on 30/12/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
{
    LoderView *loderObj;
}
@property (weak, nonatomic) IBOutlet UILabel *lblHeader;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _lblHeader.text =_detailType;
    
    _lblDetail.text = [[_detailArray objectAtIndex:0] valueForKey:@"details"];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - btn Actions
- (IBAction)btnBackClicked:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}





@end
