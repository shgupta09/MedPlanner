//
//  AppDelegate.m
//  TatabApp
//
//  Created by Shagun Verma on 20/09/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//

#import "AppDelegate.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
@import Firebase;
@import FirebaseMessaging;
@import FirebaseInstanceID;
@import UserNotifications;
#import "AGPushNoteView.h"
#import "RatingVC.h"
#import "TermVC.h"
@interface AppDelegate ()


@end

@implementation AppDelegate

@synthesize xmppStream;
@synthesize xmppRoster;
@synthesize _chatDelegate;
@synthesize _messageDelegate;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [CommonFunction stroeBoolValueForKey:isLoggedInHit withBoolValue:false];

    [FIRMessaging messaging].delegate = self;
    [self initRootViewController];
    
    if (![CommonFunction getBoolValueFromDefaultWithKey:IsLanguageSelected]) {
        [CommonFunction stroeBoolValueForKey:IsLanguageSelected withBoolValue:true];
         [CommonFunction storeValueInDefault:Selected_Language_English andKey:Selected_Language];
    }
    if( SYSTEM_VERSION_LESS_THAN( @"10.0" ) )
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound |    UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
    }
    else
    {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error)
         {
             if( !error )
             {
                 [[UIApplication sharedApplication] registerForRemoteNotifications];  // required to get the app to do anything at all about push notifications
                 NSLog( @"Push registration success." );
             }
             else
             {
                 NSLog( @"Push registration FAILED" );
                 NSLog( @"ERROR: %@ - %@", error.localizedFailureReason, error.localizedDescription );
                 NSLog( @"SUGGESTIONS: %@ - %@", error.localizedRecoveryOptions, error.localizedRecoverySuggestion );  
             }  
         }];  
    }
    [FIRApp configure];


    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    application.applicationIconBadgeNumber = 0;

    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self clearData];
    [self saveContext];
}
//In App Delegate

+(AppDelegate *)getDelegate
{
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}


- (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken {
    NSLog(@"FCM registration token: %@", fcmToken);
         NSLog(@"FCM registration token: %@", fcmToken);
    [CommonFunction storeValueInDefault:fcmToken andKey:DEVICE_ID];

    if(![fcmToken isEqualToString:[CommonFunction getValueFromDefaultWithKey:DEVICE_ID_LoginUSer]]&& [CommonFunction getBoolValueFromDefaultWithKey:isLoggedIn]){
        [self hitApiForaddingTheDeviceID];
    }


    // TODO: If necessary send token to application server.
    // Note: This callback is fired at each app startup and whenever a new token is generated.
}
-(void)hitApiForaddingTheDeviceID{
    
    
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    [parameter setValue:[CommonFunction getValueFromDefaultWithKey:DEVICE_ID] forKey:DEVICE_ID];
    [parameter setValue:[CommonFunction getValueFromDefaultWithKey:loginuserId] forKey:loginuserId];
    
    
    if ([ CommonFunction reachability]) {
        //        [self addLoder];
        
        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,@"registration_ids"]  postResponse:parameter postImage:nil requestType:POST tag:nil isRequiredAuthentication:YES header:@"" completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                if ([[responseObj valueForKey:@"status_code"] isEqualToString:@"HK001"]) {
                    [CommonFunction storeValueInDefault:[CommonFunction getValueFromDefaultWithKey:DEVICE_ID] andKey:DEVICE_ID_LoginUSer];
                    //                    [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:[responseObj valueForKey:@"message"] isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
                }else
                {
                    //                    [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:[responseObj valueForKey:@"message"] isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
                    //                    [self removeloder];
                    //                    [self removeloder];
                }
                //                [self removeloder];
            }
        }];
    } else {
        //        [self removeloder];
        //        [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:Network_Issue_Message isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Warning_Key_For_Image];
    }
}
#pragma mark - push_Notifiactiom
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString *str = [NSString stringWithFormat:@"%@",deviceToken];
    str = [str stringByReplacingOccurrencesOfString:@"<" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@">" withString:@""];
//    [CommonFunction storeValueInDefault:str andKey:DEVICE_ID];
    [FIRMessaging messaging].APNSToken = deviceToken;

    
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max) {
        UIUserNotificationType allNotificationTypes =
        (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    } else {
        // iOS 10 or later
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
        // For iOS 10 display notification (sent via APNS)
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
        UNAuthorizationOptions authOptions =
        UNAuthorizationOptionAlert
        | UNAuthorizationOptionSound
        | UNAuthorizationOptionBadge;
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
        }];
#endif
    }
    
//    [application registerForRemoteNotifications];

}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"received");
//    if (userInfo[kGCMMessageIDKey]) {
//        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
//    }
    
    // Print full message.
    NSLog(@"%@", userInfo);
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"received");
    NSLog(@"%@", userInfo);
//    [CommonFunction storeValueInDefault:[userInfo valueForKey:NOTIFICATION_DOCTOR_ID] andKey:NOTIFICATION_DOCTOR_ID];
//    [CommonFunction storeValueInDefault:[userInfo valueForKey:NOTIFICATION_DOCTOR_ID] andKey:NOTIFICATION_PATIENT_ID];
    if (application.applicationState == UIApplicationStateActive)   {
        [AGPushNoteView showWithNotificationMessage:[[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"body"] ];
        [AGPushNoteView setMessageAction:^(NSString *message) {
            
        }];
    }
    if ([[[[userInfo valueForKey:@"aps"] valueForKey:@"alert"] valueForKey:@"title"] isEqualToString:@"New Patient"]) {
//        [self hitApiForTheQueueCount];
        
    }else if ([[[[userInfo valueForKey:@"aps"] valueForKey:@"alert"] valueForKey:@"title"] isEqualToString:@"Start Chating"]) {
//        [CommonFunction stroeBoolValueForKey:NOTIFICATION_BOOl withBoolValue:true];
    }else if ([[[[userInfo valueForKey:@"aps"] valueForKey:@"alert"] valueForKey:@"title"] isEqualToString:@"End Chat"]){
        
        RatingVC *vc = [[RatingVC alloc]initWithNibName:@"RatingVC" bundle:nil];
        [[self topViewController] presentViewController:vc animated:true completion:nil];
        [CommonFunction stroeBoolValueForKey:NOTIFICATION_BOOl withBoolValue:false];
        [CommonFunction storeValueInDefault:@"0" andKey:NOTIFICATION_DOCTOR_ID];
        [CommonFunction storeValueInDefault:@"0" andKey:NOTIFICATION_PATIENT_ID];
    }
    
}
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
                        queueObj.dependentName = [NSString stringWithFormat:@"%@",[[obj valueForKey:@"dependent"] valueForKey:@"name"]];
                        queueObj.jabberId = [NSString stringWithFormat:@"%@%@",[[[obj valueForKey:@"email"] componentsSeparatedByString:@"@"] objectAtIndex:0],[[[obj valueForKey:@"email"] componentsSeparatedByString:@"@"] objectAtIndex:1]];
                        
                        [[QueueDetails sharedInstance].myDataArray addObject:queueObj];
                    }];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateCountLAbel" object:nil];

                }
                
            }
        }
         ];
    }
}
-(void)refreshToken:(NSNotification *)notification{
    
}
-(void)fbHandler{
    FIRMessaging.messaging.shouldEstablishDirectChannel = true;
    
}
#pragma mark -status Bar
-(void)hideStatusBar{
    UIView *subViewArray = [self.window viewWithTag:100];
    subViewArray.hidden = YES;
}

-(void)showStatusBar{
    UIView *subViewArray = [self.window viewWithTag:100];
    subViewArray.hidden = NO;
}


#pragma mark - clear DATA

-(void)clearData{
    [CommonFunction stroeBoolValueForKey:isAwarenessApiHIt withBoolValue:false];
}
#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"TatabApp"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
        return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TatabApp" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"TatabApp.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}
- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}
#pragma mark- Top ViewController

- (UIViewController *)topViewController{
    return [self topViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}
- (UIViewController *)topViewController:(UIViewController *)rootViewController
{
    if (rootViewController.presentedViewController == nil) {
        return rootViewController;
    }
    
    if ([rootViewController.presentedViewController isMemberOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController.presentedViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        return [self topViewController:lastViewController];
    }
    
    UIViewController *presentedViewController = (UIViewController *)rootViewController.presentedViewController;
    return [self topViewController:presentedViewController];
}


#pragma mark - initializeWindow


- (void)initRootViewController {
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    SplashScreenViewController* vc;
    vc = [[SplashScreenViewController alloc] initWithNibName:@"SplashScreenViewController" bundle:nil];
    _window.rootViewController = vc;
    [self.window makeKeyAndVisible];
}
- (void)switchLanguage {
    [self.window removeFromSuperview];
    [self initRootViewController];
}


@end
