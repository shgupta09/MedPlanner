//
//  VideoListObject.h
//  TatabApp
//
//  Created by Shagun Verma on 03/10/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoListObject : NSObject

@property(nonatomic ,strong) NSString *id;
@property(nonatomic ,strong) NSString *post_id;
@property(nonatomic ,strong) NSString *media_type;
@property(nonatomic ,strong) NSString *content;
@property(nonatomic ,strong) NSString *post_by;
@property(nonatomic ,strong) NSString *total_likes;
@property(nonatomic ,strong) NSString *liked_on;
@property(nonatomic ,strong) NSString *url;
@property BOOL is_liked;

@end
