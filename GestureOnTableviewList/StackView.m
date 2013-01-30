//
//  StackView.m
//  GestureOnTableviewList
//
//  Created by Snow on 1/30/13.
//  Copyright (c) 2013 RbBtSn0w. All rights reserved.
//

#import "StackView.h"

@implementation StackView

@synthesize downView = _downView,
middleView = _middleView,
upView = _upView;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/



-(void)dealloc{
    
    [super dealloc];
}

@end
