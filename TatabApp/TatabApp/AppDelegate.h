//
//  AppDelegate.h
//  TatabApp
//
//  Created by Shagun Verma on 20/09/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,SWRevealViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

