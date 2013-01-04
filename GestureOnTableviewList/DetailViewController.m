//
//  DetailViewController.m
//  GestureOnTableviewList
//
//  Created by Snow on 1/3/13.
//  Copyright (c) 2013 RbBtSn0w. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)gestureRecognizer;
@end

@implementation DetailViewController

@synthesize pageDelegate = _pageDelegate;

- (void)dealloc
{
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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Detail", @"Detail");
        UISwipeGestureRecognizer *gestureRecognizerDirectionRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
        [gestureRecognizerDirectionRight setDirection:UISwipeGestureRecognizerDirectionRight];
        [self.view addGestureRecognizer:gestureRecognizerDirectionRight];
        [gestureRecognizerDirectionRight release];
        
        UISwipeGestureRecognizer *gestureRecognizerDirectionLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
        [gestureRecognizerDirectionLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
        [self.view addGestureRecognizer:gestureRecognizerDirectionLeft];
        [gestureRecognizerDirectionLeft release];

    }
    return self;
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
- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)gestureRecognizer {
   // NSLog(@"should began gesture %@", gestureRecognizer);
    if (gestureRecognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        //[self moveLeftColumnButtonPressed:nil];
        NSLog(@"Move Left");
        if([self.pageDelegate respondsToSelector:@selector(detailViewControllerWithPreviousPage:)]){
            BOOL state = [self.pageDelegate detailViewControllerWithPreviousPage:self];
            if (!state) {
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"The page is first page on top" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [av show];
                [av release];
            }
        }
    }
    else if (gestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        //[self moveRightColumnButtonPressed:nil];
        NSLog(@"Move Right");
        if ([self.pageDelegate respondsToSelector:@selector(detailViewControllerWithNextPage:)]) {
            BOOL state = [self.pageDelegate detailViewControllerWithNextPage:self];
            if (!state) {
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"The page is first page on bottom" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [av show];
                [av release];
            }
        }

    }
}

							
@end
