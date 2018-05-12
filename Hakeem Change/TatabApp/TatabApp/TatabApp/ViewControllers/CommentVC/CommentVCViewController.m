//
//  CommentVCViewController.m
//  TatabApp
//
//  Created by NetprophetsMAC on 2/6/18.
//  Copyright © 2018 Shagun Verma. All rights reserved.
//

#import "CommentVCViewController.h"

@interface CommentVCViewController ()<UITextFieldDelegate>
{
    LoderView *loderObj;
    CustomAlert *alertObj;
    NSMutableArray *dataArray;

}
@property (weak, nonatomic) IBOutlet UIButton *btnLike;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewCurrentUser;
@end

@implementation CommentVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData];
    dataArray = [NSMutableArray new];
    alertObj = [[CustomAlert alloc] initWithFrame:self.view.frame];

    [_imgViewCurrentUser sd_setImageWithURL:[NSURL URLWithString:[CommonFunction getValueFromDefaultWithKey:logInImageUrl]]];
    _imgViewCurrentUser.layer.borderColor = [[CommonFunction colorWithHexString:Primary_GreenColor] CGColor];
    _imgViewCurrentUser.layer.borderWidth = 1;
    _imgViewPostDataType.layer.borderColor = [[CommonFunction colorWithHexString:Primary_GreenColor] CGColor];
    _imgViewPostDataType.layer.borderWidth = 1;
    _imgViewPostDataUser.layer.borderColor = [[CommonFunction colorWithHexString:Primary_GreenColor] CGColor];
    _imgViewPostDataUser.layer.borderWidth = 1;
    _txtFieldComment.layer.borderColor = [[CommonFunction colorWithHexString:Primary_GreenColor] CGColor];
    _txtFieldComment.layer.borderWidth = 1;
    [_imgViewPostDataUser sd_setImageWithURL:[NSURL URLWithString:_postObj.icon_url]];
    [_imgViewPostDataType setImage:[self setImageFor:_postObj.clinicName]];
    _txtFieldComment.layer.cornerRadius = 5;
    _imgViewCurrentUser.layer.cornerRadius = 5;
    _imgViewPostDataType.layer.cornerRadius = 5;
    _imgViewPostDataUser.layer.cornerRadius = 5;
    
    _imgViewPostDataType.layer.masksToBounds = true;
    _imgViewPostDataUser.layer.masksToBounds = true;
    _imgViewCurrentUser.layer.masksToBounds = true;
     _txtFieldComment.layer.masksToBounds = true;
    
    _lblPostDataTitle.text = [NSString stringWithFormat:@"Dr. %@",_postObj.post_by];
    if([_postObj.type isEqualToString:@"photo"]){
        _lblPostDataContent.hidden = true;
        _imgViewContent.hidden = false;
        [_imgViewContent sd_setImageWithURL:[NSURL URLWithString:_postObj.url]];
        _cons_imgViewHeiht.active = true;

    }
    else
    {
        _cons_imgViewHeiht.active = false ;
        _lblPostDataContent.hidden = false;
        _imgViewContent.hidden = true;

        _lblPostDataContent.text = _postObj.content;
    }
    
    if ([_postObj.is_liked intValue] >0) {
        [_btnLike setBackgroundImage:[UIImage imageNamed:@"Liked"] forState:UIControlStateNormal];

    }
    else{
        [_btnLike setBackgroundImage:[UIImage imageNamed:@"Like"] forState:UIControlStateNormal];
        
    }

    _lblLikesCount.text = [NSString stringWithFormat:@"%@",_postObj.total_likes];
    _lblCommentCount.text = [NSString stringWithFormat:@"%@",_postObj.total_comments];
    _lblShareCount.text = @"0";
    if ([CommonFunction isEnglishSelected]) {
        _lblPostDataContent.textAlignment = NSTextAlignmentLeft;
    }else{
        _lblPostDataContent.textAlignment = NSTextAlignmentRight;
    }
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidLayoutSubviews{
    loderObj.frame = self.view.frame;
    alertObj.frame = self.view.frame;
}
-(void)setData{
    [_tbl_View registerNib:[UINib nibWithNibName:@"CommentTableViewCell" bundle:nil]forCellReuseIdentifier:@"CommentTableViewCell"];
    _tbl_View.rowHeight = UITableViewAutomaticDimension;
    _tbl_View.estimatedRowHeight = 100;
    _tbl_View.multipleTouchEnabled = NO;
    [self hitApiForComments];
}

#pragma mark- tableView delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (dataArray.count == 0) {
        _lbl_NoComment.hidden = false;
        _noCommentSeperator.hidden = true;
    }else{
        _lbl_NoComment.hidden = true;
        _noCommentSeperator.hidden = false;
    }
    return dataArray.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentTableViewCell *cell = [_tbl_View dequeueReusableCellWithIdentifier:@"CommentTableViewCell"];
    if (cell == nil) {
        cell = [[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CommentTableViewCell"];
    }
    CommentClass *obj = [dataArray objectAtIndex:indexPath.row];
    if (![obj.Usertype isEqualToString:@"Patient"]) {
        cell.lblUserName.text = [NSString stringWithFormat:@"Dr. %@",[obj.comment_by capitalizedString]];
        cell.imgViewType.layer.cornerRadius = 5;
        cell.imgViewType.layer.masksToBounds = true;
        cell.imgViewType.hidden = false;
        cell.imgViewType.image = [CommonFunction setImageFor:obj.specialization];
    }else{
        cell.lblUserName.text = [NSString stringWithFormat:@"%@",[obj.comment_by capitalizedString]];
        cell.imgViewType.hidden = true;
    }
    cell.lblComment.text = obj.comment;
    cell.imgViewUser.layer.cornerRadius = 5;
    cell.imgViewUser.layer.masksToBounds = true;
  
    [cell.imgViewUser sd_setImageWithURL:[NSURL URLWithString:obj.profile_pic] placeholderImage:[UIImage imageNamed:@"dependentsuser"]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if(indexPath.row == dataArray.count-1){
        cell.lowerSeperatorView.hidden = true;
    }else{
        cell.lowerSeperatorView.hidden = false;
    }
    return cell;
    
    
}

#pragma mark - Api Related
-(void)hitApiForComments{
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    [parameter setValue:_postId forKey:@"post_id"];
    
    if ([ CommonFunction reachability]) {
        [self addLoder];
        
        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_FOR_GET_COMMENTS]  postResponse:parameter postImage:nil requestType:POST tag:nil isRequiredAuthentication:YES header:@"" completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"]) {
                    dataArray = [NSMutableArray new];
                    NSArray *tempArray = [NSArray new];
                    tempArray  = [responseObj valueForKey:@"comments"];
                    [tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        CommentClass *commentObj = [CommentClass new];
                        commentObj.comment_id = [obj valueForKey:@"comment_id"];
                        commentObj.comment = [obj valueForKey:@"comment"];
                        commentObj.comment_by = [NSString stringWithFormat:@"%@" ,[obj valueForKey:@"comment_by"]];
                        commentObj.posted_at = [obj valueForKey:@"posted_at"];
                        commentObj.profile_pic = [obj valueForKey:@"profile_pic"];
                        commentObj.Usertype = [obj valueForKey:@"Usertype"];
                        if (![commentObj.Usertype isEqualToString:@"Patient"]) {
                            commentObj.specialization  = [obj valueForKey:@"specialization"];
                        }
                        
                        [dataArray addObject:commentObj];
                    }];
                    _lblCommentCount.text = [NSString stringWithFormat:@"%d",dataArray.count];

                    [_tbl_View reloadData];
                    [self removeloder];
                }else
                {
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

-(void)hitApiForAddComment{
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    [parameter setValue:_postId forKey:@"post_id"];
    [parameter setValue:[CommonFunction getValueFromDefaultWithKey:loginuserId] forKey:@"user_id"];
    [parameter setValue:_txtFieldComment.text forKey:@"comment"];
    
    if ([ CommonFunction reachability]) {
        [self addLoder];
        
        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_FOR_ADD_COMMENTS]  postResponse:parameter postImage:nil requestType:POST tag:nil isRequiredAuthentication:YES header:@"" completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"]) {
                    [self removeloder];
                    [self.view endEditing:true];
                    _txtFieldComment.text = @"";
                    [self hitApiForComments];
                }else
                {
                    [self addAlertWithTitle:[Langauge getTextFromTheKey:Warning_Key] andMessage:[responseObj valueForKey:@"message"] isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)hitAPiTolikeAPost:(NSString *)likeBool{
    NSMutableDictionary *parameterDict = [[NSMutableDictionary alloc]init];
    [parameterDict setValue:[CommonFunction getValueFromDefaultWithKey:loginuserId] forKey:@"user_id"];
    [parameterDict setValue:_postObj.post_id forKey:@"post_id"];
    [parameterDict setValue:likeBool forKey:@"is_liked"];
    
    if ([ CommonFunction reachability]) {
        [self addLoder];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,@"postlike"]  postResponse:parameterDict postImage:nil requestType:POST tag:nil isRequiredAuthentication:YES header:NPHeaderName completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"] == true){
                   
                    if ([_postObj.is_liked intValue] >0) {
                        _postObj.is_liked = @"0";
                        [_btnLike setBackgroundImage:[UIImage imageNamed:@"Like"] forState:UIControlStateNormal];
                        _lblLikesCount.text = [NSString stringWithFormat:@"%d   ",[_postObj.total_likes integerValue]-1];
                        _postObj.total_likes = [NSString stringWithFormat:@"%d",[_postObj.total_likes integerValue]-1];
                    }
                    else{
                        _postObj.is_liked = @"1";
                        [_btnLike setBackgroundImage:[UIImage imageNamed:@"Liked"] forState:UIControlStateNormal];
                        _lblLikesCount.text = [NSString stringWithFormat:@"%d   ",[_postObj.total_likes integerValue]+1];
                        _postObj.total_likes = [NSString stringWithFormat:@"%d",[_postObj.total_likes integerValue]+1];
                    }
                    [self removeloder];
                }
                else
                {
                    [self addAlertWithTitle:[Langauge getTextFromTheKey:Warning_Key] andMessage:[responseObj valueForKey:@"message"] isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
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

#pragma mark - Loder Related
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

#pragma marl - textfield delegate methods
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField.text.length + string.length > 250 && ![string isEqualToString: @""]) {
        [self addAlertWithTitle:[Langauge getTextFromTheKey:Warning_Key] andMessage:@"The comment length is more than 250 characters." isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
        return false;
    }
    

    
    return true;
}


#pragma mark - btn Actions
- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}
- (IBAction)likeBtnAction:(id)sender {
    if ([_postObj.is_liked intValue] >0) {
       [self hitAPiTolikeAPost:@"0"];
        
    }
    else{
       [self hitAPiTolikeAPost:@"1"];
        
    }
    
}
- (IBAction)btnCommentSend:(id)sender {
    if ([_txtFieldComment.text  isEqual: @""]){

    }
    else
    {
        [self hitApiForAddComment];
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return true;
}


#pragma mark - other
-(UIImage*) setImageFor:(NSString*) clinicName{
    
    if ([clinicName isEqualToString:@"Abdominal Clinic"]) {
        return [UIImage imageNamed:@"sec-abdomen-1"];
    }
    else if ([clinicName isEqualToString:@"Psychological Clinic"]) {
        return [UIImage imageNamed:@"sec-psy-1"];
    }
    else if ([clinicName isEqualToString:@"Family and Community Clinic"]) {
        return [UIImage imageNamed:@"sec-family-1"];
    }
    else if ([clinicName isEqualToString:@"Obgyne Clinic"]) {
        return [UIImage imageNamed:@"sec-obgyen-1"];
    }
    else if ([clinicName isEqualToString:@"Pediatrics Clinic"]) {
        return [UIImage imageNamed:@"section-children"];
    }
    
    return [UIImage imageNamed:@""];
}


@end
