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
@interface ChatViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    XMPPHandler* hm;
    NSMutableArray	*messagesArray;
    LoderView *loderObj;
    NSString* fromId;
    UIImagePickerController * picker;
    NSMutableArray *imageDataArray;
    UIImagePickerControllerSourceType *sourceType;
    UIImageView *imgViewToZoom;
    UITapGestureRecognizer *cameraGesture;
    NSMutableArray *doctorListArray;
    NSString *uploadType;
    __weak IBOutlet UITextView *textView_advice;
    
    Boolean ifphoto;
}

@property (weak, nonatomic) IBOutlet UIButton *btnSend;
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (weak, nonatomic) IBOutlet UITextField *txtField;
@property (weak, nonatomic) IBOutlet UIView *viewOnlineStatus;
@property (strong, nonatomic) IBOutlet UIView *popUpView;


@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_mySwitch
     setOn:YES animated:YES];
    ifphoto = true;
    _viewToClip.layer.cornerRadius = 5;
    _viewToClip.layer.masksToBounds = true;
    doctorListArray = [NSMutableArray new];

    picker = [[UIImagePickerController alloc] init];
    lbl_title.text = @"Chat";
   imageDataArray = [NSMutableArray new];
    _lbl_Name.text = [NSString stringWithFormat:@"Dr. %@",_objDoctor.first_name];
    NSString* email = [CommonFunction getValueFromDefaultWithKey:loginemail];
    
    NSString* foo = [NSString stringWithFormat:@"%@%@",[[email componentsSeparatedByString:@"@"] objectAtIndex:0],[[email componentsSeparatedByString:@"@"] objectAtIndex:1]];
    NSString* userID = foo;
    fromId = userID;
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    _tblView.rowHeight = UITableViewAutomaticDimension;
    _tblView.estimatedRowHeight = 225;
    cameraGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeImage)];
    [cameraGesture setNumberOfTapsRequired:1];
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
        [self hitApiForDoctorList];
    }else{
        _viewPatient.hidden = true;
        _viewDoctor.hidden = false;
    }
    [self setChat];

    
    
    
    // Do any additional setup after loading the view from its nib.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidLayoutSubviews{
    loderObj.frame = self.view.frame;
}

-(void)viewDidDisappear:(BOOL)animated{
   
}


-(void)setUpRegisterUser{
    hm = [[XMPPHandler alloc] init];
    hm.userId = @"121214545487878";
    hm.userPassword = @"willpower";
    hm.hostName = @"35.154.181.86";
    hm.hostPort = [NSNumber numberWithInteger:5222];
   
     [hm registerUser];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notficationRecieved:) name:XMPPStreamDidRegister object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notficationRecieved:) name:XMPPStreamDidNotRegister object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notficationRecieved:) name:XMPPStreamDidConnect object:nil];
}



-(void)setChat{
    
    hm = [[XMPPHandler alloc] init];
    hm.userId = fromId;
    hm.userPassword = @"Admin@123";
    hm.hostName = @"35.154.181.86";
    hm.hostPort = [NSNumber numberWithInteger:5222];
    [hm connectToXMPPServer];
    [hm setMyStatus:MyStatusAvailable];
    [self.tblView registerClass:[MessageCell class] forCellReuseIdentifier: @"MessageCell"];
    [self.tblView registerClass:[ImageMessageCell class] forCellReuseIdentifier: @"ImageMessageCell"];
    [_tblView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BackgroundGeneral"]]];
  
    
    
    // You may need to alter these settings depending on the server you're connecting to
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notficationRecieved:) name:XMPPStreamDidReceiveMessage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notficationRecieved:) name:XMPPStreamDidSendMessage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notficationRecieved:) name:XMPPStreamDidReceivePresence object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notficationRecieved:) name:XMPPStreamDidRegister object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notficationRecieved:) name:XMPPStreamDidNotAuthenticate object:nil];
    
    
    
    [self setMessageArray:false];
    //    [hm registerUser];
    // Do any additional setup after loading the view from its nib.
}


-(void) notficationRecieved:(NSNotification*) notification{
    
    if ([notification.name isEqualToString:XMPPStreamDidReceiveMessage])
    {
        XMPPMessage* messageContent = notification.object;
        
        
        [self saveMessage:@"1" senderId:messageContent andeMessage:messageContent.body];
        [self setMessageArray:true];
      
    }
    
    else if ([notification.name isEqualToString:XMPPStreamDidSendMessage])
    {
        XMPPMessage* messageContent = notification.object;
        [self saveMessage:@"0" senderId:messageContent andeMessage:messageContent.body];
        [self setMessageArray:true];
        _txtField.text = @"";
       }
    else if ([notification.name isEqualToString:XMPPStreamDidReceivePresence])
    {

//        XMPPPresence* presence = notification.object;
//        
//        NSString *presenceType = [presence type]; // online/offline
//        NSString *myUsername = hm.userId;
//        NSString *presenceFromUser = [[presence from] user];
//        
//        if (![presenceFromUser isEqualToString:_toId]) {
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
    
    }
    else if ([notification.name isEqualToString:XMPPStreamDidNotAuthenticate])
    {
        [hm registerUser];
    }
    else if ([notification.name isEqualToString:XMPPStreamDidRegister])
    {
        [self setChat];
    }
    

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
                    
                    [hm sendMessage:newMessage toFriendWithFriendId:_toId andMessageId:@"34"];
                    
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

- (IBAction)switch_btn:(id)sender {
    if ([_mySwitch isOn]) {
        [self.mySwitch setOn:YES animated:YES];

        NSLog(@"Switch is on");
    } else {
        NSLog(@"Switch is off");
        [hm disconnectFromXMPPServer];
        [self.mySwitch setOn:NO animated:YES];
    }
}


- (IBAction)btnBackClicked:(id)sender {
    [hm disconnectFromXMPPServer];
    [hm clearXMPPStream];
    ifphoto = false;

    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)btnActionSubmit:(id)sender {
   
    
    
    if ([textView_advice.text isEqualToString:PlaceHolder] ||[textView_advice.text isEqualToString:@""]){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Please enter some text" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
     [self hitApiForUpload];
    }
}
- (IBAction)btnAction_Cancel:(id)sender {
    textView_advice.text = @"";
    [CommonFunction removeAnimationFromView:_popUpView];
}
- (IBAction)btnActionPreception:(id)sender {
    uploadType = @"prescription";
    [self addPopupview];
}
- (IBAction)btnAction_fellowUp:(id)sender {
    uploadType = @"followup";
    [self addPopupview];
}
- (IBAction)btnAction_Diagnose:(id)sender {
    uploadType = @"diagnosis";
    [self addPopupview];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    Chat *s = (Chat *) [messagesArray objectAtIndex:indexPath.row];
    NSString *message = s.message;
    if (message){
        NSDictionary *dictOfMedia = [NSPropertyListSerialization
                                     propertyListWithData:[message dataUsingEncoding:NSUTF8StringEncoding]
                                     options:kNilOptions
                                     format:NULL
                                     error:NULL];
        
        
        if (dictOfMedia!=nil && [dictOfMedia isKindOfClass:[NSDictionary class]] && [dictOfMedia objectForKey:@"type"])
        {
            [CommonFunction resignFirstResponderOfAView:self.view];
            imgViewToZoom= [[UIImageView alloc]initWithFrame:self.view.frame];
            [imgViewToZoom sd_setImageWithURL:[dictOfMedia objectForKey:@"url"]];
            [imgViewToZoom addGestureRecognizer:cameraGesture];
            imgViewToZoom.userInteractionEnabled = true;
            [self.view addSubview:imgViewToZoom];
            
        }
    }
}
-(void)removeImage{
    [imgViewToZoom removeFromSuperview];
}

#pragma mark -other

-(void)addPopupview{
//     [CommonFunction setResignTapGestureToView:_popUpView andsender:self];
    textView_advice.text = @"Add some text...";
    textView_advice.textColor = [UIColor darkGrayColor]; //optional

    [[self popUpView] setAutoresizesSubviews:true];
    [[self popUpView] setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) ;
    frame.origin.y = 0.0f;
    self.popUpView.center = CGPointMake(self.view.center.x, self.view.center.y);
    [[self popUpView] setFrame:frame];
    [self.view addSubview:_popUpView];
    [CommonFunction addAnimationToview:_popUpView];
}
-(void)setMessageArray:(BOOL)isScroll{
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Chat"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"((senderId == %@)AND(recieverId == %@))OR((senderId == %@)AND(recieverId == %@))",[_toId lowercaseString],[fromId lowercaseString],[fromId lowercaseString],[_toId lowercaseString]];
    messagesArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
//    [CommonFunction resignFirstResponderOfAView:self.view];
    
    [self.tblView reloadData];
    if (isScroll) {
        [self setTblScroll];
    }
    
    
}
-(void)setTblScroll{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:([messagesArray count]-1) inSection:0];
    if ([messagesArray count]>0){
        [_tblView scrollToRowAtIndexPath:indexPath
                        atScrollPosition:UITableViewScrollPositionBottom
                                animated:YES];
    }
    
    
}

-(void)saveMessage:(NSString *)isReceive senderId:(XMPPMessage *)messageContent andeMessage:(NSString *)messageString{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // Create a new managed object
    NSManagedObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"Chat" inManagedObjectContext:context];
    [newDevice setValue:messageString forKey:@"message"];
    [newDevice setValue:isReceive forKey:@"isReceive"];

    
    
    [newDevice setValue:isReceive forKey:@"isReceive"];

    if (![isReceive  isEqual: @"0"] ){
        
        BOOL ischat = messageContent.isChatMessage;
        if (ischat){
            NSXMLNode *fromNode = [messageContent attributeForName:@"from"];
            NSXMLNode *toNode = [messageContent attributeForName:@"to"];
            NSString *from = [fromNode stringValue];
            NSString *to = [toNode stringValue];
            [newDevice setValue:[[[from componentsSeparatedByString:@"@"] objectAtIndex:0] lowercaseString]  forKey:@"senderId"];
            [newDevice setValue:[[[to componentsSeparatedByString:@"@"] objectAtIndex:0] lowercaseString] forKey:@"recieverId"];
        }
        
    }
    else
    {

        [newDevice setValue:[fromId lowercaseString] forKey:@"senderId"];
        [newDevice setValue:[_toId lowercaseString] forKey:@"recieverId"];
    }

    
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
    if ([_mySwitch isOn]) {
        NSString *messageStr = _txtField.text;
        if([messageStr length] > 0) {
            [hm sendMessage:messageStr toFriendWithFriendId:_toId andMessageId:@"34"];
        }
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"You have to be Online to send the message." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        //                    [CommonFunction storeValueInDefault:@"true" andKey:@"isLoggedIn"];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
        [textField resignFirstResponder];
    
    return YES;
}

- (IBAction)btnAddFileClicked:(id)sender {
    if ([_mySwitch isOn]) {
        [self showActionSheet];
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"You have to be Online to send the message." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        //                    [CommonFunction storeValueInDefault:@"true" andKey:@"isLoggedIn"];
        [self presentViewController:alertController animated:YES completion:nil];
    }
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
    loderObj.lbl_title.text = @"Please wait...";
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


#pragma mark - Api Related
-(void)hitApiForDoctorList{
    
    
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    [parameter setValue:[CommonFunction getValueFromDefaultWithKey:loginuserId] forKey:@"patient_id"];
    
    if ([ CommonFunction reachability]) {
        [self addLoder];
        
        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_GET_CHAT_GROUP]  postResponse:parameter postImage:nil requestType:POST tag:nil isRequiredAuthentication:YES header:@"" completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"] || [[responseObj valueForKey:@"status_code"] isEqualToString:@"HK002"]) {
                    
                   __block bool tempBool = false;
                    doctorListArray = [NSMutableArray new];
                    NSArray *tempArray = [NSArray new];
                    tempArray  = [responseObj valueForKey:@"data"];
                    [tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (_objDoctor.doctor_id == [[obj valueForKey:@"doctor_id"] integerValue]  ) {
                            tempBool = true;
                        }
                        
                    }];
                    if (!tempBool || tempArray.count == 0) {
                        UIAlertController* alertController = [UIAlertController
                                                              alertControllerWithTitle:@"Add to Chat list"
                                                              message:@"Do you wish to add this doctor into your chat list? Will be added into your EMR secton."
                                                              preferredStyle:UIAlertControllerStyleActionSheet];
                        
                        UIAlertAction* item1 = [UIAlertAction actionWithTitle:@"Add"
                                                                        style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction *action) {
                                                                          //do something here
                                                                          
                                                                          [self hitApiForToAddIntoChatGroup];
                                                                          [alertController dismissViewControllerAnimated:YES completion:nil];
                                                                      }];
                        
                        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                            [alertController dismissViewControllerAnimated:YES completion:nil];
                        }];
                        
                        [alertController addAction:item1];
                        [alertController addAction:cancelAction];
                        
                        alertController.popoverPresentationController.sourceView = self.view;
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                    //                        Specialization *specializationObj = [Specialization new];
                    //                        specializationObj.classificationOfDoctor = [obj valueForKey:@"classification"];
                    //                        specializationObj.created_at = [obj valueForKey:@"created_at"];
                    //                        specializationObj.current_grade = [obj valueForKey:@"current_grade"];
                    //                        specializationObj.doctor_id = [[obj valueForKey:@"doctor_id"] integerValue];
                    //                        specializationObj.first_name = [obj valueForKey:@"first_name"];
                    //                        specializationObj.gender = [obj valueForKey:@"gender"];
                    //                        specializationObj.last_name = [obj valueForKey:@"last_name"];
                    //                        specializationObj.photo = [obj valueForKey:@"photo"];
                    //                        specializationObj.sub_specialist = [obj valueForKey:@"sub_specialist"];
                    //                        specializationObj.workplace = [obj valueForKey:@"workplace"];
                    //                        specializationObj.jabberId = [NSString stringWithFormat:@"%@%@",[[[obj valueForKey:@"email"] componentsSeparatedByString:@"@"] objectAtIndex:0],[[[obj valueForKey:@"email"] componentsSeparatedByString:@"@"] objectAtIndex:1]];
                    //                        
                    //                        [doctorListArray addObject:specializationObj];
//                    [doctorListArray]
                    
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




-(void)hitApiForToAddIntoChatGroup{
    
    
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    [parameter setValue:[CommonFunction getValueFromDefaultWithKey:loginuserId] forKey:@"patient_id"];
    [parameter setValue:[NSString stringWithFormat:@"%ld", (long)_objDoctor.doctor_id ] forKey:@"doctor_id"];
    
    if ([ CommonFunction reachability]) {
        [self addLoder];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_ADD_CHAT_GROUP]  postResponse:parameter postImage:nil requestType:POST tag:nil isRequiredAuthentication:YES header:@"" completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"]) {
                    NSLog(@"Added Successfully into the chat list");
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:[responseObj valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:ok];
                }else{
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
-(void)hitApiForUpload{
    
   
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    [parameter setValue:[CommonFunction getValueFromDefaultWithKey:loginuserId] forKey:@"doctor_id"];
    [parameter setValue:[NSString stringWithFormat:@"%ld", (long)_objDoctor.doctor_id ] forKey:@"patient_id"];
    [parameter setValue:uploadType forKey:@"type"];
    [parameter setValue:textView_advice.text forKey:@"detail"];
    
    if ([ CommonFunction reachability]) {
        [self addLoder];
        
        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_UPLOAD_DOCTOR_ADVICE]  postResponse:parameter postImage:nil requestType:POST tag:nil isRequiredAuthentication:YES header:@"" completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"]) {
                    
                    
                    NSLog(@"Added Successfully into the chat list");
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:[responseObj valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [CommonFunction removeAnimationFromView:_popUpView];
                        textView_advice.text = @"";
                    }];
                    [alertController addAction:ok];
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





@end





