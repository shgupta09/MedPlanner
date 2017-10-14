//
//  RearViewController.m
//  TatabApp
//
//  Created by NetprophetsMAC on 10/3/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//

#import "RearViewController.h"
@interface RearViewController ()
{
    NSArray *titleArray;
    NSArray *titleImageArray;
     SWRevealViewController *revealController;

}
@end

@implementation RearViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     revealController = [self revealViewController];
    titleArray  = [[NSArray alloc]initWithObjects:@"GENERAL CLINIC",@"FAMILY AND COMMUNITY CLINIC",@"PSYOLOGY CLINIC",@"ABDOMINAL CLINIC",@"OBGYNE",@"PEDIATRICS",@"SETTING",@"PROFILE",@"Logout", nil];
    titleImageArray = [[NSArray alloc] initWithObjects:@"menu-general",@"menu-family",@"menu-psy",@"menu-stomach",@"menu-fetus",@"menu-children",@"Icon---Setttings",@"Icon---Profile",@"", nil];
     [_tbl_View registerNib:[UINib nibWithNibName:@"RearCell" bundle:nil]forCellReuseIdentifier:@"RearCell"];
    _tbl_View.rowHeight = UITableViewAutomaticDimension;
    _tbl_View.estimatedRowHeight = 100;
    _tbl_View.multipleTouchEnabled = NO;

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- tableView delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return titleArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RearCell *rearCell = [_tbl_View dequeueReusableCellWithIdentifier:@"RearCell"];
    rearCell.lbl_title.text = [titleArray objectAtIndex:indexPath.row];
    rearCell.imgView.image = [UIImage imageNamed:[titleImageArray objectAtIndex:indexPath.row]];

    rearCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return rearCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [revealController revealToggle:nil];
   
        
        switch (indexPath.row) {
                
            case 0:
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
            {
                DoctorListVC* vc ;
                vc = [[DoctorListVC alloc] initWithNibName:@"DoctorListVC" bundle:nil];
                vc.titleStr = [titleArray objectAtIndex:indexPath.row];
                [self.navigationController pushViewController:vc animated:true];

            }
                
                break;
            case 8 :{
                
                UIAlertController * alert=   [UIAlertController
                                              alertControllerWithTitle:@"Logout"
                                              message:@"Are you sure you want to Logout?"
                                              preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* ok = [UIAlertAction
                                     actionWithTitle:@"OK"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         [_tbl_View reloadData];
                                         [CommonFunction stroeBoolValueForKey:isLoggedIn withBoolValue:false];
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                         [[NSNotificationCenter defaultCenter]
                                          postNotificationName:@"LogoutNotification"
                                          object:self];
                                         
                                     }];
                UIAlertAction* cancel = [UIAlertAction
                                         actionWithTitle:@"Cancel"
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action)
                                         {
                                             [alert dismissViewControllerAnimated:YES completion:nil];
                                             [[NSNotificationCenter defaultCenter]
                                              postNotificationName:@"CancelNotification"
                                              object:self];
                                             
                                         }];
                
                [alert addAction:ok];
                [alert addAction:cancel];
                
                [self presentViewController:alert animated:YES completion:nil];
                
            }break;
            default:
                break;
        }
        
    
    
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
