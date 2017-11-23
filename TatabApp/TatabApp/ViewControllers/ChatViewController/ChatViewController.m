//
//  ChatViewController.m
//  TatabApp
//
//  Created by Shagun Verma on 07/11/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//

#import "ChatViewController.h"
#import "XMPPHandler.h"
#import "MessageCell.h"
#import "Chat+CoreDataProperties.h"
#import "ImageMessageCell.h"
@interface ChatViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    XMPPHandler* hm;
    NSMutableArray	*messagesArray;
    LoderView *loderObj;
    NSString* toId ;
    NSString* fromId;
    UIImagePickerController * picker;
    NSMutableArray *imageDataArray;
    UIImagePickerControllerSourceType *sourceType;
    
    
}
@property (weak, nonatomic) IBOutlet UIButton *btnSend;

@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (weak, nonatomic) IBOutlet UITextField *txtField;
@property (weak, nonatomic) IBOutlet UIView *viewOnlineStatus;


@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    picker = [[UIImagePickerController alloc] init];
    lbl_title.text = [NSString stringWithFormat:@"Dr. %@",_objDoctor.first_name];
   imageDataArray = [NSMutableArray new];
    NSArray* foo = [[CommonFunction getValueFromDefaultWithKey:loginemail] componentsSeparatedByString: @"@"];
    NSString* userID = [foo objectAtIndex: 0];
    toId = @"123456";
    fromId = userID;
//    toId = @"78910";
//    fromId = userID;
    _viewShowStatus.layer.cornerRadius = 5;
    _viewShowStatus.layer.masksToBounds = true;
    _btnSend.layer.cornerRadius = 5;
    _btnSend.layer.masksToBounds = true;
    _txtField.layer.cornerRadius = 5;
    _txtField.layer.masksToBounds = true;
    messagesArray = [[NSMutableArray alloc] init];
    
    _addOptionBtnAction.tintColor = [UIColor whiteColor];
    UIImage * image = [UIImage imageNamed:@"Plus"];
    [_addOptionBtnAction setBackgroundImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    
    XMPPStream* st = [[XMPPStream alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    _tblView.rowHeight = UITableViewAutomaticDimension;
    _tblView.estimatedRowHeight = 225;
    
    [self setChat];
    
    if ([[CommonFunction getValueFromDefaultWithKey:loginuserType] isEqualToString:@"Patient"]) {
        _viewPatient.hidden = false;
        _viewDoctor.hidden = true;
        _imgView_PatientDoctor.layer.cornerRadius = _imgView_PatientDoctor.frame.size.width/2;
        _imgView_PatientDoctor.layer.borderColor = [UIColor redColor].CGColor;
        _imgView_PatientDoctor.layer.borderWidth = 2;
        _imgView_PatientDoctor.clipsToBounds = true;
        _lbl_Patient_DoctorName.text = _objDoctor.first_name;
        _imgView_patient_BackGround.image = [UIImage imageNamed:_awarenessObj.category_name];
        _imgView_patient_BackGround.alpha = .3;
        _imgView_patient_BackGround.clipsToBounds = true;
        _lbl_Patient_Clinic.text = _awarenessObj.category_name;
         [_imgView_PatientDoctor sd_setImageWithURL:[NSURL URLWithString:_objDoctor.photo] placeholderImage:[UIImage imageNamed:@"doctor.png"]];
    }else{
        _viewPatient.hidden = true;
        _viewDoctor.hidden = false;
    }
    // Do any additional setup after loading the view from its nib.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidLayoutSubviews{
    loderObj.frame = self.view.frame;
}
-(void)viewDidAppear:(BOOL)animated{


//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [hm sendMessage:@"hiiiiiiii" toFriendWithFriendId:@"shubham" andMessageId:@"1222"];
//    });
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [hm disconnectFromXMPPServer];
    [hm clearXMPPStream];
}
-(void)setUpRegisterUser{
    hm = [[XMPPHandler alloc] init];
    hm.userId = @"121214545487878";
    hm.userPassword = @"willpower";
    hm.hostName = @"80.209.227.103";
    hm.hostPort = [NSNumber numberWithInteger:5222];
   
     [hm registerUser];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notficationRecieved:) name:XMPPStreamDidRegister object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notficationRecieved:) name:XMPPStreamDidNotRegister object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notficationRecieved:) name:XMPPStreamDidConnect object:nil];
    
}



-(void)setChat{
    
    hm = [[XMPPHandler alloc] init];
    hm.userId = fromId;
    hm.userPassword = [CommonFunction getValueFromDefaultWithKey:loginPassword];
    hm.hostName = @"80.209.227.103";
    
    hm.hostPort = [NSNumber numberWithInteger:5222];
    
    //    [hm registerUser];
    [hm connectToXMPPServer];
    
    
    [hm setMyStatus:MyStatusAvailable];
    
    
    [self.tblView registerClass:[MessageCell class] forCellReuseIdentifier: @"MessageCell"];
    [self.tblView registerClass:[ImageMessageCell class] forCellReuseIdentifier: @"ImageMessageCell"];
    [CommonFunction setViewBackground:_tblView withImage:[UIImage imageNamed:@"BackgroundGeneral"]];
//    [self.tblView registerNib:[UINib nibWithNibName:@"ImageMessageCell" bundle:nil] forCellReuseIdentifier: @"ImageMessageCell"];
    // You may need to alter these settings depending on the server you're connecting to
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notficationRecieved:) name:XMPPStreamDidReceiveMessage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notficationRecieved:) name:XMPPStreamDidSendMessage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notficationRecieved:) name:XMPPStreamDidReceivePresence object:nil];
      
    
    
    [self setMessageArray:false];
    //    [hm registerUser];
    // Do any additional setup after loading the view from its nib.
}


-(void) notficationRecieved:(NSNotification*) notification{
    
    if ([notification.name isEqualToString:XMPPStreamDidReceiveMessage])
    {
        XMPPMessage* messageContent = notification.object;
        [self saveMessage:@"1" senderId:messageContent.elementID andeMessage:messageContent.body];
        [self setMessageArray:true];
        _txtField.text = @"";
      
    }
    
    else if ([notification.name isEqualToString:XMPPStreamDidSendMessage])
    {
        XMPPMessage* messageContent = notification.object;
        [self saveMessage:@"0" senderId:messageContent.elementID andeMessage:messageContent.body];
        [self setMessageArray:true];
        _txtField.text = @"";
       }
    else if ([notification.name isEqualToString:XMPPStreamDidReceivePresence])
    {
        XMPPPresence* presence = notification.object;
        
        NSString *presenceType = [presence type]; // online/offline
        NSString *myUsername = hm.userId;
        NSString *presenceFromUser = [[presence from] user];
        
// Change to show online
//        if (![presenceFromUser isEqualToString:myUsername]) {
//            
//            if ([presenceType isEqualToString:@"available"]) {
//                _viewShowStatus.backgroundColor = [UIColor greenColor];
//                
//                
//            } else if ([presenceType isEqualToString:@"unavailable"]) {
//                
//                _viewShowStatus.backgroundColor = [UIColor whiteColor];
//                
//            }
//            
//        }
    
    }else if([notification.name isEqualToString:XMPPStreamDidConnect]){
        [hm registerUser];
    }
    

}
#pragma mark - hit Api
-(void)hitImageUploadApi{
    
    
    if ([ CommonFunction reachability]) {
        [self addLoder];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_UploadDocument] postResponse:nil withImageData:nil isImageChanged:false requestType:POST requiredAuthorization:false ImageKey:@"photo" DataArray:imageDataArray completetion:^(BOOL status, id responseObj, NSString *tag, NSError *error, NSInteger statusCode) {
            if (error == nil) {
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"] == true){
                    [self removeloder];
                    
                    NSDictionary *dict = @{@"type":@"image",
                                           @"url": [[responseObj valueForKey:@"urls"] valueForKey:@"photo"]};
                    
                    NSString *newMessage = [NSString stringWithFormat:@"%@",dict];
                    
                    //                    [hm sendImage:[UIImage imageNamed:@"BackgroundGeneral"] withMessage:newMessage toFriendWithFriendId:@"shuam" andMessageId:@"34"];
                    [hm sendMessage:newMessage toFriendWithFriendId:toId andMessageId:@"34"];
                    
                }
                else
                {
                    [self removeloder];
                    
                }
                
            }
            else
            {
                [self removeloder];
                
            }
            
        }];
    }
    
    
    
    
}
#pragma mark - btn Actions
- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark -Table view delegates
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [messagesArray count];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
        Chat *s = (Chat *) [messagesArray objectAtIndex:indexPath.row];
    //    NSString *sender = [s objectForKey:@"sender"];
    NSString *message = s.message;
    
    if (message){
        NSDictionary *dictOfMedia = [NSPropertyListSerialization
                                     propertyListWithData:[message dataUsingEncoding:NSUTF8StringEncoding]
                                     options:kNilOptions
                                     format:NULL
                                     error:NULL];
        
        
        if (dictOfMedia!=nil && [dictOfMedia isKindOfClass:[NSDictionary class]] && [dictOfMedia objectForKey:@"type"])
        {
            
            
            return 170;
            
        }
        else
        {
            MessageCell *cell = [[MessageCell alloc] init];
            Chat *s = (Chat *) [messagesArray objectAtIndex:indexPath.row];
            Message *msg = [[Message alloc] init];
            msg.date = s.date;
            msg.text = s.message;
            cell.message = msg;
            return [cell height];
            

        }

    }
    return 10;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    Chat *s = (Chat *) [messagesArray objectAtIndex:indexPath.row];
    //    NSString *sender = [s objectForKey:@"sender"];
    NSString *message = s.message;
    
    if (message){
    NSDictionary *dictOfMedia = [NSPropertyListSerialization
                                 propertyListWithData:[message dataUsingEncoding:NSUTF8StringEncoding]
                                 options:kNilOptions
                                 format:NULL
                                 error:NULL];
    
    
    if (dictOfMedia!=nil && [dictOfMedia isKindOfClass:[NSDictionary class]] && [dictOfMedia objectForKey:@"type"])
    {
               
        static NSString *CellIdentifier = @"ImageMessageCell";
        ImageMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell)
        {
            cell = [[ImageMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        Message *msg = [[Message alloc] init];
        msg.date = s.date;
        msg.text = message;
        if ([s.isReceive isEqualToString:@"1"]){
            msg.sender = MessageSenderSomeone;
        }
        else{
            msg.sender = MessageSenderMyself;
        }
        
        msg.imgURL = [dictOfMedia objectForKey:@"url"];
        cell.message = msg;
       
//        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[dictOfMedia objectForKey:@"url"]]];
        
        
        return cell;

    }
    else
    {
        static NSString *CellIdentifier = @"MessageCell";
        MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell)
        {
            cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        Message *msg = [[Message alloc] init];
        msg.date = s.date;
        msg.text = message;
        if ([s.isReceive isEqualToString:@"1"]){
            msg.sender = MessageSenderSomeone;
        }
        else{
            msg.sender = MessageSenderMyself;
        }
        
        
        cell.message = msg;
        
        
        return cell;

    }
    
    }
    return [[UITableViewCell alloc] init];
}


#pragma mark -other
-(void)setMessageArray:(BOOL)isScroll{
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Chat"];
    messagesArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    [CommonFunction resignFirstResponderOfAView:self.view];
    
    [self.tblView reloadData];
    if (isScroll) {
        [self setTblScroll];
    }
    
    
}
-(void)setTblScroll{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:([messagesArray count]-1) inSection:0];
    [_tblView scrollToRowAtIndexPath:indexPath
                    atScrollPosition:UITableViewScrollPositionBottom
                            animated:YES];
    
}

-(void)saveMessage:(NSString *)isReceive senderId:(NSString *)senderId andeMessage:(NSString *)messageString{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // Create a new managed object
    NSManagedObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"Chat" inManagedObjectContext:context];
    [newDevice setValue:messageString forKey:@"message"];
    [newDevice setValue:isReceive forKey:@"isReceive"];
    [newDevice setValue:senderId forKey:@"senderId"];
    
    [newDevice setValue:[NSDate date] forKey:@"date"];
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
}
- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    
    
    
    return context;
}
- (IBAction)sendMessage {
    NSString *messageStr = _txtField.text;
    if([messageStr length] > 0) {
        [hm sendMessage:messageStr toFriendWithFriendId:toId andMessageId:@"34"];
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
        [textField resignFirstResponder];
    
    return YES;
}

- (IBAction)btnAddFileClicked:(id)sender {
    
    [self showActionSheet];
}



#pragma mark - keyboard notification
- (void)keyboardDidShow: (NSNotification *) notif{
    // Do something here
    NSDictionary* keyboardInfo = [notif userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    _bottomConstraint.constant = keyboardFrameBeginRect.size.height;
    [_tblView reloadData];
}

- (void)keyboardDidHide: (NSNotification *) notif{
    // Do something here
    _bottomConstraint.constant = 0;
}


#pragma mark - add loder

-(void)addLoder{
    self.view.userInteractionEnabled = NO;
    //  loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
    loderObj = [[LoderView alloc] initWithFrame:self.view.frame];
    loderObj.lbl_title.text = @"Uploading image...";
    [self.view addSubview:loderObj];
}

-(void)removeloder{
    //loderObj = nil;
    [loderObj removeFromSuperview];
    //[loaderView removeFromSuperview];
    self.view.userInteractionEnabled = YES;
}

#pragma mark- ActionSheet

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
    UIView *cameraOverlayView = [[UIView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 100.0f, 5.0f, 100.0f, 35.0f)];
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
    
    UIImage *capturedImage = [self imageToCompress:[info valueForKey:@"UIImagePickerControllerOriginalImage"]];
 
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
       [self hitImageUploadApi];
    return processedImage;
    
}
@end





