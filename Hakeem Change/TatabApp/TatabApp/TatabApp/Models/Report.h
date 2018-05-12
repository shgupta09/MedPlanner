//
//  Report.h
//  TatabApp
//
//  Created by shubham gupta on 1/10/18.
//  Copyright © 2018 Shagun Verma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Report : NSObject
@property(nonatomic ,strong) NSString *doctor_id;
@property(nonatomic ,strong) NSString *timing;
@property(nonatomic ,strong) NSString *reading;
@property(nonatomic ,strong) NSString *comment;
@property(nonatomic ,strong) NSString *date;
@property(nonatomic ,strong) NSString *heart_rate;
@property(nonatomic ,strong) NSString *sys;
@property(nonatomic ,strong) NSString *dis;
@property(nonatomic ,strong) NSString *weight;
@property(nonatomic ,strong) NSString *rest_hr;
@property(nonatomic ,strong) NSString *height;
@property(nonatomic ,strong) NSString *temperature;
@end
