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
    NSMutableArray *titleArray;
    NSMutableArray *titleImageArray;
     SWRevealViewController *revealController;
   // NSMutableArray *categoryArray;
    LoderView *loderObj;

}
@end

@implementation RearViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     revealController = [self revealViewController];
    
    _viewToClip.layer.cornerRadius = 5;
    _viewToClip.layer.masksToBounds = true;
    _viewToClip.layer.borderColor = [UIColor blackColor].CGColor;
    _viewToClip.layer.borderWidth = 1;
     [_tbl_View registerNib:[UINib nibWithNibName:@"RearCell" bundle:nil]forCellReuseIdentifier:@"RearCell"];
    _tbl_View.rowHeight = UITableViewAutomaticDimension;
    _tbl_View.estimatedRowHeight = 100;
    _tbl_View.multipleTouchEnabled = NO;
    
    //categoryArray = [AwarenessCategory sharedInstance].myDataArray;
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
      if ([CommonFunction getBoolValueFromDefaultWithKey:isLoggedIn]) {
          
          if ([[CommonFunction getValueFromDefaultWithKey:loginuserType] isEqualToString:@"Patient"]) {
              titleArray  = [[NSMutableArray alloc]initWithObjects:@"Depentents",@"EMR and tracker",@"Profile",@"Awareness",@"Setting",@"Notificatios", nil];
              titleImageArray = [[NSMutableArray alloc] initWithObjects:@"menu-general",@"menu-general",@"Icon---Profile",@"menu-general",@"Icon---Setttings",@"Icon---Setttings", nil];
          }
          else{
              titleArray  = [[NSMutableArray alloc]initWithObjects:@"Queue",@"EMR and tracker",@"Profile",@"Awareness",@"Setting",@"Notificatios", nil];
              titleImageArray = [[NSMutableArray alloc] initWithObjects:@"queue",@"menu-general",@"Icon---Profile",@"menu-general",@"Icon---Setttings",@"Icon---Setttings", nil];
              [_imgView sd_setImageWithURL:[NSURL URLWithString:[CommonFunction getValueFromDefaultWithKey:logInImageUrl]]];
          }
           _lblNAme.text = [CommonFunction getValueFromDefaultWithKey:loginfirstname];
          _lblNAme.hidden = false;
          _lbl_Loguot.hidden = false;
          _imgView.hidden = false;
   
      }else{
          _lblNAme.hidden = true;
          _lbl_Loguot.hidden = true;
          _imgView.hidden = true;
          titleArray = [[NSMutableArray alloc]initWithObjects:@"Login", nil];
          titleImageArray = [[NSMutableArray alloc] initWithObjects:@"Icon---Setttings",nil];
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
         
         return titleArray.count;

         
         
     }else{
         return 1;
     }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RearCell *rearCell = [_tbl_View dequeueReusableCellWithIdentifier:@"RearCell"];
     if ([CommonFunction getBoolValueFromDefaultWithKey:isLoggedIn]) {
//    
//    if (indexPath.row<categoryArray.count) {
//        AwarenessCategory *obj = [categoryArray objectAtIndex:indexPath.row];
//        rearCell.lbl_title.text = obj.category_name;
//
//        rearCell.imgView.image = [CommonFunction getImageWithUrlString:obj.icon_url];
//        
//        [rearCell.imgView setImage:[UIImage imageNamed:obj.icon_url]];
//    }else{
//        rearCell.lbl_title.text = [titleArray objectAtIndex:indexPath.row-categoryArray.count];
//        rearCell.imgView.image = [UIImage imageNamed:[titleImageArray objectAtIndex:indexPath.row-categoryArray.count]];
//
//    }
         rearCell.lbl_title.text = [titleArray objectAtIndex:indexPath.row];
         rearCell.imgView.image = [UIImage imageNamed:[titleImageArray objectAtIndex:indexPath.row]];
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
//    if (indexPath.row<categoryArray.count){
//        
//        DoctorListVC* vc ;
//        vc = [[DoctorListVC alloc] initWithNibName:@"DoctorListVC" bundle:nil];
//        vc.awarenessObj = [categoryArray objectAtIndex:indexPath.row];
//        [self.navigationController pushViewController:vc animated:true];
//    }else{
        
        if ([[CommonFunction getValueFromDefaultWithKey:loginuserType] isEqualToString:@"Patient"]) {
            switch (indexPath.row) {
                case 0:
                    break;
                    
                case 1:
                {
                    EMRHealthContainerVC* vc ;
                    vc = [[EMRHealthContainerVC alloc] initWithNibName:@"EMRHealthContainerVC" bundle:nil];
                    [self.navigationController pushViewController:vc animated:true];
                }
                case 2:
                    break;
                case 3:
                {
                    EMRHealthContainerVC* vc ;
                    vc = [[EMRHealthContainerVC alloc] initWithNibName:@"EMRHealthContainerVC" bundle:nil];
                    [self.navigationController pushViewController:vc animated:true];
                }
                
                case 4:
                    break;
                case 5:
                {
                    EMRHealthContainerVC* vc ;
                    vc = [[EMRHealthContainerVC alloc] initWithNibName:@"EMRHealthContainerVC" bundle:nil];
                    [self.navigationController pushViewController:vc animated:true];
                }
                    break;

                default:
                    break;
            }
        }
        else
        {
            switch (indexPath.row) {
                case 0:{
                    DoctorListVC* vc ;
                    vc = [[DoctorListVC alloc] initWithNibName:@"DoctorListVC" bundle:nil];
                    
                    AwarenessCategory *awarenessObj = [AwarenessCategory new];
                    awarenessObj.category_name = [CommonFunction getValueFromDefaultWithKey:Specialist];
                    awarenessObj.category_id = [CommonFunction getIDFromClinic:awarenessObj.category_name];
                    vc.awarenessObj = awarenessObj;
                    [self.navigationController pushViewController:vc animated:true];
                }
                    break;
                case 1:
                {
//                    EMRHealthContainerVC* vc ;
//                    vc = [[EMRHealthContainerVC alloc] initWithNibName:@"EMRHealthContainerVC" bundle:nil];
//                    [self.navigationController pushViewController:vc animated:true];
                }
                case 2:{
                    HomeViewController* vc ;
                    vc = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
                    [self.navigationController pushViewController:vc animated:true];
                }
                    break;
                case 3:{
                    
                }
                    break;
                case 4:{
                }
                    break;
                case 5:{
                }
                    break;
                default:
                    break;
            }
        }
        
     }else{
         LoginViewController* vc ;
         vc = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
         [self.navigationController pushViewController:vc animated:true];

     }
    
}
- (IBAction)btn_Logout:(id)sender {
    
    UIAlertController * alert=   [UIAlertController
                                                                                    alertControllerWithTitle:@"Logout"
                                                                                    message:@"Are you sure you want to Logout?"
                                                                                    preferredStyle:UIAlertControllerStyleAlert];
                                  
                                                      UIAlertAction* ok = [UIAlertAction
                                                                           actionWithTitle:@"OK"
                                                                           style:UIAlertActionStyleDefault
                                                                           handler:^(UIAlertAction * action)
                                                                           {
                                                                               [revealController revealToggle:nil];

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
