//
//  THEntrylistViewController.m
//  BlogReaderApp
//
//  Created by James Rochabrun on 26-05-16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import "THEntrylistViewController.h"
#import "THCoreDataStack.h"
#import "THDiaryEntry.h"
#import "THEntryViewcontroller.h"
#import "THEntryCell.h"
#import "UIColor+CustomColor.h"
#import "UIFont+CustomFont.h"
#import "DetailviewController.h"
#import "GridCollectionViewCell.h"
#import "GridCollectionViewFlowLayout.h"
#import "FilterViewController.h"
#import <UIKit/UIKit.h>



@interface THEntrylistViewController ()<NSFetchedResultsControllerDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *gridCollectionViewController;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property NSBlockOperation *blockOperation;
@property BOOL shouldReloadCollectionView;
@property UIButton *home;
@property UIButton *favorites;
@property UIButton *addEntry;
@property (nonatomic,strong) UIImage*pickedImage;


@end

@implementation THEntrylistViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //this performs the fetch request
    //step 4
    self.title = @"My Diary";
    [self.fetchedResultsController performFetch:nil];
    self.gridCollectionViewController.collectionViewLayout = [[GridCollectionViewFlowLayout alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self createToolbar];
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
}


#pragma show tableview or collectionView
- (IBAction)segmentedControl:(UISegmentedControl *)sender {
    
    if (sender.selectedSegmentIndex == 1) {
        self.tableView.hidden = YES;
    } else {
        self.tableView.hidden = NO;
    }
}

#pragma toolbar
- (void)createToolbar {
    
    CGRect frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - 50, [[UIScreen mainScreen] bounds].size.width, 50);
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:frame];
    [toolbar setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
    [toolbar setBarTintColor:[UIColor whiteColor]];
    [self.view addSubview:toolbar];
    
    _home = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 38, 31)];
    [_home addTarget:self action:@selector(goToHome) forControlEvents:UIControlEventTouchUpInside];
    [_home setBackgroundImage:[UIImage imageNamed:@"home"] forState:UIControlStateNormal];
    [_home setBackgroundImage:[UIImage imageNamed:@"homeSelected"] forState:UIControlStateSelected];
    
    UIBarButtonItem *home = [[UIBarButtonItem alloc] initWithCustomView:_home];
    
    _addEntry = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [_addEntry addTarget:self action:@selector(selectPhoto) forControlEvents:UIControlEventTouchUpInside];
    [_addEntry setBackgroundImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    
    UIBarButtonItem *addEntry = [[UIBarButtonItem alloc] initWithCustomView:_addEntry];

    _favorites = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36,30)];
    [_favorites addTarget:self action:@selector(goToFavorites) forControlEvents:UIControlEventTouchUpInside];
    [_favorites setBackgroundImage:[UIImage imageNamed:@"love"] forState:UIControlStateNormal];
    [_favorites setBackgroundImage:[UIImage imageNamed:@"favoriteSelected"] forState:UIControlStateSelected];
    
    UIBarButtonItem *favorites = [[UIBarButtonItem alloc] initWithCustomView:_favorites];
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    NSArray *buttonItems = [NSArray arrayWithObjects:spacer, home, spacer, addEntry,spacer,  favorites,spacer, nil];
    [toolbar setItems:buttonItems];
    
}

//- (void)addentry {
    
    
  //  dispatch_async(dispatch_get_main_queue(), ^(void){
   // [self performSegueWithIdentifier:@"add" sender:self.addEntry];
    //});
//}

- (void)goToHome {
    
    [_home setSelected:YES];
    [_favorites setSelected:NO];
    [_addEntry setSelected:NO];
    THCoreDataStack *coreDataStack = [THCoreDataStack  defaultStack];

    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"THDiaryEntry"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:coreDataStack.managedObjectContext sectionNameKeyPath:@"sectionName" cacheName:nil];
    _fetchedResultsController.delegate = self;

    [self.fetchedResultsController performFetch:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
    [self.tableView reloadData];
    [self.gridCollectionViewController reloadData];
    });
}

- (void)goToFavorites{
    
    [_favorites setSelected:YES];
    [_home setSelected:NO];
    [_addEntry setSelected:NO];

    THCoreDataStack *coreDataStack = [THCoreDataStack  defaultStack];

    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"THDiaryEntry"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isFavorite == %d", YES];
    [fetchRequest setPredicate:predicate];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:coreDataStack.managedObjectContext sectionNameKeyPath:@"sectionName" cacheName:nil];
    _fetchedResultsController.delegate = self;

    [self.fetchedResultsController performFetch:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
    [self.tableView reloadData];
    [self.gridCollectionViewController reloadData];
    });
}

#pragma Coredata Methods

//step 2
- (NSFetchRequest *)entrylistfetchRequest {
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"THDiaryEntry"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    return  fetchRequest;
}

//step 3
//this is a getter so thats why we replace self for  _
//sectionName is a property in the THDiaryEntry object we can use any name of a property in the thDiaryEntry for create a section
- (NSFetchedResultsController*)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    THCoreDataStack *coreDataStack = [THCoreDataStack  defaultStack];
    NSFetchRequest *fetchRequest = [self entrylistfetchRequest];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:coreDataStack.managedObjectContext sectionNameKeyPath:@"sectionName" cacheName:nil];
    _fetchedResultsController.delegate = self;
    return _fetchedResultsController;
}


//delegate methods
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
    self.shouldReloadCollectionView = NO;
    self.blockOperation = [[NSBlockOperation alloc]init];
}
//
////step 8
////delegate method
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
    
    if (self.shouldReloadCollectionView) {
        [self.gridCollectionViewController reloadData];
    } else {
        [self.gridCollectionViewController performBatchUpdates:^{
            [self.blockOperation start];
        } completion:nil];
    }
}

//this performs the animation

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    __weak UICollectionView *collectionView = self.gridCollectionViewController;
    
    switch (type) {
        case NSFetchedResultsChangeInsert: {
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            if ([collectionView numberOfSections] > 0) {
                if ([collectionView numberOfItemsInSection:indexPath.section] == 0) {
                    self.shouldReloadCollectionView = YES;
                } else {
                    [self.blockOperation addExecutionBlock:^{
                        [collectionView insertItemsAtIndexPaths:@[newIndexPath]];
                    }];
                }
            } else {
                self.shouldReloadCollectionView = YES;
            }
            break;
        }
        case NSFetchedResultsChangeDelete: {
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            if ([collectionView numberOfItemsInSection:indexPath.section] == 1) {
                self.shouldReloadCollectionView = YES;
            } else {
                [self.blockOperation addExecutionBlock:^{
                    [collectionView deleteItemsAtIndexPaths:@[indexPath]];
                }];
            }
            break;
        }
            
        case NSFetchedResultsChangeUpdate: {
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.blockOperation addExecutionBlock:^{
                [collectionView reloadItemsAtIndexPaths:@[indexPath]];
            }];
            break;
        }
        default:
            break;
    }
}

//if we dont use this method the app will crash when we delete tha last item
- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    __weak UICollectionView *collectionView = self.gridCollectionViewController;
    
    switch (type) {
        case NSFetchedResultsChangeInsert: {
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.blockOperation addExecutionBlock:^{
                [collectionView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
            }];
            break;
        }
        case NSFetchedResultsChangeDelete: {
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.blockOperation addExecutionBlock:^{
                [collectionView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
            }];
            break;
        }
        default:
            break;
    }
}


#pragma tableView methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  self.fetchedResultsController.sections.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.fetchedResultsController.sections.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 4, tableView.frame.size.width, 25)];
    [label setFont:[UIFont regularFont:15]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[UIColor newGrayColor]];
    //NSFETCHRESULTCONTROLLER
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    //this is setted in THDiaryEntry+CoreDataProperties.m
    NSString *sectionName = [sectionInfo name];
    ///////////////////////////////////////////
    [label setText:sectionName];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor whiteColor]]; //your background
    return view;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}


//step 6
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}


//step 7
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    THEntryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    THDiaryEntry *entry = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell configureCellForEntry:entry];
    
    return cell;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  
    GridCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    THDiaryEntry *entry = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell configureGridCellForEntry:entry];    
    return cell;
}

//deleting cell methods
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

//deleting coredata method
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
}

//adding an extra button to the cell
-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    UITableViewRowAction *deleteButton = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                     {
                                         [self removeEntryFromCoreData:indexPath];
                                     }];
    deleteButton.backgroundColor = [UIColor alertColor]; //arbitrary color
    
    return @[deleteButton];
}

- (void)removeEntryFromCoreData:(NSIndexPath*)indexPath {
    THDiaryEntry *entry = [self.fetchedResultsController objectAtIndexPath:indexPath];
    THCoreDataStack *coreDataStack = [THCoreDataStack defaultStack];
    [[coreDataStack managedObjectContext] deleteObject:entry];
    [coreDataStack saveContext];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        
        if ([segue.identifier isEqualToString:@"showFromGrid"]) {
            
            NSIndexPath *indexPath = [self.gridCollectionViewController indexPathForCell:sender];
            UINavigationController *navigationController = (UINavigationController*)segue.destinationViewController;
            DetailViewController *detailViewController = (DetailViewController*)navigationController.topViewController;
            THDiaryEntry *entry = [self.fetchedResultsController objectAtIndexPath:indexPath];
            detailViewController.entry = entry;
            
        } else if ([segue.identifier isEqualToString:@"show"]) {
            
            NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
            UINavigationController *navigationController = segue.destinationViewController;
            DetailViewController *detailViewController = (DetailViewController*)navigationController.topViewController;
            detailViewController.entry = [self.fetchedResultsController objectAtIndexPath: indexPath];
  
        } else if ([segue.identifier isEqualToString:@"filter"]) {
            
            UINavigationController *navigationController = segue.destinationViewController;
            FilterViewController *filterVC = (FilterViewController *)navigationController.topViewController;
           _pickedImage = filterVC.pickedImage;
        }
    });
}

#pragma camera actions

- (void)selectPhoto {
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self promptForSource];
    } else{
        [self promptForPhotoRoll];
    }
}

- (void)promptForSource {
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        
        UIAlertController *modalAlert = [UIAlertController alertControllerWithTitle: @"Image Source"
                                                                            message: nil
                                                                     preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *camera = [UIAlertAction actionWithTitle:@"Camera"
                                                         style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                             [self promptForCamera];
                                                         }];
        UIAlertAction *photoRoll = [UIAlertAction actionWithTitle:@"Photo Roll"
                                                            style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                [self promptForPhotoRoll];
                                                            }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                         style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                         }];
        [modalAlert addAction:camera];
        [modalAlert addAction:photoRoll];
        [modalAlert addAction:cancel];
        
        [self presentViewController:modalAlert animated:YES completion:nil];
        
    });
}

- (void)promptForCamera {
    
    UIImagePickerController *controller = [UIImagePickerController new];
    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)promptForPhotoRoll {
    UIImagePickerController *controller = [UIImagePickerController new];
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

//overwriting the setter for pickedImage


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    image =  [self squareImageWithImage:image scaledToSize:CGSizeMake(300, 1)];
    _pickedImage = image;
    
    //go to next VC
    
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self performSegueWithIdentifier:@"filter" sender:self];
    }];
    
}

#pragma fixing orientation of photo and scale
- (UIImage *)squareImageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    double ratio;
    double delta;
    CGPoint offset;
    //make a new square size, that is the resized imaged width
    CGSize sz = CGSizeMake(newSize.width, newSize.width);
    //figure out if the picture is landscape or portrait, then
    //calculate scale factor and offset
    if (image.size.width > image.size.height) {
        ratio = newSize.width / image.size.width;
        delta = (ratio*image.size.width - ratio*image.size.height);
        offset = CGPointMake(delta/2, 0);
    } else {
        ratio = newSize.width / image.size.height;
        delta = (ratio*image.size.height - ratio*image.size.width);
        offset = CGPointMake(0, delta/2);
    }
    //make the final clipping rect based on the calculated values
    CGRect clipRect = CGRectMake(-offset.x, -offset.y,
                                 (ratio * image.size.width) + delta,
                                 (ratio * image.size.height) + delta);
    
    //start a new context, with scale factor 0.0 so retina displays get
    //high quality image
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(sz, YES, 0.0);
    } else {
        UIGraphicsBeginImageContext(sz);
    }
    UIRectClip(clipRect);
    [image drawInRect:clipRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}























@end
