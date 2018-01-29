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
<<<<<<< HEAD
@property (strong, nonatomic) IBOutlet UIView *popUpView;
@property (weak, nonatomic) IBOutlet CustomTextField *txt_Relationship;
=======
@property bool isManageDependants;
>>>>>>> 434ed7b347d04b6e1df0936f4e73a7a84f48df4a
@end
