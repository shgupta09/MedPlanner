//
//  NewAwareVC.m
//  TatabApp
//
//  Created by shubham gupta on 1/11/18.
//  Copyright © 2018 Shagun Verma. All rights reserved.
//

#import "NewAwareVC.h"
#import "MediaPostCell.h"
#import "OTPVc.h"
#import "MMDrawerController.h"
@interface NewAwareVC ()<UITextViewDelegate,UITextFieldDelegate>{
    
    UIView *addSubView;
    UIImageView *imgView;
    SWRevealViewController *revealController;
    
    MMDrawerController * drawerController;
    BOOL isOpen;
    UIView *tempView;
    UITapGestureRecognizer *singleFingerTap;
    UIImagePickerControllerSourceType *sourceType;
    UIImagePickerController * picker;
     NSMutableArray *imageDataArray;
    LoderView *loderObj;
      NSMutableArray *categoryArray;
    NSMutableArray *dataArray;
    NSString *imageUrl;
    bool is_Media;
    NSString *postId;
    NSMutableArray *sortedArray;
    NSMutableArray *unsortedArray;
    BOOL ISFirsTime;
    CustomAlert *alertObj;
    CustomTabBar *tabBarObj;
    NSString *strToSearch;
    NSString *strToSearchEnglish;
    
}
@end

@implementation NewAwareVC

- (void)viewDidLoad {
    [super viewDidLoad];
    alertObj = [[CustomAlert alloc] initWithFrame:self.view.frame];
    strToSearch = @"";
    strToSearchEnglish = @"";
    _searchOptionBtnAction.tintColor = [UIColor whiteColor];
    tempView = [UIView new];
    UIImage * image = [UIImage imageNamed:@"Icon---Search"];
    [_searchOptionBtnAction setBackgroundImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    ISFirsTime = true;
    _tbl_Constraint.constant = 0;
    _lbl_SearchedText.hidden = true;
    _btnClearSearch.hidden = true;
    sortedArray = [NSMutableArray new];
    unsortedArray = [NSMutableArray new];
    _viewToClip.layer.cornerRadius = 5;
    _viewToClip.layer.masksToBounds = true;
    _viewToClip2.layer.cornerRadius = 20;
    _viewToClip2.layer.masksToBounds = true;
    dataArray = [NSMutableArray new];
    imageUrl = @"";
    is_Media = false;
    categoryArray = [[NSMutableArray alloc] init] ;
    imageDataArray = [NSMutableArray new];
    picker = [[UIImagePickerController alloc] init];
    isOpen = false;
    revealController = [self revealViewController];
    
    singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                              action:@selector(handleSingleTap:)];
    [_tbl_View registerNib:[UINib nibWithNibName:@"TextPostCell" bundle:nil]forCellReuseIdentifier:@"TextPostCell"];
    [_tbl_View registerNib:[UINib nibWithNibName:@"MediaPostCell" bundle:nil]forCellReuseIdentifier:@"MediaPostCell"];

    _tbl_View.rowHeight = UITableViewAutomaticDimension;
    _tbl_View.estimatedRowHeight = 200;
    _tbl_View.multipleTouchEnabled = NO;
    addSubView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    imgView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 80, [[UIScreen mainScreen] bounds].size.width-40, [[UIScreen mainScreen] bounds].size.height-160)];
    [imgView setContentMode:UIViewContentModeCenter];

    imgView.center = addSubView.center;
   // imgView.center = CGPointMake(imgView.center.x, imgView.center.y-50) ;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"Queue Tapped"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"LogoutNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"LogOutTapped"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"NONE TO CHAT"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"None Queue"
                                               object:nil];
    
    
    [self addCustomTabBar];
    tabBarObj.btnAwareness.highlighted = true;
    _lbl_NoData.text = [Langauge getTextFromTheKey:@"no_data"];
    _lbl_title.text = [Langauge getTextFromTheKey:@"awareness"];
    // Do any additional setup after loading the view from its nib.
}



-(void)checkForOTP{
    NSString *mobilStr = [NSString stringWithFormat:@"%@",[CommonFunction getValueFromDefaultWithKey:LOGIN_IS_MOBILE_VERIFY]];
    if (![mobilStr isEqualToString:@"1"] && [CommonFunction getBoolValueFromDefaultWithKey:isLoggedInHit] && ![CommonFunction getBoolValueFromDefaultWithKey:isLoggedIn] ) {
        [self otpVerification];
    }
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    loderObj.frame = self.view.frame;
    alertObj.frame = self.view.frame;
    tabBarObj.frame =CGRectMake(0, self.view.frame.size.height-49, self.view.frame.size.width, 49);
    
    
    
  
}
-(void)receiveNotification:(NSNotification*)notObj{
    [tempView removeGestureRecognizer:singleFingerTap];
    [tempView removeFromSuperview];
    isOpen = false;
    if ([notObj.name isEqualToString:@"LogoutNotification"]) {
        [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:[Langauge getTextFromTheKey:@"logout_success"] isTwoButtonNeeded:false firstbuttonTag:103 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Alert_Key_For_Image];
        
        [CommonFunction stroeBoolValueForKey:NOTIFICATION_BOOl withBoolValue:false];
        [CommonFunction storeValueInDefault:@"0" andKey:NOTIFICATION_DOCTOR_ID];
        [CommonFunction storeValueInDefault:@"0" andKey:NOTIFICATION_PATIENT_ID];
        [self hitApiForaddingTheDeviceID];
    }else if([notObj.name isEqualToString:@"LogOutTapped"]){
     [self addAlertWithTitle:[Langauge getTextFromTheKey:Warning_Key] andMessage:[Langauge getTextFromTheKey:@"logout_sure"]   isTwoButtonNeeded:true firstbuttonTag:101 secondButtonTag:104 firstbuttonTitle:[Langauge getTextFromTheKey:@"ok"] secondButtonTitle:[Langauge getTextFromTheKey:@"cancel"] image:Warning_Key_For_Image];
    }else if([notObj.name isEqualToString:@"NONE TO CHAT"]){
    [self addAlertWithTitle:[Langauge getTextFromTheKey:Warning_Key] andMessage:@"No patient present in the queue." isTwoButtonNeeded:false firstbuttonTag:103 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
    }else if ([notObj.name isEqualToString:@"UpdateCountLAbel"]){
        
        
    }else if([notObj.name isEqualToString:@"None Queue"]){
          [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:@"Queue is empty." isTwoButtonNeeded:false firstbuttonTag:Tag_For_Remove_Alert secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
    }else if([notObj.name isEqualToString:@"Queue Tapped"]){
        [self disapper];
    }
    
  /*  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Logout Successfully" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self viewWillAppear:TRUE];
    }];
    [alertController addAction:ok];
    [self presentViewController:alertController animated:YES completion:nil];
    */
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:true];
    self.navigationController.navigationBar.hidden = true;
    isOpen = false;
    if ([CommonFunction getBoolValueFromDefaultWithKey:isLoggedIn]){

    if (![[CommonFunction getValueFromDefaultWithKey:loginuserType] isEqualToString:@"Patient"]) {
        //tabBarObj.view.hidden = false;
        if (![CommonFunction getBoolValueFromDefaultWithKey:isLoggedIn]){
            _btn_Post.hidden = true;
            _btn_Post.userInteractionEnabled = false;
            _btn_Post.hidden = true;
            _btn_Post.userInteractionEnabled = false;
            [_imgView_Profile removeFromSuperview];
            [_btn_Post removeFromSuperview];
        }else{
            _btn_Post.hidden = false;
            _btn_Post.userInteractionEnabled = true;
              [_imgView_Profile sd_setImageWithURL:[NSURL URLWithString:[CommonFunction getValueFromDefaultWithKey:logInImageUrl]]];
            [self hitApiForTheQueueCount];
        }
    }else{
        _btn_Post.hidden = true;
        _btn_Post.userInteractionEnabled = false;
        [_imgView_Profile removeFromSuperview];
        //tabBarObj.view.hidden = true;
    }
    }else{
        _btn_Post.hidden = true;
        _btn_Post.userInteractionEnabled = false;
        [_imgView_Profile removeFromSuperview];
        tabBarObj.view.hidden = true;
    }
    if (!is_Media) {
    [self geAllPost];    
    }
    [self performSelector:@selector(checkForOTP)  withObject:nil afterDelay:1];


}
//The event handling method
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    self.navigationController.navigationBar.userInteractionEnabled = true;
    if (isOpen){
        if ([CommonFunction isEnglishSelected]) {
            [revealController revealToggle:nil];
        }else{
            [revealController rightRevealToggle:nil];
        }
        [tempView removeGestureRecognizer:singleFingerTap];
        [tempView removeFromSuperview];
        isOpen = false;
    }else{
        [tempView removeGestureRecognizer:singleFingerTap];
        [tempView removeFromSuperview];
    }
    
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [self disapper];
}
-(void)disapper{
    [tempView removeGestureRecognizer:singleFingerTap];
    [tempView removeFromSuperview];
    isOpen = false;
}

#pragma mark - ZoomImage
-(void)addTapAtZoomedImage{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zoomOut)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [addSubView addGestureRecognizer:singleTap];
}

-(void)zoomWithImage:(NSString *)imageUrlString{
    [imgView sd_setImageWithURL:[NSURL URLWithString:imageUrlString]];
    addSubView = [[UIView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height)];
    [addSubView setBackgroundColor:[UIColor colorWithRed:0.5/255.0f green:0.5/255.0f blue:0.5/255.0f alpha:.8]];
    [addSubView addSubview:imgView];
    addSubView.tag = 101;
    imgView.tag = 102;
    [self.view addSubview:addSubView];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    addSubView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        // animate it to the identity transform (100% scale)
        addSubView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        // if you want to do something once the animation finishes, put it here
    }];
    [self addTapAtZoomedImage];
    
    
}

-(void)zoomOut{
    //    [addSubView setFrame:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 0, 0)];
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        // animate it to the identity transform (100% scale)
        addSubView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished){
        [addSubView removeFromSuperview];
        [imgView removeFromSuperview];
        [addSubView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.tag == 102) {
                [obj removeFromSuperview];
            }
        }];
        [[self.view subviews] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.tag == 101) {
                [obj removeFromSuperview];
            }
        }];
    }];
    
}

#pragma mark - textviewDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 100){
        return false;
    }
    return true;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Add some text..."]) {
        textView.text = @"";
        textView.textColor = [UIColor whiteColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Add some text...";
        textView.textColor = [UIColor darkGrayColor]; //optional
    }
    [textView resignFirstResponder];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if (textView.text.length + text.length <= 250) {
       
    
        _LBLCHARACTERCOUNT.textColor = [UIColor whiteColor];
    }else if(textView.text.length + text.length > 500 && ![text isEqualToString: @""]){
         [self addAlertWithTitle:[Langauge getTextFromTheKey:Warning_Key] andMessage:@"The content length is more than 500 characters. Content length should be 250 characters." isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
        return false;
    }
    else{
        _LBLCHARACTERCOUNT.textColor = [UIColor redColor];
    }
    [_LBLCHARACTERCOUNT setText:[NSString stringWithFormat:@"%d",(int)(250-textView.text.length- text.length)]];
    
    return true;
    
}

#pragma mark - textField Delegate


#pragma mark- SWRevealViewController

- (IBAction)revealAction:(id)sender {
    //    self.view.userInteractionEnabled = false;
    self.navigationController.navigationBar.userInteractionEnabled = true;
    
    
    if (isOpen) {
        if ([CommonFunction isEnglishSelected]) {
            [revealController revealToggle:nil];
        }else{
             [revealController rightRevealToggle:nil];
        }
       
        
        [tempView removeGestureRecognizer:singleFingerTap];
        [tempView removeFromSuperview];
        isOpen = false;
        
        
        
    }
    else{
        
        if ([CommonFunction isEnglishSelected]) {
            [revealController revealToggle:nil];
        }else{
            [revealController rightRevealToggle:nil];
        }
        tempView.frame  =CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height);
        //tempView.backgroundColor = [UIColor redColor];
        [tempView addGestureRecognizer:singleFingerTap];
        [self.view addSubview:tempView];
        isOpen = true;
    }
    
}

#pragma mark- tableView delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (dataArray.count == 0) {
        _lbl_NoData.hidden = false;
        return 0;
    }
    _lbl_NoData.hidden = true;
    return dataArray.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PostData *obj = [dataArray objectAtIndex:indexPath.row];
    if ([obj.type isEqualToString:@"photo"] ) {


        MediaPostCell *cell = [_tbl_View dequeueReusableCellWithIdentifier:@"MediaPostCell"];
        if (cell == nil) {
            cell = [[MediaPostCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MediaPostCell"];
        }
        cell.clinicImageView.layer.borderColor = [CommonFunction colorWithHexString:Primary_GreenColor].CGColor;
        cell.clinicImageView.layer.borderWidth = 1;
        cell.lbl_DoctorName.text = [NSString stringWithFormat:@"Dr. %@",obj.post_by];
        [cell.imgView_Content sd_setImageWithURL:[NSURL URLWithString:obj.url]];
        cell.imgViewContentContainer.layer.shadowRadius  = 2.0f;
        cell.imgViewContentContainer.layer.shadowColor   = [UIColor colorWithRed:176.f/255.f green:199.f/255.f blue:226.f/255.f alpha:1.f].CGColor;
        cell.imgViewContentContainer.layer.shadowOffset  = CGSizeMake(0.0f, 0.0f);
        cell.imgViewContentContainer.layer.shadowOpacity = 0.9f;
        cell.imgViewContentContainer.layer.masksToBounds = NO;
        
        UIEdgeInsets shadowInsets     = UIEdgeInsetsMake(0, 0, -1.5f, 0);
        UIBezierPath *shadowPath      = [UIBezierPath bezierPathWithRect:UIEdgeInsetsInsetRect(cell.imgViewContentContainer.bounds, shadowInsets)];
        cell.imgViewContentContainer.layer.shadowPath    = shadowPath.CGPath;
        cell.viewForImage.layer.cornerRadius = 5;
        cell.viewForImage.layer.masksToBounds = true;
        cell.doctorImageView.layer.cornerRadius = 5;
        cell.doctorImageView.layer.masksToBounds = true;
        cell.clinicImageView.layer.cornerRadius = 5;
        cell.clinicImageView.layer.masksToBounds = true;
        [cell.btn_Like addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        cell.btn_Like.tag = 1000+indexPath.row;
        [cell.btn_Comment addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        cell.btn_Comment.tag = 2000+indexPath.row;
        [cell.btn_Share addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        cell.btn_Share.tag = 3000+indexPath.row;
        cell.lbl_LikeCount.text = [NSString stringWithFormat:@"%@",obj.total_likes];
        cell.lbl_CommentCount.text = [NSString stringWithFormat:@"%@",obj.total_comments];
//        cell.lbl_ShareCount.text = [NSString stringWithFormat:@"%@",obj.total_likes];
        [cell.doctorImageView sd_setImageWithURL:[NSURL URLWithString:obj.icon_url]];
        [cell.clinicImageView setImage:[CommonFunction setImageFor:obj.clinicName]];
        cell.profileBtn.tag = 5000+indexPath.row;
        [cell.profileBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        cell.contentBtn.tag = 4000+indexPath.row;
        [cell.contentBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        if (![CommonFunction getBoolValueFromDefaultWithKey:isLoggedIn]){
            [cell.btn_Like setBackgroundImage:[UIImage imageNamed:@"Like"] forState:UIControlStateNormal];
            
        }else{
            if ([obj.is_liked intValue] >0) {
                [cell.btn_Like setBackgroundImage:[UIImage imageNamed:@"Liked"] forState:UIControlStateNormal];
            }
            else{
                [cell.btn_Like setBackgroundImage:[UIImage imageNamed:@"Like"] forState:UIControlStateNormal];
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        TextPostCell *cell = [_tbl_View dequeueReusableCellWithIdentifier:@"TextPostCell"];
        if (cell == nil) {
            cell = [[TextPostCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"TextPostCell"];
        }
        cell.lbl_DoctorName.text = [NSString stringWithFormat:@"Dr. %@",obj.post_by];
        cell.lbl_Content.text = obj.content;
        cell.viewForImage.layer.cornerRadius = 5;
        cell.viewForImage.layer.masksToBounds = true;
        cell.doctorImageView.layer.cornerRadius = 5;
        cell.doctorImageView.layer.masksToBounds = true;
        cell.clinicImageView.layer.cornerRadius = 5;
        cell.clinicImageView.layer.masksToBounds = true;
        cell.clinicImageView.layer.borderColor = [CommonFunction colorWithHexString:@"7AC430"].CGColor;
        cell.clinicImageView.layer.borderWidth = 1;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.btn_Like addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        cell.btn_Like.tag = 1000+indexPath.row;
        [cell.btn_Comment addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        cell.btn_Comment.tag = 2000+indexPath.row;
        [cell.btn_Share addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        cell.btn_Share.tag = 3000+indexPath.row;
        cell.lbl_LikeCount.text = [NSString stringWithFormat:@"%@",obj.total_likes];
        cell.lbl_CommentCount.text = [NSString stringWithFormat:@"%@",obj.total_comments];
//        cell.lbl_ShareCount.text = [NSString stringWithFormat:@"%@",obj.total_likes];
        [cell.doctorImageView sd_setImageWithURL:[NSURL URLWithString:obj.icon_url]];
        [cell.clinicImageView setImage:[CommonFunction setImageFor:obj.clinicName]];
        cell.profileContent.tag = 5000+indexPath.row;
        [cell.profileContent addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];

        if (![CommonFunction getBoolValueFromDefaultWithKey:isLoggedIn]){

            [cell.btn_Like setBackgroundImage:[UIImage imageNamed:@"Like"] forState:UIControlStateNormal];

        }else{
            if ([obj.is_liked intValue] >0) {
                [cell.btn_Like setBackgroundImage:[UIImage imageNamed:@"Liked"] forState:UIControlStateNormal];
            }
            else{
                [cell.btn_Like setBackgroundImage:[UIImage imageNamed:@"Like"] forState:UIControlStateNormal];
            }
        }
        
        return cell;

    }
    TextPostCell *cell = [_tbl_View dequeueReusableCellWithIdentifier:@"TextPostCell"];
    return cell;
}




-(void)btnClicked:(id)sender{
    if (((UIButton *)sender).tag /1000 == 5){
        PostData *obj= [dataArray objectAtIndex:((UIButton *)sender).tag%1000];
        [self zoomWithImage:obj.icon_url];
        
    }else if (((UIButton *)sender).tag /1000 == 4){
              PostData *obj2= [dataArray objectAtIndex:((UIButton *)sender).tag%1000];
              [self zoomWithImage:obj2.url];
    }else if (((UIButton *)sender).tag /1000 == 2){
         if ([CommonFunction getBoolValueFromDefaultWithKey:isLoggedIn]){
          
                PostData *obj= [dataArray objectAtIndex:((UIButton *)sender).tag%1000];
                postId= obj.post_id;
             CommentVCViewController* vc ;
             vc = [[CommentVCViewController alloc] initWithNibName:@"CommentVCViewController" bundle:nil];
             vc.postId = obj.post_id;
             vc.postObj = obj;
             [self.navigationController pushViewController:vc animated:true];
         }else{
             LoginViewController* vc ;
             vc = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
             [self.navigationController pushViewController:vc animated:true];
         }

    }
    else{
            if ([CommonFunction getBoolValueFromDefaultWithKey:isLoggedIn]){
                if (((UIButton *)sender).tag /1000 == 1){
                    PostData *obj= [dataArray objectAtIndex:((UIButton *)sender).tag%1000];
                    postId= obj.post_id;
                    if ([obj.is_liked intValue] >0 ) {
                        [self hitAPiTolikeAPost:@"0"];
                    }
                    else{
                        [self hitAPiTolikeAPost:@"1"];
                    }
                }
                
            }else{
                LoginViewController* vc ;
                vc = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
                [self.navigationController pushViewController:vc animated:true];
            }

        }
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
}

#pragma mark-BtnAction
- (IBAction)btnAction_Search:(id)sender {
    _txt_Search.text = strToSearch ;
    [_btn1 setTitle:[Langauge getTextFromTheKey:@"obgyne"] forState:UIControlStateNormal];
    [_btn2 setTitle:[Langauge getTextFromTheKey:@"pediatrics"] forState:UIControlStateNormal];
    [_btn3 setTitle:[Langauge getTextFromTheKey:@"abdominal"] forState:UIControlStateNormal];
    [_btn4 setTitle:[Langauge getTextFromTheKey:@"psychological"] forState:UIControlStateNormal];
    [_btn5 setTitle:[Langauge getTextFromTheKey:@"family_and_community"] forState:UIControlStateNormal];
    [self addPopupview2];
    
    
}
- (IBAction)btnAction_SearchCategory:(id)sender {
    [_btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     [_btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     [_btn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     [_btn4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     [_btn5 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btn1.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
    [_btn2.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
    [_btn3.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
    [_btn4.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
    [_btn5.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
    
    
    
    switch (((UIButton *)sender).tag) {
        case 0:
            _txt_Search.text = [Langauge getTextFromTheKey:@"obgyne"];
            strToSearchEnglish = @"obgyne";
             [_btn1 setTitleColor:[CommonFunction colorWithHexString:primary_Color] forState:UIControlStateNormal];
            [_btn1.titleLabel setFont:[UIFont boldSystemFontOfSize:15.f]];
            break;
        case 1:
            _txt_Search.text = [Langauge getTextFromTheKey:@"pediatrics"];
            strToSearchEnglish = @"pediatric";
             [_btn2 setTitleColor:[CommonFunction colorWithHexString:primary_Color] forState:UIControlStateNormal];
            [_btn2.titleLabel setFont:[UIFont boldSystemFontOfSize:15.f]];

            break;
        case 2:
            _txt_Search.text = [Langauge getTextFromTheKey:@"abdominal"];
            strToSearchEnglish = @"abodminal";
             [_btn3 setTitleColor:[CommonFunction colorWithHexString:primary_Color] forState:UIControlStateNormal];
            [_btn3.titleLabel setFont:[UIFont boldSystemFontOfSize:15.f]];

            break;
        case 3:
            _txt_Search.text = [Langauge getTextFromTheKey:@"psychological"];
            strToSearchEnglish = @"psycological";
           [_btn4 setTitleColor:[CommonFunction colorWithHexString:primary_Color] forState:UIControlStateNormal];
            [_btn4.titleLabel setFont:[UIFont boldSystemFontOfSize:15.f]];

            break;
        case 4:
            _txt_Search.text =[Langauge getTextFromTheKey:@"family_and_community"];
            strToSearchEnglish = @"Family and Community";
             [_btn5 setTitleColor:[CommonFunction colorWithHexString:primary_Color] forState:UIControlStateNormal];
            [_btn5.titleLabel setFont:[UIFont boldSystemFontOfSize:15.f]];

            break;
                        
        default:
            break;
    }
}


- (IBAction)btn_ActionFilter:(id)sender {
    
}
- (IBAction)btnActionPost:(id)sender {
    [self addPopupview];
}

- (IBAction)btnAction_Cancel:(id)sender {
    //_txt_txtView.text =@"";
    [CommonFunction removeAnimationFromView:_popUpView];
}
- (IBAction)btnAction_Cancel2:(id)sender {
    _txt_Search.text = @"";
    [CommonFunction removeAnimationFromView:_popUpView2];
}

- (IBAction)btnActionSendPost:(id)sender {
    if ([_txt_txtView.text isEqualToString:PlaceHolder]||[_txt_txtView.text isEqualToString:@""]){
       /* UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Please enter some text" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
        */
         [self addAlertWithTitle:[Langauge getTextFromTheKey:Warning_Key] andMessage:@"Please enter some text" isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
    }else if(_txt_txtView.text.length >250){
           [self addAlertWithTitle:[Langauge getTextFromTheKey:Warning_Key] andMessage:@"The content length is more than 250 characters. Content length should be 250 characters." isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
    }else{
        
        [self uploadPost];
    }
    
    
}
- (IBAction)btnAction_Attatchment:(id)sender {
    sourceType = UIImagePickerControllerSourceTypeCamera;
    [self imageCapture];
}
- (IBAction)btnAction_ApplySearch:(id)sender {
     strToSearch = _txt_Search.text;
    sortedArray = [NSMutableArray new];
    [unsortedArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       PostData *tempObj = (PostData *)obj;
        if ([[tempObj.clinicName lowercaseString] containsString:[strToSearchEnglish lowercaseString]]) {
            [sortedArray addObject:obj];
        }
    }];
    dataArray = sortedArray;
    [_tbl_View reloadData];
    [CommonFunction removeAnimationFromView:_popUpView2];
    _btnClearSearch.hidden = false;
    _lbl_SearchedText.hidden = false;
    _lbl_SearchedText.text = [NSString stringWithFormat:@"%@: %@",[Langauge getTextFromTheKey:@"search_phrase"],[strToSearch capitalizedString]];
    _tbl_Constraint.constant = 40;
}
- (IBAction)btnAction_CalearSearch:(id)sender {
    dataArray = unsortedArray;
    [_tbl_View reloadData];
    _btnClearSearch.hidden = true;
    _lbl_SearchedText.hidden = true;
    _tbl_Constraint.constant = 0;
}
- (IBAction)btnDocumentAttachment:(id)sender {
    [self selectPhoto];
    
}

- (IBAction)btnAction_ImageToSend:(id)sender {
    [self imageToCompress:_imgView_ToShow.image];
}
#pragma mark-Other



-(void)showActionSheet{
    [CommonFunction resignFirstResponderOfAView:self.view];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Options"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"Camera"
                                                    otherButtonTitles:@"Library", nil];
    
    [actionSheet showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        sourceType = UIImagePickerControllerSourceTypeCamera;
        [self imageCapture];
    }else if(buttonIndex == 1){
        [self selectPhoto];
    }
    
    
}

- (void)selectPhoto {
    
    picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
    
}


#pragma mark - Image Capture related
-(void)imageCapture{
    picker.delegate = self;
    
    picker.sourceType = sourceType;
    picker.cameraDevice=UIImagePickerControllerCameraDeviceRear;
    picker.videoQuality = UIImagePickerControllerQualityType640x480;
    UIView *cameraOverlayView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 100.0f, 5.0f, 100.0f, 35.0f)];
    [cameraOverlayView setBackgroundColor:[UIColor blackColor]];
    UIButton *emptyBlackButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 35.0f)];
    [emptyBlackButton setBackgroundColor:[UIColor blackColor]];
    [emptyBlackButton setEnabled:YES];
    [cameraOverlayView addSubview:emptyBlackButton];
    picker.allowsEditing = NO;
    picker.showsCameraControls = YES;
    picker.delegate = self;
    
    picker.cameraOverlayView = cameraOverlayView;
    [[AppDelegate getDelegate]hideStatusBar];
    [self presentModalViewController:picker animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [[AppDelegate getDelegate]showStatusBar];
    
    UIImage *capturedImage =[info valueForKey:@"UIImagePickerControllerOriginalImage"];;
    [self addPopupview3:capturedImage];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [[AppDelegate getDelegate]showStatusBar];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(UIImage *)imageToCompress:(UIImage *)image{
    
    // Determine output size
    CGFloat maxSize = 640.0f;
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGFloat newWidth = width;
    CGFloat newHeight = height;
    
    // If any side exceeds the maximun size, reduce the greater side to 1200px and proportionately the other one
    if (width > maxSize || height > maxSize) {
        if (width > height) {
            newWidth = maxSize;
            newHeight = (height*maxSize)/width;
        } else {
            newHeight = maxSize;
            newWidth = (width*maxSize)/height;
        }
    }
    
    // Resize the image
    CGSize newSize = CGSizeMake(newWidth, newHeight);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Set maximun compression in order to decrease file size and enable faster uploads & downloads
    NSData *imageData = UIImageJPEGRepresentation(newImage, 0.0f);
    
    [imageDataArray addObject:imageData];
    UIImage *processedImage = [UIImage imageWithData:imageData];
    is_Media = true;
    [self hitImageUploadApi];
    
    return processedImage;
    
}
-(void)resignResponder{
    [CommonFunction resignFirstResponderOfAView:self.view];
    if ([_popUpView isDescendantOfView:self.view]) {
        [_popUpView removeFromSuperview];
    }else if ([_popUpView2 isDescendantOfView:self.view]) {
        [_popUpView2 removeFromSuperview];
    }
    else if ([_popUpView3 isDescendantOfView:self.view]) {
        [_popUpView3 removeFromSuperview];
    }
}


-(void)addPopupview{
    [CommonFunction setResignTapGestureToView:_popUpView andsender:self];
    if ([_txt_txtView.text isEqualToString:@"Add some text..."]){
    _txt_txtView.text = @"Add some text...";
        [_LBLCHARACTERCOUNT setText:[NSString stringWithFormat:@"%d",250]];
        // _txt_txtView.textColor = [UIColor darkGrayColor]; //optional
    }
    [_txt_txtView becomeFirstResponder];
   
    [[self popUpView] setAutoresizesSubviews:true];
    [[self popUpView] setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) ;
    frame.origin.y = 0.0f;
    self.popUpView.center = CGPointMake(self.view.center.x, self.view.center.y);
    [[self popUpView] setFrame:frame];
    [self.view addSubview:_popUpView];
    [CommonFunction addAnimationToview:_popUpView];
}

-(void)addPopupview2{
     [CommonFunction setResignTapGestureToView:_popUpView2 andsender:self];
    [_txt_Search becomeFirstResponder];
    [[self popUpView2] setAutoresizesSubviews:true];
    [[self popUpView2] setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) ;
    frame.origin.y = 0.0f;
    self.popUpView2.center = CGPointMake(self.view.center.x, self.view.center.y);
    [[self popUpView2] setFrame:frame];
    [self.view addSubview:_popUpView2];
     [CommonFunction addAnimationToview:_popUpView2];
    
}
-(void)addPopupview3:(UIImage *)image{
     [CommonFunction setResignTapGestureToView:_popUpView3 andsender:self];
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) ;
    frame.origin.y = 0.0f;
    self.popUpView3.center = CGPointMake(self.view.center.x, self.view.center.y);
    [[self popUpView3] setFrame:frame];

    _imgView_ToShow.image = image;
    [_popUpView removeFromSuperview];
    [self.view addSubview:_popUpView3];
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
#pragma mark- Hit Api
-(void)hitApiForStartTheChat:(QueueDetails*)obj{
    
    
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    [parameter setValue:[CommonFunction getValueFromDefaultWithKey:loginuserId] forKey:@"doctor_id"];
    [parameter setValue:obj.patient_id forKey:@"patient_id"];
    [parameter setValue:obj.queue_id forKey:@"queue_id"];
    [parameter setValue:obj.dependentID forKey:DEPENDANT_ID];
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
                    temp.dependent_id = [NSString stringWithFormat:@"%@",[[[responseObj valueForKey:@"patient"] valueForKey:@"dependents"] valueForKey:@"dependent_id"]];
                    temp.dependent_Name = [NSString stringWithFormat:@"%@",[[[responseObj valueForKey:@"patient"] valueForKey:@"dependents"] valueForKey:@"name"]];
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
                    
                }else if([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK003"]){
                     [self addAlertWithTitle:[Langauge getTextFromTheKey:Warning_Key] andMessage:@"Queue is empty" isTwoButtonNeeded:false firstbuttonTag:Tag_For_Remove_Alert secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
                }
                
                else
                {
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

-(void)hitApiForaddingTheDeviceID{
    
    
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    [parameter setValue:@"123" forKey:DEVICE_ID];
    [parameter setValue:[CommonFunction getValueFromDefaultWithKey:loginuserId] forKey:loginuserId];
    
    
    if ([ CommonFunction reachability]) {
        //        [self addLoder];
        
        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,@"registration_ids"]  postResponse:parameter postImage:nil requestType:POST tag:nil isRequiredAuthentication:YES header:@"" completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"]) {
                    [CommonFunction storeValueInDefault:[CommonFunction getValueFromDefaultWithKey:DEVICE_ID] andKey:DEVICE_ID_LoginUSer];
                    //                    [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:[responseObj valueForKey:@"message"] isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
                }else
                {
                    //                    [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:[responseObj valueForKey:@"message"] isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
                    //                    [self removeloder];
                    //                    [self removeloder];
                }
                //                [self removeloder];
            }
        }];
    } else {
        //        [self removeloder];
        //        [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:Network_Issue_Message isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
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
                   }
                
            }else{
                [self removeloder];
            }
            }
        ];
    }
}


-(void)hitImageUploadApi{

    if ([ CommonFunction reachability]) {
        [self addLoder];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_UploadDocument] postResponse:nil withImageData:nil isImageChanged:false requestType:POST requiredAuthorization:false ImageKey:@"photo" DataArray:imageDataArray completetion:^(BOOL status, id responseObj, NSString *tag, NSError *error, NSInteger statusCode) {
            if (error == nil) {
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"] == true){
                    
                    NSDictionary *dict = [[responseObj valueForKey:@"urls"] valueForKey:@"photo"];
                    
                    imageUrl = [NSString stringWithFormat:@"%@",dict];
                    [self removeloder];
                    [_popUpView3 removeFromSuperview];
                    [self uploadPost];
                   }
                else{
                    [self removeloder];
                }
            }
            else{
                [self removeloder];
            }
        }];
    }
}

-(void) getData
{
    
    
    if ([ CommonFunction reachability]) {
        [self addLoder];
        
//      loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
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
                [self removeloder];
            }else{
                [self removeloder];
            }
        }];
    } else {
        [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:Network_Issue_Message isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
    }
    
}

-(void)hitAPiTolikeAPost:(NSString *)likeBool{
    NSMutableDictionary *parameterDict = [[NSMutableDictionary alloc]init];
    [parameterDict setValue:[CommonFunction getValueFromDefaultWithKey:loginuserId] forKey:@"user_id"];
    [parameterDict setValue:postId forKey:@"post_id"];
    [parameterDict setValue:likeBool forKey:@"is_liked"];
    
    if ([ CommonFunction reachability]) {
        [self addLoder];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,@"postlike"]  postResponse:parameterDict postImage:nil requestType:POST tag:nil isRequiredAuthentication:YES header:NPHeaderName completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"] == true){
                    [self removeloder];
                    [self geAllPost];
                }
                else
                {
                    [self addAlertWithTitle:[Langauge getTextFromTheKey:Error_Key] andMessage:[responseObj valueForKey:@"message"] isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Error_Key_For_Image];
                    [self removeloder];
                    [self removeloder];
                }
                
                
                
            }
            
            else {
                [self removeloder];
            [self addAlertWithTitle:[Langauge getTextFromTheKey:Error_Key] andMessage:Sevrer_Issue_Message isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Error_Key_For_Image];
            }
            
            
        }];
    } else {
        [self addAlertWithTitle:[Langauge getTextFromTheKey:Error_Key] andMessage:Network_Issue_Message isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Error_Key_For_Image];
    }
    
    
}

-(void)geAllPost{
    
    NSMutableDictionary *parameterDict;
    if (![CommonFunction getBoolValueFromDefaultWithKey:isLoggedIn]){
        parameterDict = [[NSMutableDictionary alloc]init];
        parameterDict = nil;
    }else{
        parameterDict = [[NSMutableDictionary alloc]init];
        [parameterDict setValue:[CommonFunction getValueFromDefaultWithKey:loginuserId] forKey:@"user_id"];
        
    }

    
    if ([ CommonFunction reachability]) {
        if (ISFirsTime) {
        [self addLoder];
        }
        
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,@"posts"]  postResponse:parameterDict postImage:nil requestType:POST tag:nil isRequiredAuthentication:YES header:NPHeaderName completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"] == true){
                    is_Media = false;
                    ISFirsTime = false;
                    unsortedArray = [NSMutableArray new];
                    NSArray *tempArray = [responseObj valueForKey:@"posts"];
                    [tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        PostData *postData = [PostData new];
                        postData.tags = [obj valueForKey:@"tags"];
                        postData.type = [obj valueForKey:@"type"];
                        postData.url = [obj valueForKey:@"url"];
                        postData.content = [obj valueForKey:@"content"];
                        postData.post_by = [obj valueForKey:@"post_by"];
                        postData.total_likes = [obj valueForKey:@"total_likes"];
                        postData.liked_on = [obj valueForKey:@"liked_on"];
                        postData.post_id = [obj valueForKey:@"post_id"];
                        postData.is_liked = [obj valueForKey:@"is_liked"]  ;
                        postData.icon_url = [obj valueForKey:@"user_pic"];
                        postData.clinicName = [obj valueForKey:@"specialist"];
                        postData.total_comments = [obj valueForKey:@"total_comments"];
                        
                        
                        [unsortedArray addObject:postData];
                    }];
                    dataArray = unsortedArray;
                    [_tbl_View reloadData];
                    [self removeloder];
                }
                else
                {
                    [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:[responseObj valueForKey:@"message"] isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
                    [self removeloder];
                    [self removeloder];
                }
                
                
                
            }
            
            else {
                [self removeloder];
           [self addAlertWithTitle:[Langauge getTextFromTheKey:Error_Key] andMessage:Sevrer_Issue_Message isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Error_Key_For_Image];
            }
            
            
        }];
    } else {
        [self addAlertWithTitle:[Langauge getTextFromTheKey:Error_Key] andMessage:Network_Issue_Message isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Error_Key_For_Image];
    }
    
    
}
-(void)uploadPost{
    NSMutableDictionary *parameterDict = [[NSMutableDictionary alloc]init];
    [parameterDict setValue:[CommonFunction getValueFromDefaultWithKey:loginuserId] forKey:@"user_id"];
    [parameterDict setValue:@"1" forKey:@"awareness_id"];
    if (!is_Media) {
        [parameterDict setValue:@"text" forKey:@"type"];
        [parameterDict setValue:@"" forKey:@"url"];

    }else{
        [parameterDict setValue:@"photo" forKey:@"type"];
        [parameterDict setValue:imageUrl forKey:@"url"];

    }
    [parameterDict setValue:@"text" forKey:@"tags"];
    //Text/Media
    
    [parameterDict setValue:_txt_txtView.text forKey:@"content"];
    
    if ([ CommonFunction reachability]) {
        [self addLoder];
        
        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,@"addpost"]  postResponse:[parameterDict mutableCopy] postImage:nil requestType:POST tag:nil isRequiredAuthentication:YES header:NPHeaderName completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"] == true){
                  
                    
                    [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:[responseObj valueForKey:@"message"] isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Alert_Key_For_Image];
                    [CommonFunction removeAnimationFromView:_popUpView];
                    _txt_txtView.text = @"";
                   
                    //                    [CommonFunction storeValueInDefault:@"true" andKey:@"isLoggedIn"];
                    
                    
                    [self removeloder];

                    [self geAllPost];
                }
                else
                {
                    [self addAlertWithTitle:[Langauge getTextFromTheKey:Error_Key] andMessage:[responseObj valueForKey:@"message"] isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Error_Key_For_Image];
                    [self removeloder];
                    [self removeloder];
                }
                
                
                
            }
            
            else {
                [self removeloder];
           [self addAlertWithTitle:[Langauge getTextFromTheKey:Error_Key] andMessage:Sevrer_Issue_Message isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Error_Key_For_Image];
            }
            
            
        }];
    } else {
        [self addAlertWithTitle:[Langauge getTextFromTheKey:Error_Key] andMessage:Network_Issue_Message isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Error_Key_For_Image];
    }
    
    
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
        alertObj.btn2.hidden = false;
        alertObj.btn3.hidden = false;
        [alertObj.btn2 setTitle:firstButtonTitle forState:UIControlStateNormal];
        [alertObj.btn3 setTitle:secondButtonTitle forState:UIControlStateNormal];
        alertObj.btn2.tag = firstButtonTag;
        alertObj.btn3.tag = secondButtonTag;
        [alertObj.btn2 addTarget:self action:@selector(btnActionForCustomAlert:) forControlEvents:UIControlEventTouchUpInside];
        [alertObj.btn3 addTarget:self action:@selector(btnActionForCustomAlert:) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
        alertObj.btn1.hidden = false;
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
        case 103:{
            [self removeAlert];
         [self viewWillAppear:TRUE];
        }
            break;
        case 104:{
            
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"CancelNotification"
             object:self];
            [self removeAlert];
        }
            break;
        case 101:{
            [self removeAlert];
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
#pragma mark- Custom Tab Bar

-(void)addCustomTabBar{
    tabBarObj = [[CustomTabBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-49, _tbl_View.frame.size.width, 49)];
    [tabBarObj.btnHealthTracker addTarget:self action:@selector(btnActionForCustomTab:) forControlEvents:UIControlEventTouchUpInside];
    [tabBarObj.btnAwareness addTarget:self action:@selector(btnActionForCustomTab:) forControlEvents:UIControlEventTouchUpInside];
    [tabBarObj.btnMedicalRecord addTarget:self action:@selector(btnActionForCustomTab:) forControlEvents:UIControlEventTouchUpInside];
    
        tabBarObj.lbl_EMR.text =[Langauge getTextFromTheKey:@"emr_tracker"];
      tabBarObj.lbl_Consultation.text =[Langauge getTextFromTheKey:@"Consultation"];
      tabBarObj.lbl_Awareness.text =[Langauge getTextFromTheKey:@"awareness"];
//    tabBarObj.btnHealthTracker.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
//    tabBarObj.btnHealthTracker.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
//     tabBarObj.btnAwareness.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
//     tabBarObj.btnMedicalRecord.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
//    tabBarObj.btnMedicalRecord.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    tabBarObj.imgAwareness.image = [UIImage imageNamed:@"tabAwarenessActive"];
    tabBarObj.lbl_Awareness.textColor =  [CommonFunction colorWithHexString:primary_Color];

    [self.view addSubview:tabBarObj];
}
-(IBAction)btnActionForCustomTab:(id)sender{
    switch (((UIButton *)sender).tag) {
        
        case 0:{
            
            if ([[CommonFunction getValueFromDefaultWithKey:loginuserType] isEqualToString:@"Patient"]) {
                NSArray * tempArray = self.navigationController.viewControllers;
                __block BOOL isFound = false;
                [tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([[obj class] isKindOfClass:[ChooseDependantViewController class]]){
                        isFound = true;
                    }
                }];
                if (!isFound) {
                ChooseDependantViewController* vc ;
                vc = [[ChooseDependantViewController alloc] initWithNibName:@"ChooseDependantViewController" bundle:nil];
                vc.patientID = [CommonFunction getValueFromDefaultWithKey:loginuserId];
                vc.classObj = self;
                vc.isManageDependants = false;
                
                [self.navigationController pushViewController:vc animated:true];
                }
            }else{
            NSArray * tempArray = self.navigationController.viewControllers;
            __block BOOL isFound = false;
            [tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([[obj class] isKindOfClass:[ChooseDependantViewController class]]){
                    isFound = true;
                }
            }];
            if (!isFound) {
                ChoosePatientViewController* vc ;
                vc = [[ChoosePatientViewController alloc] initWithNibName:@"ChoosePatientViewController" bundle:nil];
                [self.navigationController pushViewController:vc animated:true];
            }
            }
            
//            tabBarObj.imgTracker.image = [UIImage imageNamed:@"tabHelthTrackerActive"];
//            tabBarObj.imgAwareness.image = [UIImage imageNamed:@"tabAwareness"];
//            tabBarObj.img_Cunsultation.image = [UIImage imageNamed:@"tabMedicalRecord"];
//            tabBarObj.lbl_Awareness.textColor = [UIColor lightGrayColor];
//            tabBarObj.lbl_EMR.textColor = [CommonFunction colorWithHexString:primary_Color];
//            tabBarObj.lbl_Consultation.textColor = [UIColor lightGrayColor];
        }
            break;
        case 1:{
            
            if ([[CommonFunction getValueFromDefaultWithKey:loginuserType] isEqualToString:@"Patient"]) {
                AwarenessCategoryViewController *vc = [[AwarenessCategoryViewController alloc]initWithNibName:@"AwarenessCategoryViewController" bundle:nil];
                [self.navigationController pushViewController:vc animated:true];
            }else{
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
//            tabBarObj.imgTracker.image = [UIImage imageNamed:@"tabHelthTracker"];
//            tabBarObj.imgAwareness.image = [UIImage imageNamed:@"tabAwareness"];
//            tabBarObj.img_Cunsultation.image = [UIImage imageNamed:@"tabMedicalRecordActive"];
//            tabBarObj.lbl_Awareness.textColor = [UIColor lightGrayColor];
//            tabBarObj.lbl_EMR.textColor = [UIColor lightGrayColor];
//            tabBarObj.lbl_Consultation.textColor =  [CommonFunction colorWithHexString:primary_Color];
        }
            break;
        case 2:{
            [self.navigationController popToRootViewControllerAnimated:true];
            tabBarObj.imgTracker.image = [UIImage imageNamed:@"tabHelthTracker"];
            tabBarObj.imgAwareness.image = [UIImage imageNamed:@"tabAwarenessActive"];
            tabBarObj.img_Cunsultation.image = [UIImage imageNamed:@"tabMedicalRecord"];
            tabBarObj.lbl_Awareness.textColor =  [CommonFunction colorWithHexString:primary_Color];
            tabBarObj.lbl_EMR.textColor = [UIColor lightGrayColor];
            tabBarObj.lbl_Consultation.textColor = [UIColor lightGrayColor];
                   }
            break;
        default:
            
            break;
    }
}
#pragma mark - Otp Verification

-(void)otpVerification{
    OTPVc *otpObj = [[OTPVc alloc]initWithNibName:@"OTPVc" bundle:nil];
    otpObj.delegateProperty = self;
    [self presentViewController:otpObj animated:true completion:nil];
    
}

#pragma mark- OPT Delegate
- (void)otpDelegateMethodWithnumber:(NSString *)number{
    //    [_parameterDict setValue:number forKey:loginmobile];
    //    [self hitApi];
}

@end
