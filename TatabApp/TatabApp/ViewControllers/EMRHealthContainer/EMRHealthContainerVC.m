//
//  EMRHealthContainerVC.m
//  TatabApp
//
//  Created by Shagun Verma on 28/12/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//

#import "EMRHealthContainerVC.h"
#import "DoctorListEMRLogTableViewCell.h"
#import "DetailViewController.h"
@interface EMRHealthContainerVC ()<UITableViewDataSource,UITableViewDelegate,DoctorListEMRLogTableViewCellDelegate>
{
    LoderView *loderObj;
    NSMutableArray *doctorListArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tblView;

@end

@implementation EMRHealthContainerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    doctorListArray = [NSMutableArray new];
    [_tblView registerNib:[UINib nibWithNibName:@"DoctorListEMRLogTableViewCell" bundle:nil]forCellReuseIdentifier:@"DoctorListEMRLogTableViewCell"];
    _tblView.rowHeight = UITableViewAutomaticDimension;
    _tblView.estimatedRowHeight = 100;
    _tblView.multipleTouchEnabled = NO;
    
    
    
//    [CommonFunction storeValueInDefault:[CommonFunction trimString:_txtUsername.text] andKey:loginfirstname];
//    [CommonFunction storeValueInDefault:[[responseObj objectForKey:loginUser] valueForKey:loginuserId] andKey:loginuserId];
//    [CommonFunction storeValueInDefault:[[responseObj objectForKey:loginUser] valueForKey:loginuserType] andKey:loginuserType];
//    [CommonFunction storeValueInDefault:[[responseObj objectForKey:loginUser] valueForKey:loginuserGender] andKey:loginuserGender];
//    [CommonFunction storeValueInDefault:[[responseObj objectForKey:loginUser] valueForKey:loginuseIsComplete] andKey:loginuseIsComplete];
//    [CommonFunction storeValueInDefault:[[responseObj objectForKey:loginUser] valueForKey:loginemail] andKey:loginemail];
//    [CommonFunction storeValueInDefault:[[responseObj objectForKey:loginUser] valueForKey:loginUserToken] andKey:loginUserToken];
//    [CommonFunction storeValueInDefault:[[responseObj objectForKey:loginUser] valueForKey:loginfirstname] andKey:loginfirstname];
//    [CommonFunction storeValueInDefault:_txtPassword.text andKey:loginPassword];

    
    [_lblPatientName setText:[CommonFunction getValueFromDefaultWithKey:loginfirstname]];
    [_lblgender setText:[CommonFunction getValueFromDefaultWithKey:loginuserGender]];
    
    [self hitApiForSpeciality];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return doctorListArray.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    DoctorListEMRLogTableViewCell *cell = [_tblView dequeueReusableCellWithIdentifier:@"DoctorListEMRLogTableViewCell"];
    
    if (cell == nil) {
        cell = [[DoctorListEMRLogTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"DoctorListEMRLogTableViewCell"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    Specialization *obj = [doctorListArray objectAtIndex:indexPath.row];
        cell.lblName.text = [NSString stringWithFormat:@"Dr. %@",obj.first_name];
        cell.lblCategoryName.text = obj.sub_specialist;
        //    cell.profileImageView.image = [CommonFunction getImageWithUrlString:obj.photo];
        [cell.imgViewProfile sd_setImageWithURL:[NSURL URLWithString:obj.photo] placeholderImage:[UIImage imageNamed:@"doctor.png"]];
    cell.lblDate.text = obj.created_at;
        cell.imgViewProfile.layer.cornerRadius = 8;
        cell.imgViewProfile.clipsToBounds = true;
    
    [cell.btnDetails setTag:indexPath.row];
    [cell.btnfollowUp setTag:indexPath.row];
    [cell.btnPrescription setTag:indexPath.row];
    cell.delegate = self;
    
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    ChatViewController* vc = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
//        Specialization *obj = [doctorListArray objectAtIndex:indexPath.row];
//        vc.objDoctor = obj;
//        vc.awarenessObj = _awarenessObj;
//        vc.toId = obj.jabberId;
//        [self.navigationController pushViewController:vc animated:true];
   
}

#pragma maek - cell buttons actions

-(void)btnDetailsTapped:(UIButton *)sender{
    UIButton* btn = sender;
    Specialization* obj = [doctorListArray objectAtIndex:btn.tag];
    NSLog(@"%@", obj.first_name);
    
    [self hitApiForDetails:obj.doctor_id];
}
-(void)btnFollowTapped:(UIButton *)sender{
    UIButton* btn = sender;
    Specialization* obj = [doctorListArray objectAtIndex:btn.tag];
    NSLog(@"%@", obj.first_name);
    
    [self hitApiForFollowUp:obj.doctor_id];
}

-(void)btnPrescriptionTapped:(UIButton *)sender{
    UIButton* btn = sender;
    Specialization* obj = [doctorListArray objectAtIndex:btn.tag];
    NSLog(@"%@", obj.first_name);
    
    [self hitApiForPrescription:obj.doctor_id];
}


#pragma mark - btn Actions
- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}


#pragma mark - Api Related


-(void)hitApiForDetails:(int)doctorId{
    
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    [parameter setValue:[CommonFunction getValueFromDefaultWithKey:loginuserId] forKey:@"patient_id"];
    [parameter setValue:[NSString stringWithFormat:@"%d", doctorId] forKey:@"doctor_id"];
    
    if ([ CommonFunction reachability]) {
        [self addLoder];
        
        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_GET_PRES_FOLLOW_UP_DETAILS]  postResponse:parameter postImage:nil requestType:POST tag:nil isRequiredAuthentication:YES header:@"" completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"]) {
                    
                    
                    NSMutableArray* array = [NSMutableArray new];
                    NSArray *tempArray = [NSArray new];
                    tempArray  = [[responseObj valueForKey:@"data"] valueForKey:@"diagnosis"];;
                    [tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        CommonInfoPatient *object = [CommonInfoPatient new];
                        object.identifier = [obj valueForKey:@"id"];
                        object.created_at = [obj valueForKey:@"created_at"];
                        object.type = [obj valueForKey:@"type"];
                        object.details = [obj valueForKey:@"details"];
                        
                        [array addObject:object];
                    }];
                    DetailViewController* vc = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
                    vc.detailType = @"diagnosis";
                    vc.detailArray = array;
                    [self presentViewController:vc animated:false completion:^{
                        [self removeloder];
                        
                    }];
                    
                    
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
-(void)hitApiForPrescription:(int)doctorId{
    
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    [parameter setValue:[CommonFunction getValueFromDefaultWithKey:loginuserId] forKey:@"patient_id"];
    [parameter setValue:[NSString stringWithFormat:@"%d", doctorId] forKey:@"doctor_id"];
    
    if ([ CommonFunction reachability]) {
        [self addLoder];
        
        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_GET_PRES_FOLLOW_UP_DETAILS]  postResponse:parameter postImage:nil requestType:POST tag:nil isRequiredAuthentication:YES header:@"" completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"]) {
                    
                    
                    NSMutableArray* array = [NSMutableArray new];
                    NSArray *tempArray = [NSArray new];
                    tempArray  = [[responseObj valueForKey:@"data"] valueForKey:@"prescription"];;
                    [tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        CommonInfoPatient *object = [CommonInfoPatient new];
                        object.identifier = [obj valueForKey:@"id"];
                        object.created_at = [obj valueForKey:@"created_at"];
                        object.type = [obj valueForKey:@"type"];
                        object.details = [obj valueForKey:@"details"];
                        
                        [array addObject:object];
                    }];
                    DetailViewController* vc = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
                    vc.detailType = @"diagnosis";
                    vc.detailArray = array;
                    [self presentViewController:vc animated:false completion:^{
                        [self removeloder];
                        
                    }];
                    
                    
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

-(void)hitApiForFollowUp:(int)doctorId{
    
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    [parameter setValue:[CommonFunction getValueFromDefaultWithKey:loginuserId] forKey:@"patient_id"];
    [parameter setValue:[NSString stringWithFormat:@"%d", doctorId] forKey:@"doctor_id"];

    if ([ CommonFunction reachability]) {
        [self addLoder];
        
        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_GET_PRES_FOLLOW_UP_DETAILS]  postResponse:parameter postImage:nil requestType:POST tag:nil isRequiredAuthentication:YES header:@"" completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"]) {
                    NSMutableArray* array = [NSMutableArray new];
                    NSArray *tempArray = [NSArray new];
                    tempArray  = [[responseObj valueForKey:@"data"] valueForKey:@"followup"];;
                    [tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        CommonInfoPatient *object = [CommonInfoPatient new];
                        object.identifier = [obj valueForKey:@"id"];
                        object.created_at = [obj valueForKey:@"created_at"];
                        object.type = [obj valueForKey:@"type"];
                        object.details = [obj valueForKey:@"details"];
                        
                        [array addObject:object];
                    }];
                    DetailViewController* vc = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
                    vc.detailType = @"followup";
                    vc.detailArray = array;
                    [self presentViewController:vc animated:false completion:^{
                        [self removeloder];

                    }];
                    
                    
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


-(void)hitApiForSpeciality{
    
    
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    [parameter setValue:[CommonFunction getValueFromDefaultWithKey:loginuserId] forKey:@"patient_id"];
    
    if ([ CommonFunction reachability]) {
        [self addLoder];
        
        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_GET_CHAT_GROUP]  postResponse:parameter postImage:nil requestType:POST tag:nil isRequiredAuthentication:YES header:@"" completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"]) {
                    
                    
                    doctorListArray = [NSMutableArray new];
                    NSArray *tempArray = [NSArray new];
                    tempArray  = [responseObj valueForKey:@"data"];
                    [tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        Specialization *specializationObj = [Specialization new];
                        specializationObj.classificationOfDoctor = [obj valueForKey:@"classification"];
                        specializationObj.created_at = [obj valueForKey:@"created_at"];
                        specializationObj.current_grade = [obj valueForKey:@"current_grade"];
                        specializationObj.doctor_id = [[obj valueForKey:@"doctor_id"] integerValue];
                        specializationObj.first_name = [obj valueForKey:@"first_name"];
                        specializationObj.gender = [obj valueForKey:@"gender"];
                        specializationObj.last_name = [obj valueForKey:@"last_name"];
                        specializationObj.photo = [obj valueForKey:@"photo"];
                        specializationObj.sub_specialist = [obj valueForKey:@"sub_specialist"];
                        specializationObj.workplace = [obj valueForKey:@"workplace"];
                        specializationObj.jabberId = [NSString stringWithFormat:@"%@%@",[[[obj valueForKey:@"email"] componentsSeparatedByString:@"@"] objectAtIndex:0],[[[obj valueForKey:@"email"] componentsSeparatedByString:@"@"] objectAtIndex:1]];
                        
                        [doctorListArray addObject:specializationObj];
                    }];
                    [_tblView reloadData];
                
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


#pragma mark - add loder

-(void)addLoder{
    self.view.userInteractionEnabled = NO;
    //  loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
    loderObj = [[LoderView alloc] initWithFrame:self.view.frame];
    loderObj.lbl_title.text = @"Fetching doctors...";
    [self.view addSubview:loderObj];
}

-(void)removeloder{
    //loderObj = nil;
    [loderObj removeFromSuperview];
    //[loaderView removeFromSuperview];
    self.view.userInteractionEnabled = YES;
}




            
@end
