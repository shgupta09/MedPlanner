//
//  WebServicesCall.m
//  Pay Wasel
//
//  Created by Harsh Jaiswal on 04/08/15.
//  Copyright (c) 2015 Aman Thakur. All rights reserved.
//

#import "WebServicesCall.h"
#import "AFNetworking.h"
#import "AppDelegate.h"


@implementation WebServicesCall
+(void)responseWithUrl:(NSString *)url postResponse:(id )parameter postImage:(UIImage *)image requestType:(RequestType)requestType tag:(NSString *)tag isRequiredAuthentication:(BOOL)requiredAuthentication header:(NSString *)usreNamePassword completetion:(void (^)(BOOL, id, NSString *, NSError *, NSInteger,id, BOOL))completion {
    extern BOOL isLogout;
    
    
    
    // timestamp......
    NSTimeInterval timeInMiliseconds = [[NSDate date] timeIntervalSince1970];
    NSString *timeInStr = [NSString stringWithFormat:@"%f",timeInMiliseconds];
    AFHTTPRequestOperationManager * requestManager = [AFHTTPRequestOperationManager manager];
    requestManager.requestSerializer = [AFJSONRequestSerializer serializer];
    requestManager.responseSerializer = [AFJSONResponseSerializer serializer];
    [requestManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [requestManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    requestManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    requestManager.requestSerializer.timeoutInterval = 30;

//    [requestManager.requestSerializer setValue:usreNamePassword forHTTPHeaderField:@"authtoken"];
//    [requestManager.requestSerializer setValue:timeInStr forHTTPHeaderField:@"timestamp"];
        
    if (requiredAuthentication) {
        NSString *token = [CommonFunction getValueFromDefaultWithKey:loginUserToken];
       
        [requestManager.requestSerializer setValue:token forHTTPHeaderField:@"authtoken"];
    }
     NSString *urlString = url;
    switch (requestType) {
        case Get:
        {
            [requestManager GET:urlString parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [operation.response statusCode];
                completion(true,responseObject,tag,nil,operation.response.statusCode,operation,NO);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                //NSLog(operation.responseObject)
                completion(false,nil,tag,error,operation.response.statusCode,operation,NO);
            }];
            break;
        }
        case POST:
        {
            [requestManager POST:urlString  parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
                completion(true,responseObject,tag,nil,operation.response.statusCode,operation,YES);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                completion(false,nil,tag,error,operation.response.statusCode,operation,NO);
            }];
            break;
        }
        case PUT:
        {
            [requestManager PUT:urlString  parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
                completion(true,responseObject,tag,nil,operation.response.statusCode,operation,NO);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                completion(false,nil,tag,nil,operation.response.statusCode,operation,NO);
            }];
            break;
        }
        case Delete:
        {
            [requestManager DELETE:urlString parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
                completion(true,responseObject,tag,nil,operation.response.statusCode,operation,NO);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
        }];
            break;
        }
        case PATCH:
        {
            [requestManager PATCH:urlString parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
                completion(true,responseObject,tag,nil,operation.response.statusCode,operation,NO);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                
            }];
            break;
        }
            
        case POSTIMAGE:
        {
            AFHTTPRequestOperation *op = [requestManager POST:urlString parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.8) name:@"picture" fileName:@"picture.jpg"mimeType:@"image/jpeg"];
            }
                                               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                   NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
                                               }
                                               failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                   NSLog(@"Error: %@ ***** %@", operation.responseString, error);
                                               }];
            
            [op start];
        }
        default:
            break;
    }
}


+(void)responseWithUrl:(NSString *)url postResponse:(NSDictionary *)parameters withImageData:(NSData *)img isImageChanged:(BOOL)isImageChanged requestType:(RequestType)requestType requiredAuthorization:(BOOL)requiredAuthorization ImageKey:(NSString *)key DataArray:(NSArray*)imageDataArray completetion:(void (^)(BOOL status,id responseObj, NSString *tag, NSError *error , NSInteger statusCode))completion{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
    requestManager.requestSerializer = [AFJSONRequestSerializer serializer];
    requestManager.responseSerializer = [AFJSONResponseSerializer serializer];
    [requestManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accepts"];
    [requestManager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    
    if (requiredAuthorization) {
//        NSString *token = [UserDefaultUtility getDeviceToken];
//        //NSLog(@"token %@",token);
//        [requestManager.requestSerializer setValue:[NSString stringWithFormat:@"gatekeeper %@",token] forHTTPHeaderField:@"Authorization"];
    }

    NSString *urlString = url;
    NSString *requestTypeString = (requestType == POST)?@"POST":@"PUT";
    NSMutableURLRequest *request = [requestManager.requestSerializer multipartFormRequestWithMethod:requestTypeString URLString:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
        int i = 0;
        for(NSData *eachImage in imageDataArray)
        {
            [formData appendPartWithFileData:eachImage name:key fileName:[NSString stringWithFormat:@"file%d.jpg",i ] mimeType:@"image/jpeg"];
            i++;
        }
    } error:nil];
    AFHTTPRequestOperation *requestOperation = [requestManager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject){
        completion(true,responseObject,nil,nil,operation.response.statusCode);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(false,nil,nil,error,operation.response.statusCode);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
    
    [requestOperation start];
}


+(void)uploadPhoto:(UIImage*)image completetion:(void (^)(BOOL status,id responseObj, NSString *tag, NSError *error , NSInteger statusCode))completion{
    AFHTTPRequestOperationManager * requestManager = [AFHTTPRequestOperationManager manager];
    requestManager.requestSerializer = [AFJSONRequestSerializer serializer];
    requestManager.responseSerializer = [AFJSONResponseSerializer serializer];
    [requestManager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
//    NSString *token = [[ResourceData alloc] getToken];
//    //NSLog(@"token %@",token);
//    [requestManager.requestSerializer setValue:[NSString stringWithFormat:@"gatekeeper %@",token] forHTTPHeaderField:@"Authorization"];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@""]];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    AFHTTPRequestOperation *op = [manager POST:[NSString stringWithFormat:@"%@picture-upload/",@""] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //do not put image inside parameters dictionary as I did, but append it!
        [formData appendPartWithFileData:imageData name:@"document" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(true,responseObject,nil,nil,operation.response.statusCode);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(false,nil,nil,nil,operation.response.statusCode);
    }];
    [op start];
}




+ (NSString*)encodeStringTo64:(NSString*)fromString
{
    NSData *plainData = [fromString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String;
    if ([plainData respondsToSelector:@selector(base64EncodedStringWithOptions:)]) {
        base64String = [plainData base64EncodedStringWithOptions:kNilOptions];  // iOS 7+
    } else {
        base64String = [plainData base64Encoding];                              // pre iOS7
    }
    
    return base64String;
}
@end
