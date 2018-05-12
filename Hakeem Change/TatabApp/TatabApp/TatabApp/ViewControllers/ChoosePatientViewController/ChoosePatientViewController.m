//
//  ChoosePatientViewController.m
//  TatabApp
//
//  Created by Shagun Verma on 27/01/18.
//  Copyright © 2018 Shagun Verma. All rights reserved.
//

#import "ChoosePatientViewController.h"

@interface ChoosePatientViewController ()
{
    LoderView *loderObj;
    NSMutableArray *dependantListArray;
    NSMutableArray *patientListArray;
    CustomAlert *alertObj;
}
@property (weak, nonatomic) IBOutlet UITableView *tbl_View;
@end

@implementation ChoosePatientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData];
    dependantListArray = [NSMutableArray new];
    alertObj = [[CustomAlert alloc] initWithFrame:self.view.frame];

    
    
        
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidLayoutSubviews{
    loderObj.frame = self.view.frame;
    alertObj.frame = self.view.frame;
}
-(void)setData{
    [_tbl_View registerNib:[UINib nibWithNibName:@"SelectUserTableViewCell" bundle:nil]forCellReuseIdentifier:@"SelectUserTableViewCell"];
    _tbl_View.rowHeight = UITableViewAutomaticDimension;
    _tbl_View.estimatedRowHeight = 100;
    _tbl_View.multipleTouchEnabled = NO;
    
    
    [self hitApiForPatientList];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark- tableView delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
        return patientListArray.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectUserTableViewCell *cell = [_tbl_View dequeueReusableCellWithIdentifier:@"SelectUserTableViewCell"];
    
    if (cell == nil) {
        cell = [[SelectUserTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SelectUserTableViewCell"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
            ChatPatient *obj = [patientListArray objectAtIndex:indexPath.row];
        cell.lbl_name.text = [NSString stringWithFormat:@"Mr. %@",obj.name];
    cell.btn_Cross.hidden = true;

        //    cell.profileImageView.image = [CommonFunction getImageWithUrlString:obj.photo];
//        [cell.profileImageView setImage:[UIImage imageNamed:@"profile.png"]];
    
        cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.size.width/2;
        cell.profileImageView.clipsToBounds = true;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ChooseDependantViewController* vc ;
    vc = [[ChooseDependantViewController alloc] initWithNibName:@"ChooseDependantViewController" bundle:nil];
    vc.patientID = ((ChatPatient *)[patientListArray objectAtIndex:indexPath.row]).patient_id;
    vc.patientName = ((ChatPatient *)[patientListArray objectAtIndex:indexPath.row]).name;
    vc.classObj = self;
    [self.navigationController pushViewController:vc animated:true];
   

}

#pragma mark - btn Actions
- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}


#pragma mark - Api Related
-(void)hitApiForPatientList{
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    [parameter setValue:[CommonFunction getValueFromDefaultWithKey:loginuserId] forKey:@"doctor_id"];
    
    if ([ CommonFunction reachability]) {
        [self addLoder];
        
        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_FETCH_PATIENTS]  postResponse:parameter postImage:nil requestType:POST tag:nil isRequiredAuthentication:YES header:@"" completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"]) {
                    patientListArray = [NSMutableArray new];
                    NSArray *tempArray = [NSArray new];
                    tempArray  = [responseObj valueForKey:@"data"];
                    [tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        ChatPatient *specializationObj = [ChatPatient new];
                        specializationObj.gender = [obj valueForKey:@"gender"];
                        specializationObj.patient_id = [obj valueForKey:@"patient_id"];
                        specializationObj.name = [NSString stringWithFormat:@"%@",[obj valueForKey:@"first_name"]];
                        specializationObj.dob = [obj valueForKey:@"date_of_birth"];
                        specializationObj.jabberId = [NSString stringWithFormat:@"%@%@",[[[obj valueForKey:@"email"] componentsSeparatedByString:@"@"] objectAtIndex:0],[[[obj valueForKey:@"email"] componentsSeparatedByString:@"@"] objectAtIndex:1]];
                        
                        [patientListArray addObject:specializationObj];
                    }];
                    [_tbl_View reloadData];
                }else
                {
                    [self addAlertWithTitle:[Langauge getTextFromTheKey:Error_Key] andMessage:[responseObj valueForKey:@"message"] isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Error_Key_For_Image];
                    [self removeloder];
                    [self removeloder];
                }
                [self removeloder];
                
            }else{
                [self removeloder];
            }
            
            
            
        }];
    } else {
        [self removeloder];
        [self addAlertWithTitle:[Langauge getTextFromTheKey:Error_Key] andMessage:Network_Issue_Message isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Error_Key_For_Image];
    }
}


#pragma mark - Api Related
/*-(void)hitApiForDependants:(ChatPatient*)patient{
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    [parameter setValue:patient.patient_id forKey:@"user_id"];
    
    if ([ CommonFunction reachability]) {
        [self addLoder];
        
        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_FETCH_DEPENDANTS]  postResponse:parameter postImage:nil requestType:POST tag:nil isRequiredAuthentication:YES header:@"" completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"]) {
                    patientListArray = [NSMutableArray new];
                    NSArray *tempArray = [NSArray new];
 
                    tempArray  = [[responseObj valueForKey:@"patient"] valueForKey:@"childrens"];
                    [tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        RegistrationDpendency *dependencyObj = [RegistrationDpendency new];
                        dependencyObj.name = [obj valueForKey:@"name"];
                        dependencyObj.depedant_id = [obj valueForKey:@"id"];
                        dependencyObj.gender = [obj valueForKey:@"gender"];
                        
                        [dependantListArray addObject:dependencyObj];
                    }];
                    
                    patient.dependants = dependantListArray;
                    
                    if (patient.dependants.count>0) {
                        ChooseDependantViewController* vc ;
                        vc = [[ChooseDependantViewController alloc] initWithNibName:@"ChooseDependantViewController" bundle:nil];
                        vc.patient = patient;
                        [self.navigationController pushViewController:vc animated:true];

                    }
                    else
                    {
                        EMRHealthContainerVC* vc ;
                        vc = [[EMRHealthContainerVC alloc] initWithNibName:@"EMRHealthContainerVC" bundle:nil];
                        vc.isdependant = false;
                        vc.patient = patient;
                        [self.navigationController pushViewController:vc animated:true];
                    }
               
                
                }else
                {
                    [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:Sevrer_Issue_Message isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
                    [self removeloder];
                    [self removeloder];
                }
                [self removeloder];
                
            }
            
            
            
        }];
    } else {
        [self removeloder];
        [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:Network_Issue_Message isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
    }
}
*/
-(void)addLoder{
    self.view.userInteractionEnabled = NO;
    //  loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
    loderObj = [[LoderView alloc] initWithFrame:self.view.frame];
    loderObj.lbl_title.text = [Langauge getTextFromTheKey:@"please_wait"];
    [self.view addSubview:loderObj];
}

-(void)removeloder{
    //loderObj = nil;
    [loderObj removeFromSuperview];
    //[loaderView removeFromSuperview];
    self.view.userInteractionEnabled = YES;
}

#pragma mark- Custom Loder
-(void)addAlertWithTitle:(NSString *)titleString andMessage:(NSString *)messageString isTwoButtonNeeded:(BOOL)isTwoBUtoonNeeded firstbuttonTag:(NSInteger)firstButtonTag secondButtonTag:(NSInteger)secondButtonTag firstbuttonTitle:(NSString *)firstButtonTitle secondButtonTitle:(NSString *)secondButtonTitle image:(NSString *)imageName{
    [CommonFunction resignFirstResponderOfAView:self.view];
    alertObj.lbl_title.text = titleString;
    alertObj.lbl_message.text = messageString;
    alertObj.iconImage.image = [UIImage imageNamed:imageName];
    if (isTwoBUtoonNeeded) {
        alertObj.btn1.hidden = true;
        alertObj.btn2.hidden = false;
        alertObj.btn3.hidden = false;
        [alertObj.btn2 setTitle:firstButtonTitle forState:UIControlStateNormal];
        [alertObj.btn3 setTitle:secondButtonTitle forState:UIControlStateNormal];
        alertObj.btn2.tag = firstButtonTag;
        alertObj.btn3.tag = secondButtonTag;
        [alertObj.btn2 addTarget:self action:@selector(btnActionForCustomAlert:) forControlEvents:UIControlEventTouchUpInside];
        [alertObj.btn3 addTarget:self action:@selector(btnActionForCustomAlert:) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
         alertObj.btn2.hidden = true;
        alertObj.btn3.hidden = true;
        alertObj.btn1.hidden = false;
        alertObj.btn1.tag = firstButtonTag;
        [alertObj.btn1 setTitle:firstButtonTitle forState:UIControlStateNormal];
        [alertObj.btn1 addTarget:self
                          action:@selector(btnActionForCustomAlert:) forControlEvents:UIControlEventTouchUpInside];
    }
    alertObj.transform = CGAffineTransformMakeScale(0.01, 0.01);
   if (![alertObj isDescendantOfView:self.view]) {
        [self.view addSubview:alertObj];
    }
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        // animate it to the identity transform (100% scale)
        alertObj.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        // if you want to do something once the animation finishes, put it here
    }];
    
    
}
-(void)removeAlert{
    if ([alertObj isDescendantOfView:self.view]) {
        [alertObj removeFromSuperview];
    }
    
}

-(IBAction)btnActionForCustomAlert:(id)sender{
    switch (((UIButton *)sender).tag) {
        case Tag_For_Remove_Alert:
            [self removeAlert];
            break;
            
        default:
            
            break;
    }
}



@end
