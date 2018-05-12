//
//  AwarenessVideoListViewController.m
//  TatabApp
//
//  Created by Shagun Verma on 03/10/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//

#import "AwarenessVideoListViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import <AVKit/AVKit.h>


@interface AwarenessVideoListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray* arrVideos;
    CustomAlert *alertObj;
}
@property (weak, nonatomic) IBOutlet UILabel *lblSelectedVideoHeading;
@property (weak, nonatomic) IBOutlet UILabel *lblSelectedVideoText;
@property (weak, nonatomic) IBOutlet UIButton *btnLike;
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (weak, nonatomic) IBOutlet UIView *videoPlayerContainerView;
@property (nonatomic, retain) AVPlayerViewController *playerViewController;

@end

@implementation AwarenessVideoListViewController{
    LoderView *loderObj;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    alertObj = [[CustomAlert alloc] initWithFrame:self.view.frame];

    arrVideos = [[NSMutableArray alloc] init];
    _categoryId = 4;
    _playerViewController = [[AVPlayerViewController alloc] init];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    _playerViewController.player = [AVPlayer playerWithURL:[NSURL URLWithString:@"http://dataheadstudio.com/test/upload/videos/ff.mp4"]];
    _playerViewController.view.frame = CGRectMake(0, 64, self.videoPlayerContainerView.bounds.size.width, self.videoPlayerContainerView.bounds.size.height);
    _playerViewController.showsPlaybackControls = YES;
//    [self.view addSubview:_playerViewController.view];
    self.view.autoresizesSubviews = YES;
    _playerViewController.view.bounds = self.videoPlayerContainerView.bounds;
    _playerViewController.view.center = self.videoPlayerContainerView.center;
    [self addChildViewController:_playerViewController];
    [self.view addSubview:_playerViewController.view];
    [_playerViewController didMoveToParentViewController:self];
    

    [_tblView registerNib:[UINib nibWithNibName:@"VideoListTableViewCell" bundle:nil]forCellReuseIdentifier:@"VideoListTableViewCell"];
    _tblView.rowHeight = UITableViewAutomaticDimension;
    _tblView.estimatedRowHeight = 35;
    _tblView.backgroundColor = [UIColor clearColor];//
    
    [self getData];
    
    _lblSelectedVideoHeading.textColor = [CommonFunction colorWithHexString:COLORCODE_FOR_TEXTFIELD];

    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidLayoutSubviews{
    loderObj.frame = self.view.frame;
    alertObj.frame = self.view.frame;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) getData
{
    
    NSMutableDictionary *parameterDict = [[NSMutableDictionary alloc]init];
    [parameterDict setValue:@"4" forKey:@"category_id"];
    [parameterDict setValue:[self getUniqueDeviceIdentifierAsString] forKey:@"device_id"];

    if ([ CommonFunction reachability]) {
        [self addLoder];
        
        //            loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
        [WebServicesCall responseWithUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,@"posts"]  postResponse:parameterDict postImage:nil requestType:POST tag:nil isRequiredAuthentication:NO header:NPHeaderName completetion:^(BOOL status, id responseObj, NSString *tag, NSError * error, NSInteger statusCode, id operation, BOOL deactivated) {
            if (error == nil) {
                
                for (NSDictionary* sub in [responseObj objectForKey:@"posts"]) {
                    
                    VideoListObject* s = [[VideoListObject alloc] init  ];
                    [sub enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
                        [s setValue:obj forKey:(NSString *)key];
                    }];
                    
                    [arrVideos addObject:s];
                }
                
                
                [_tblView reloadData];
                [self removeloder];
                
            }else{
                [self removeloder];
            }
            
            
            
        }];
    } else {
        [self addAlertWithTitle:[Langauge getTextFromTheKey:Error_Key] andMessage:Network_Issue_Message isTwoButtonNeeded:false firstbuttonTag:100 secondButtonTag:0 firstbuttonTitle:[Langauge getTextFromTheKey:OK_Btn] secondButtonTitle:nil image:Error_Key_For_Image];
    }
    
}


#pragma mark- tableView delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (arrVideos.count>0) {
        return arrVideos.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    VideoListTableViewCell *cell = [_tblView dequeueReusableCellWithIdentifier:@"VideoListTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    VideoListObject* videoObject = [arrVideos objectAtIndex:indexPath.row];
//    cell.imgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: videoObject.icon_url]]];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:videoObject.url] placeholderImage:[UIImage imageNamed:@"doctor.png"]];

    cell.lblVideoHeading.text = @"Lorem Ipsum";
    cell.lblVideoContent.text = videoObject.content;
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - add loder

-(void)addLoder{
    self.view.userInteractionEnabled = NO;
    //  loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
    loderObj = [[LoderView alloc] initWithFrame:self.view.frame];
    loderObj.lbl_title.text = [Langauge getTextFromTheKey:@"please_wait"];
    [self.view addSubview:loderObj];
}

-(void)removeloder{
    //loderObj = nil;
    [loderObj removeFromSuperview];
    //[loaderView removeFromSuperview];
    self.view.userInteractionEnabled = YES;
}

- (IBAction)btnBackClicked:(id)sender {

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma -Identify Device ID
-(NSString *)getUniqueDeviceIdentifierAsString{
    UIDevice *device = [UIDevice currentDevice];
    
    NSString  *currentDeviceId = [[device identifierForVendor]UUIDString];
    NSString*CDID=[currentDeviceId substringToIndex: MIN(16, [currentDeviceId length])];
    return CDID;
}

#pragma mark- Custom Loder
-(void)addAlertWithTitle:(NSString *)titleString andMessage:(NSString *)messageString isTwoButtonNeeded:(BOOL)isTwoBUtoonNeeded firstbuttonTag:(NSInteger)firstButtonTag secondButtonTag:(NSInteger)secondButtonTag firstbuttonTitle:(NSString *)firstButtonTitle secondButtonTitle:(NSString *)secondButtonTitle image:(NSString *)imageName{
    [CommonFunction resignFirstResponderOfAView:self.view];
    alertObj.lbl_title.text = titleString;
    alertObj.lbl_message.text = messageString;
    alertObj.iconImage.image = [UIImage imageNamed:imageName];
    if (isTwoBUtoonNeeded) {
        alertObj.btn1.hidden = true;
        alertObj.btn2.hidden = false;
        alertObj.btn3.hidden = false;
        [alertObj.btn2 setTitle:firstButtonTitle forState:UIControlStateNormal];
        [alertObj.btn3 setTitle:secondButtonTitle forState:UIControlStateNormal];
        alertObj.btn2.tag = firstButtonTag;
        alertObj.btn3.tag = secondButtonTag;
        [alertObj.btn2 addTarget:self action:@selector(btnActionForCustomAlert:) forControlEvents:UIControlEventTouchUpInside];
        [alertObj.btn3 addTarget:self action:@selector(btnActionForCustomAlert:) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
         alertObj.btn2.hidden = true;
        alertObj.btn3.hidden = true;
        alertObj.btn1.hidden = false;
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
            
        default:
            
            break;
    }
}


@end
