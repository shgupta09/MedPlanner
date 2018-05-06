//
//  DProfileVC.m
//  TatabApp
//
//  Created by shubham gupta on 5/6/18.
//  Copyright © 2018 Shagun Verma. All rights reserved.
//

#import "DProfileVC.h"
#import "DProfileCellType1.h"
#import "DProfileCellType2.h"
#import "ProfileImageCell.h"
#import "Profile.h"
#import "ExperianceClass.h"
#import "Education.h"
@interface DProfileVC (){
    LoderView *loderObj;
    CustomAlert *alertObj;
    int numberOfEducation;
    int numberOfYearOfExperience;
    BOOL isEdit;
    Profile *profileObj;
}

@end

@implementation DProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    alertObj = [[CustomAlert alloc] initWithFrame:self.view.frame];
    profileObj = [Profile new];
    [self setData];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidLayoutSubviews{
    loderObj.frame = self.view.frame;
    alertObj.frame = self.view.frame;
}
-(void)setData{
    numberOfEducation = 2;
    numberOfYearOfExperience = 2;
    [self setLanguageData];
    [self setUpTableData];
    [self hitDoctorApi];
}
-(void)setLanguageData{
    _lbl_Title.text = [Langauge getTextFromTheKey:@"Doctor_Profile"];
    [_btn_Save setTitle:[Langauge getTextFromTheKey:@"Edit"] forState:UIControlStateNormal];
    isEdit = false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark- tableView delegate


-(void)setUpTableData{
    [_tblList registerNib:[UINib nibWithNibName:@"DProfileCellType1" bundle:nil]forCellReuseIdentifier:@"DProfileCellType1"];
    [_tblList registerNib:[UINib nibWithNibName:@"DProfileCellType2" bundle:nil]forCellReuseIdentifier:@"DProfileCellType2"];
    [_tblList registerNib:[UINib nibWithNibName:@"ProfileImageCell" bundle:nil]forCellReuseIdentifier:@"ProfileImageCell"];
    
    _tblList.rowHeight = UITableViewAutomaticDimension;
    _tblList.estimatedRowHeight = 100;
    _tblList.multipleTouchEnabled = NO;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6+[profileObj.experianceArray count]+[profileObj.educationArray count];
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0){
        ProfileImageCell *cell = [_tblList dequeueReusableCellWithIdentifier:@"ProfileImageCell"];
        
        if (cell == nil) {
            cell = [[ProfileImageCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ProfileImageCell"];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.img_Profile.layer.masksToBounds = true;
        cell.img_Profile.layer.cornerRadius = 65;
        cell.lbl_Title.text = profileObj.name;
        [cell.img_Profile sd_setImageWithURL:[NSURL URLWithString:profileObj.upload]];
//        cell.img_Profile.image = [UIImage imageNamed:@"Like"];
//        cell.lbl_Title.text = [Langauge getTextFromTheKey:@"About_Me"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }
   else if (indexPath.row == 1){
            DProfileCellType1 *cell = [_tblList dequeueReusableCellWithIdentifier:@"DProfileCellType1"];
            
            if (cell == nil) {
                cell = [[DProfileCellType1 alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"DProfileCellType1"];
                }
            cell.lbl2.hidden = true;
            cell.img_Icon.image = [UIImage imageNamed:@"Like"];
            cell.lbl_titleName.text = [Langauge getTextFromTheKey:@"About_Me"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
       
            return cell;
        }
         else if (indexPath.row == 2){
            DProfileCellType2 *cell = [_tblList dequeueReusableCellWithIdentifier:@"DProfileCellType2"];
            
            if (cell == nil) {
                cell = [[DProfileCellType2 alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"DProfileCellType2"];
                
            }
            cell.lbl1.hidden = true;
            cell.lbl2.hidden = true;
            cell.lbl3_UpperConstraint.constant = -10;
             
             if ([profileObj.about_me isEqualToString:@""]) {
                 cell.lbl3.text = @"N/A";
             }else{
                 cell.lbl3.text = profileObj.about_me;
             }
             if(isEdit){
                 cell.btn.layer.borderColor = [CommonFunction colorWithHexString:primary_Color].CGColor;
                 cell.traillingConstraint.constant = 5;
                 cell.btnDelete.hidden = true;
                 cell.btn.tag = 3;
                 cell.btn.hidden = false;
                 [cell.btn addTarget:self action:@selector(btnActionAdd:) forControlEvents:UIControlEventTouchUpInside];
             }else{
                 cell.traillingConstraint.constant = 5;
                 cell.btnDelete.hidden = true;
                 cell.btn.layer.borderColor = [UIColor clearColor   ].CGColor;
                 cell.btn.hidden = true;
             }
             cell.selectionStyle = UITableViewCellSelectionStyleNone;

            return cell;
        }
       else  if (indexPath.row == 3){
            DProfileCellType1 *cell = [_tblList dequeueReusableCellWithIdentifier:@"DProfileCellType1"];
            
            if (cell == nil) {
                cell = [[DProfileCellType1 alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"DProfileCellType1"];
                }
           if(isEdit){
               cell.btn.tag = 0;
               cell.btn.hidden = false;
               cell.lbl2.text = @"+";
               [cell.btn addTarget:self action:@selector(btnActionAdd:) forControlEvents:UIControlEventTouchUpInside];
           }else{
               cell.lbl2.text = @"";
               cell.btn.hidden = true;
           }
           cell.img_Icon.image = [UIImage imageNamed:@"Like"];
           cell.lbl_titleName.text = [Langauge getTextFromTheKey:@"Education"];
           cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
       else if ((indexPath.row >3 && ((indexPath.row <= 3+profileObj.educationArray.count )&&profileObj.educationArray.count>0))){
           DProfileCellType2 *cell = [_tblList dequeueReusableCellWithIdentifier:@"DProfileCellType2"];
           
           if (cell == nil) {
               cell = [[DProfileCellType2 alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"DProfileCellType2"];
           }
           cell.lbl1.hidden = false;
           cell.lbl2.hidden = true;
           cell.lbl3_UpperConstraint.constant = 10;
           Education *objClass = [Education new];
           objClass = [profileObj.educationArray objectAtIndex:indexPath.row-3];
           cell.lbl1.text = objClass.university_name;
           cell.lbl3.text = objClass.description;
           if(isEdit){
               cell.btn.layer.borderColor = [CommonFunction colorWithHexString:primary_Color].CGColor;
             cell.traillingConstraint.constant = 30;
               cell.btnDelete.hidden = false;
               cell.btn.tag = 100 + (indexPath.row - 3);
               cell.btnDelete.tag = 200 + (indexPath.row - 3);
               [cell.btn addTarget:self action:@selector(btnActionEditEducation:) forControlEvents:UIControlEventAllTouchEvents];
               [cell.btnDelete addTarget:self action:@selector(btnActionDeleteEducation:) forControlEvents:UIControlEventAllTouchEvents];

           }
           else{
               cell.btn.layer.borderColor = [UIColor clearColor].CGColor;
               cell.traillingConstraint.constant = 5;
               cell.btnDelete.hidden = true;
           }
           cell.selectionStyle = UITableViewCellSelectionStyleNone;

           return cell;
       }
       else  if (indexPath.row == 4+profileObj.educationArray.count){
           DProfileCellType1 *cell = [_tblList dequeueReusableCellWithIdentifier:@"DProfileCellType1"];
           
           if (cell == nil) {
               cell = [[DProfileCellType1 alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"DProfileCellType1"];
               
           }
           cell.lbl2.hidden = false;
           cell.lbl2.text = profileObj.home_location;
           cell.img_Icon.image = [UIImage imageNamed:@"Like"];
           cell.lbl_titleName.text = [Langauge getTextFromTheKey:@"Location"];
           if(isEdit){
               cell.btn.layer.borderColor = [CommonFunction colorWithHexString:primary_Color].CGColor;
               cell.btn.tag = 1;
               [cell.btn addTarget:self action:@selector(btnActionAdd:) forControlEvents:UIControlEventTouchUpInside];
               cell.btn.hidden = false;
           }else{
               cell.btn.hidden = true;
               cell.btn.layer.borderColor = [UIColor clearColor   ].CGColor;
           }
           cell.selectionStyle = UITableViewCellSelectionStyleNone;

           return cell;
       }
       else  if (indexPath.row == 5+profileObj.educationArray.count){
           DProfileCellType1 *cell = [_tblList dequeueReusableCellWithIdentifier:@"DProfileCellType1"];
           
           if (cell == nil) {
               cell = [[DProfileCellType1 alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"DProfileCellType1"];
               
           }
           if (isEdit) {
               cell.btn.tag = 2;
               cell.btn.hidden = false;
               cell.lbl2.text = @"+";
               [cell.btn addTarget:self action:@selector(btnActionAdd:) forControlEvents:UIControlEventTouchUpInside];
           }
           else{
               cell.lbl2.text = @"";
               cell.btn.hidden = true;
           }
//           cell.lbl2.text = @"Kasganj";
           cell.img_Icon.image = [UIImage imageNamed:@"Like"];
           cell.lbl_titleName.text = [Langauge getTextFromTheKey:@"Years_Of_Experience"];
           cell.selectionStyle = UITableViewCellSelectionStyleNone;

           return cell;
       }
       else if (indexPath.row >= 6+profileObj.educationArray.count){
           DProfileCellType2 *cell = [_tblList dequeueReusableCellWithIdentifier:@"DProfileCellType2"];
           
           if (cell == nil) {
               cell = [[DProfileCellType2 alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"DProfileCellType2"];
               
           }
           ExperianceClass *objClass = [ExperianceClass new];
           objClass = [profileObj.experianceArray objectAtIndex:indexPath.row-6];
           cell.lbl1.hidden = false;
           cell.lbl2.hidden = false;
           cell.lbl3_UpperConstraint.constant = 10;
           cell.lbl1.text = objClass.hospital_name;
           cell.lbl2.text = [NSString stringWithFormat:@"%@-%@",objClass.worked_since,objClass.resigned_since];
           cell.lbl3.text = objClass.descriptionObj;
           if(isEdit){
               cell.btn.layer.borderColor = [CommonFunction colorWithHexString:primary_Color].CGColor;
               cell.btn.tag =
               cell.traillingConstraint.constant = 30;
               cell.btnDelete.hidden = false;
               cell.btn.tag = 100 + (indexPath.row - 6-profileObj.educationArray.count);
               cell.btnDelete.tag = 100 + (indexPath.row - 6-profileObj.educationArray.count);
               [cell.btn addTarget:self action:@selector(btnActionEditExperience:) forControlEvents:UIControlEventTouchUpInside];
               [cell.btnDelete addTarget:self action:@selector(btnActionDeleteExperience:) forControlEvents:UIControlEventTouchUpInside];
           }
           else{
               cell.btn.layer.borderColor = [UIColor clearColor   ].CGColor;
               cell.traillingConstraint.constant = 5;
               cell.btnDelete.hidden = true;

           }
           cell.selectionStyle = UITableViewCellSelectionStyleNone;

           
           return cell;
       }
    DProfileCellType1 *cell = [_tblList dequeueReusableCellWithIdentifier:@"DProfileCellType1"];
    
    if (cell == nil) {
        cell = [[DProfileCellType1 alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"DProfileCellType1"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
    
}


-(void)btnActionAdd:(UIButton *)btn{
    if (btn.tag == 0) {
        NSLog(@"Add Education");
    }else if (btn.tag == 1){
        NSLog(@"Location");
    }else if (btn.tag == 2){
        NSLog(@"Add experience");
    }else if(btn.tag ==3){
        NSLog(@"About tapped");
    }
    
}
-(void)btnActionEditAbout{
    NSLog(@"AboutEditTapped");
}
-(void)btnActionEditEducation:(UIButton *)btn{
    NSLog(@"EducationEditTapped %d",btn.tag);
}
-(void)btnActionDeleteEducation:(UIButton *)btn{
    NSLog(@"EducationDEleteTapped %d",btn.tag);
}
-(void)btnActionEditExperience:(UIButton *)btn{
    NSLog(@"ExperienceEditTapped %d",btn.tag);
}
-(void)btnActionDeleteExperience:(UIButton *)btn{
    NSLog(@"ExperienceDEleteTapped %d",btn.tag);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

#pragma mark - Btn Action

- (IBAction)btnAction_Save:(id)sender {
    if (!isEdit) {
        isEdit = true;
         [_btn_Save setTitle:[Langauge getTextFromTheKey:@"Save"] forState:UIControlStateNormal];
        [_tblList reloadData];
    }else{
        isEdit = false;
        [_tblList reloadData];
         [_btn_Save setTitle:[Langauge getTextFromTheKey:@"Edit"] forState:UIControlStateNormal];
    }
    
}
- (IBAction)btnAction_Back:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
#pragma mark - hit api
-(void)hitDoctorApi{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    //[dict setValue:[CommonFunction getValueFromDefaultWithKey:loginuserId] forKey:loginUser];
    [dict setValue:@"26" forKey:@"doctor_id"];
    if ([ CommonFunction reachability]) {
        [self addLoder];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_Get_Doctor]  postResponse:[dict mutableCopy] postImage:nil requestType:POST tag:nil isRequiredAuthentication:NO header:NPHeaderName completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"] == true){
                    NSDictionary *dataDict = [NSDictionary new];
                    dataDict = [responseObj valueForKey:@"data"];
                    profileObj = [Profile new];
                    profileObj.about_me = [CommonFunction checkForNull:[dataDict valueForKey:@"about_me"]];
                    profileObj.home_location =  [CommonFunction checkForNull:[dataDict valueForKey:@"home_location"]];
                    profileObj.name =  [CommonFunction checkForNull:[dataDict valueForKey:@"name"]];
                    profileObj.upload =  [CommonFunction checkForNull:[dataDict valueForKey:@"upload"]];
                    NSArray *tempArray = [NSArray new];
                    NSMutableArray *tempArray2 = [NSMutableArray new];
                    tempArray =  [dataDict valueForKey:@"experience"];
                    [tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        ExperianceClass *expObj = [ExperianceClass new];
                        expObj.descriptionObj = [CommonFunction checkForNull:[obj valueForKey:@"description"]];
                        expObj.hospital_name = [CommonFunction checkForNull:[obj valueForKey:@"hospital_name"]];
                        expObj.resigned_since = [CommonFunction checkForNull:[obj valueForKey:@"resigned_since"]];
                        expObj.worked_since = [CommonFunction checkForNull:[obj valueForKey:@"worked_since"]];
                        [tempArray2 addObject:expObj];
                    }];
                    profileObj.experianceArray = tempArray2;
                    tempArray =  [dataDict valueForKey:@"education"];
                    tempArray2 = [NSMutableArray new];
                    [tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        Education *eduObj = [Education new];
                        
                        eduObj.edu_id = [CommonFunction checkForNull:[obj valueForKey:@"edu_id"]];
                        eduObj.university_name = [CommonFunction checkForNull:[obj valueForKey:@"university_name"]];
                        eduObj.description = [CommonFunction checkForNull:[obj valueForKey:@"description"]];
                        [tempArray2 addObject:eduObj];
                    }];
                    profileObj.educationArray = tempArray2;
                    [_tblList reloadData];
                    [self removeloder];
                }
                else
                {
                    [self addAlertWithTitle:[Langauge getTextFromTheKey:Error_Key] andMessage:[responseObj valueForKey:@"message"] isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Error_Key_For_Image];
                    [self removeloder];
                }
            }
            else {
                [self removeloder];
                [self addAlertWithTitle:[Langauge getTextFromTheKey:Error_Key] andMessage:Sevrer_Issue_Message isTwoButtonNeeded:false firstbuttonTag:1001 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Error_Key_For_Image];
            }
            
            
        }];
    } else {
        [self addAlertWithTitle:[Langauge getTextFromTheKey:Error_Key] andMessage:Network_Issue_Message isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Error_Key_For_Image];
    }
    
    
}
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
        case 101:{
            [self removeloder];
            // [_popUpView removeFromSuperview];
            [self removeAlert];
        }
        case 1001:{
            [self dismissViewControllerAnimated:true completion:nil];
            
            
        }
        default:
            
            break;
    }
}
@end
