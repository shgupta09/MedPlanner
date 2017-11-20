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
#import "SMMessageViewTableCell.h"
#import "Chat+CoreDataProperties.h"
@interface ChatViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    XMPPHandler* hm;
    NSMutableArray	*messagesArray;
}
@property (weak, nonatomic) IBOutlet UIButton *btnSend;

@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (weak, nonatomic) IBOutlet UITextField *txtField;
@property (weak, nonatomic) IBOutlet UIView *viewOnlineStatus;


@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    lbl_title.text = _titleStr;
   
    _btnSend.layer.cornerRadius = 5;
    _btnSend.layer.masksToBounds = true;
    _txtField.layer.cornerRadius = 5;
    _txtField.layer.masksToBounds = true;
    messagesArray = [[NSMutableArray alloc] init];
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
//    [CommonFunction setViewBackground:self.tblView withImage:[UIImage imageNamed:@"BackgroundGeneral"]];
//    [self setUpRegisterUser];
    [self setChat];
    // Do any additional setup after loading the view from its nib.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated{


//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [hm sendMessage:@"hiiiiiiii" toFriendWithFriendId:@"shubham" andMessageId:@"1222"];
//    });
    
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
        
        if (![presenceFromUser isEqualToString:myUsername]) {
            
            if ([presenceType isEqualToString:@"available"]) {
                lbl_title.backgroundColor = [UIColor greenColor];
                
                
            } else if ([presenceType isEqualToString:@"unavailable"]) {
                
                lbl_title.backgroundColor = [UIColor redColor];
                
            }
            
        }
    
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
               
        static NSString *CellIdentifier = @"ImageMessageTableViewCell";
        ImageMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        
//        Message *msg = [[Message alloc] init];
//        msg.date = s.date;
//        msg.text = message;
//        if ([s.isReceive isEqualToString:@"1"]){
//            msg.sender = MessageSenderSomeone;
//        }
//        else{
//            msg.sender = MessageSenderMyself;
//        }
//        
//        
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[dictOfMedia objectForKey:@"url"]]];
        
        cell.backgroundColor = [UIColor redColor];
        
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
        
        cell.backgroundColor = [UIColor yellowColor];
        
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

-(void)setUpRegisterUser{
    hm = [[XMPPHandler alloc] init];
    hm.userId = @"shu";
    hm.userId = @"qwerty";
    hm.userId = @"ady";
    hm.userPassword = @"willpower";
    hm.hostName = @"80.209.227.103";
    hm.hostPort = [NSNumber numberWithInteger:5222];
    
    //        [hm registerNewUser:true];
    [hm registerUser];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notficationRecieved:) name:XMPPStreamDidRegister object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notficationRecieved:) name:XMPPStreamDidNotRegister object:nil];
    
    
}


-(void)setChat{
    
    hm = [[XMPPHandler alloc] init];
    hm.userId = @"shu";
    hm.userPassword = @"willpower";
    hm.hostName = @"80.209.227.103";
    
    hm.hostPort = [NSNumber numberWithInteger:5222];
    
    //    [hm registerUser];
    [hm connectToXMPPServer];
    
        
    [hm setMyStatus:MyStatusAvailable];
    
    
    [self.tblView registerClass:[MessageCell class] forCellReuseIdentifier: @"MessageCell"];
    [self.tblView registerNib:[UINib nibWithNibName:@"ImageMessageTableViewCell" bundle:nil] forCellReuseIdentifier: @"ImageMessageTableViewCell"];
    // You may need to alter these settings depending on the server you're connecting to
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notficationRecieved:) name:XMPPStreamDidReceiveMessage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notficationRecieved:) name:XMPPStreamDidSendMessage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notficationRecieved:) name:XMPPStreamDidReceivePresence object:nil];
    
    [self setMessageArray:false];
    //    [hm registerUser];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)sendMessage {
    NSString *messageStr = _txtField.text;
    if([messageStr length] > 0) {
        [hm sendMessage:messageStr toFriendWithFriendId:@"shu" andMessageId:@"34"];
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
        [textField resignFirstResponder];
    
    return YES;
}

- (IBAction)btnAddFileClicked:(id)sender {
    
    NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:@"BackgroundGeneral"]);

    NSString* imageURLReturned = @"";
    
    NSMutableArray *imgArray = [NSMutableArray new];
    [imgArray addObject:imageData];
    
//    [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,API_UploadDocument] postResponse:nil withImageData:nil isImageChanged:false requestType:POST requiredAuthorization:false ImageKey:@"photo" DataArray:imgArray completetion:^(BOOL status, id responseObj, NSString *tag, NSError *error, NSInteger statusCode) {
//        if (error == nil) {
//            if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"] == true){
//                imageURLReturned = [[responseObj valueForKey:@"urls"] valueForKey:@"photo"];
//            }
//            else
//            {
//            }
//            
//        }
//        
//    }];
//
    
    NSDictionary *dict = @{@"type":@"image",
                           @"url":@"https://www.w3schools.com/w3images/fjords.jpg"};
    
    NSString *newMessage = [NSString stringWithFormat:@"%@",dict];

    [hm sendImage:[UIImage imageNamed:@"BackgroundGeneral"] withMessage:newMessage toFriendWithFriendId:@"shu" andMessageId:@"34"];
    
    
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



@end





