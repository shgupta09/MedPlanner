//
//  ChooseDependantViewController.m
//  TatabApp
//
//  Created by Shagun Verma on 27/01/18.
//  Copyright © 2018 Shagun Verma. All rights reserved.
//

#import "ChooseDependantViewController.h"

@interface ChooseDependantViewController ()
{
    LoderView *loderObj;
    NSMutableArray *dependantListArray;
    ChatPatient *patient;
}

@property (weak, nonatomic) IBOutlet UITableView *tbl_View;
@end

@implementation ChooseDependantViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData];

    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidLayoutSubviews{
    loderObj.frame = self.view.frame;
}
-(void)setData{
    patient = [ChatPatient new];
    [_tbl_View registerNib:[UINib nibWithNibName:@"SelectUserTableViewCell" bundle:nil]forCellReuseIdentifier:@"SelectUserTableViewCell"];
    _tbl_View.rowHeight = UITableViewAutomaticDimension;
    _tbl_View.estimatedRowHeight = 100;
    _tbl_View.multipleTouchEnabled = NO;
    [self hitApiForDependants];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark- tableView delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return patient.dependants.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectUserTableViewCell *cell = [_tbl_View dequeueReusableCellWithIdentifier:@"SelectUserTableViewCell"];
    
    if (cell == nil) {
        cell = [[SelectUserTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SelectUserTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
        RegistrationDpendency* dependant = [patient.dependants objectAtIndex:indexPath.row];
    if ([_classObj isKindOfClass:[RearViewController class]] && _isManageDependants) {
        cell.btn_Cross.hidden = false;
        cell.sideImageView.hidden = true;
        [cell.btn_Cross addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        cell.btn_Cross.tag = indexPath.row;
        cell.btn_Cross.userInteractionEnabled = true;
        if (indexPath.row==0) {
            cell.btn_Cross.hidden = true;
            cell.btn_Cross.userInteractionEnabled = false;
        }
    }else{
        cell.btn_Cross.hidden = true;
        cell.sideImageView.hidden = false;
    }
        cell.lbl_name.text = [NSString stringWithFormat:@"%@",dependant.name];
        
        //    cell.profileImageView.image = [CommonFunction getImageWithUrlString:obj.photo];
        [cell.profileImageView setImage:[UIImage imageNamed:@"profile.png"]];
        cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.size.width/2;
        cell.profileImageView.clipsToBounds = true;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)btnClicked:(id)sender{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:[NSString stringWithFormat:@"Are you sure you want to delete %@ ?",((RegistrationDpendency *)[dependantListArray objectAtIndex:((UIButton *)sender).tag]).name] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self hitApiForRemoveDependants:((RegistrationDpendency *)[dependantListArray objectAtIndex:((UIButton *)sender).tag]).depedant_id];
        }];
        [alertController addAction:ok];
        UIAlertAction* no = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:no];
        //                    [CommonFunction storeValueInDefault:@"true" andKey:@"isLoggedIn"];
        [self presentViewController:alertController animated:YES completion:nil];

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    if (!_isManageDependants){
        if (indexPath.row == 0) {
            EMRHealthContainerVC* vc ;
            vc = [[EMRHealthContainerVC alloc] initWithNibName:@"EMRHealthContainerVC" bundle:nil];
            ChatPatient* pat = [ChatPatient new];
            pat.patient_id = _patientID;
            vc.patient = pat;
            vc.isdependant = false;
            [self.navigationController pushViewController:vc animated:true];
        }
        else
        {
            EMRHealthContainerVC* vc ;
            vc = [[EMRHealthContainerVC alloc] initWithNibName:@"EMRHealthContainerVC" bundle:nil];
            ChatPatient* pat = [ChatPatient new];
            pat.patient_id = _patientID;
            vc.patient = pat;
            vc.dependant = [patient.dependants objectAtIndex:indexPath.row];
            vc.isdependant = true;
            [self.navigationController pushViewController:vc animated:true];

        }

    }
    
    
}


#pragma mark - Api Related
-(void)hitApiForDependants{
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    [parameter setValue:_patientID forKey:@"user_id"];
    
    if ([ CommonFunction reachability]) {
        [self addLoder];
        
        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_FETCH_DEPENDANTS]  postResponse:parameter postImage:nil requestType:POST tag:nil isRequiredAuthentication:YES header:@"" completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"]) {
                    NSArray *tempArray = [NSArray new];
                    dependantListArray = [NSMutableArray new];
                    RegistrationDpendency *dependencyObj = [RegistrationDpendency new];
                   // dependencyObj.name = [[responseObj valueForKey:@"patient"] valueForKey:@"name"];
                     dependencyObj.name = @"Main Profile";
                    dependencyObj.depedant_id = [[responseObj valueForKey:@"patient"] valueForKey:@"id"];
                    dependencyObj.gender = [[responseObj valueForKey:@"patient"] valueForKey:@"gender"];
                    dependencyObj.isMainProfile = true;
                    [dependantListArray addObject: dependencyObj];
                    tempArray  = [[responseObj valueForKey:@"patient"] valueForKey:@"childrens"];
                    
                    [tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        RegistrationDpendency *dependencyObj = [RegistrationDpendency new];
                        dependencyObj.name = [obj valueForKey:@"name"];
                        dependencyObj.depedant_id = [obj valueForKey:@"id"];
                        dependencyObj.gender = [obj valueForKey:@"gender"];
                         dependencyObj.relation = [CommonFunction checkForNull:[obj valueForKey:@"relation"]];
                        dependencyObj.isMainProfile = false;
                        [dependantListArray addObject:dependencyObj];
                    }];
                    patient.dependants = dependantListArray;
                    
                    [_tbl_View reloadData];
                    
                    
                }else
                {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:[responseObj valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:ok];
                    //                    [CommonFunction storeValueInDefault:@"true" andKey:@"isLoggedIn"];
                    [self presentViewController:alertController animated:YES completion:nil];
                    [self removeloder];
                }
                [self removeloder];
                
            }
            
            
            
        }];
    } else {
        [self removeloder];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Network Error" message:@"No Network Access" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
-(void)hitApiForRemoveDependants:(NSString *)dependentID{
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    [parameter setValue:_patientID forKey:@"user_id"];
     [parameter setValue:dependentID forKey:@"Dependent_id"];
    
    if ([ CommonFunction reachability]) {
        [self addLoder];
        
        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_FETCH_DEPENDANTS]  postResponse:parameter postImage:nil requestType:POST tag:nil isRequiredAuthentication:YES header:@"" completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"]) {
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Dependent remove successfully." preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:ok];
                    [self hitApiForDependants];
                    //                    [CommonFunction storeValueInDefault:@"true" andKey:@"isLoggedIn"];
                    [self presentViewController:alertController animated:YES completion:nil];

                }else
                {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:[responseObj valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:ok];
                    //                    [CommonFunction storeValueInDefault:@"true" andKey:@"isLoggedIn"];
                    [self presentViewController:alertController animated:YES completion:nil];
                    [self removeloder];
                }
                [self removeloder];
                
            }
            
            
            
        }];
    } else {
        [self removeloder];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Network Error" message:@"No Network Access" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}


#pragma mark - btn Actions
- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}


-(void)addLoder{
    self.view.userInteractionEnabled = NO;
    //  loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
    loderObj = [[LoderView alloc] initWithFrame:self.view.frame];
    loderObj.lbl_title.text = @"Please wait...";
    [self.view addSubview:loderObj];
}

-(void)removeloder{
    //loderObj = nil;
    [loderObj removeFromSuperview];
    //[loaderView removeFromSuperview];
    self.view.userInteractionEnabled = YES;
}



@end
