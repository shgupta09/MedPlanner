//
//  ChatViewController.h
//  TatabApp
//
//  Created by Shagun Verma on 07/11/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface ChatViewController : UIViewController{
    __weak IBOutlet UILabel *lbl_title;
}
@property (strong, nonatomic) NSString *titleStr;



@end
