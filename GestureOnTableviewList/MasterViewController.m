//
//  MasterViewController.m
//  GestureOnTableviewList
//
//  Created by Snow on 1/3/13.
//  Copyright (c) 2013 RbBtSn0w. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
    NSIndexPath *_synchIndexPathForTablelistCount;
}
@property (strong , nonatomic) NSIndexPath *synchIndexPathForTablelistCount;
@end

@implementation MasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Master", @"Master");
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            self.clearsSelectionOnViewWillAppear = NO;
            self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
        }
    }
    return self;
}

- (void)dealloc
{
    [_detailViewController release];
    [_objects release];
    [_synchIndexPathForTablelistCount release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *addButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)] autorelease];
    self.navigationItem.rightBarButtonItem = addButton;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.synchIndexPathForTablelistCount = [NSIndexPath indexPathForRow:_objects.count inSection:0];
    return _objects.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    
    NSDate *object = _objects[indexPath.row];
    cell.textLabel.text = [object description];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDate *object = _objects[indexPath.row];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        if (!self.detailViewController) {
            self.detailViewController = [[[DetailViewController alloc] initWithNibName:@"DetailViewController_iPhone" bundle:nil] autorelease];
            self.detailViewController.pageDelegate = self;
        }
        self.detailViewController.detailItem = object;
        self.detailViewController.title =  [NSString stringWithFormat:@"%d   Detail",indexPath.row];
        self.detailViewController.currentIndex = indexPath.row;
        [self.navigationController pushViewController:self.detailViewController animated:YES];
    }else{
        self.detailViewController.detailItem = object;
        self.detailViewController.title =  [NSString stringWithFormat:@"%d   Detail",indexPath.row];
        self.detailViewController.currentIndex = indexPath.row;
    }
    
}






#pragma mark    -
#pragma mark    Detail View Page Controller
/**
 *   Reload table view result and find current page to previous page
 **/
-(BOOL)detailViewControllerWithPreviousPage:(DetailViewController *)detailViewController withCurrentIndex:(NSInteger)currentIndex{
    
    NSInteger previousIndex = currentIndex-1;
    NSInteger mixIndex = 0;
    NSInteger maxIndex = _objects.count-1;
    
    if ( mixIndex <= previousIndex && previousIndex <= maxIndex) {
        NSData *object = _objects[previousIndex];
        self.detailViewController.detailItem = object;
        self.detailViewController.title =  [NSString stringWithFormat:@"%d   Detail",previousIndex];
        self.detailViewController.currentIndex = previousIndex;
        return YES;
    }else{
        return NO;
    }
}

/**
 *   Reload table view result and find current page to last page
 **/
-(BOOL)detailViewControllerWithNextPage:(DetailViewController *)detailViewController withCurrentIndex:(NSInteger)currentIndex{
    
    NSInteger lastIndex = currentIndex+1;
    NSInteger mixIndex = 0;
    NSInteger maxIndex = _objects.count-1;

    if (mixIndex<= lastIndex && lastIndex <=maxIndex) {
        NSData *object = _objects[lastIndex];
        self.detailViewController.detailItem = object;
        self.detailViewController.title =  [NSString stringWithFormat:@"%d   Detail",lastIndex];
        self.detailViewController.currentIndex = lastIndex;
        return YES;
    }else{
        return NO;
    }
}


@end
