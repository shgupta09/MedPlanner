//
//  WebServicesCall.h
//  Pay Wasel
//
//  Created by Harsh Jaiswal on 04/08/15.
//  Copyright (c) 2015 Aman Thakur. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum
{
    Get =1,
    POST,
    PUT,
    Delete,
    PATCH,
    POSTIMAGE,
}RequestType;
extern BOOL isLogout;
@interface WebServicesCall : NSObject
+(void)responseWithUrl:(NSString *)url postResponse:(id )parameter postImage:(UIImage *)image requestType:(RequestType)requestType tag:(NSString *)tag isRequiredAuthentication:(BOOL)requiredAuthentication header:(NSString *)usreNamePassword completetion:(void (^)(BOOL, id, NSString *, NSError *, NSInteger,id, BOOL))completion;
+(void)responseWithUrl:(NSString *)url postResponse:(NSDictionary *)parameters withImageData:(NSData *)img isImageChanged:(BOOL)isImageChanged requestType:(RequestType)requestType requiredAuthorization:(BOOL)requiredAuthorization ImageKey:(NSString *)key DataArray:(NSArray*)imageDataArray completetion:(void (^)(BOOL status,id responseObj, NSString *tag, NSError *error , NSInteger statusCode))completion;
+(void)uploadPhoto:(UIImage*)image completetion:(void (^)(BOOL status,id responseObj, NSString *tag, NSError *error , NSInteger statusCode))completion;

@end
