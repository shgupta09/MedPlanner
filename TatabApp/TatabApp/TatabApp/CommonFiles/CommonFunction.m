//
//  CommonFunction.m
//  ShreeAirlines
//
//  Created by NetprophetsMAC on 3/17/17.
//  Copyright © 2017 Netprophets. All rights reserved.
//

#import "CommonFunction.h"

@implementation CommonFunction
+(void)addBottomLineIngraph:(UIView *)graph{
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(graph.frame.origin.x+7, graph.bounds.size.height-10, graph.frame.size.width-17, 1)];
    bottomView.backgroundColor = [UIColor lightGrayColor];
    [graph addSubview:bottomView];
    [graph bringSubviewToFront:bottomView];
}

+(UIColor*) getColorFor:(NSString*) type{
    
    if ([type isEqualToString:@"HR"]){
        return [UIColor colorWithRed:19.0/255.0 green:141.0/255.0 blue:117.0/255.0 alpha:1];
    }
    else if ([type isEqualToString:@"DIA"]){
         return [UIColor colorWithRed:247.0/255.0 green:164.0/255.0 blue:30.0/255.0 alpha:1];
    }
    else if ([type isEqualToString:@"SYS"]){
         return [UIColor colorWithRed:208.0/255.0 green:0/255.0 blue:0/255.0 alpha:1];
    }
     return [UIColor greenColor];
}

+(BOOL)isValidPassword:(NSString*)password
{
    //!~`@#$%^&*-+();:={}[],.<>?\\/\"\'
    //NSRegularExpression* regex = [[NSRegularExpression alloc] initWithPattern:@"^.*(?=.{6,})(?=.*[a-z])(?=.*[A-Z]).*$" options:0 error:nil];
//    NSRegularExpression* regex = [[NSRegularExpression alloc] initWithPattern:@"^.*(?=.{6,})(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])" options:0 error:nil];
//
//    return [regex numberOfMatchesInString:password options:0 range:NSMakeRange(0, [password length])] > 0;
    if (password.length>=8 && password.length<=16) {
        return true;
    }
    return false;
}
+(UIView *)setStatusBarColor{
    UIApplication *app = [UIApplication sharedApplication];
    CGFloat statusBarHeight = app.statusBarFrame.size.height;
    
    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, statusBarHeight)];
    statusBarView.backgroundColor  =  [UIColor colorWithRed:146.0/255.0f green:0.0/255.0f blue:17.0/255.0f alpha:1];
    return statusBarView;
}

+(void)setNavToController:(UIViewController *)viewController title:(NSString *)title isCrossBusston:(BOOL)IsCross{
//    title = [title capitalizedString];
    [viewController.view addSubview:[CommonFunction setStatusBarColor]];
    [viewController.navigationController setNavigationBarHidden:YES animated:NO];
    UINavigationBar *newNavBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 44.0)];
    newNavBar.barTintColor = [UIColor colorWithRed:210.0/255.0f green:32.0/255.0f blue:33.0/255.0f alpha:0.0];
    newNavBar.translucent = false;
    UINavigationItem *newItem = [[UINavigationItem alloc] init];
    UIImageView *backgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44.0)];
    backgroundView.image = [UIImage imageNamed:@"Home_ Title bar graphic"];
//    backgroundView.image = [UIImage imageNamed:@"Home_ Title bar graphic"];
//    [newNavBar setBackgroundImage:[UIImage imageNamed:@"Home_ Title bar graphic-1"] forBarMetrics:UIBarMetricsDefault];
//    
//    newNavBar.backgroundColor = [UIColor whiteColor];
    [newNavBar addSubview:backgroundView];
    
    UILabel* lbNavTitle = [[UILabel alloc] initWithFrame:CGRectMake(0,(viewController.view.bounds.size.width/2)
                           -20,[UIScreen mainScreen].bounds.size.width,40)];
    lbNavTitle.textAlignment = UITextAlignmentLeft;
    lbNavTitle.text = title;
    lbNavTitle.textColor = [UIColor colorWithRed:233.0f/255.0f green:141.0f/255.0f blue:25.0f/255.0f alpha:1];
    newItem.titleView = lbNavTitle;
    
    
//    [[UIBarButtonItem alloc] initWithTitle:@"<"
//                                     style:UIBarButtonItemStylePlain
//                                    target:viewController
//                                    action:@selector(backTapped)];
    UIBarButtonItem *dashboard;
    if (IsCross){
     dashboard = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"close"] style:UIBarButtonItemStylePlain target:viewController action:@selector(backTapped)];
    }else{
   dashboard = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:viewController action:@selector(backTapped)];
    }
    
    dashboard.tintColor = [UIColor colorWithRed:233.0f/255.0f green:141.0f/255.0f blue:25.0f/255.0f alpha:1];
    dashboard.tintColor = [UIColor whiteColor];
    newItem.leftBarButtonItem = dashboard;
    [newNavBar setItems:@[newItem]];
    
//    UINavigationController *xyz = [[UINavigationController alloc] initWithRootViewController:<#(nonnull UIViewController *)#>];
//    [xyz ]
//    
//    xyz
    [viewController.view addSubview:newNavBar];
   
}


// For storing the value in default

+(void)storeValueInDefault:(NSString *)valueString andKey:(NSString *)keyString{
    
    [[NSUserDefaults standardUserDefaults]setValue:valueString forKey:keyString];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}

// For reteriving the value in default
+(NSString *)getValueFromDefaultWithKey:(NSString *)keyString{
    
    return [[NSUserDefaults standardUserDefaults]valueForKey:keyString];
    
}


// For storing the Object in default
+(void)storeObjectInDefault:(NSDictionary * )valueDict andKey:(NSString *)keyString{
    [[NSUserDefaults standardUserDefaults]setObject:valueDict forKey:keyString];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}

// For reteriving the object in default
+(NSDictionary *)getObjectFromDefaultWithKey:(NSString *)keyString{
    
    return [[NSUserDefaults standardUserDefaults]objectForKey:keyString];
    
}


// For storing the bool value in default
+(void)stroeBoolValueForKey:(NSString *)keyString withBoolValue:(BOOL)boolValue{
    
    [[NSUserDefaults standardUserDefaults]setBool:boolValue forKey:keyString];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}

// For reteriving the bool value in default
+(BOOL)getBoolValueFromDefaultWithKey:(NSString *)keyString{
    
    return [[NSUserDefaults standardUserDefaults]boolForKey:keyString];
    
}


//for validating the email

+(BOOL)validateEmailWithString:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:[CommonFunction trimString:email]];
}

//For validating mobile

+(BOOL)validateMobile:(NSString *)mobile{
    if (mobile.length == 0){
        return false;
    }
    NSString *emailRegex = @"[0-9]{8,18}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isValidMobile = [emailTest evaluateWithObject:mobile];
    NSString *firstCharacter = [mobile substringToIndex:1];
    if (isValidMobile != true){
        return false;
    }
    return true;
}

+(BOOL)validateMobileWithStartFive:(NSString *)mobile{
    if (mobile.length == 0){
        return false;
    }
    NSString *emailRegex = @"[0-9]{9,9}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isValidMobile = [emailTest evaluateWithObject:mobile];
    NSString *firstCharacter = [mobile substringToIndex:1];
    if (![firstCharacter isEqualToString:@"5"]) {
        return false;
    }
    if (isValidMobile != true){
        return false;
    }
    return true;
}
+(BOOL)validateName:(NSString *)name{
    
    
//    NSString *nameExpression = @"[a-zA-Z. ]{2,18}";
//    NSPredicate *regex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nameExpression];
////    return true;
//    return [regex evaluateWithObject:[self trimString:name]];
    
    if (name.length>2 && name.length<19){
        return true;
    }else{
        return false;
    }
    return true;
   }
+(BOOL)validatePassport:(NSString *)name{
    
    
    NSString *nameExpression = @"[a-zA-Z0-9]{8,18}";
    NSPredicate *regex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nameExpression];
    //    return true;
    return [regex evaluateWithObject:[self trimString:name]];
}


// set the User Interface
+(void)setResignTapGestureToView:(UIView *)view andsender:(id )sender{
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:sender action:@selector(resignResponder)];
    
    [view addGestureRecognizer:singleTap];
}

//For hiding the keyboard
+(void)resignFirstResponderOfAView:(UIView *)view{
    [view endEditing:YES];
}

+(NSString *)trimString:(NSString *)str{

    NSString *trimmedString = [str stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceCharacterSet]];
    return trimmedString;
}


+(UIView *)loaderViewWithTitle:(NSString *)titleStr{
    UIView *loaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [loaderView setBackgroundColor:[UIColor blackColor]];
    loaderView.alpha = .9;
    
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc]
                                             initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    activityView.center=CGPointMake([UIScreen mainScreen].bounds.size.width/2,( [UIScreen mainScreen].bounds.size.height-64)/2);
    [activityView startAnimating];
    [loaderView addSubview:activityView];
    UILabel *lblForTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, activityView.center.y+30, [UIScreen mainScreen].bounds.size.width-40, 30)];
    lblForTitle.textColor = [UIColor whiteColor];
    lblForTitle.font = [UIFont fontWithName:@"RobotoSlab-Bold" size:17];
    lblForTitle.textAlignment = NSTextAlignmentCenter;
    lblForTitle.text = titleStr;
    [loaderView addSubview:lblForTitle];
    return loaderView;
    
}

+(BOOL)isEnglishSelected{
    if ([[CommonFunction getValueFromDefaultWithKey:Selected_Language] isEqualToString:Selected_Language_English]) {
        return true;
    }
    return false;
}
+(BOOL)reachability
{
    Reachability  *internetReachable = [Reachability reachabilityForInternetConnection:true];
    
    // Internet is reachable
    if([internetReachable currentReachabilityStatus])
    {
        return YES;
    }
    else
    {
        return NO;
    }
    return NO;
}
+(BOOL)reachabilityForIPV6
{
    Reachability  *internetReachable = [Reachability reachabilityForInternetConnection:false];
    
    // Internet is reachable
    if([internetReachable currentReachabilityStatus])
    {
        return YES;
    }
    else
    {
        return NO;
    }
    return NO;
}



+ (UIColor *)colorWithHexString:(NSString *)hexCode {
    NSString *noHashString = [hexCode stringByReplacingOccurrencesOfString:@"#" withString:@""];
    NSScanner *scanner = [NSScanner scannerWithString:noHashString];
    [scanner setCharactersToBeSkipped:[NSCharacterSet symbolCharacterSet]]; // remove + and $
    
    unsigned hex;
    if (![scanner scanHexInt:&hex]) return nil;
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:1.0f];
}

+(id)checkForNull:(id)tel{
    if(tel==(id) [NSNull null] || [tel length]==0 || [tel isEqualToString:@""])
    {
        return @"";
    }
    else
    {
        return tel;
        
    }
    
}

+(NSString *)ConvertDateTime:(NSString *)dateStr andTime:(NSString *)time{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MMM-YYYY"];
    NSDate *dateTemp = [formatter dateFromString:dateStr];
    [formatter setDateFormat:@"MMM, dd YYYY"];
    NSString *newDate = [formatter stringFromDate:dateTemp];
    
    
   
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    
    
    dateFormatter1.dateFormat = @"HH:mm";
    NSDate *date = [dateFormatter1 dateFromString:time];
    dateFormatter1.dateFormat = @"hh:mm:ss a";
    NSString *timeStr = [dateFormatter1 stringFromDate:date];
    NSString *temp = [NSString stringWithFormat:@"%@ %@",newDate,timeStr];
    return temp;
}
+(NSString *)timeConverter:(NSString *)timeString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"HH:mm";
    NSDate *date = [dateFormatter dateFromString:timeString];
    dateFormatter.dateFormat = @"hh:mm a";
    NSString *pmamDateString = [dateFormatter stringFromDate:date];
    return pmamDateString;
}

+(NSNumber *)convertStrToNumber:(NSString *)str{
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *myNumber = [f numberFromString:str];
    return myNumber;
}
+(NSString *)ConvertDateTime:(NSString *)dateStr{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
 
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *newDate = [formatter dateFromString:dateStr];
    [formatter setDateFormat:@"dd/MM/YYYY"];
    return [formatter stringFromDate:newDate];
}
+(NSString *)ConvertDateTime2:(NSString *)dateStr{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *newDate = [formatter dateFromString:dateStr];
    [formatter setDateFormat:@"dd/MM/YYYY"];
    return [formatter stringFromDate:newDate];
}

+(NSDate *)convertStringToDate:(NSString *)dtrDate{
    
    
    NSString* substring = @"Dec 5 2012 12:08 PM";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setDateFormat:@"MMM d yyyy h:mm a"]; // not 'p' but 'a'
    NSDate *dateFromString = [dateFormatter dateFromString:substring];
    return dateFromString;
}

+(NSString *)getThePrice:(NSString *)price{
    NSLog(@"%@",price);
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *myNumber = [f numberFromString:price];
    NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle]; // Here you can choose the style
    
    NSString *formatted = [numberFormatter stringFromNumber:myNumber];
    NSLog(@"%@",formatted);
    return formatted;
}





+(void) setViewBackground:(UIView*) view withImage:(UIImage*) background {
    UIGraphicsBeginImageContext(view.frame.size);
    [background drawInRect:view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    view.backgroundColor = [UIColor colorWithPatternImage:image];
    
}

+(UIImage *)getImageWithUrlString:(NSString*)urlString{
    UIImage *img =  [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]]];
    return img;
}
+(void)addAnimationToview:(UIView *)viewToAnimate{
    viewToAnimate.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        // animate it to the identity transform (100% scale)
        viewToAnimate.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        // if you want to do something once the animation finishes, put it here
    }];
}
+(void)removeAnimationFromView:(UIView *)viewToRemoveAnimation{
    /*[UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        // animate it to the identity transform (100% scale)
        viewToRemoveAnimation.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished){
        [viewToRemoveAnimation removeFromSuperview];
            }];*/
    [viewToRemoveAnimation removeFromSuperview];

}

+(NSString *)getIDFromClinic:(NSString *)stringNAme{
    
    if ([stringNAme isEqualToString:@"Abdominal Clinic"]) {
        return @"1";
    }
    else if ([stringNAme isEqualToString:@"Psychological Clinic"]) {
        return @"2";
    }
    else if ([stringNAme isEqualToString:@"Family and Community Clinic"]) {
        return @"3";
    }
    else if ([stringNAme isEqualToString:@"Obgyne Clinic"]) {
        return @"4";
    }
    else if ([stringNAme isEqualToString:@"Pediatrics Clinic"]) {
        return @"5";
    }
    return @"";
}

+(NSString *)setOneMonthOldGate{
    NSDate *today = [[NSDate alloc] init];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setMonth:-1]; // note that I'm setting it to -1
    NSDate *endOfWorldWar3 = [gregorian dateByAddingComponents:offsetComponents toDate:today options:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    return [dateFormatter stringFromDate:endOfWorldWar3];
}
+(UIImage*)setImageFor:(NSString*) clinicName{
    
    if ([clinicName isEqualToString:@"Abdominal Clinic"]) {
        return [UIImage imageNamed:@"sec-abdomen-1"];
    }
    else if ([clinicName isEqualToString:@"Psychological Clinic"]) {
        return [UIImage imageNamed:@"sec-psy-1"];
    }
    else if ([clinicName isEqualToString:@"Family and Community Clinic"]) {
        return [UIImage imageNamed:@"sec-family-1"];
    }
    else if ([clinicName isEqualToString:@"Obgyne Clinic"]) {
        return [UIImage imageNamed:@"sec-obgyen-1"];
    }
    else if ([clinicName isEqualToString:@"Pediatrics Clinic"]) {
        return [UIImage imageNamed:@"section-children"];
    }
    
    return [UIImage imageNamed:@""];
}
+(NSArray *)getCityArray{
    NSError *error = nil;

    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"cities-en"
                                                         ofType:@"json"];
    NSData *dataFromFile = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:dataFromFile
                                                         options:kNilOptions
                                                           error:&error];
    if (error != nil) {
        NSLog(@"Error: was not able to load messages.");
        return nil;
    }else{
        return [data valueForKey:@"Cities"];
    }

}
+(void)setShadowOpacity:(UIView *)view{
    view.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    view.layer.shadowOffset = CGSizeMake( 0, 0);
    view.layer.shadowOpacity = 0.4;
    view.layer.shadowRadius = 4.0;
}
+(void)setCornerRadius:(UIView *)view Radius:(CGFloat)radius{
    view.layer.cornerRadius = radius;
}

@end
