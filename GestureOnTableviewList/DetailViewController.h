//
//  DetailViewController.h
//  GestureOnTableviewList
//
//  Created by Snow on 1/3/13.
//  Copyright (c) 2013 RbBtSn0w. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DetailViewControllerPageDelegate;
@interface DetailViewController : UIViewController<UISplitViewControllerDelegate>{
    id<DetailViewControllerPageDelegate> _pageDelegate;
    NSInteger currentIndex;
}

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@property (nonatomic , assign) id<DetailViewControllerPageDelegate> pageDelegate;

@property (nonatomic)   NSInteger currentIndex;

@end



@protocol DetailViewControllerPageDelegate <NSObject>

- (BOOL)detailViewControllerWithNextPage:(DetailViewController*)detailViewController withCurrentIndex:(NSInteger)currentIndex;
- (BOOL)detailViewControllerWithPreviousPage:(DetailViewController*)detailViewController withCurrentIndex:(NSInteger)currentIndex;

@end