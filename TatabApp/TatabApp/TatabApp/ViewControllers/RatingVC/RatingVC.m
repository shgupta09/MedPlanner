//
//  RatingVC.m
//  TatabApp
//
//  Created by NetprophetsMAC on 2/22/18.
//  Copyright © 2018 Shagun Verma. All rights reserved.
//

#import "RatingVC.h"

@interface RatingVC (){
    BOOL isQueueRated;
    BOOL isServiceRated;
    CustomAlert *alertObj;
}
@end

@implementation RatingVC


-(void)viewDidLayoutSubviews{
    alertObj.frame = self.view.frame;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    alertObj = [[CustomAlert alloc] initWithFrame:self.view.frame];

    isQueueRated = false;
    isServiceRated = false;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnActionRating:(id)sender {
    if (((UIButton *)sender).tag/100==1) {
        isServiceRated = true;
    }else if  (((UIButton *)sender).tag/100==2){
        isQueueRated = true;
    }
    
}

- (IBAction)subMitBtnAction:(id)sender {
    
    if (!isServiceRated) {
          [self addAlertWithTitle:AlertKey andMessage:@"Please Provide Rating for our service." isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:OK_Btn secondButtonTitle:nil image:Warning_Key_For_Image];
    }else if (!isQueueRated){
        [self addAlertWithTitle:AlertKey andMessage:@"Please Provide Rating for wait in queue." isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:OK_Btn secondButtonTitle:nil image:Warning_Key_For_Image];
    }else{
        [self dismissViewControllerAnimated:true completion:nil];
        RearViewController *rearViewController = [[RearViewController alloc]initWithNibName:@"RearViewController" bundle:nil];
        SWRevealViewController *mainRevealController;
        NewAwareVC *frontViewController = [[NewAwareVC alloc]initWithNibName:@"NewAwareVC" bundle:nil];
        mainRevealController = [[SWRevealViewController alloc]initWithRearViewController:rearViewController frontViewController:frontViewController];
        
        mainRevealController.delegate = self;
        mainRevealController.view.backgroundColor = [UIColor blackColor];
        //            [frontViewController.view addSubview:[CommonFunction setStatusBarColor]];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:mainRevealController];
        ((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.rootViewController = nav;
    }
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
        case 101:{
            [self removeAlert];
        }
        default:
            
            break;
    }
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
