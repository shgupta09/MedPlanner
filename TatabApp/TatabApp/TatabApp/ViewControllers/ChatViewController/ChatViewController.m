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
    CustomAlert *alertObj;
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
    alertObj = [[CustomAlert alloc] initWithFrame:self.view.frame];

    [_mySwitch setOn:YES animated:YES];
    ifphoto = true;
    _viewToClip.layer.cornerRadius = 5;
    _viewToClip.layer.masksToBounds = true;
    doctorListArray = [NSMutableArray new];

    picker = [[UIImagePickerController alloc] init];
    lbl_title.text = @"Chat";
   imageDataArray = [NSMutableArray new];
    if (![[CommonFunction getValueFromDefaultWithKey:loginuserType] isEqualToString:@"Patient"]) {
       
       if ([_objDoctor.dependent_id isEqualToString:@"0"]) {
            _lbl_Name.text = [NSString stringWithFormat:@"%@",[_objDoctor.first_name capitalizedString]];

        }else{
            _lbl_Name.text = [NSString stringWithFormat:@"%@",[_objDoctor.dependent_Name capitalizedString]];

        }
        _btn_queue.hidden = false;
        if ([QueueDetails sharedInstance].myDataArray.count>0) {
            _lbl_queueCount.hidden = false;
            _lbl_queueCount.text = [NSString stringWithFormat:@"%d",[QueueDetails sharedInstance].myDataArray.count];
        }else{
            _lbl_queueCount.hidden = true;

        }
    }else{
    _lbl_Name.text = [NSString stringWithFormat:@"Dr. %@",[_objDoctor.first_name capitalizedString]];
        _lbl_queueCount.hidden = true;
        _btn_queue.hidden = true;
    }
    
    NSString* email = [CommonFunction getValueFromDefaultWithKey:loginemail];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"UpdateCountLAbel"
                                               object:nil];
    
    //test
    NSString* foo = [NSString stringWithFormat:@"%@%@",[[email componentsSeparatedByString:@"@"] objectAtIndex:0],[[email componentsSeparatedByString:@"@"] objectAtIndex:1]];
    NSString* userID = foo;
    fromId = userID;
    
    
    //abhinav
//    _toId = @"shagdep";
//    fromId = @"ddhh";
////
    //iphone 6
//    _toId = @"ddhh";
//    fromId = @"shagdep";
    
    
    
    
    
    
    _viewShowStatus.layer.cornerRadius = 5;
    _viewShowStatus.layer.masksToBounds = true;
    _btnSend.layer.cornerRadius = 5;
    _btnSend.layer.masksToBounds = true;
    _txtField.layer.cornerRadius = 5;
    _txtField.layer.masksToBounds = true;
    messagesArray = [[NSMutableArray alloc] init];
    _addOptionBtnAction.tintColor = [UIColor whiteColor];
    _imgView_patient_BackGround.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_Chat",_awarenessObj.category_name]];
    UIImage * image = [UIImage imageNamed:@"documentWhite"];
    [_addOptionBtnAction setBackgroundImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    
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
        _lbl_Patient_DoctorName.text = [_objDoctor.first_name capitalizedString];
        _imgView_patient_BackGround.image = [UIImage imageNamed:_awarenessObj.category_name];
        _imgView_patient_BackGround.alpha = .3;
        _imgView_patient_BackGround.clipsToBounds = true;
        _lbl_Patient_Clinic.text = _awarenessObj.category_name;
         [_imgView_PatientDoctor sd_setImageWithURL:[NSURL URLWithString:_objDoctor.photo] placeholderImage:[UIImage imageNamed:@"doctor.png"]];
//        [self hitApiForDoctorList];
        _btn_EndChat.hidden = true;
        
    }else{
        _viewPatient.hidden = true;
        _viewDoctor.hidden = false;
        [_btn_FollowUp setSelected:false];
        [self hitAPiForCheckFollowUP];

//        [self hitApiForStartTheChat];
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
    alertObj.frame = self.view.frame;
}

-(void)viewDidDisappear:(BOOL)animated{
   
}


-(void)setUpRegisterUser{
    hm = [[XMPPHandler alloc] init];
    hm.userId = @"121214545487878";
    hm.userPassword = @"willpower";
    hm.hostName = EjabbrdIP;
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
    hm.hostName = EjabbrdIP;
    hm.hostPort = [NSNumber numberWithInteger:5222];
    
    [hm connectToXMPPServer];
    [hm setMyStatus:MyStatusAvailable];
    [self.tblView registerClass:[MessageCell class] forCellReuseIdentifier: @"MessageCell"];
    [self.tblView registerClass:[ImageMessageCell class] forCellReuseIdentifier: @"ImageMessageCell"];
    
    
    // You may need to alter these settings depending on the server you're connecting to
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notficationRecieved:) name:XMPPStreamDidReceiveMessage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notficationRecieved:) name:XMPPStreamDidSendMessage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notficationRecieved:) name:XMPPStreamDidReceivePresence object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notficationRecieved:) name:XMPPStreamDidRegister object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notficationRecieved:) name:XMPPStreamDidNotAuthenticate object:nil];
    
    
    
    [self setMessageArray:false];
    [self setLanguageData];
    //    [hm registerUser];
    // Do any additional setup after loading the view from its nib.
}
-(void)setLanguageData{
    lbl_title.text = [Langauge getTextFromTheKey:@"chat"];
    _lbl_Patient_Clinic.text = [Langauge getTextFromTheKey:[_awarenessObj.category_name stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
    _lbl_Clinic.text = [Langauge getTextFromTheKey:@"clinic"];
    _lbl_Dr.text = [Langauge getTextFromTheKey:@"dr"];
    _txtField.placeholder = [Langauge getTextFromTheKey:@"chat_placeholder"];
    _lbl_patient.text = [Langauge getTextFromTheKey:@"patient"];
    _lbl_FollowUP.text = [Langauge getTextFromTheKey:@"follow_up"];
    _lbl_Diagnoses.text = [Langauge getTextFromTheKey:@"diagnosis"];
    _lbl_prescription.text = [Langauge getTextFromTheKey:@"prescription"];
    
//    [_btn_Continue setTitle:[Langauge getTextFromTheKey:@"continue_tv"] forState:UIControlStateNormal];
//    _txtName.placeholder = [Langauge getTextFromTheKey:@"First_Name"];
    
}

-(void)receiveNotification:(NSNotification*)notObj{
    if ([notObj.name isEqualToString:@"UpdateCountLAbel"]){
        
        if (![[CommonFunction getValueFromDefaultWithKey:loginuserType] isEqualToString:@"Patient"]) {
            _lbl_Name.text = [NSString stringWithFormat:@"%@",[_objDoctor.first_name capitalizedString]];
            _btn_queue.hidden = false;
            if ([QueueDetails sharedInstance].myDataArray.count>0) {
                _lbl_queueCount.hidden = false;
                _lbl_queueCount.text = [NSString stringWithFormat:@"%d",[QueueDetails sharedInstance].myDataArray.count];
            }else{
                _lbl_queueCount.hidden = true;
                
            }
        }
    }
}
-(void) notficationRecieved:(NSNotification*) notification{
    
    if ([notification.name isEqualToString:XMPPStreamDidReceiveMessage])
    {
        
        
        XMPPMessage* messageContent = notification.object;
        
        if(messageContent.hasReceiptResponse){
            [self setDeliveryTrueForMessageid:messageContent.receiptResponseID];
            [self setMessageArray:false];

            DebugLog(@"XMPPStreamDelegate : Message Receipt Response for Message - %@",messageContent.receiptResponseID);
        }
        else{
            [self saveMessage:@"1" senderId:messageContent andeMessage:messageContent.body];
            [self setMessageArray:true];
        }
        
    }
    
    else if ([notification.name isEqualToString:XMPPStreamDidSendMessage])
    {
        XMPPMessage* messageContent = notification.object;
        if(messageContent.hasReceiptResponse){
      
        }
        else
        {
            [self saveMessage:@"0" senderId:messageContent andeMessage:messageContent.body];
            [self setMessageArray:true];
            _txtField.text = @"";
            [_btnSend setImage:[UIImage imageNamed:@"cameraWhite"] forState:UIControlStateNormal];
          
        }
        
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
#pragma mark - textFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.text.length == 1 && [string isEqualToString:@""]) {
        [_btnSend setImage:[UIImage imageNamed:@"cameraWhite"] forState:UIControlStateNormal];
    }else{
        [_btnSend setImage:[UIImage imageNamed:@"sendButton-1"] forState:UIControlStateNormal];
    }
    return true;
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
                    
                    
                    
                                        NSError *error;
                                        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                                                           options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                                                             error:&error];
                    
                                        if (! jsonData) {
                                            NSLog(@"Got an error: %@", error);
                                        } else {
                                            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                                            NSString *newMessage = [NSString stringWithFormat:jsonString];
                    
                                            //                    [hm sendImage:[UIImage imageNamed:@"BackgroundGeneral"] withMessage:newMessage toFriendWithFriendId:@"shuam" andMessageId:@"34"];
                    
                                            [hm sendMessage:newMessage toFriendWithFriendId:_toId andMessageId:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] ]];
                                        }

                    
//                    NSString *newMessage = [NSString stringWithFormat:@"%@",dict];
//
//                    //                    [hm sendImage:[UIImage imageNamed:@"BackgroundGeneral"] withMessage:newMessage toFriendWithFriendId:@"shuam" andMessageId:@"34"];
//
//                    [hm sendMessage:newMessage toFriendWithFriendId:_toId andMessageId:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] ]];

                    
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
- (IBAction)btnAction_EndChat:(id)sender {
    [CommonFunction resignFirstResponderOfAView:self.view];
    [self hitApiForEndTheChat];
    
}

- (IBAction)switch_btn:(id)sender {
    if ([_mySwitch isOn]) {
        [self hitApiForDoctorToBeOnline:@"1"];
        
//        [hm connectToXMPPServer];
        NSLog(@"Switch is on");
    } else {
        NSLog(@"Switch is off");
//        [hm disconnectFromXMPPServer];
        [self hitApiForDoctorToBeOnline:@"2"];
        
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
       /* UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Please enter some text" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];*/
        [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:@"Please enter some text" isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
        
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
//    uploadType = @"followup";
//    [self addPopupview];
    if (_btn_FollowUp.isSelected == false) {
        [self hitAPiToUploadFollowUP:@"true"];
//         [_btn_FollowUp setSelected:true];
    }else{
//         [_btn_FollowUp setSelected:false];
        [self hitAPiToUploadFollowUP:@"false"];
    }
    
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
        NSData* data = [message dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        
        NSDictionary *dictOfMedia = [NSJSONSerialization
                                     JSONObjectWithData:data
                                     options:0
                                     error:&error];
        
        if (dictOfMedia!=nil && [dictOfMedia isKindOfClass:[NSDictionary class]] && [dictOfMedia objectForKey:@"type"])
        {
            
            
            return 160;
            
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
        NSData* data = [message dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;

        NSDictionary *dictOfMedia = [NSJSONSerialization
                                     JSONObjectWithData:data
                                     options:0
                                     error:&error];
    
    
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
            msg.status = MessageStatusSent;

        }
        if ([s.delivered  isEqual: @"1"] ) {
            msg.status = MessageStateDelivered;
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
//            msg.status = MessageStatusSent;
        }
        else{
            msg.sender = MessageSenderMyself;
            msg.status = MessageStatusSent;
        }
        
        if ([s.delivered  isEqual: @"1"] ) {
            msg.status = MessageStateDelivered;
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
        NSData* data = [message dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        
        NSDictionary *dictOfMedia = [NSJSONSerialization
                                     JSONObjectWithData:data
                                     options:0
                                     error:&error];
        
        
        
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
     [CommonFunction setResignTapGestureToView:_popUpView andsender:self];
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
-(void)resignResponder{
    [CommonFunction resignFirstResponderOfAView:self.view];
    if ([_popUpView isDescendantOfView:self.view]) {
        [_popUpView removeFromSuperview];
    }
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


#pragma mark xml parser delegate methods


-(void)saveMessage:(NSString *)isReceive senderId:(XMPPMessage *)messageContent andeMessage:(NSString *)messageString{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // Create a new managed object
    NSManagedObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"Chat" inManagedObjectContext:context];
    [newDevice setValue:messageString forKey:@"message"];
    [newDevice setValue:isReceive forKey:@"isReceive"];
  
    DDXMLElement* element = [[messageContent elementsForName:@"request"] firstObject];
    
    [newDevice setValue:[[element attributesAsDictionary] valueForKey:@"id"] forKey:@"messageId"];

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

-(void)setDeliveryTrueForMessageid:(NSString *)messageId{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Chat"];
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"messageId==%@",messageId];
    
    NSError *fetchError;
    NSArray *fetchResultArray = [context executeFetchRequest:fetchRequest error:&fetchError];
 
    // Create a new managed object
    NSManagedObject *newDevice = [fetchResultArray firstObject];
    [newDevice setValue:@"1" forKey:@"delivered"];
    
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
            [hm sendMessage:messageStr toFriendWithFriendId:_toId andMessageId:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] ]];
        }else{
            sourceType = UIImagePickerControllerSourceTypeCamera;
            [self imageCapture];
        }
    }else{
        
         [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:@"You have to be Online to send the message." isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
        
       /* UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"You have to be Online to send the message." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        //                    [CommonFunction storeValueInDefault:@"true" andKey:@"isLoggedIn"];
        [self presentViewController:alertController animated:YES completion:nil];
        .*/
    }
    
}




- (IBAction)btnAddFileClicked:(id)sender {
    if ([_mySwitch isOn]) {
       // [self showActionSheet];
        [self selectPhoto];
    }else{
        /*UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"You have to be Online to send the message." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        //                    [CommonFunction storeValueInDefault:@"true" andKey:@"isLoggedIn"];
        [self presentViewController:alertController animated:YES completion:nil];*/
        
        [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:@"You have to be Online to send the message." isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
    }
}


#pragma mark - keyboard notification
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}



- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}



#pragma mark - keyboard movements

- (void)keyboardWillShow:(NSNotification *)notification

{
    
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    if(((int)[[UIScreen mainScreen] nativeBounds].size.height)==2436) {
        if (@available(iOS 11.0, *)) {
            _bottomConstraint.constant =333;
        } else {
            // Fallback on earlier versions
            _bottomConstraint.constant = keyboardSize.height;

        }
    }else{
        _bottomConstraint.constant = keyboardSize.height;
    }
}





-(void)keyboardWillHide:(NSNotification *)notification
{
    _bottomConstraint.constant = 0;
    
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
                        queueObj.dependentName = [NSString stringWithFormat:@"%@",[[obj valueForKey:@"dependent"] valueForKey:@"dependent_name"]];

                        queueObj.jabberId = [NSString stringWithFormat:@"%@%@",[[[obj valueForKey:@"email"] componentsSeparatedByString:@"@"] objectAtIndex:0],[[[obj valueForKey:@"email"] componentsSeparatedByString:@"@"] objectAtIndex:1]];
                        
                        [[QueueDetails sharedInstance].myDataArray addObject:queueObj];
                        
                    }];
                    if ([QueueDetails sharedInstance].myDataArray.count>0) {
                        _lbl_queueCount.hidden = false;
                        _lbl_queueCount.text = [NSString stringWithFormat:@"%d",[QueueDetails sharedInstance].myDataArray.count];
                    }else{
                        _lbl_queueCount.hidden = true;
                        
                    }
                    
                }
                if ([QueueDetails sharedInstance].myDataArray.count>0) {
                    _lbl_queueCount.hidden = false;
                    _lbl_queueCount.text = [NSString stringWithFormat:@"%d",[QueueDetails sharedInstance].myDataArray.count];
                }else{
                    _lbl_queueCount.hidden = true;
                    
                }
                
            }else{
                [self removeloder];
            }
        }];
    }
}


-(void)hitApiForEndTheChat{
    
    
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    [parameter setValue:[CommonFunction getValueFromDefaultWithKey:loginuserId] forKey:@"doctor_id"];
    [parameter setValue:_objDoctor.doctor_id forKey:@"patient_id"];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    [parameter setValue:[dateFormatter stringFromDate:date] forKey:@"end_datetime"];
 

    if (_objDoctor.dependent_id == nil || [_objDoctor.dependent_id isEqualToString:@"0"]) {
        [parameter setValue:@"na" forKey:DEPENDANT_ID];
    }else{
        [parameter setValue:_objDoctor.dependent_id forKey:DEPENDANT_ID];
    }
    NSLog(@"%@",parameter);
    if ([ CommonFunction reachability]) {
        [self addLoder];
        
        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,@"endchat"]  postResponse:parameter postImage:nil requestType:POST tag:nil isRequiredAuthentication:YES header:@"" completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"]) {
                    [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:[responseObj valueForKey:@"message"] isTwoButtonNeeded:false firstbuttonTag:1001 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
                    [self hitApiForTheQueueCount];
                    
                    
                }else
                {
                    [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:[responseObj valueForKey:@"message"] isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
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
        [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:Network_Issue_Message isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
    }
}

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
                    [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:[responseObj valueForKey:@"message"] isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
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
        [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:Network_Issue_Message isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
    }
}

-(void)hitApiForDoctorToBeOnline:(NSString *)statusToChange{
    
    
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    [parameter setValue:[CommonFunction getValueFromDefaultWithKey:loginuserId] forKey:@"doctor_id"];
    [parameter setValue:statusToChange forKey:@"status_id"];
    
    
    if ([ CommonFunction reachability]) {
        [self addLoder];
        
        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,@"godoctor_online"]  postResponse:parameter postImage:nil requestType:POST tag:nil isRequiredAuthentication:YES header:@"" completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"]) {
                    [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:[responseObj valueForKey:@"message"] isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
                    if ([statusToChange isEqualToString:@"1"]) {
                        [self.mySwitch setOn:YES animated:YES];
                    }else{
                        [self.mySwitch setOn:NO animated:YES];

                    }
                   
                    
                }else
                {
                    [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:[responseObj valueForKey:@"message"] isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
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
        [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:Network_Issue_Message isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
    }
}



-(void)hitApiForToAddIntoChatGroup{
    
    
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    [parameter setValue:[CommonFunction getValueFromDefaultWithKey:loginuserId] forKey:@"patient_id"];
    [parameter setValue:[NSString stringWithFormat:@"%ld", (long)_objDoctor.doctor_id ] forKey:@"doctor_id"];
    if (_objDoctor.dependent_id == nil || [_objDoctor.dependent_id isEqualToString:@"0"]) {
        [parameter setValue:@"na" forKey:DEPENDANT_ID];
    }else{
        [parameter setValue:_objDoctor.dependent_id forKey:DEPENDANT_ID];
    }
    
    if ([ CommonFunction reachability]) {
        [self addLoder];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_ADD_CHAT_GROUP]  postResponse:parameter postImage:nil requestType:POST tag:nil isRequiredAuthentication:YES header:@"" completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"]) {
                    NSLog(@"Added Successfully into the chat list");
                    
                                        [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:[responseObj valueForKey:@"message"] isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
                   /* UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:[responseObj valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:ok];
                    */
                }else{
                    [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:[responseObj valueForKey:@"message"] isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
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
        [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:Network_Issue_Message isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
    }
}
-(void)hitApiForUpload{
    
   
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    [parameter setValue:[CommonFunction getValueFromDefaultWithKey:loginuserId] forKey:@"doctor_id"];
    [parameter setValue:_objDoctor.doctor_id forKey:@"patient_id"];
    
    [parameter setValue:uploadType forKey:@"type"];
    [parameter setValue:textView_advice.text forKey:@"detail"];
    if (_objDoctor.dependent_id == nil || [_objDoctor.dependent_id isEqualToString:@"0"]) {
        [parameter setValue:@"na" forKey:DEPENDANT_ID];
    }else{
        [parameter setValue:_objDoctor.dependent_id forKey:DEPENDANT_ID];
    }
    if ([ CommonFunction reachability]) {
        [self addLoder];
        
        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_UPLOAD_DOCTOR_ADVICE]  postResponse:parameter postImage:nil requestType:POST tag:nil isRequiredAuthentication:YES header:@"" completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"]) {
                    
                    [_popUpView removeFromSuperview];
                    NSLog(@"Added Successfully into the chat list");
                      [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:[responseObj valueForKey:@"message"] isTwoButtonNeeded:false firstbuttonTag:101 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
                /*    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:[responseObj valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [CommonFunction removeAnimationFromView:_popUpView];
                        textView_advice.text = @"";
                    }];
                    [alertController addAction:ok];
                    [self presentViewController:alertController animated:YES completion:nil];
                 */
                    
                }else
                {
                    [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:[responseObj valueForKey:@"message"] isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
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
        [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:Network_Issue_Message isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
    }
}


-(void)hitAPiForCheckFollowUP{
    
    
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    [parameter setValue:[CommonFunction getValueFromDefaultWithKey:loginuserId] forKey:@"doctor_id"];
    [parameter setValue:_objDoctor.doctor_id forKey:@"patient_id"];
    if (_objDoctor.dependent_id == nil || [_objDoctor.dependent_id isEqualToString:@"0"]) {
        [parameter setValue:@"na" forKey:DEPENDANT_ID];
    }else{
        [parameter setValue:_objDoctor.dependent_id forKey:DEPENDANT_ID];
    }
//    [parameter setValue:"" forKey:""];
    
    
    if ([ CommonFunction reachability]) {
        [self addLoder];
        
        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_FOR_CHECK_FOLLOWUP]  postResponse:parameter postImage:nil requestType:POST tag:nil isRequiredAuthentication:YES header:@"" completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"]) {
                    
                  NSString *strTocheck =  [CommonFunction checkForNull:[[responseObj valueForKey:@"data"] valueForKey:@"is_follow"]];
                    if ([strTocheck isEqualToString:@"false"] || [strTocheck isEqualToString:@""]) {
                        [_btn_FollowUp setSelected:false];

                    }else{
                        [_btn_FollowUp setSelected:true];

                    }
                    
                }else
                {
                   
                    [self removeloder];
                }
                [self removeloder];
                
            }else{
                [self removeloder];
            }
            
            
            
        }];
    } else {
       
    }
}

-(void)hitAPiToUploadFollowUP:(NSString *)statusStr{
    
    
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    [parameter setValue:[CommonFunction getValueFromDefaultWithKey:loginuserId] forKey:@"doctor_id"];
    [parameter setValue:_objDoctor.doctor_id forKey:@"patient_id"];
    [parameter setValue:statusStr forKey:@"is_follow"];
    if (_objDoctor.dependent_id == nil || [_objDoctor.dependent_id isEqualToString:@"0"]) {
        [parameter setValue:@"na" forKey:DEPENDANT_ID];
    }else{
        [parameter setValue:_objDoctor.dependent_id forKey:DEPENDANT_ID];
    }
    if ([ CommonFunction reachability]) {
        [self addLoder];
        
        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,@"followup"]  postResponse:parameter postImage:nil requestType:POST tag:nil isRequiredAuthentication:YES header:@"" completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"]) {
                    
                    
                    if (![statusStr isEqualToString:@"false"] ) {
                        [_btn_FollowUp setSelected:true];
                        
                    }else{
                        [_btn_FollowUp setSelected:false];
                        
                    }
                    
                }else
                {
                    
                    [self removeloder];
                }
                [self removeloder];
                
            }else{
                [self removeloder];
            }
            
            
            
        }];
    } else {
        
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
        case 101:
                {
                    [CommonFunction removeAnimationFromView:_popUpView];
                    textView_advice.text = @"";
                    [self removeAlert];
        }
            break;
        case 1001:{
            [self.navigationController popToRootViewControllerAnimated:true];
            [self removeAlert];

            break;
        }
        case 1002:{
            [self removeAlert];
            
            break;
        }

        default:
            
            break;
    }
}



@end





