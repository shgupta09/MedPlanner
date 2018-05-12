//
//  SMMessageViewTableCell.m
//  JabberClient
//
//  Created by cesarerocchi on 9/8/11.
//  Copyright 2011 studiomagnolia.com. All rights reserved.
//

#import "SMMessageViewTableCell.h"

@interface SMMessageViewTableCell(){

        __unsafe_unretained UILabel	*senderAndTimeLabel;
        __unsafe_unretained UITextView *messageContentView;
        __unsafe_unretained UIImageView *bgImageView;
        
    }

@end


@implementation SMMessageViewTableCell

@synthesize senderAndTimeLabel, messageContentView, bgImageView;



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

		senderAndTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 20)];
		senderAndTimeLabel.textAlignment = UITextAlignmentCenter;
		senderAndTimeLabel.font = [UIFont systemFontOfSize:11.0];
		senderAndTimeLabel.textColor = [UIColor lightGrayColor];
		[self.contentView addSubview:senderAndTimeLabel];
		
		bgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
		[self.contentView addSubview:bgImageView];
		
		messageContentView = [[UITextView alloc] init];
		messageContentView.backgroundColor = [UIColor clearColor];
		messageContentView.editable = NO;
		messageContentView.scrollEnabled = NO;
		[messageContentView sizeToFit];
		[self.contentView addSubview:messageContentView];

    }
	
    return self;
	
}








@end
