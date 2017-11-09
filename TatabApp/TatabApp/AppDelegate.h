//
//  AppDelegate.h
//  TatabApp
//
//  Created by Shagun Verma on 20/09/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <XMPPFramework/XMPPFramework.h>
#import "XMPPRoster.h"
#import "XMPP.h"
#import "SMChatDelegate.h"
#import "SMMessageDelegate.h"

@class SMBuddyListViewController;


@interface AppDelegate : UIResponder <UIApplicationDelegate,SWRevealViewControllerDelegate>{
    XMPPStream *xmppStream;
    XMPPRoster *xmppRoster;
    
    NSString *password;
    
    BOOL isOpen;
    
    __unsafe_unretained NSObject <SMChatDelegate> *_chatDelegate;
    __unsafe_unretained NSObject <SMMessageDelegate> *_messageDelegate;

}

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

////XMPP
//@property (nonatomic, strong) XMPPStream *xmppStream;
//@property (nonatomic, strong) XMPPRosterCoreDataStorage *xmppRosterStorage;
//@property (nonatomic, strong) XMPPRoster *xmppRoster;
//@property (nonatomic, strong) id<ChatDelegate> *delegate;


@property (nonatomic, readonly) XMPPStream *xmppStream;
@property (nonatomic, readonly) XMPPRoster *xmppRoster;

@property (nonatomic, assign) id  _chatDelegate;
@property (nonatomic, assign) id  _messageDelegate;

- (BOOL)connect;
- (void)disconnect;

- (void)saveContext;


@end

