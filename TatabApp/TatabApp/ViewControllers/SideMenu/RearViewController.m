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
    NSMutableArray *categoryArray;
    LoderView *loderObj;

}
@end

@implementation RearViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     revealController = [self revealViewController];
    
    titleArray  = [[NSArray alloc]initWithObjects:@"SETTING",@"EMR & HEALTH",@"PROFILE",@"Logout", nil];
    titleImageArray = [[NSArray alloc] initWithObjects:@"Icon---Setttings",@"Icon---Setttings",@"Icon---Profile",@"", nil];
     [_tbl_View registerNib:[UINib nibWithNibName:@"RearCell" bundle:nil]forCellReuseIdentifier:@"RearCell"];
    _tbl_View.rowHeight = UITableViewAutomaticDimension;
    _tbl_View.estimatedRowHeight = 100;
    _tbl_View.multipleTouchEnabled = NO;
    
    categoryArray = [AwarenessCategory sharedInstance].myDataArray;
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
      if ([CommonFunction getBoolValueFromDefaultWithKey:isLoggedIn]) {
          
          if ([[CommonFunction getValueFromDefaultWithKey:loginuserType] isEqualToString:@"Patient"]) {
              titleArray  = [[NSArray alloc]initWithObjects:@"SETTING",@"EMR & HEALTH",@"PROFILE",@"Logout", nil];
              titleImageArray = [[NSArray alloc] initWithObjects:@"Icon---Setttings",@"Icon---Setttings",@"Icon---Profile",@"", nil];
          }
          else{
              titleArray  = [[NSArray alloc]initWithObjects:@"SETTING",@"PROFILE",@"Logout", nil];
              titleImageArray = [[NSArray alloc] initWithObjects:@"Icon---Setttings",@"Icon---Profile",@"", nil];
          }
   
      }else{
          titleArray = [[NSArray alloc]initWithObjects:@"Login", nil];
          titleImageArray = [[NSArray alloc] initWithObjects:@"Icon---Setttings",nil];
      }
    [_tbl_View reloadData];
}
-(void)viewDidLayoutSubviews{
    loderObj.frame = self.view.frame;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- tableView delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
     if ([CommonFunction getBoolValueFromDefaultWithKey:isLoggedIn]) {
         
         if ([[CommonFunction getValueFromDefaultWithKey:loginuserType] isEqualToString:@"Patient"]) {
             return categoryArray.count+4;
         }
         else{
             return categoryArray.count+3;
         }

         
         
     }else{
         return 1;
     }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RearCell *rearCell = [_tbl_View dequeueReusableCellWithIdentifier:@"RearCell"];
     if ([CommonFunction getBoolValueFromDefaultWithKey:isLoggedIn]) {
    
    if (indexPath.row<categoryArray.count) {
        AwarenessCategory *obj = [categoryArray objectAtIndex:indexPath.row];
        rearCell.lbl_title.text = obj.category_name;

        rearCell.imgView.image = [CommonFunction getImageWithUrlString:obj.icon_url];
        
        [rearCell.imgView setImage:[UIImage imageNamed:obj.icon_url]];
    }else{
        rearCell.lbl_title.text = [titleArray objectAtIndex:indexPath.row-categoryArray.count];
        rearCell.imgView.image = [UIImage imageNamed:[titleImageArray objectAtIndex:indexPath.row-categoryArray.count]];

    }
   
     }else{
         rearCell.lbl_title.text = [titleArray objectAtIndex:indexPath.row];
         rearCell.imgView.image = [UIImage imageNamed:[titleImageArray objectAtIndex:indexPath.row]];
     }
    rearCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return rearCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [revealController revealToggle:nil];
     if ([CommonFunction getBoolValueFromDefaultWithKey:isLoggedIn]) {
    if (indexPath.row<categoryArray.count){
        
        DoctorListVC* vc ;
        vc = [[DoctorListVC alloc] initWithNibName:@"DoctorListVC" bundle:nil];
        vc.awarenessObj = [categoryArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:vc animated:true];
    }else{
        
        if ([[CommonFunction getValueFromDefaultWithKey:loginuserType] isEqualToString:@"Patient"]) {
            switch (indexPath.row-categoryArray.count) {
                case 0:
                    break;
                case 1:
                {
                    EMRHealthContainerVC* vc ;
                    vc = [[EMRHealthContainerVC alloc] initWithNibName:@"EMRHealthContainerVC" bundle:nil];
                    [self.navigationController pushViewController:vc animated:true];
                }
                    
                    break;
                case 3 :{
                    
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
        else
        {
            switch (indexPath.row-categoryArray.count) {
                case 0:
                    break;
                case 1:
                {
                    
                }
                    
                    break;
                case 2 :{
                    
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
        

    }
    
    
     }else{
         LoginViewController* vc ;
         vc = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
         [self.navigationController pushViewController:vc animated:true];

     }
    
}

#pragma mark - add loder

-(void)addLoder{
    self.view.userInteractionEnabled = NO;
    //  loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
    loderObj = [[LoderView alloc] initWithFrame:self.view.frame];
    loderObj.lbl_title.text = @"Fetching data...";
    [self.view addSubview:loderObj];
}

-(void)removeloder{
    //loderObj = nil;
    [loderObj removeFromSuperview];
    //[loaderView removeFromSuperview];
    self.view.userInteractionEnabled = YES;
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
