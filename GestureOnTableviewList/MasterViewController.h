//
//  MasterViewController.h
//  GestureOnTableviewList
//
//  Created by Snow on 1/3/13.
//  Copyright (c) 2013 RbBtSn0w. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"
@class DetailViewController;

@interface MasterViewController : UITableViewController<SWGestureRecognizerDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;

@end
