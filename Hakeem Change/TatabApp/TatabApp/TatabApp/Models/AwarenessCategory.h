//
//  AwarenessCategory.h
//  TatabApp
//
//  Created by Shagun Verma on 02/10/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AwarenessCategory : NSObject

@property(nonatomic ,strong) NSString *category_id;
@property(nonatomic ,strong) NSString *category_name;
@property(nonatomic ,strong) NSString *icon_url;
-(NSMutableArray*) myDataArray;
+(AwarenessCategory*) sharedInstance;

@end
