//
//  PaymentVC.h
//  TatabApp
//
//  Created by NetprophetsMAC on 4/6/18.
//  Copyright © 2018 Shagun Verma. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PaymentDelegate <NSObject>
@optional
- (void)paymentStatusMethod:(BOOL)status doctor:(NSString*)doctorID;
// ... other methods here
@end
@interface PaymentVC : UIViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property(nonatomic,strong) NSString *urlString;
@property(nonatomic,strong) NSString *doctorId;
@property (nonatomic, weak) id <PaymentDelegate> delegateProperty;
@property (weak, nonatomic) IBOutlet UILabel *lbl_title;

@end
