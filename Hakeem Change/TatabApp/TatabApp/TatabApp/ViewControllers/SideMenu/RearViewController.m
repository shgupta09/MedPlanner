//
//  RearViewController.m
//  TatabApp
//
//  Created by NetprophetsMAC on 10/3/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//

#import "RearViewController.h"
#import "SettingVC.h"
#import "DProfileVC.h"
@interface RearViewController ()
{
    NSMutableArray *titleArray;
    NSMutableArray *titleImageArray;
     SWRevealViewController *revealController;
   // NSMutableArray *categoryArray;
    LoderView *loderObj;
    CustomAlert *alertObj;


}
@property (weak, nonatomic) IBOutlet UIView *lblSectionSeparator;
@end

@implementation RearViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    alertObj = [[CustomAlert alloc] initWithFrame:self.view.frame];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"UpdateCountLAbel"
                                               object:nil];
     revealController = [self revealViewController];
    _lbl_Loguot.text = [Langauge getTextFromTheKey:@"logout"];
//    _viewToClip.layer.cornerRadius = 5;
//    _viewToClip.layer.masksToBounds = true;
//    _viewToClip.layer.borderColor = [UIColor whiteColor].CGColor;
//    _viewToClip.layer.borderWidth = 1;
     [_tbl_View registerNib:[UINib nibWithNibName:@"RearCell" bundle:nil]forCellReuseIdentifier:@"RearCell"];
    _tbl_View.rowHeight = UITableViewAutomaticDimension;
    _tbl_View.estimatedRowHeight = 100;
    _tbl_View.multipleTouchEnabled = NO;
    
    //categoryArray = [AwarenessCategory sharedInstance].myDataArray;
    
    // Do any additional setup after loading the view from its nib.
}

-(void)receiveNotification:(NSNotification*)notObj{
    if ([notObj.name isEqualToString:@"UpdateCountLAbel"]){
        
        [_tbl_View reloadData];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [_tbl_View reloadData];
    if ([CommonFunction getBoolValueFromDefaultWithKey:isLoggedIn]){
          if ([[CommonFunction getValueFromDefaultWithKey:loginuserType] isEqualToString:@"Patient"]) {
              titleArray  = [[NSMutableArray alloc]initWithObjects:@"dependent",@"emr_and_tracker",@"profile",@"action_settings",@"need_help", nil];
              titleImageArray = [[NSMutableArray alloc] initWithObjects:@"menu-children",@"menu-general",@"Icon---Profile",@"Icon---Setttings",@"Icon---Setttings", nil];
             
              _lblName.text = [[CommonFunction getValueFromDefaultWithKey:loginfirstname] capitalizedString];
          }
          else{
              titleArray  = [[NSMutableArray alloc]initWithObjects:@"queue",@"emr_and_tracker",@"profile",@"action_settings",@"Doctor_Profile", @"need_help",nil];
              titleImageArray = [[NSMutableArray alloc] initWithObjects:@"queueWhite",@"menu-general",@"Icon---Profile",@"Icon---Setttings",@"Icon---Setttings",@"Icon---Setttings", nil];
              [_imgView sd_setImageWithURL:[NSURL URLWithString:[CommonFunction getValueFromDefaultWithKey:logInImageUrl]]];
            
              if([[CommonFunction getValueFromDefaultWithKey:loginfirstname] containsString:@"Dr."])
              {
                    _lblName.text = [NSString stringWithFormat:@"%@",[[CommonFunction getValueFromDefaultWithKey:loginfirstname] capitalizedString]];
              }else{
                  _lblName.text = [NSString stringWithFormat:@"Dr. %@",[[CommonFunction getValueFromDefaultWithKey:loginfirstname] capitalizedString]];
              }
            

          }
           _lblNAme.text = [CommonFunction getValueFromDefaultWithKey:loginemail];
        
          _viewToClip.hidden = false;
          _lblSectionSeparator.hidden = false;
      }else{
          _viewToClip.hidden = true;
          _lblSectionSeparator.hidden = true;
          titleArray = [[NSMutableArray alloc]initWithObjects:[Langauge getTextFromTheKey:@"login"], nil];
          titleImageArray = [[NSMutableArray alloc] initWithObjects:@"Icon---Setttings",nil];
      }
    [_tbl_View reloadData];
}
-(void)viewDidLayoutSubviews{
    loderObj.frame = self.view.frame;
    alertObj.frame = self.view.frame;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- tableView delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
   if ([CommonFunction getBoolValueFromDefaultWithKey:isLoggedIn]){
         
         return titleArray.count;

         
         
     }else{
         return 1;
     }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RearCell *rearCell = [_tbl_View dequeueReusableCellWithIdentifier:@"RearCell"];
    rearCell.countLabel.hidden = true;
   if ([CommonFunction getBoolValueFromDefaultWithKey:isLoggedIn]){
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
         rearCell.lbl_title.text = [Langauge getTextFromTheKey:[titleArray objectAtIndex:indexPath.row]];
         rearCell.imgView.image = [UIImage imageNamed:[titleImageArray objectAtIndex:indexPath.row]];
         if ([rearCell.lbl_title.text isEqualToString:@"QUEUE"] && [[QueueDetails sharedInstance].myDataArray count]>0) {
             rearCell.countLabel.hidden = false;
             rearCell.countLabel.text = [NSString stringWithFormat:@"%d",[[QueueDetails sharedInstance].myDataArray count]];
         }
     }else{
         rearCell.lbl_title.text = [Langauge getTextFromTheKey:[titleArray objectAtIndex:indexPath.row]];
         rearCell.imgView.image = [UIImage imageNamed:[titleImageArray objectAtIndex:indexPath.row]];
     }
    rearCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return rearCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([CommonFunction isEnglishSelected]) {
        [revealController revealToggle:nil];
    }else{
        [revealController rightRevealToggle:nil];
    }
   if ([CommonFunction getBoolValueFromDefaultWithKey:isLoggedIn]){
//    if (indexPath.row<categoryArray.count){
//        
//        DoctorListVC* vc ;
//        vc = [[DoctorListVC alloc] initWithNibName:@"DoctorListVC" bundle:nil];
//        vc.awarenessObj = [categoryArray objectAtIndex:indexPath.row];
//        [self.navigationController pushViewController:vc animated:true];
//    }else{
        
        if ([[CommonFunction getValueFromDefaultWithKey:loginuserType] isEqualToString:@"Patient"]) {
            switch (indexPath.row) {
                case 0:{
                    
                    ChooseDependantViewController* vc ;
                    vc = [[ChooseDependantViewController alloc] initWithNibName:@"ChooseDependantViewController" bundle:nil];
                    vc.patientID = [CommonFunction getValueFromDefaultWithKey:loginuserId];
                    vc.classObj = self;
                    vc.isManageDependants = true;
                    [self.navigationController pushViewController:vc animated:true];
                }
                    break;
                    
                case 1:
                {
                    ChooseDependantViewController* vc ;
                    vc = [[ChooseDependantViewController alloc] initWithNibName:@"ChooseDependantViewController" bundle:nil];
                    vc.patientID = [CommonFunction getValueFromDefaultWithKey:loginuserId];
                    vc.classObj = self;
                    vc.isManageDependants = false;

                    [self.navigationController pushViewController:vc animated:true];
                }
                    break;
                case 2:{
                    PatientHomeVC* vc ;
                    vc = [[PatientHomeVC alloc] initWithNibName:@"PatientHomeVC" bundle:nil];
                    [self.navigationController pushViewController:vc animated:true];
                }
                    break;
                case 3:
                {
                    SettingVC* vc ;
                    vc = [[SettingVC alloc] initWithNibName:@"SettingVC" bundle:nil];
                    [self.navigationController pushViewController:vc animated:true];
                }
                    break;

                
                case 4:{
                    NeedHelpVCViewController* vc = [[NeedHelpVCViewController alloc] initWithNibName:@"NeedHelpVCViewController" bundle:nil];
                    vc.isPushed = true;
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
                    
//                    DoctorListVC* vc ;
//                    vc = [[DoctorListVC alloc] initWithNibName:@"DoctorListVC" bundle:nil];
//                    
//                    AwarenessCategory *awarenessObj = [AwarenessCategory new];
//                    awarenessObj.category_name = [CommonFunction getValueFromDefaultWithKey:Specialist];
//                    awarenessObj.category_id = [CommonFunction getIDFromClinic:awarenessObj.category_name];
//                    vc.awarenessObj = awarenessObj;
//                    [self.navigationController pushViewController:vc animated:true];
                    
                    [[NSNotificationCenter defaultCenter]
                     postNotificationName:@"Queue Tapped"
                     object:self];
                    if ([[QueueDetails sharedInstance].myDataArray count]== 0) {
//                        [[NSNotificationCenter defaultCenter]
//                         postNotificationName:@"NONE TO CHAT"
//                         object:self];
                        
                        QueueDetails *obj = [QueueDetails new];
                        obj.patient_id = @"na";
                        obj.queue_id = @"na";
                        obj.dependentID = @"na";
                        [self hitApiForStartTheChat:obj];

                    }else{
                        QueueDetails *obj = [[QueueDetails sharedInstance].myDataArray objectAtIndex:0];
                        [self hitApiForStartTheChat:obj];
                    }
                    
                   

                }
                    break;
                case 1:
                {
                    ChoosePatientViewController* vc ;
                    vc = [[ChoosePatientViewController alloc] initWithNibName:@"ChoosePatientViewController" bundle:nil];
                    [self.navigationController pushViewController:vc animated:true];
                }
                    break;

                case 2:{
                    HomeViewController* vc ;
                    vc = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
                    [self.navigationController pushViewController:vc animated:true];
                }
                    break;
                case 3:{
                    SettingVC* vc ;
                    vc = [[SettingVC alloc] initWithNibName:@"SettingVC" bundle:nil];
                    [self.navigationController pushViewController:vc animated:true];
                }
                    break;
                case 4:{

                    DProfileVC* vc = [[DProfileVC alloc] initWithNibName:@"DProfileVC" bundle:nil];
                    vc.isLofinUser = true;
                    [self.navigationController pushViewController:vc animated:true];
                }
                    break;
                case 5:{
                    NeedHelpVCViewController* vc = [[NeedHelpVCViewController alloc] initWithNibName:@"NeedHelpVCViewController" bundle:nil];
                    vc.isPushed = true;
                    [self.navigationController pushViewController:vc animated:true];
                }break;
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

//#pragma mark - Api Related
//-(void)hitApiForDependants:(NSString*)patientId{
//    NSMutableDictionary *parameter = [NSMutableDictionary new];
//    [parameter setValue:patientId forKey:@"user_id"];
//
//    if ([ CommonFunction reachability]) {
//        [self addLoder];
//        
//        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
//        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_FETCH_DEPENDANTS]  postResponse:parameter postImage:nil requestType:POST tag:nil isRequiredAuthentication:YES header:@"" completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
//            if (error == nil) {
//                
//                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"]) {
//                    NSArray *tempArray = [NSArray new];
//                    NSMutableArray *dependantListArray = [NSMutableArray new];
//                    ChatPatient* patient = [ChatPatient new];
//                    
//                    patient.patient_id = [CommonFunction getValueFromDefaultWithKey:loginuserId];
//                    
//                    
//                    tempArray  = [[responseObj valueForKey:@"patient"] valueForKey:@"childrens"];
//                    [tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                        RegistrationDpendency *dependencyObj = [RegistrationDpendency new];
//                        dependencyObj.name = [obj valueForKey:@"name"];
//                        dependencyObj.depedant_id = [obj valueForKey:@"id"];
//                        dependencyObj.gender = [obj valueForKey:@"gender"];
//                        
//                        [dependantListArray addObject:dependencyObj];
//                    }];
//                    
//                    patient.dependants = dependantListArray;
//                
//                    
//                }else
//                {
//                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:[responseObj valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
//                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
//                    [alertController addAction:ok];
//                    //                    [CommonFunction storeValueInDefault:@"true" andKey:@"isLoggedIn"];
//                    [self presentViewController:alertController animated:YES completion:nil];
//                    [self removeloder];
//                }
//                [self removeloder];
//                
//            }
//            
//            
//            
//        }];
//    } else {
//        [self removeloder];
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Network Error" message:@"No Network Access" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
//        [alertController addAction:ok];
//        [self presentViewController:alertController animated:YES completion:nil];
//    }
//}


- (IBAction)btn_Logout:(id)sender {
    if ([CommonFunction isEnglishSelected]) {
        [revealController revealToggle:nil];
    }else{
        [revealController rightRevealToggle:nil];
    }
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"LogOutTapped"
     object:self];
     
    /*
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
*/

}

#pragma mark - add loder

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
        case Tag_For_Remove_Alert:{
           
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"CancelNotification"
             object:self];
            [self removeAlert];
        }
            break;
        case 101:{
            [self removeAlert];
            [revealController revealToggle:nil];
            
            [_tbl_View reloadData];
            [CommonFunction stroeBoolValueForKey:isLoggedIn withBoolValue:false];
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"LogoutNotification"
             object:self];
        }
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

#pragma mark - Api hit
-(void)hitApiForStartTheChat:(QueueDetails*)obj{
    
    
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    [parameter setValue:[CommonFunction getValueFromDefaultWithKey:loginuserId] forKey:@"doctor_id"];
    [parameter setValue:obj.patient_id forKey:@"patient_id"];
    [parameter setValue:obj.queue_id forKey:@"queue_id"];
    if ([obj.dependentID isEqualToString:@"0"]) {
        [parameter setValue:@"na" forKey:DEPENDANT_ID];
    }else{
        [parameter setValue:obj.dependentID forKey:DEPENDANT_ID];
    }
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    [parameter setValue:[dateFormatter stringFromDate:date] forKey:@"start_datetime"];
    NSLog(@"%@",parameter);
    
    if ([ CommonFunction reachability]) {
//        [self addLoder];
        
        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,@"startchat"]  postResponse:parameter postImage:nil requestType:POST tag:nil isRequiredAuthentication:YES header:@"" completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"]) {
//                    [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:[responseObj valueForKey:@"message"] isTwoButtonNeeded:false firstbuttonTag:1002 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
                    
                 
                    
                    
                    
                    ChatViewController* vc = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
                    Specialization* temp = [Specialization new];
                    NSLog(@"%@ Chat With %@",[CommonFunction getValueFromDefaultWithKey:loginfirstname],obj.name);
                    temp.first_name = obj.name;
                    temp.doctor_id = obj.patient_id;
                    temp.dependent_id = obj.dependentID;
                    temp.dependent_Name = obj.dependentName;
                    vc.objDoctor  = temp;
                    vc.queue_id = obj.queue_id;
                    
                    //                    vc.awarenessObj = _awarenessObj;
                    vc.toId = obj.jabberId;
                    [self.navigationController pushViewController:vc animated:true];
                    
                }else if([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK002"]){
                   
                    
                    ChatViewController* vc = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
                    Specialization* temp = [Specialization new];
                    NSLog(@"%@ Chat With %@",[CommonFunction getValueFromDefaultWithKey:loginfirstname],[[responseObj valueForKey:@"patient"] valueForKey:@"name"]);
                    temp.first_name = [[responseObj valueForKey:@"patient"] valueForKey:@"name"];
                    temp.doctor_id = [[responseObj valueForKey:@"patient"] valueForKey:@"patient_id"];
                    temp.dependent_id = [NSString stringWithFormat:@"%@",[[[responseObj valueForKey:@"patient"] valueForKey:@"dependents"] valueForKey:@"dependent_id"]];
                    temp.dependent_Name = [NSString stringWithFormat:@"%@",[[[responseObj valueForKey:@"patient"] valueForKey:@"dependents"] valueForKey:@"name"]];
                    vc.objDoctor  = temp;
                    vc.queue_id = obj.queue_id;
                    
                    //                    vc.awarenessObj = _awarenessObj;
                    vc.toId = [NSString stringWithFormat:@"%@%@",[[[[responseObj valueForKey:@"patient"] valueForKey:@"email"] componentsSeparatedByString:@"@"] objectAtIndex:0],[[[[responseObj valueForKey:@"patient"] valueForKey:@"email"] componentsSeparatedByString:@"@"] objectAtIndex:1]];
                    [self.navigationController pushViewController:vc animated:true];
                    
                }
                
                else
                {
                    [self hitApiForTheQueueCount];
                    //[self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:[responseObj valueForKey:@"message"] isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
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
-(void)hitApiForTheQueueCount{
    [[QueueDetails sharedInstance].myDataArray removeAllObjects];
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    [parameter setValue:[CommonFunction getValueFromDefaultWithKey:loginuserId] forKey:@"doctor_id"];
    if ([ CommonFunction reachability]) {
        
        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,@"getallqueuepatient"]  postResponse:parameter postImage:nil requestType:POST tag:nil isRequiredAuthentication:YES header:@"" completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"]) {
                    NSLog(@"%@",responseObj);
                    NSArray *tempArray = [responseObj valueForKey:@"data"];
                    
                    [tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        QueueDetails *queueObj = [QueueDetails new];
                        queueObj.queue_id = [obj valueForKey:@"queue_id"];
                        queueObj.name = [obj valueForKey:@"name"];
                        queueObj.email = [obj valueForKey:@"email"];
                        queueObj.doctor_id = [obj valueForKey:@"doctor_id"];
                        queueObj.patient_id = [obj valueForKey:@"patient_id"];
                        queueObj.dependentID = [NSString stringWithFormat:@"%@",[[obj valueForKey:@"dependent"] valueForKey:@"dependent_id"]];
                        queueObj.dependentName = [NSString stringWithFormat:@"%@",[[obj valueForKey:@"dependent"] valueForKey:@"name"]];
                        queueObj.jabberId = [NSString stringWithFormat:@"%@%@",[[[obj valueForKey:@"email"] componentsSeparatedByString:@"@"] objectAtIndex:0],[[[obj valueForKey:@"email"] componentsSeparatedByString:@"@"] objectAtIndex:1]];
                        
                        [[QueueDetails sharedInstance].myDataArray addObject:queueObj];
                    }];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateCountLAbel" object:nil];
                }else{
//                      [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:[responseObj valueForKey:@"message"]  isTwoButtonNeeded:false firstbuttonTag:Tag_For_Remove_Alert secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
                    [[NSNotificationCenter defaultCenter]
                     postNotificationName:@"None Queue"
                     object:self];
                }
                
            }else{
                [self removeloder];
            }
        }
         ];
    }
}


@end
