//
//  NewAwareVC.m
//  TatabApp
//
//  Created by shubham gupta on 1/11/18.
//  Copyright © 2018 Shagun Verma. All rights reserved.
//

#import "NewAwareVC.h"
#import "MediaPostCell.h"
@interface NewAwareVC ()<UITextViewDelegate,UITextFieldDelegate>{
    
    UIView *addSubView;
    UIImageView *imgView;
    SWRevealViewController *revealController;
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
    
}
@end

@implementation NewAwareVC

- (void)viewDidLoad {
    [super viewDidLoad];
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
    addSubView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    imgView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 80, self.view.frame.size.width-40, self.view.frame.size.height-160)];
    imgView.center = addSubView.center;
   // imgView.center = CGPointMake(imgView.center.x, imgView.center.y-50) ;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification)
                                                 name:@"LogoutNotification"
                                               object:nil];
    // Do any additional setup after loading the view from its nib.
}

-(void)receiveNotification{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Logout Successfully" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self viewWillAppear:TRUE];
    }];
    [alertController addAction:ok];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:true];
    self.navigationController.navigationBar.hidden = true;
    isOpen = false;
    if (![[CommonFunction getValueFromDefaultWithKey:loginuserType] isEqualToString:@"Patient"]) {
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
        }
    }else{
        _btn_Post.hidden = true;
        _btn_Post.userInteractionEnabled = false;
        [_imgView_Profile removeFromSuperview];
    }
    if (!is_Media) {
    [self geAllPost];    
    }
    

}
//The event handling method
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    self.navigationController.navigationBar.userInteractionEnabled = true;
    if (isOpen){
        [revealController revealToggle:nil];
        [tempView removeGestureRecognizer:singleFingerTap];
        [tempView removeFromSuperview];
        isOpen = false;
    }
    
}
-(void)viewWillDisappear:(BOOL)animated{
    
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
    
    if (textView.text.length == 250 && ![text isEqualToString: @""]) {
        return false;
    }
    
    [_LBLCHARACTERCOUNT setText:[NSString stringWithFormat:@"%lu",250-textView.text.length]];
    
    return true;
    
}
#pragma mark- SWRevealViewController

- (IBAction)revealAction:(id)sender {
    //    self.view.userInteractionEnabled = false;
    self.navigationController.navigationBar.userInteractionEnabled = true;
    
    
    if (isOpen) {
        
        [revealController revealToggle:nil];
        
        [tempView removeGestureRecognizer:singleFingerTap];
        [tempView removeFromSuperview];
        isOpen = false;
    }
    else{
        
        [revealController revealToggle:nil];
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
//        cell.lbl_CommentCount.text = [NSString stringWithFormat:@"%@",obj.total_likes];
//        cell.lbl_ShareCount.text = [NSString stringWithFormat:@"%@",obj.total_likes];
        [cell.doctorImageView sd_setImageWithURL:[NSURL URLWithString:obj.icon_url]];
        [cell.clinicImageView setImage:[self setImageFor:obj.clinicName]];
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.btn_Like addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        cell.btn_Like.tag = 1000+indexPath.row;
        [cell.btn_Comment addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        cell.btn_Comment.tag = 2000+indexPath.row;
        [cell.btn_Share addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        cell.btn_Share.tag = 3000+indexPath.row;
        cell.lbl_LikeCount.text = [NSString stringWithFormat:@"%@",obj.total_likes];
//        cell.lbl_CommentCount.text = [NSString stringWithFormat:@"%@",obj.total_likes];
//        cell.lbl_ShareCount.text = [NSString stringWithFormat:@"%@",obj.total_likes];
        [cell.doctorImageView sd_setImageWithURL:[NSURL URLWithString:obj.icon_url]];
        [cell.clinicImageView setImage:[self setImageFor:obj.clinicName]];
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


-(void)btnClicked:(id)sender{
    if (((UIButton *)sender).tag /1000 == 5){
        PostData *obj= [dataArray objectAtIndex:((UIButton *)sender).tag%1000];
        [self zoomWithImage:obj.icon_url];
        
    }else if (((UIButton *)sender).tag /1000 == 4){
              PostData *obj2= [dataArray objectAtIndex:((UIButton *)sender).tag%1000];
              [self zoomWithImage:obj2.url];
    }else{
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
    _txt_Search.text = @"";
    [self addPopupview2];
    
    
}
- (IBAction)btnAction_SearchCategory:(id)sender {
    [_btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     [_btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     [_btn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     [_btn4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     [_btn5 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    switch (((UIButton *)sender).tag) {
        case 0:
            _txt_Search.text = @"obgyne";
             [_btn1 setTitleColor:[CommonFunction colorWithHexString:primary_Color] forState:UIControlStateNormal];
           
            break;
        case 1:
            _txt_Search.text = @"pediatric";
             [_btn2 setTitleColor:[CommonFunction colorWithHexString:primary_Color] forState:UIControlStateNormal];
            break;
        case 2:
            _txt_Search.text = @"abodminal";
             [_btn3 setTitleColor:[CommonFunction colorWithHexString:primary_Color] forState:UIControlStateNormal];
            break;
        case 3:
            _txt_Search.text = @"psycological";
           [_btn4 setTitleColor:[CommonFunction colorWithHexString:primary_Color] forState:UIControlStateNormal];
            break;
        case 4:
            _txt_Search.text = @"Family and Community";
             [_btn5 setTitleColor:[CommonFunction colorWithHexString:primary_Color] forState:UIControlStateNormal];
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
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Please enter some text" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        [self uploadPost];
    }
    
    
}
- (IBAction)btnAction_Attatchment:(id)sender {
    sourceType = UIImagePickerControllerSourceTypeCamera;
    [self imageCapture];
}
- (IBAction)btnAction_ApplySearch:(id)sender {
     NSString *strToSearch = _txt_Search.text;
    sortedArray = [NSMutableArray new];
    [unsortedArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       PostData *tempObj = (PostData *)obj;
        if ([[tempObj.clinicName lowercaseString] containsString:[strToSearch lowercaseString]]) {
            [sortedArray addObject:obj];
        }
    }];
    dataArray = sortedArray;
    [_tbl_View reloadData];
    [CommonFunction removeAnimationFromView:_popUpView2];
    _btnClearSearch.hidden = false;
    _lbl_SearchedText.hidden = false;
    _lbl_SearchedText.text = [NSString stringWithFormat:@"search phrase: %@",[strToSearch capitalizedString]];
    _tbl_Constraint.constant = 25;
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

    _imgView_ToShow.image = image;
    [_popUpView removeFromSuperview];
    [self.view addSubview:_popUpView3];
}
#pragma mark - add loder

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
#pragma mark- Hit Api
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
            }
        }];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Network Error" message:@"No Network Access" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
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
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:[responseObj valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:ok];
                    //                    [CommonFunction storeValueInDefault:@"true" andKey:@"isLoggedIn"];
                    [self presentViewController:alertController animated:YES completion:nil];
                    [self removeloder];
                }
                
                
                
            }
            
            else {
                [self removeloder];
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:[error description] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:ok];
                [self presentViewController:alertController animated:YES completion:nil];
            }
            
            
        }];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Network Error" message:@"No Network Access" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
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
                        
                        [unsortedArray addObject:postData];
                    }];
                    dataArray = unsortedArray;
                    [_tbl_View reloadData];
                    [self removeloder];
                }
                else
                {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:[responseObj valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:ok];
                    //                    [CommonFunction storeValueInDefault:@"true" andKey:@"isLoggedIn"];
                    [self presentViewController:alertController animated:YES completion:nil];
                    [self removeloder];
                }
                
                
                
            }
            
            else {
                [self removeloder];
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:[error description] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:ok];
                [self presentViewController:alertController animated:YES completion:nil];
            }
            
            
        }];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Network Error" message:@"No Network Access" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
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
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:[responseObj valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [CommonFunction removeAnimationFromView:_popUpView];
                        _txt_txtView.text = @"";
                    }];
                    [alertController addAction:ok];
                    //                    [CommonFunction storeValueInDefault:@"true" andKey:@"isLoggedIn"];
                    
                    [self presentViewController:alertController animated:YES completion:nil];
                    [self removeloder];

                    [self geAllPost];
                }
                else
                {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:[responseObj valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:ok];
                    //                    [CommonFunction storeValueInDefault:@"true" andKey:@"isLoggedIn"];
                    [self presentViewController:alertController animated:YES completion:nil];
                    [self removeloder];
                }
                
                
                
            }
            
            else {
                [self removeloder];
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:[error description] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:ok];
                [self presentViewController:alertController animated:YES completion:nil];
            }
            
            
        }];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Network Error" message:@"No Network Access" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 100){
        return false;
    }
    return true;
}


@end
