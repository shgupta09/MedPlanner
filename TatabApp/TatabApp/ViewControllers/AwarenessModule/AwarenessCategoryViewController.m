//
//  AwarenessCategoryViewController.m
//  TatabApp
//
//  Created by Shagun Verma on 02/10/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//

#import "AwarenessCategoryViewController.h"

@interface AwarenessCategoryViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    NSMutableArray *categoryArray;
    CustomAlert *alertObj;
}
@end

@implementation AwarenessCategoryViewController{
    LoderView *loderObj;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    categoryArray = [[NSMutableArray alloc] init] ;
    
    [_tblView registerNib:[UINib nibWithNibName:@"AwarenessCategoryTableViewCell" bundle:nil]forCellReuseIdentifier:@"AwarenessCategoryTableViewCell"];
    _tblView.rowHeight = UITableViewAutomaticDimension;
    _tblView.estimatedRowHeight = 35;
    _tblView.backgroundColor = [UIColor clearColor];
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
                
                [_tblView reloadData];
                [self removeloder];
                
            }
            
            
            
        }];
    } else {
        [self addAlertWithTitle:Warning_Key andMessage:No_Network isTwoButtonNeeded:false firstbuttonTag:Tag_For_Remove_Alert secondButtonTag:0 firstbuttonTitle:OK_Btn secondButtonTitle:nil imgName:Warning_Key];
    }
    
}

#pragma mark- tableView delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (categoryArray.count>0) {
        return categoryArray.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    AwarenessCategoryTableViewCell *cell = [_tblView dequeueReusableCellWithIdentifier:@"AwarenessCategoryTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    AwarenessCategory* category = [categoryArray objectAtIndex:indexPath.row];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:category.icon_url] placeholderImage:[UIImage imageNamed:@"doctor.png"]];
    cell.lblName.text = category.category_name;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AwarenessVideoListViewController* vc;
    vc = [[AwarenessVideoListViewController alloc] initWithNibName:@"AwarenessVideoListViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:true];
    
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

- (IBAction)btnBackClicked:(id)sender {
    
    [self dismissViewControllerAnimated:true completion:nil];
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


@end
