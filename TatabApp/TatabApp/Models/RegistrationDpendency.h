//
//  RegistrationDpendency.h
//  TatabApp
//
//  Created by NetprophetsMAC on 9/25/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegistrationDpendency : NSObject
@property(nonatomic ,strong) NSString *name;
@property(nonatomic ,strong) NSString *birthDay;
@property(nonatomic ,strong) NSString *Hospitalname;
@property(nonatomic ,strong) NSString *workedSince;
@property(nonatomic ,strong) NSString *resignedSince;
@property(nonatomic ) BOOL isMale;
@end
