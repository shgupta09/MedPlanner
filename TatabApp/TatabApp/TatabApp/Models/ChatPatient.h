//
//  ChatPatient.h
//  TatabApp
//
//  Created by Shagun Verma on 27/11/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatPatient : NSObject

@property(nonatomic ,strong) NSString *patient_id;
@property(nonatomic ,strong) NSString *gender;
@property(nonatomic ,strong) NSString *dob;
@property(nonatomic ,strong) NSString *country_code;
@property(nonatomic ,strong) NSString *name;
@property(nonatomic ,strong) NSString *email;
@property(nonatomic ,strong) NSString *jabberId;
@property(nonatomic ,strong) NSMutableArray *dependants;

@end
