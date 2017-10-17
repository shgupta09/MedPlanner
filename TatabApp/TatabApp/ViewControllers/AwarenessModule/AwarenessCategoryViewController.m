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
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Network Error" message:@"No Network Access" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
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

@end
