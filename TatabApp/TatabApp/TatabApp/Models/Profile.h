//
//  Profile.h
//  TatabApp
//
//  Created by shubham gupta on 5/6/18.
//  Copyright © 2018 Shagun Verma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Profile : NSObject
@property(nonatomic ,strong) NSString *about_me;
@property(nonatomic ,strong) NSString *home_location;
@property(nonatomic ,strong) NSString *name;
@property(nonatomic ,strong) NSString *upload;
@property(nonatomic , strong) NSMutableArray *educationArray;
@property(nonatomic , strong) NSMutableArray *experianceArray;
@end
