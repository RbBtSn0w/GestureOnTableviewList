//
//  DetailViewController.m
//  GestureOnTableviewList
//
//  Created by Snow on 1/3/13.
//  Copyright (c) 2013 RbBtSn0w. All rights reserved.
//

#import "DetailViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface DetailViewController (){
    
    UIView *_topView;
    UIView *_bottomView;
    
    UIView *_referenceView;
    
    float oldX , oldY;
    BOOL dragging;
    CGRect hiddenReferenceFrame;
    CGRect showReferenceFrame;
    BOOL isPush;
    
    BOOL isMoveIn;
    BOOL isReveal;
    
}


@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UIView *bottomView;

- (void)configureView;
- (void)addGestureRecognizersToView:(UIView*)contentView;
- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)swipeGestureRecognizer;
//- (void)handlePanContentView:(UIPanGestureRecognizer *)panGestureRecognizer;



-(void)animationWillMoveInView:(UIView*)currentWillHiddenView withWillShowView:(UIView*)nextWillShowView;

-(void)animationWillMoveOutView:(UIView*)currentWillHiddenView withWillShowView:(UIView*)nextWillShowView;

@end

@implementation DetailViewController

@synthesize pageDelegate = _pageDelegate;

@synthesize currentIndex;

@synthesize topView = _topView , bottomView = _bottomView;

- (void)dealloc
{
    [_topView release];
    [_bottomView release];
    [_detailItem release];
    [_detailDescriptionLabel release];
    [_masterPopoverController release];
    [super dealloc];
    
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        [_detailItem release];
        _detailItem = [newDetailItem retain];

        // Update the view.
        [self configureView];
    }
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
    NSLog(@"aTopView center is point X: %f, Y: %f",self.topView.center.x,self.topView.center.y);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)addSubViewOn{
    
    [_topView addSubview:_detailDescriptionLabel];
    
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.topView];

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Detail", @"Detail");
        self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
        showReferenceFrame = self.view.frame;
        hiddenReferenceFrame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            _detailDescriptionLabel.frame = CGRectMake(20, 265, 280, 18);
        }else{
            _detailDescriptionLabel.frame = CGRectMake(20, 493, 728, 18);
        }
        
        if (self.topView == nil) {
            _topView = [[UIView alloc] initWithFrame:self.view.bounds];
            _topView.backgroundColor = [UIColor greenColor];
            _topView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        }
        
        if (self.bottomView == nil) {
            _bottomView = [[UIView alloc] initWithFrame:self.view.bounds];
            _bottomView.backgroundColor = [UIColor brownColor];
            _bottomView.autoresizesSubviews = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        }
        
        
        
        [self addGestureRecognizersToView:self.view];
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [self addSubViewOn];
}

#pragma mark    -
#pragma mark    Split View
-(void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = pc;
}
-(void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem{
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}



#pragma mark    -
#pragma mark    Gesture Recognizer

-(void)addGestureRecognizersToView:(UIView*)contentView{
    //Swipe Gesture For Right
    UISwipeGestureRecognizer *swipeGestureRecognizerDirectionRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [swipeGestureRecognizerDirectionRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [contentView addGestureRecognizer:swipeGestureRecognizerDirectionRight];
    [swipeGestureRecognizerDirectionRight release];
    //Swipe Gesture For Left
    UISwipeGestureRecognizer *swipeGestureRecognizerDirectionLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [swipeGestureRecognizerDirectionLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [contentView addGestureRecognizer:swipeGestureRecognizerDirectionLeft];
    [swipeGestureRecognizerDirectionLeft release];

    //Pan Gesture
//    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanContentView:)];
//    panGestureRecognizer.maximumNumberOfTouches = 1;
//    [contentView addGestureRecognizer:panGestureRecognizer];
//    [panGestureRecognizer release];
    
}


//which one view on top , it's top view;
- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)swipeGestureRecognizer {
   // NSLog(@"should began gesture %@", gestureRecognizer);
    if (swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"Move To Left");
        if ([self.pageDelegate respondsToSelector:@selector(swGestureRecognizerWithNextPage:withCurrentIndex:)]) {
            BOOL state = [self.pageDelegate swGestureRecognizerWithNextPage:self withCurrentIndex:currentIndex];
            if (!state) {
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"This page is first page on bottom" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [av show];
                [av release];
            }else{

                    
                    UIView *aTopView = [[self.view subviews] lastObject];
                    UIView *aBottomView = nil;
                    if(self.view.subviews.count >= 2)
                        aBottomView = [self.view.subviews objectAtIndex:[[self.view subviews] indexOfObject:aTopView]-1];
                    
                    
                    [self animationWillMoveInView:aTopView withWillShowView:aBottomView];

                    
            }
        }
    }
    else if (swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"Move To Right");
        if([self.pageDelegate respondsToSelector:@selector(swGestureRecognizerWithPreviousPage:withCurrentIndex:)]){
            BOOL state = [self.pageDelegate swGestureRecognizerWithPreviousPage:self withCurrentIndex:currentIndex];
            if (!state) {
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"This page is first page on top" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [av show];
                [av release];
            }else{

                    
                    UIView *aTopView = [[self.view subviews] lastObject];
                    UIView *aBottomView = nil;
                    if(self.view.subviews.count >= 2)
                    aBottomView = [self.view.subviews objectAtIndex:[[self.view subviews] indexOfObject:aTopView]-1];
                    
                    
                    [self animationWillMoveOutView:aTopView withWillShowView:aBottomView];
                    
                    return;
               
                }
        }
    }
}






//- (void)reloadNewDataOnUnreferenceView:(id)sender{
//    
//    
//    // remove shadow on layer
//    [[_topView layer] setShadowOpacity:0.0];
//    [[_topView layer] setShadowRadius:0.0];
//    [[_topView layer] setShadowColor:nil];
//    
//    
//    [[_bottomView layer] setShadowOpacity:0.0];
//    [[_bottomView layer] setShadowRadius:0.0];
//    [[_bottomView layer] setShadowColor:nil];
//    
//    
//        
//    
//    NSInteger topLayer = [[self.view subviews] indexOfObject:self.topView];
//    NSInteger bottomLayer = [[self.view subviews] indexOfObject:self.bottomView];
//    [self.view exchangeSubviewAtIndex:topLayer withSubviewAtIndex:bottomLayer];
//    
//    if (_referenceView == self.topView) {
//        [self.bottomView addSubview:self.detailDescriptionLabel];
//    }else if (_referenceView == self.bottomView){
//        [self.topView addSubview:self.detailDescriptionLabel];
//    }
//
//    CGRect newMove1 = self.bottomView.frame;
//    CGRect newMove2 = self.topView.frame;
//    newMove1 = newMove2 = showReferenceFrame;
//    self.bottomView.frame = newMove1;
//    self.bottomView.frame = newMove2;
//    
//}



#pragma mark    -
#pragma mark        Animation Action
//- (void)exchangeViewOnHierarchy{
//    
//    NSInteger topLayer = [[self.view subviews] indexOfObject:self.topView];
//    NSInteger bottomLayer = [[self.view subviews] indexOfObject:self.bottomView];
//    
//    [self.view exchangeSubviewAtIndex:topLayer withSubviewAtIndex:bottomLayer];
//    CGRect newMove = _referenceView.frame;
//    newMove.origin.x = _referenceView.frame.origin.x ? showReferenceFrame.origin.x : hiddenReferenceFrame.origin.x;
//    _referenceView.frame = newMove;
//    
//}
/**
 *  Top view is on screen
 **/
//-(void)animationMoveView:(UIView*)aTopView withBottomView:(UIView*)aBottomView{
//    
//    [UIView beginAnimations:@"AnimationMove" context:nil];
//    [UIView setAnimationDelegate:self];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationDuration:10];
//    if (isMoveIn) {
//        CGRect newMove = aTopView.frame;
//        newMove = showReferenceFrame;
//        aTopView.frame = newMove;
//        _referenceView = aBottomView;
//        isMoveIn = !isMoveIn;
//    }else if (isReveal){
//        CGRect newMove = aTopView.frame;
//        newMove = hiddenReferenceFrame;
//        aTopView.frame = newMove;
//        //_referenceView = aTopView;
//        isReveal = !isReveal;
//    }
//    [UIView setAnimationDidStopSelector:@selector(reloadNewDataOnUnreferenceView:)];
//    [UIView commitAnimations];
//
//}



-(void)animationWillMoveInView:(UIView*)currentWillHiddenView withWillShowView:(UIView*)nextWillShowView{
    
    /*
    [UIView beginAnimations:@"AnimationMoveIn" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:10];
        
    CGRect currentRect = currentWillShowView.frame;
    currentRect = showReferenceFrame;
    currentWillShowView.frame = currentRect;

    //Add shadow
    currentWillShowView.layer.shadowOffset = CGSizeMake(0, 3);
    currentWillShowView.layer.shadowColor = [UIColor blackColor].CGColor;
    currentWillShowView.layer.shadowOpacity = 1;
    currentWillShowView.layer.shadowRadius = 6.0;

    
    [UIView setAnimationDidStopSelector:@selector(reloadNewDataOnUnreferenceView:)];
    [UIView commitAnimations];
    */
    if (nextWillShowView == nil) {
        return;
    }
    
    CGRect startRect = nextWillShowView.frame;
    startRect = hiddenReferenceFrame;
    nextWillShowView.frame = startRect;
    
    
    NSInteger topLayer = [[self.view subviews] indexOfObject:currentWillHiddenView];
    NSInteger bottomLayer = [[self.view subviews] indexOfObject:nextWillShowView];
    [self.view exchangeSubviewAtIndex:topLayer withSubviewAtIndex:bottomLayer];
    
    
    [UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        CGRect currentRect = nextWillShowView.frame;
        currentRect = showReferenceFrame;
        nextWillShowView.frame = currentRect;
        
        //Add shadow
        nextWillShowView.layer.shadowOffset = CGSizeMake(0, 3);
        nextWillShowView.layer.shadowColor = [UIColor blackColor].CGColor;
        nextWillShowView.layer.shadowOpacity = 1;
        nextWillShowView.layer.shadowRadius = 6.0;
        
    } completion:^(BOOL finished) {
        
        // remove shadow on layer
        [[nextWillShowView layer] setShadowOpacity:0.0];
        [[nextWillShowView layer] setShadowRadius:0.0];
        [[nextWillShowView layer] setShadowColor:nil];

        [nextWillShowView addSubview:_detailDescriptionLabel];

    }];
    
    
}

-(void)animationWillMoveOutView:(UIView*)currentWillHiddenView withWillShowView:(UIView*)nextWillShowView{
    
    /*
    [UIView beginAnimations:@"AnimationMoveOut" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:10];
    
    CGRect currentRect = currentWillHiddenView.frame;
    currentRect = hiddenReferenceFrame;
    currentWillHiddenView.frame = currentRect;
    
    //Add shadow
    currentWillHiddenView.layer.shadowOffset = CGSizeMake(0, 3);
    currentWillHiddenView.layer.shadowColor = [UIColor blackColor].CGColor;
    currentWillHiddenView.layer.shadowOpacity = 1;
    currentWillHiddenView.layer.shadowRadius = 6.0;
    
    [UIView setAnimationDidStopSelector:@selector(reloadNewDataOnUnreferenceView:)];
    
    [self.view exchangeSubviewAtIndex:currentWillHiddenView withSubviewAtIndex:nextWillShowView];

    CGRect finishedRect = currentWillHiddenView.frame;
    finishedRect = showReferenceFrame;
    currentWillHiddenView.frame = finishedRect;

    
    [UIView commitAnimations];
     */
    
    if (nextWillShowView == nil) {
        return;
    }
    
    CGRect startRect = currentWillHiddenView.frame;
    startRect = showReferenceFrame;
    currentWillHiddenView.frame = startRect;
    
    
    [UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect currentRect = currentWillHiddenView.frame;
        currentRect = hiddenReferenceFrame;
        currentWillHiddenView.frame = currentRect;
        
        //Add shadow
        currentWillHiddenView.layer.shadowOffset = CGSizeMake(0, 3);
        currentWillHiddenView.layer.shadowColor = [UIColor blackColor].CGColor;
        currentWillHiddenView.layer.shadowOpacity = 1;
        currentWillHiddenView.layer.shadowRadius = 6.0;

    } completion:^(BOOL finished) {
        
        // remove shadow on layer
        [[currentWillHiddenView layer] setShadowOpacity:0.0];
        [[currentWillHiddenView layer] setShadowRadius:0.0];
        [[currentWillHiddenView layer] setShadowColor:nil];
        
        NSInteger topLayer = [[self.view subviews] indexOfObject:currentWillHiddenView];
        NSInteger bottomLayer = [[self.view subviews] indexOfObject:nextWillShowView];
        [self.view exchangeSubviewAtIndex:topLayer withSubviewAtIndex:bottomLayer];
        
        CGRect finishedRect = currentWillHiddenView.frame;
        finishedRect = showReferenceFrame;
        currentWillHiddenView.frame = finishedRect;
        
        
        [nextWillShowView addSubview:_detailDescriptionLabel];
        
    }];
    
}


/*
#pragma mark-
#pragma mark    CATransition 

-(void)animate:(id)sender{
    
    //Set up the animation
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.5;
    //animation.timingFunction = UIViewAnimationCurveEaseOut;
    if (isMoveIn) {
        animation.type = kCATransitionMoveIn;
        animation.subtype = kCATransitionFromLeft;
        isMoveIn = !isMoveIn;
    }else if (isReveal){
        animation.type = kCATransitionReveal;
        animation.subtype = kCATransitionFromRight;
        isReveal = !isReveal;
    }
    
    
    NSInteger aBottomLayer = [[self.view subviews] indexOfObject:self.bottomView];
    NSInteger aTopLayer = [[self.view subviews] indexOfObject:self.topView];
    [self.view exchangeSubviewAtIndex:aBottomLayer withSubviewAtIndex:aTopLayer];
    
    
    [[self.view layer] addAnimation:animation forKey:@"animation"];
}
*/

@end
