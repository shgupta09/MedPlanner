//
//  CommentVCViewController.m
//  TatabApp
//
//  Created by NetprophetsMAC on 2/6/18.
//  Copyright © 2018 Shagun Verma. All rights reserved.
//

#import "CommentVCViewController.h"

@interface CommentVCViewController ()
{
    LoderView *loderObj;
    CustomAlert *alertObj;
    NSMutableArray *dataArray;

}
@end

@implementation CommentVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData];
    dataArray = [NSMutableArray new];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidLayoutSubviews{
    loderObj.frame = self.view.frame;
}
-(void)setData{
    [_tbl_View registerNib:[UINib nibWithNibName:@"TextPostCell" bundle:nil]forCellReuseIdentifier:@"TextPostCell"];
    _tbl_View.rowHeight = UITableViewAutomaticDimension;
    _tbl_View.estimatedRowHeight = 100;
    _tbl_View.multipleTouchEnabled = NO;
    [self hitApiForComments];
}

#pragma mark- tableView delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (dataArray.count == 0) {
        _lbl_NoComment.hidden = false;
    }else{
        _lbl_NoComment.hidden = true;
    }
    return dataArray.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TextPostCell *cell = [_tbl_View dequeueReusableCellWithIdentifier:@"TextPostCell"];
    if (cell == nil) {
        cell = [[TextPostCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"TextPostCell"];
    }
    CommentClass *obj = [dataArray objectAtIndex:indexPath.row];
    cell.lbl_DoctorName.text = [NSString stringWithFormat:@"Dr. %@",obj.comment_by];
    cell.lbl_Content.text = obj.comment;
    cell.viewForImage.layer.cornerRadius = 5;
    cell.viewForImage.layer.masksToBounds = true;
    cell.doctorImageView.layer.cornerRadius = 5;
    cell.doctorImageView.layer.masksToBounds = true;
    cell.clinicImageView.layer.cornerRadius = 5;
    cell.clinicImageView.layer.masksToBounds = true;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.btn_Like.hidden = true;
    cell.btn_Share.hidden = true;
    cell.btn_Comment.hidden = true;
    cell.lbl_LikeCount.hidden = true;
    cell.lbl_ShareCount.hidden = true;
    cell.lbl_CommentCount.hidden = true;
    cell.seperator_View1.hidden = true;
    /*[cell.btn_Like addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    cell.btn_Like.tag = 1000+indexPath.row;
    [cell.btn_Comment addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    cell.btn_Comment.tag = 2000+indexPath.row;
    [cell.btn_Share addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    cell.btn_Share.tag = 3000+indexPath.row;
    cell.lbl_LikeCount.text = [NSString stringWithFormat:@"%@",obj.total_likes];
           cell.lbl_CommentCount.text = [NSString stringWithFormat:@"%@",obj.total_likes];
        cell.lbl_ShareCount.text = [NSString stringWithFormat:@"%@",obj.total_likes];
     */
    //[cell.doctorImageView sd_setImageWithURL:[NSURL URLWithString:obj.icon_url]];
    //[cell.clinicImageView setImage:[self setImageFor:obj.clinicName]];
   // cell.profileContent.tag = 5000+indexPath.row;
   // [cell.profileContent addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
   /* if (![CommonFunction getBoolValueFromDefaultWithKey:isLoggedIn]){
        
        [cell.btn_Like setBackgroundImage:[UIImage imageNamed:@"Like"] forState:UIControlStateNormal];
        
    }else{
        if ([obj.is_liked intValue] >0) {
            [cell.btn_Like setBackgroundImage:[UIImage imageNamed:@"Liked"] forState:UIControlStateNormal];
        }
        else{
            [cell.btn_Like setBackgroundImage:[UIImage imageNamed:@"Like"] forState:UIControlStateNormal];
        }
    }
   */
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
                        
                        
                        [dataArray addObject:commentObj];
                    }];
                    [_tbl_View reloadData];
                    [self removeloder];
                }else
                {
                    [self addAlertWithTitle:AlertKey andMessage:[responseObj valueForKey:@"message"] isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:OK_Btn secondButtonTitle:nil image:Warning_Key_For_Image];
                    [self removeloder];
                    [self removeloder];
                }
                [self removeloder];
                
            }
            
            
            
        }];
    } else {
        [self removeloder];
        [self addAlertWithTitle:AlertKey andMessage:Network_Issue_Message isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:OK_Btn secondButtonTitle:nil image:Warning_Key_For_Image];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Loder Related
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

#pragma mark- Custom Loder
-(void)addAlertWithTitle:(NSString *)titleString andMessage:(NSString *)messageString isTwoButtonNeeded:(BOOL)isTwoBUtoonNeeded firstbuttonTag:(NSInteger)firstButtonTag secondButtonTag:(NSInteger)secondButtonTag firstbuttonTitle:(NSString *)firstButtonTitle secondButtonTitle:(NSString *)secondButtonTitle image:(NSString *)imageName{
    [CommonFunction resignFirstResponderOfAView:self.view];
    alertObj = [[CustomAlert alloc] initWithFrame:self.view.frame];
    alertObj.lbl_title.text = titleString;
    alertObj.lbl_message.text = messageString;
    alertObj.iconImage.image = [UIImage imageNamed:imageName];
    if (isTwoBUtoonNeeded) {
        alertObj.btn1.hidden = true;
        [alertObj.btn2 setTitle:firstButtonTitle forState:UIControlStateNormal];
        [alertObj.btn3 setTitle:secondButtonTitle forState:UIControlStateNormal];
        alertObj.btn2.tag = firstButtonTag;
        alertObj.btn3.tag = secondButtonTag;
        [alertObj.btn2 addTarget:self action:@selector(btnActionForCustomAlert:) forControlEvents:UIControlEventTouchUpInside];
        [alertObj.btn3 addTarget:self action:@selector(btnActionForCustomAlert:) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
        alertObj.btn2.hidden = true;
        alertObj.btn3.hidden = true;
        alertObj.btn1.tag = firstButtonTag;
        [alertObj.btn1 setTitle:firstButtonTitle forState:UIControlStateNormal];
        [alertObj.btn1 addTarget:self
                          action:@selector(btnActionForCustomAlert:) forControlEvents:UIControlEventTouchUpInside];
    }
    alertObj.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [self.view addSubview:alertObj];
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


#pragma mark - btn Actions
- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}



@end
