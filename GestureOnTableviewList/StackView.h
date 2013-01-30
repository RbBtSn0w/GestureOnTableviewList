//
//  StackView.h
//  GestureOnTableviewList
//
//  Created by Snow on 1/30/13.
//  Copyright (c) 2013 RbBtSn0w. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StackView : UIView{
    UIView *_downView;
    UIView *_middleView;
    UIView *_upView;
}

@property (nonatomic, retain) UIView *downView;
@property (nonatomic, retain) UIView *middleView;
@property (nonatomic, retain) UIView *upView;


@end
