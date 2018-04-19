//
//  ChooseDependantViewController.h
//  TatabApp
//
//  Created by Shagun Verma on 27/01/18.
//  Copyright © 2018 Shagun Verma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseDependantViewController : UIViewController

@property (nonatomic,strong) NSString* patientID;
@property (nonatomic,strong) NSString* patientName;
@property (nonatomic,strong) id classObj;
@property (strong, nonatomic) IBOutlet UIView *popUpView;
@property (weak, nonatomic) IBOutlet CustomTextField *txt_Relationship;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;
@property bool isManageDependants;
@property (nonatomic,strong)AwarenessCategory *awarenessObj;
@property (weak, nonatomic) IBOutlet UILabel *lbl_title;
@property (weak, nonatomic) IBOutlet CustomButton *btn_DependentAdd;





@end
