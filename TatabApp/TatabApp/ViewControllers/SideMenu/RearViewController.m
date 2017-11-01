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
    CustomAlert *alertObj;

}
@end

@implementation RearViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     revealController = [self revealViewController];
    titleArray  = [[NSArray alloc]initWithObjects:@"SETTING",@"PROFILE",@"Logout", nil];
    titleImageArray = [[NSArray alloc] initWithObjects:@"Icon---Setttings",@"Icon---Profile",@"", nil];
     [_tbl_View registerNib:[UINib nibWithNibName:@"RearCell" bundle:nil]forCellReuseIdentifier:@"RearCell"];
    _tbl_View.rowHeight = UITableViewAutomaticDimension;
    _tbl_View.estimatedRowHeight = 100;
    _tbl_View.multipleTouchEnabled = NO;
    if (![CommonFunction getBoolValueFromDefaultWithKey:isAwarenessApiHIt]) {
        [self getData];
    }else{
        categoryArray = [AwarenessCategory sharedInstance].myDataArray;
    }
    // Do any additional setup after loading the view from its nib.
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
   
    return categoryArray.count+3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RearCell *rearCell = [_tbl_View dequeueReusableCellWithIdentifier:@"RearCell"];
    if (indexPath.row<categoryArray.count) {
        AwarenessCategory *obj = [categoryArray objectAtIndex:indexPath.row];
        rearCell.lbl_title.text = obj.category_name;
//        rearCell.imgView.image = [CommonFunction getImageWithUrlString:obj.icon_url];
        
        [rearCell.imgView sd_setImageWithURL:[NSURL URLWithString:obj.icon_url] placeholderImage:[UIImage imageNamed:@"doctor.png"]];
    }else{
        rearCell.lbl_title.text = [titleArray objectAtIndex:indexPath.row-categoryArray.count];
        rearCell.imgView.image = [UIImage imageNamed:[titleImageArray objectAtIndex:indexPath.row-categoryArray.count]];

    }
   

    rearCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return rearCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [revealController revealToggle:nil];
    if (indexPath.row<categoryArray.count){
        
        DoctorListVC* vc ;
        vc = [[DoctorListVC alloc] initWithNibName:@"DoctorListVC" bundle:nil];
        vc.awarenessObj = [categoryArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:vc animated:true];
    }else{
        switch (indexPath.row-categoryArray.count) {
                
            case 0:
                break;
            case 1:
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

-(void) getData
{
    
    
    if ([ CommonFunction reachability]) {
        [self addLoder];
        
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
                categoryArray = [AwarenessCategory sharedInstance].myDataArray;
                
                [_tbl_View reloadData];
                [self removeloder];
                
            }
            
            
            
        }];
    } else {
       [self addAlertWithTitle:Warning_Key andMessage:No_Network isTwoButtonNeeded:false firstbuttonTag:Tag_For_Remove_Alert secondButtonTag:0 firstbuttonTitle:OK_Btn secondButtonTitle:nil imgName:Warning_Key];
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


#pragma mark- Custom Loder

-(void)addAlertWithTitle:(NSString *)titleString andMessage:(NSString *)messageString isTwoButtonNeeded:(BOOL)isTwoBUtoonNeeded firstbuttonTag:(NSInteger)firstButtonTag secondButtonTag:(NSInteger)secondButtonTag firstbuttonTitle:(NSString *)firstButtonTitle secondButtonTitle:(NSString *)secondButtonTitle imgName:(NSString *)imgNaame{
    alertObj = [[CustomAlert alloc] initWithFrame:self.view.frame];
    alertObj.lbl_title.text = titleString;
    alertObj.lbl_message.text = messageString;
    alertObj.iconImage.image = [UIImage imageNamed:imgNaame];
    if (isTwoBUtoonNeeded) {
        alertObj.btn1.hidden = true;
        [alertObj.btn2 setTitle:firstButtonTitle forState:UIControlStateNormal];
        [alertObj.btn3 setTitle:secondButtonTitle forState:UIControlStateNormal];
        alertObj.btn2.tag = firstButtonTag;
        alertObj.btn3.tag = secondButtonTag;
        [alertObj.btn2 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [alertObj.btn3 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
        alertObj.btn2.hidden = true;
        alertObj.btn3.hidden = true;
        alertObj.btn1.tag = firstButtonTag;
        [alertObj.btn1 setTitle:firstButtonTitle forState:UIControlStateNormal];
        [alertObj.btn1 addTarget:self
                          action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    [UIView transitionWithView:self.view duration:0.3
                       options:UIViewAnimationOptionTransitionCurlUp //change to whatever animation you like
                    animations:^ { [self.view addSubview:alertObj];
                    }
                    completion:nil];
    
}
-(void)removeAlert{
    if ([alertObj isDescendantOfView:self.view]) {
        [UIView transitionWithView:self.view duration:0.3
                           options:UIViewAnimationOptionTransitionCurlDown //change to whatever animation you like
                        animations:^ { [alertObj removeFromSuperview];
                        }
                        completion:nil];
    }
}

-(IBAction)btnAction:(id)sender{
    switch (((UIButton *)sender).tag) {
        case Tag_For_Remove_Alert:
            [self removeAlert];
            break;
            
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
