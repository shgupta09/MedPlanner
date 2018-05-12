//
//  CommonInfoPatient.h
//  TatabApp
//
//  Created by Shagun Verma on 04/01/18.
//  Copyright © 2018 Shagun Verma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonInfoPatient : NSObject

@property(nonatomic ,strong) NSString *identifier;
@property(nonatomic ,strong) NSString *type;
@property(nonatomic ,strong) NSString *details;
@property(nonatomic ,strong) NSString *created_at;

@end
