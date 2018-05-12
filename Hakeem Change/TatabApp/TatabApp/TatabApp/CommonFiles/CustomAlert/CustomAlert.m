//
//  CustomAlert.m
//  TatabApp
//
//  Created by shubham gupta on 10/17/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//

#import "CustomAlert.h"

@implementation CustomAlert

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"CustomAlert" owner:self options:nil] objectAtIndex:0];
        view.frame = frame;
        view.userInteractionEnabled = true;
        _roundView.layer.cornerRadius = _roundView.frame.size.height/2;
        _roundView.clipsToBounds = true;
        _iconImage.layer.cornerRadius = _iconImage.frame.size.height/2;
        _iconImage.clipsToBounds = true;
        [self addSubview:view];
        return self;
    }
    
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
     
        

    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
//    if (_isTwoButtonNeeded) {
//        _btn2.titleLabel.text = _titleOne;
//        _btn3.titleLabel.text = _titletwo;
//        _btn1.hidden = true;
//    }else{
//        _btn1.titleLabel.text = _titleOne;
//        _btn3.hidden = true;
//        _btn2.hidden = true;
//    }

}

@end
