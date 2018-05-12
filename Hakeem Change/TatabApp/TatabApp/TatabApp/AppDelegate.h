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
#import <UserNotifications/UserNotifications.h>

@class SMBuddyListViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,SWRevealViewControllerDelegate,UNUserNotificationCenterDelegate>{
    XMPPStream *xmppStream;
    XMPPRoster *xmppRoster;
    NSString *password;
    BOOL isOpen;
    __unsafe_unretained NSObject <SMChatDelegate> *_chatDelegate;
    __unsafe_unretained NSObject <SMMessageDelegate> *_messageDelegate;
}
// define macro
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong) NSPersistentContainer *persistentContainer;
@property (nonatomic, readonly) XMPPStream *xmppStream;
@property (nonatomic, readonly) XMPPRoster *xmppRoster;
@property (nonatomic, assign) id  _chatDelegate;
@property (nonatomic, assign) id  _messageDelegate;

- (BOOL)connect;
- (void)disconnect;
- (NSURL *)applicationDocumentsDirectory;
- (void)saveContext;

+(AppDelegate *)getDelegate;
-(void)hideStatusBar;
-(void)showStatusBar;
-(void)addStatusBar;
- (void)switchLanguage;

@end

