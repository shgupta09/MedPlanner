//
//  Langauge.m
//  TatabApp
//
//  Created by NetprophetsMAC on 4/18/18.
//  Copyright © 2018 Shagun Verma. All rights reserved.
//

#import "Langauge.h"

@implementation Langauge

+(NSString *)getTextFromTheKey:(NSString *)keyStr{
    
    NSString  *seLanguage = [CommonFunction getValueFromDefaultWithKey:Selected_Language];
    NSMutableString *path ;
    if ([seLanguage isEqualToString:Selected_Language_English]) {
        path = [[[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"] mutableCopy];
        [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"en", nil] forKey:@"AppleLanguages"];

    }else if ([seLanguage isEqualToString:Selected_Language_Arebic]) {
        path = [[[NSBundle mainBundle] pathForResource:@"ar" ofType:@"lproj"] mutableCopy];
        [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"ar", nil] forKey:@"AppleLanguages"];

    }
    NSBundle *bundle = [NSBundle bundleWithPath:path];
    
    
    
   NSString *str = [bundle localizedStringForKey:keyStr   value:@"" table:nil];

    return str;
}

@end
