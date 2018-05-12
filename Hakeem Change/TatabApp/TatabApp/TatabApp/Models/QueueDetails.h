//
//  QueueDetails.h
//  TatabApp
//
//  Created by shubham gupta on 2/10/18.
//  Copyright © 2018 Shagun Verma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QueueDetails : NSObject
@property(nonatomic ,strong) NSString *queue_id;
@property(nonatomic ,strong) NSString *name;
@property(nonatomic ,strong) NSString *email;
@property(nonatomic ,strong) NSString *doctor_id;
@property(nonatomic ,strong) NSString *patient_id;
@property(nonatomic ,strong) NSString *jabberId;
@property(nonatomic ,strong) NSString *dependentID;
@property(nonatomic ,strong) NSString *dependentName;


-(NSMutableArray*) myDataArray;
+(QueueDetails*) sharedInstance;
@end
