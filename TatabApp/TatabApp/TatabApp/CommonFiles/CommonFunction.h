//
//  CommonFunction.h
//  ShreeAirlines
//
//  Created by NetprophetsMAC on 3/17/17.
//  Copyright © 2017 Netprophets. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomAlert.h"
@interface CommonFunction : NSObject
+(void)setShadowOpacity:(UIView *)view;
+(void)setCornerRadius:(UIView *)view Radius:(CGFloat)radius;
+(BOOL)isValidPassword:(NSString*)password;
+(UIView *)setStatusBarColor;
+(void)setNavToController:(UIViewController *)viewController title:(NSString *)title isCrossBusston:(BOOL)IsCross;
+(void)storeValueInDefault:(NSString *)valueString andKey:(NSString *)keyString;
+(NSString *)getValueFromDefaultWithKey:(NSString *)keyString;
+(void)stroeBoolValueForKey:(NSString *)keyString withBoolValue:(BOOL)boolValue;
+(BOOL)getBoolValueFromDefaultWithKey:(NSString *)keyString;
+(void) setViewBackground:(UIView*) view withImage:(UIImage*) background;

+(BOOL)validateEmailWithString:(NSString *)email;
+(BOOL)validateMobile:(NSString *)mobile;
+(BOOL)validateMobileWithStartFive:(NSString *)mobile;
+(void)setResignTapGestureToView:(UIView *)view andsender:(id )sender;
+(void)resignFirstResponderOfAView:(UIView *)view;
+(NSString *)trimString:(NSString *)str;

+(UIView *)loaderViewWithTitle:(NSString *)titleStr;
+(BOOL)reachability;
+(BOOL)validateName:(NSString *)name;
+(BOOL)validatePassport:(NSString *)name;
+ (UIColor *)colorWithHexString:(NSString *)hexCode;
+(BOOL)isEnglishSelected;

+(void)storeObjectInDefault:(NSDictionary *)valueDict andKey:(NSString *)keyString;
+(NSDictionary *)getObjectFromDefaultWithKey:(NSString *)keyString;
+(id)checkForNull:(id)tel;
+(BOOL)reachabilityForIPV6;
+(NSString *)timeConverter:(NSString *)timeString;
+(NSNumber *)convertStrToNumber:(NSString *)str;
+(NSString *)ConvertDateTime:(NSString *)dateStr andTime:(NSString *)time;
+(NSDate *)convertStringToDate:(NSString *)dtrDate;
+(NSString *)getThePrice:(NSString *)price;
+(UIImage *)getImageWithUrlString:(NSString*)urlString;
+(UIColor*) getColorFor:(NSString*) type;
+(void)addAnimationToview:(UIView *)viewToAnimate;
+(void)removeAnimationFromView:(UIView *)viewToRemoveAnimation;
+(NSString *)getIDFromClinic:(NSString *)stringNAme;
+(NSString *)setOneMonthOldGate;
+(NSString *)ConvertDateTime:(NSString *)dateStr;
+(NSString *)ConvertDateTime2:(NSString *)dateStr;
+(UIImage*)setImageFor:(NSString*) clinicName;
+(NSArray *)getCityArray;
+(void)addBottomLineIngraph:(UIView *)graph;
@end
