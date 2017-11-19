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
                _viewOnlineStatus.backgroundColor = [UIColor greenColor];
                
                
            } else if ([presenceType isEqualToString:@"unavailable"]) {
                
                _viewOnlineStatus.backgroundColor = [UIColor redColor];
                
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





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    Chat *s = (Chat *) [messagesArray objectAtIndex:indexPath.row];
    //    NSString *sender = [s objectForKey:@"sender"];
    NSString *message = s.message;
    
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
    hm.userId = @"shuam";
    hm.userPassword = @"willpower";
    hm.hostName = @"80.209.227.103";
    
    hm.hostPort = [NSNumber numberWithInteger:5222];
    
    //    [hm registerUser];
    [hm connectToXMPPServer];
    
    [hm setMyStatus:MyStatusAvailable];
    
    
    [self.tblView registerClass:[MessageCell class] forCellReuseIdentifier: @"MessageCell"];
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
        [hm sendMessage:messageStr toFriendWithFriendId:@"asdf" andMessageId:@"34"];
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
        [textField resignFirstResponder];
    
    return YES;
}




@end


//
////
////  SMChatViewController.m
////  jabberClient
////
////  Created by cesarerocchi on 7/16/11.
////  Copyright 2011 studiomagnolia.com. All rights reserved.
////
//
//#import "SMChatViewController.h"
//#import "XMPP.h"
//
//
//@implementation SMChatViewController
//
//@synthesize messageField, chatWithUser, tView;
//
//
//- (JabberClientAppDelegate *)appDelegate {
//    return (JabberClientAppDelegate *)[[UIApplication sharedApplication] delegate];
//}
//
//- (XMPPStream *)xmppStream {
//    return [[self appDelegate] xmppStream];
//}
//
//- (id) initWithUser:(NSString *) userName {
//    
//    if (self = [super init]) {
//        
//        chatWithUser = userName; // @ missing
//        turnSockets = [[NSMutableArray alloc] init];
//    }
//    
//    return self;
//    
//}
//
//- (void)viewDidLoad {
//    
//    [super viewDidLoad];
//    self.tView.delegate = self;
//    self.tView.dataSource = self;
//    [self.tView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//    
//    messages = [[NSMutableArray alloc ] init];
//    
//    JabberClientAppDelegate *del = [self appDelegate];
//    del._messageDelegate = self;
//    [self.messageField becomeFirstResponder];
//    
//    XMPPJID *jid = [XMPPJID jidWithString:@"cesare@YOURSERVER"];
//    
//    NSLog(@"Attempting TURN connection to %@", jid);
//    
//    TURNSocket *turnSocket = [[TURNSocket alloc] initWithStream:[self xmppStream] toJID:jid];
//    
//    [turnSockets addObject:turnSocket];
//    
//    [turnSocket startWithDelegate:self delegateQueue:dispatch_get_main_queue()];
//    [turnSocket release];
//    
//}
//
//- (void)turnSocket:(TURNSocket *)sender didSucceed:(GCDAsyncSocket *)socket {
//    
//    NSLog(@"TURN Connection succeeded!");
//    NSLog(@"You now have a socket that you can use to send/receive data to/from the other person.");
//    
//    [turnSockets removeObject:sender];
//}
//
//- (void)turnSocketDidFail:(TURNSocket *)sender {
//    
//    NSLog(@"TURN Connection failed!");
//    [turnSockets removeObject:sender];
//    
//}
//
//
//
//#pragma mark -
//#pragma mark Actions
//
//- (IBAction) closeChat {
//    
//    [self dismissModalViewControllerAnimated:YES];
//}
//
//
//#pragma mark -
//#pragma mark Table view delegates
//
//static CGFloat padding = 20.0;
//
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    
//    NSDictionary *s = (NSDictionary *) [messages objectAtIndex:indexPath.row];
//    
//    static NSString *CellIdentifier = @"MessageCellIdentifier";
//    
//    SMMessageViewTableCell *cell = (SMMessageViewTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    if (cell == nil) {
//        cell = [[[SMMessageViewTableCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
//    }
//    
//    NSString *sender = [s objectForKey:@"sender"];
//    NSString *message = [s objectForKey:@"msg"];
//    NSString *time = [s objectForKey:@"time"];
//    
//    CGSize  textSize = { 260.0, 10000.0 };
//    CGSize size = [message sizeWithFont:[UIFont boldSystemFontOfSize:13]
//                      constrainedToSize:textSize
//                          lineBreakMode:UILineBreakModeWordWrap];
//    
//    
//    size.width += (padding/2);
//    
//    
//    cell.messageContentView.text = message;
//    cell.accessoryType = UITableViewCellAccessoryNone;
//    cell.userInteractionEnabled = NO;
//    
//    
//    UIImage *bgImage = nil;
//    
//    
//    if ([sender isEqualToString:@"you"]) { // left aligned
//        
//        bgImage = [[UIImage imageNamed:@"orange.png"] stretchableImageWithLeftCapWidth:24  topCapHeight:15];
//        
//        [cell.messageContentView setFrame:CGRectMake(padding, padding*2, size.width, size.height)];
//        
//        [cell.bgImageView setFrame:CGRectMake( cell.messageContentView.frame.origin.x - padding/2,
//                                              cell.messageContentView.frame.origin.y - padding/2,
//                                              size.width+padding,
//                                              size.height+padding)];
//        
//    } else {
//        
//        bgImage = [[UIImage imageNamed:@"aqua.png"] stretchableImageWithLeftCapWidth:24  topCapHeight:15];
//        
//        [cell.messageContentView setFrame:CGRectMake(320 - size.width - padding,
//                                                     padding*2,
//                                                     size.width,
//                                                     size.height)];
//        
//        [cell.bgImageView setFrame:CGRectMake(cell.messageContentView.frame.origin.x - padding/2,
//                                              cell.messageContentView.frame.origin.y - padding/2,
//                                              size.width+padding,
//                                              size.height+padding)];
//        
//    }
//    
//    cell.bgImageView.image = bgImage;
//    cell.senderAndTimeLabel.text = [NSString stringWithFormat:@"%@ %@", sender, time];
//    
//    return cell;
//    
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    NSDictionary *dict = (NSDictionary *)[messages objectAtIndex:indexPath.row];
//    NSString *msg = [dict objectForKey:@"msg"];
//    
//    CGSize  textSize = { 260.0, 10000.0 };
//    CGSize size = [msg sizeWithFont:[UIFont boldSystemFontOfSize:13]
//                  constrainedToSize:textSize
//                      lineBreakMode:UILineBreakModeWordWrap];
//    
//    size.height += padding*2;
//    
//    CGFloat height = size.height < 65 ? 65 : size.height;
//    return height;
//    
//}
//
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    
//    return [messages count];
//    
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    
//    return 1;
//    
//}
//
//
//#pragma mark -
//#pragma mark Chat delegates
//
//
//- (void)newMessageReceived:(NSDictionary *)messageContent {
//    
//    }
//
//
//- (void)didReceiveMemoryWarning {
//    // Releases the view if it doesn't have a superview.
//    [super didReceiveMemoryWarning];
//    
//    // Release any cached data, images, etc. that aren't in use.
//}
//
//- (void)viewDidUnload {
//    [super viewDidUnload];
//    // Release any retained subviews of the main view.
//    // e.g. self.myOutlet = nil;
//}
//
//
//- (void)dealloc {
//    
//    [messageField dealloc];
//    [chatWithUser dealloc];
//    [tView dealloc];
//    [super dealloc];
//}
//

//@end


