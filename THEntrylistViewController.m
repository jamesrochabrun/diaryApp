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



@interface THEntrylistViewController ()<NSFetchedResultsControllerDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *gridCollectionViewController;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property NSBlockOperation *blockOperation;
@property BOOL shouldReloadCollectionView;
@property UIButton *home;
@property UIButton *favorites;
@property UIButton *addEntry;


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
    [_addEntry addTarget:self action:@selector(addentry) forControlEvents:UIControlEventTouchUpInside];
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

- (void)addentry {
    [self performSegueWithIdentifier:@"add" sender:_addEntry];
}

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
    [self.tableView reloadData];
    [self.gridCollectionViewController reloadData];
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
    [self.tableView reloadData];
    [self.gridCollectionViewController reloadData];
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

    if ([segue.identifier isEqual :@"show"]) {
        
        UITableViewCell *cell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        UINavigationController *navigationController = segue.destinationViewController;
        DetailViewController *detailViewController = (DetailViewController*)navigationController.topViewController;
        detailViewController.entry = [self.fetchedResultsController objectAtIndexPath:indexPath];
        NSLog(@"show details %@", detailViewController.entry);
        
    } else if ([segue.identifier isEqualToString:@"showFromGrid"]) {
        
        UICollectionViewCell *cell = sender;
        NSIndexPath *indexPath = [self.gridCollectionViewController indexPathForCell:cell];
        UINavigationController *navigationController = segue.destinationViewController;
        DetailViewController *detailViewController = (DetailViewController*)navigationController.topViewController;
        detailViewController.entry = [self.fetchedResultsController objectAtIndexPath:indexPath];    }
    });

}

























@end
