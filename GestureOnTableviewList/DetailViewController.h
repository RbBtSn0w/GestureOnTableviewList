//
//  DetailViewController.h
//  GestureOnTableviewList
//
//  Created by Snow on 1/3/13.
//  Copyright (c) 2013 RbBtSn0w. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWGestureRecognizerDelegate.h"
#import <QuartzCore/QuartzCore.h>

@interface DetailViewController : UIViewController<UISplitViewControllerDelegate>{
    id<SWGestureRecognizerDelegate> _pageDelegate;
    NSInteger currentIndex;
}

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@property (nonatomic , assign) id<SWGestureRecognizerDelegate> pageDelegate;

@property (nonatomic)   NSInteger currentIndex;

@end
