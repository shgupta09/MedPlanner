//
//  Relation.h
//  TatabApp
//
//  Created by shubham gupta on 1/27/18.
//  Copyright © 2018 Shagun Verma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Relation : NSObject
@property(nonatomic ,strong) NSString *idValue;
@property(nonatomic ,strong) NSString *name;
-(NSMutableArray*) myDataArray;
+(Relation*) sharedInstance;
@end
