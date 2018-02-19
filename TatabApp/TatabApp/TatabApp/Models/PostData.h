//
//  PostData.h
//  TatabApp
//
//  Created by shubham gupta on 1/12/18.
//  Copyright © 2018 Shagun Verma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostData : NSObject
@property(nonatomic ,strong) NSString *tags;
@property(nonatomic ,strong) NSString *type;
@property(nonatomic ,strong) NSString *url;
@property(nonatomic ,strong) NSString *content;
@property(nonatomic ,strong) NSString *post_by;
@property(nonatomic ,strong) NSString *total_likes;
@property(nonatomic ,strong) NSString *total_comments;
@property(nonatomic ,strong) NSString *total_shares;
@property(nonatomic ,strong) NSString *liked_on;
@property(nonatomic ,strong) NSString *post_id;
@property(nonatomic ,strong) NSString *is_liked;
@property(nonatomic ,strong) NSString *icon_url;
@property(nonatomic ,strong) NSString *clinicName;
@end
