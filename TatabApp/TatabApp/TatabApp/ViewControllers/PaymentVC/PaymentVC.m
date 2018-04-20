    //
//  PaymentVC.m
//  TatabApp
//
//  Created by NetprophetsMAC on 4/6/18.
//  Copyright © 2018 Shagun Verma. All rights reserved.
//

#import "PaymentVC.h"

@interface PaymentVC (){
    CustomAlert *alertObj;
  LoderView *loderObj;
}
@end

@implementation PaymentVC

- (void)viewDidLoad {
    [super viewDidLoad];
//      NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"a" ofType:@"html"];
//        NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
//        [_webView loadHTMLString:htmlString baseURL: [[NSBundle mainBundle] bundleURL]];
//
    [self setUpData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUpData{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_urlString]];
    _lbl_title.text = [Langauge getTextFromTheKey:@"payment"];
    [self.webView setScalesPageToFit:YES];
    [self.webView loadRequest:request];
}

#pragma mark - Webview Delegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
//    [self addLoder];
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
//    [self removeloder];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    [_webView stringByEvaluatingJavaScriptFromString:@"success"];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[Langauge getTextFromTheKey:AlertKey] message:error.description preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    [self presentViewController:alertController animated:YES completion:nil];
    [self removeloder];
}


-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if ([[[inRequest URL] absoluteString] isEqualToString:@"ios:success"]) {
        [_delegateProperty paymentStatusMethod:true doctor:_doctorId];
        [self.navigationController popViewControllerAnimated:true];
    }else if([[[inRequest URL] absoluteString] isEqualToString:@"ios:failure"]){
        [_delegateProperty paymentStatusMethod:false doctor:_doctorId];
        [self.navigationController popViewControllerAnimated:true];
    }
    return true;
}
#pragma mark - add loder

-(void)addLoder{
    self.view.userInteractionEnabled = NO;
    //  loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
    loderObj = [[LoderView alloc] initWithFrame:self.view.frame];
    loderObj.lbl_title.text = @"initialize...";
    [self.view addSubview:loderObj];
}

-(void)removeloder{
    //loderObj = nil;
    [loderObj removeFromSuperview];
    //[loaderView removeFromSuperview];
    self.view.userInteractionEnabled = YES;
}

- (IBAction)btnBackClicked:(id)sender {
   
   
    
      [self addAlertWithTitle:[Langauge getTextFromTheKey:AlertKey] andMessage:[Langauge getTextFromTheKey:@"are_sure_you_want"] isTwoButtonNeeded:true firstbuttonTag:105 secondButtonTag:Tag_For_Remove_Alert firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:[Langauge getTextFromTheKey:Cancel_Btn] image:Warning_Key_For_Image];
}


#pragma mark- Custom Loder
-(void)addAlertWithTitle:(NSString *)titleString andMessage:(NSString *)messageString isTwoButtonNeeded:(BOOL)isTwoBUtoonNeeded firstbuttonTag:(NSInteger)firstButtonTag secondButtonTag:(NSInteger)secondButtonTag firstbuttonTitle:(NSString *)firstButtonTitle secondButtonTitle:(NSString *)secondButtonTitle image:(NSString *)imageName{
    [CommonFunction resignFirstResponderOfAView:self.view];
    alertObj.lbl_title.text = titleString;
    alertObj.lbl_message.text = messageString;
    alertObj.iconImage.image = [UIImage imageNamed:imageName];
    if (isTwoBUtoonNeeded) {
        alertObj.btn1.hidden = true;
        [alertObj.btn2 setTitle:firstButtonTitle forState:UIControlStateNormal];
        [alertObj.btn3 setTitle:secondButtonTitle forState:UIControlStateNormal];
        alertObj.btn2.tag = firstButtonTag;
        alertObj.btn3.tag = secondButtonTag;
        [alertObj.btn2 addTarget:self action:@selector(btnActionForCustomAlert:) forControlEvents:UIControlEventTouchUpInside];
        [alertObj.btn3 addTarget:self action:@selector(btnActionForCustomAlert:) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
        alertObj.btn2.hidden = true;
        alertObj.btn3.hidden = true;
        alertObj.btn1.tag = firstButtonTag;
        [alertObj.btn1 setTitle:firstButtonTitle forState:UIControlStateNormal];
        [alertObj.btn1 addTarget:self
                          action:@selector(btnActionForCustomAlert:) forControlEvents:UIControlEventTouchUpInside];
    }
    alertObj.transform = CGAffineTransformMakeScale(0.01, 0.01);
    if (![alertObj isDescendantOfView:self.view]) {
        [self.view addSubview:alertObj];
    }
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        // animate it to the identity transform (100% scale)
        alertObj.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        // if you want to do something once the animation finishes, put it here
    }];
    
    
}
-(void)removeAlert{
    if ([alertObj isDescendantOfView:self.view]) {
        [alertObj removeFromSuperview];
    }
    
}

-(IBAction)btnActionForCustomAlert:(id)sender{
    switch (((UIButton *)sender).tag) {
        case Tag_For_Remove_Alert:
            [self removeAlert];
            break;
       case 105:
              [self.navigationController popViewControllerAnimated:true];
            break;
            
            break;
        default:
            
            break;
    }
}

@end
