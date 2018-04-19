//
//  ChatViewController.h
//  TatabApp
//
//  Created by Shagun Verma on 07/11/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface ChatViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UITextViewDelegate>{
    __weak IBOutlet UILabel *lbl_title;
}
@property (weak, nonatomic) IBOutlet UILabel *lbl_queueCount;
@property (weak, nonatomic) IBOutlet UIButton *btn_queue;
@property (weak, nonatomic) IBOutlet UIButton *btn_EndChat;
@property (weak, nonatomic) IBOutlet UIView *viewToClip;
@property (weak, nonatomic) IBOutlet UISwitch *mySwitch;
@property (strong, nonatomic) Specialization *objDoctor;
@property (nonatomic,strong)AwarenessCategory *awarenessObj;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (retain, nonatomic) XMPPIncomingFileTransfer *xmppIncomingFileTransfer;
@property (weak, nonatomic) IBOutlet UIButton *addOptionBtnAction;
@property (weak, nonatomic) IBOutlet UIView *viewShowStatus;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Name;

//PatientView
@property (weak, nonatomic) IBOutlet UIImageView *imgView_patient_BackGround;
@property (weak, nonatomic) IBOutlet UIImageView *imgView_PatientDoctor;
@property (weak, nonatomic) IBOutlet UIView *viewPatient;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (strong, nonatomic) NSString* queue_id ;

@property (strong, nonatomic) NSString* toId ;


@property (weak, nonatomic) IBOutlet UILabel *lbl_Patient_DoctorName;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Patient_Clinic;
//Doctor's View

@property (weak, nonatomic) IBOutlet UIView *viewDoctor;
@property (weak, nonatomic) IBOutlet UIButton *btn_FollowUp;
@property (nonatomic) BOOL isDependent;



//Language
@property (weak, nonatomic) IBOutlet UILabel *lbl_patient;
@property (weak, nonatomic) IBOutlet UILabel *lbl_prescription;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Diagnoses;

@property (weak, nonatomic) IBOutlet UILabel *lbl_Dr;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Clinic;

@property (weak, nonatomic) IBOutlet UILabel *lbl_FollowUP;

@end
