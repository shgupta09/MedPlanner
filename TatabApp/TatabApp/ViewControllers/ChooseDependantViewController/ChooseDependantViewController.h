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
<<<<<<< HEAD
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;
@property bool isManageDependants;
=======
@property bool isManageDependants;

>>>>>>> 8e4d1c6637128185333db4613191062b1fe200c2
@end
