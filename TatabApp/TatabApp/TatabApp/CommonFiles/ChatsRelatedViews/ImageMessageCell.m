//
//  ImageMessageCell.m
//  TatabApp
//
//  Created by Shagun Verma on 21/11/17.
//  Copyright © 2017 Shagun Verma. All rights reserved.
//

#import "ImageMessageCell.h"


@interface ImageMessageCell ()
@property (strong, nonatomic) UILabel *timeLabel;

@property (strong, nonatomic) UIImageView *bubbleImage;
@property (strong, nonatomic) UIImageView *statusIcon;
@end

@implementation ImageMessageCell

-(CGFloat)height
{
    return _bubbleImage.frame.size.height;
}
-(void)updateMessageStatus
{
    [self buildCell];
    //Animate Transition
    _statusIcon.alpha = 0;
    [UIView animateWithDuration:.5 animations:^{
        _statusIcon.alpha = 1;
    }];
}

#pragma mark -

-(id)init
{
    self = [super init];
    if (self)
    {
        [self commonInit];
    }
    return self;
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self commonInit];
    }
    return self;
}
-(void)commonInit
{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryNone;
    
    _imgView = [[UIImageView alloc] init];
    _bubbleImage = [[UIImageView alloc] init];
    _timeLabel = [[UILabel alloc] init];
    _statusIcon = [[UIImageView alloc] init];
    _resendButton = [[UIButton alloc] init];
    _resendButton.hidden = YES;
    
    [self.contentView addSubview:_bubbleImage];
    [self.contentView addSubview:_imgView];
    [self.contentView addSubview:_timeLabel];
    [self.contentView addSubview:_statusIcon];
    [self.contentView addSubview:_resendButton];
}
-(void)prepareForReuse
{
    [super prepareForReuse];
    
    _imgView.image = [UIImage imageNamed:@"BackgroundGeneral"];
    _timeLabel.text = @"";
    _statusIcon.image = nil;
    _bubbleImage.image = nil;
    _resendButton.hidden = YES;
}
-(void)setMessage:(Message *)message
{
    _message = message;
    [self buildCell];
    
    message.heigh = self.height;
}
-(void)buildCell
{
    [self setTextView];
    [self setTimeLabel];
    [self setBubble];
    
    [self addStatusIcon];
    [self setStatusIcon];
    
    [self setFailedButton];
    
    [self setNeedsLayout];
}

#pragma mark - TextView

-(void)setTextView
{
    CGFloat max_witdh = 0.7*self.contentView.frame.size.width;
    _imgView.frame = CGRectMake(0, 0, max_witdh, MAXFLOAT);
    _imgView.backgroundColor = [UIColor clearColor];
    _imgView.userInteractionEnabled = NO;
    
    [_imgView sd_setImageWithURL:[NSURL URLWithString:_message.imgURL]];
    
    CGFloat textView_x;
    CGFloat textView_y;
    CGFloat textView_w = 120;
    CGFloat textView_h = 120;
    UIViewAutoresizing autoresizing;
    
    if (_message.sender == MessageSenderMyself)
    {
        textView_x = self.contentView.frame.size.width - textView_w - 20;
        textView_y = 5;
        autoresizing = UIViewAutoresizingFlexibleLeftMargin;
    }
    else
    {
        textView_x = 20;
        textView_y = 5;
        autoresizing = UIViewAutoresizingFlexibleRightMargin;
    }
    
    _imgView.layer.borderWidth = 1;
    _imgView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _imgView.layer.cornerRadius = 5;
    _imgView.layer.masksToBounds = true;
    
    _imgView.frame = CGRectMake(textView_x, textView_y, textView_w, textView_h);
}

#pragma mark - TimeLabel

-(void)setTimeLabel
{
    _timeLabel.frame = CGRectMake(0, 0, 52, 14);
    _timeLabel.textColor = [UIColor lightGrayColor];
    _timeLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
    _timeLabel.userInteractionEnabled = NO;
    _timeLabel.alpha = 0.7;
    _timeLabel.textAlignment = NSTextAlignmentRight;
    
    //Set Text to Label
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.timeStyle = NSDateFormatterShortStyle;
    df.dateStyle = NSDateFormatterNoStyle;
    df.doesRelativeDateFormatting = YES;
    self.timeLabel.text = [df stringFromDate:_message.date];
    
    //Set position
    CGFloat time_x;
    CGFloat time_y = _imgView.frame.size.height +6;
    
    if (_message.sender == MessageSenderMyself)
    {
        time_x = _imgView.frame.origin.x + _imgView.frame.size.width - _timeLabel.frame.size.width ;
    }
    else
    {
        time_x = MAX(_imgView.frame.origin.x + _imgView.frame.size.width - _timeLabel.frame.size.width,
                     _imgView.frame.origin.x);
    }
    
    _timeLabel.frame = CGRectMake(time_x,
                                  time_y,
                                  _timeLabel.frame.size.width,
                                  _timeLabel.frame.size.height);
    
    _timeLabel.autoresizingMask = _imgView.autoresizingMask;
}

#pragma mark - Bubble

- (void)setBubble
{
    //Margins to Bubble
    CGFloat marginLeft = 5;
    CGFloat marginRight = 2;
    
    //Bubble positions
    CGFloat bubble_x;
    CGFloat bubble_y = 0;
    CGFloat bubble_width;
    CGFloat bubble_height = MIN(_imgView.frame.size.height + 25,
                                _timeLabel.frame.origin.y + _timeLabel.frame.size.height + 30);
    
    if (_message.sender == MessageSenderMyself)
    {
        
        bubble_x = MIN(_imgView.frame.origin.x -marginLeft,_timeLabel.frame.origin.x - 2*marginLeft);
        
        _bubbleImage.image = [[self imageNamed:@"bubbleMine"]
                              stretchableImageWithLeftCapWidth:15 topCapHeight:14];
        
        
        bubble_width = self.contentView.frame.size.width - bubble_x - marginRight + 10;
        bubble_width -= [self isStatusFailedCase]?[self fail_delta]:0.0;
    }
    else
    {
        bubble_x = marginRight;
        
        _bubbleImage.image = [[self imageNamed:@"bubbleSomeone"]
                              stretchableImageWithLeftCapWidth:21 topCapHeight:14];
        
        bubble_width = MAX(_imgView.frame.origin.x + _imgView.frame.size.width + marginLeft,
                           _timeLabel.frame.origin.x + _timeLabel.frame.size.width + 2*marginLeft);
    }
    
    _bubbleImage.frame = CGRectMake(bubble_x, bubble_y, bubble_width, bubble_height);
    _bubbleImage.autoresizingMask = _imgView.autoresizingMask;
}

#pragma mark - StatusIcon

-(void)addStatusIcon
{
    CGRect time_frame = _timeLabel.frame;
    CGRect status_frame = CGRectMake(0, 0,  13, 13);
    status_frame.origin.x = time_frame.origin.x + time_frame.size.width + 5;
    status_frame.origin.y = time_frame.origin.y;
    _statusIcon.frame = status_frame;
    _statusIcon.contentMode = UIViewContentModeLeft;
    _statusIcon.autoresizingMask = _imgView.autoresizingMask;
}
-(void)setStatusIcon
{
    if (self.message.status == MessageStatusSending)
        _statusIcon.image = [self imageNamed:@"status_sending"];
    else if (self.message.status == MessageStatusSent)
        _statusIcon.image = [self imageNamed:@"sent-chat"];
    else if (self.message.status == MessageStateDelivered)
        _statusIcon.image = [self imageNamed:@"delivered-chat"];
    else if (self.message.status == MessageStatusRead)
        _statusIcon.image = [self imageNamed:@"status_read"];
    if (self.message.status == MessageStatusFailed)
        _statusIcon.image = nil;
    
    _statusIcon.hidden = _message.sender == MessageSenderSomeone;
}

#pragma mark - Failed Case

//
// This delta is how much TextView
// and Bubble should shit left
//
-(NSInteger)fail_delta
{
    return 60;
}
-(BOOL)isStatusFailedCase
{
    return self.message.status == MessageStatusFailed;
}
-(void)setFailedButton
{
    NSInteger b_size = 22;
    CGRect frame = CGRectMake(self.contentView.frame.size.width - b_size - [self fail_delta]/2 + 5,
                              (self.contentView.frame.size.height - b_size)/2,
                              b_size,
                              b_size);
    
    _resendButton.frame = frame;
    _resendButton.hidden = ![self isStatusFailedCase];
    [_resendButton setImage:[self imageNamed:@"status_failed"] forState:UIControlStateNormal];
}

#pragma mark - UIImage Helper

-(UIImage *)imageNamed:(NSString *)imageName
{
    return [UIImage imageNamed:imageName
                      inBundle:[NSBundle bundleForClass:[self class]]
 compatibleWithTraitCollection:nil];
}

@end
