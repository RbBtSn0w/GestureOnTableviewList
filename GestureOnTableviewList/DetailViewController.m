//
//  DetailViewController.m
//  GestureOnTableviewList
//
//  Created by Snow on 1/3/13.
//  Copyright (c) 2013 RbBtSn0w. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController (){
    UIView *_topView;
    UIView *_bottomView;
    UIView *_referenceView;
    float oldX , oldY;
    BOOL dragging;
    CGRect hiddenReferenceFrame;
    CGRect showReferenceFrame;
    BOOL isPush;
}
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UIView *bottomView;

- (void)configureView;
- (void)addGestureRecognizersToView:(UIView*)contentView;
- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)swipeGestureRecognizer;
- (void)handlePanContentView:(UIPanGestureRecognizer *)panGestureRecognizer;


- (void)exchangeViewOnHierarchyForPushState;
- (void)exchangeViewOnHierarchyForPullState;


- (void)pushTopviewToRight:(UIView*)aBottomView withTopView:(UIView*)aTopView;
-(void)pullTopViewToLeft:(UIView*)aBottomView withTopView:(UIView*)aTopView;
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
        _topView = [[UIView alloc] initWithFrame:self.view.bounds];
        _topView.backgroundColor = [UIColor whiteColor];
        _topView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;

        
        _bottomView = [[UIView alloc] initWithFrame:self.view.bounds];
        _bottomView.backgroundColor = [UIColor brownColor];
        _bottomView.autoresizesSubviews = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        
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

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)swipeGestureRecognizer {
   // NSLog(@"should began gesture %@", gestureRecognizer);
    if (swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"Move Left");
        if ([self.pageDelegate respondsToSelector:@selector(swGestureRecognizerWithNextPage:withCurrentIndex:)]) {
            BOOL state = [self.pageDelegate swGestureRecognizerWithNextPage:self withCurrentIndex:currentIndex];
            if (!state) {
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"This page is first page on bottom" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [av show];
                [av release];
            }else{

                [self pullTopViewToLeft:_bottomView withTopView:_topView];
            }
        }
    }
    else if (swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"Move Right");
        if([self.pageDelegate respondsToSelector:@selector(swGestureRecognizerWithPreviousPage:withCurrentIndex:)]){
            BOOL state = [self.pageDelegate swGestureRecognizerWithPreviousPage:self withCurrentIndex:currentIndex];
            if (!state) {
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"This page is first page on top" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [av show];
                [av release];
            }else{
                if (_referenceView == _topView) {
                    [self exchangeViewOnHierarchyForPushState];
                    [self pushTopviewToRight:_topView withTopView:_bottomView];
                }else if(_referenceView == _bottomView){
                    [self exchangeViewOnHierarchyForPushState];
                    [self pushTopviewToRight:_bottomView withTopView:_topView];
                }else{
                    [self pushTopviewToRight:_bottomView withTopView:_topView];
                }
            }
        }
    }
}

- (void)handlePanContentView:(UIPanGestureRecognizer *)panGestureRecognizer{
    
}




- (void)reloadNewDataOnTopView{
    [self.topView addSubview:self.detailDescriptionLabel];
}

- (void)reloadNewDataOnBottomView{
    [self.bottomView addSubview:self.detailDescriptionLabel];    
}
    


#pragma mark    -
#pragma mark        Animation Action
- (void)exchangeViewOnHierarchyForPushState{
    [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    CGRect newMove = _referenceView.frame;
    newMove = showReferenceFrame;
    _referenceView.frame = newMove;
}

- (void)exchangeViewOnHierarchyForPullState{
    [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
}
/**
 *  Top view is on screen
 **/

- (void)pushTopviewToRight:(UIView*)aBottomView withTopView:(UIView*)aTopView{
    
    [UIView beginAnimations:@"ToRight" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];
    CGRect newMove = aTopView.frame;
    newMove = hiddenReferenceFrame;
    aTopView.frame = newMove;
    [UIView setAnimationDidStopSelector:@selector(reloadNewDataOnBottomView)];
    [UIView commitAnimations];
    _referenceView = aTopView;
}

-(void)pullTopViewToLeft:(UIView*)aBottomView withTopView:(UIView*)aTopView{
    
    [UIView beginAnimations:@"ToLeft" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];
    CGRect newMove = aTopView.frame;
    newMove = showReferenceFrame;
    aTopView.frame = newMove;
    [UIView setAnimationDidStopSelector:@selector(reloadNewDataOnTopView)];
    [UIView commitAnimations];
}

@end
