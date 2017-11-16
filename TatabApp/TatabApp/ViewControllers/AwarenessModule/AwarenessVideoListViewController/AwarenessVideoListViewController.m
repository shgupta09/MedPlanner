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
                
            }
            
            
            
        }];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Network Error" message:@"No Network Access" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
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
    loderObj.lbl_title.text = @"Fetching data...";
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


@end
