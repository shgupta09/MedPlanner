//
//  RegisterCompleteViewController.h
//  TatabApp
//
//  Created by Shagun Verma on 23/09/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterCompleteViewController : UIViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource>
@property(nonatomic,strong)NSMutableDictionary *parameterDict;
@end
