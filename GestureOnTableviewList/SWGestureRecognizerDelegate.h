//
//  SWGestureRecognizerDelegate.h
//  GestureOnTableviewList
//
//  Created by Snow on 1/7/13.
//  Copyright (c) 2013 RbBtSn0w. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SWGestureRecognizerDelegate <NSObject>


@optional
- (BOOL)swGestureRecognizerWithNextPage:(id)classObject withCurrentIndex:(NSInteger)currentIndex;
- (BOOL)swGestureRecognizerWithPreviousPage:(id)classObject withCurrentIndex:(NSInteger)currentIndex;

@end
