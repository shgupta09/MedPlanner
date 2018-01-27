//
//  ChooseDependantViewController.m
//  TatabApp
//
//  Created by Shagun Verma on 27/01/18.
//  Copyright © 2018 Shagun Verma. All rights reserved.
//

#import "ChooseDependantViewController.h"

@interface ChooseDependantViewController ()
{
    LoderView *loderObj;
    NSMutableArray *doctorListArray;
    NSMutableArray *patientListArray;
}

@property (weak, nonatomic) IBOutlet UITableView *tbl_View;
@end

@implementation ChooseDependantViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidLayoutSubviews{
    loderObj.frame = self.view.frame;
}
-(void)setData{
    doctorListArray = [NSMutableArray new];
    [_tbl_View registerNib:[UINib nibWithNibName:@"SelectUserTableViewCell" bundle:nil]forCellReuseIdentifier:@"SelectUserTableViewCell"];
    _tbl_View.rowHeight = UITableViewAutomaticDimension;
    _tbl_View.estimatedRowHeight = 100;
    _tbl_View.multipleTouchEnabled = NO;
    
    
    [self hitApiForPatientList];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark- tableView delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return patientListArray.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectUserTableViewCell *cell = [_tbl_View dequeueReusableCellWithIdentifier:@"SelectUserTableViewCell"];
    
    if (cell == nil) {
        cell = [[SelectUserTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SelectUserTableViewCell"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    ChatPatient *obj = [patientListArray objectAtIndex:indexPath.row];
    cell.lbl_name.text = [NSString stringWithFormat:@"Mr. %@",obj.name];
    
    //    cell.profileImageView.image = [CommonFunction getImageWithUrlString:obj.photo];
    [cell.profileImageView setImage:[UIImage imageNamed:@"profile.png"]];
    
    cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.size.width/2;
    cell.profileImageView.clipsToBounds = true;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    ChatViewController* vc = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
    //        ChatPatient *obj = [patientListArray objectAtIndex:indexPath.row];
    //        Specialization* temp = [Specialization new];
    //        temp.first_name = obj.name;
    //        temp.doctor_id = [obj.patient_id integerValue];
    //        vc.objDoctor  = temp;
    //
    //        vc.awarenessObj = _awarenessObj;
    //        vc.toId = obj.jabberId;
    //        [self.navigationController pushViewController:vc animated:true];
    
    
}

#pragma mark - btn Actions
- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}


#pragma mark - Api Related
-(void)hitApiForPatientList{
    
    [patientListArray addObject:_patient];
}

-(void)addLoder{
    self.view.userInteractionEnabled = NO;
    //  loaderView = [CommonFunction loaderViewWithTitle:@"Please wait..."];
    loderObj = [[LoderView alloc] initWithFrame:self.view.frame];
    loderObj.lbl_title.text = @"Please wait...";
    [self.view addSubview:loderObj];
}

-(void)removeloder{
    //loderObj = nil;
    [loderObj removeFromSuperview];
    //[loaderView removeFromSuperview];
    self.view.userInteractionEnabled = YES;
}



@end
