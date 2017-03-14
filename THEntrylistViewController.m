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
#import "CommonUIConstants.h"
#import "UIImage+UIImage.h"
#import "SectionReusableView.h"
#import "PlaceholderView.h"
#import "Common.h"
#import "TableViewHeaderView.h"
#import "CustomToolBar.h"
#import "UITableView+Additions.h"


@interface THEntrylistViewController ()<NSFetchedResultsControllerDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CustomToolBarDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *gridCollectionViewController;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property NSBlockOperation *blockOperation;
@property BOOL shouldReloadCollectionView;
@property (nonatomic, strong) UIImage *pickedImage;
@property (nonatomic, assign) NSInteger sourceType;
@property (nonatomic, strong) PlaceholderView *placeHolder;
@property (nonatomic, strong) PlaceholderView *placeHolderFavorite;
@property (nonatomic, strong) CustomToolBar *customToolBar;

@end

@implementation THEntrylistViewController

#pragma LifCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //this performs the fetch request
    //step 4
    self.title = @"Momentum";
    [self.fetchedResultsController performFetch:nil];
    
    self.gridCollectionViewController.collectionViewLayout = [[GridCollectionViewFlowLayout alloc] init];
    self.gridCollectionViewController.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[THEntryCell self] forCellReuseIdentifier:@"tableviewCell"];
    self.tableView.delegate = self;
    
    _customToolBar = [CustomToolBar new];
    _customToolBar.del = self;
    [_customToolBar.homebutton setSelected:YES];
    [self.view addSubview:_customToolBar];
    
    _placeHolder = [PlaceholderView new];
    [_placeHolder setContentWithImage:[UIImage imageNamed:@"train"] andTitle:@"No Moments saved, yet" withMessage:@"Start saving your memories, snap every Moment and keep it just for you."];
    [self.view addSubview:_placeHolder];
    
    _placeHolderFavorite = [PlaceholderView new];
    [_placeHolderFavorite setContentWithImage:[UIImage imageNamed:@"favoritePic"] andTitle:@"No favorite Moments, yet" withMessage:@"Select your favorite moments by tapping on the heart button in your pictures."];
    _placeHolderFavorite.hidden = YES;
    [self.view addSubview:_placeHolderFavorite];
}

- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    CGRect frame = _placeHolder.frame;
    frame.size.height = height(self.view) - 50;
    frame.size.width = width(self.view);
    frame.origin.x = 0;
    frame.origin.y = 0;
    _placeHolder.frame = frame;
    _placeHolderFavorite.frame = frame;
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
    
    if ( _customToolBar.favoritesSelected) {
        if (self.fetchedResultsController.sections.count <= 0 ) {
            _placeHolderFavorite.hidden = NO;
        } else {
            _placeHolderFavorite.hidden = YES;
        }
    } else {
        if (self.fetchedResultsController.sections.count <= 0) {
            _placeHolder.hidden = NO;
        } else {
            _placeHolder.hidden = YES;
        }
    }
}

#pragma segmented control navigation

- (IBAction)segmentedControl:(UISegmentedControl *)sender {
    
    if (sender.selectedSegmentIndex == 1) {
        self.tableView.hidden = YES;
    } else {
        self.tableView.hidden = NO;
    }
}

#pragma toolbar navigation

- (void)goToHome {
    
    _placeHolderFavorite.hidden = YES;

    THCoreDataStack *coreDataStack = [THCoreDataStack  defaultStack];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"THDiaryEntry"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:coreDataStack.managedObjectContext sectionNameKeyPath:@"sectionName" cacheName:nil];
    _fetchedResultsController.delegate = self;
    
    [self.fetchedResultsController performFetch:nil];
    
    if (self.fetchedResultsController.sections.count <= 0) {
        _placeHolder.hidden = NO;
    } else {
        _placeHolder.hidden = YES;
    }
    
    __weak THEntrylistViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [weakSelf.tableView reloadData];
        [weakSelf.gridCollectionViewController reloadData];
    });
}

- (void)goToFavorites{
    
    _placeHolder.hidden = YES;

    THCoreDataStack *coreDataStack = [THCoreDataStack  defaultStack];

    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"THDiaryEntry"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isFavorite == %d", YES];
    [fetchRequest setPredicate:predicate];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:coreDataStack.managedObjectContext sectionNameKeyPath:@"sectionName" cacheName:nil];
    _fetchedResultsController.delegate = self;

    [self.fetchedResultsController performFetch:nil];
    
    if (self.fetchedResultsController.sections.count <= 0) {
        _placeHolderFavorite.hidden = NO;
    } else {
        _placeHolderFavorite.hidden = YES;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
    [self.tableView reloadData];
    [self.gridCollectionViewController reloadData];
    });
}

#pragma Coredata Methods

- (void)removeEntryFromCoreData:(NSIndexPath*)indexPath {
    
    THDiaryEntry *entry = [self.fetchedResultsController objectAtIndexPath:indexPath];
    THCoreDataStack *coreDataStack = [THCoreDataStack defaultStack];
    [[coreDataStack managedObjectContext] deleteObject:entry];
    [coreDataStack saveContext];
}

- (NSFetchRequest *)entrylistfetchRequest {
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"THDiaryEntry"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    return  fetchRequest;
}

- (NSFetchedResultsController *)fetchedResultsController {
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    THEntryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableviewCell" forIndexPath:indexPath];
    THDiaryEntry *entry = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell configureCellForEntry:entry];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  self.fetchedResultsController.sections.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    THDiaryEntry *entry = [self.fetchedResultsController objectAtIndexPath:indexPath];
    UIImage *img = [UIImage imageWithData:entry.image];
    //h1/ w1 = h2 / w2
    //h2 = h1 / w1 * w2
    CGFloat width = self.tableView.frame.size.width;
    CGFloat height = img.size.height / img.size.width * width;
    return  height + ((kGeomLabelCellHeight * 2) + (kGeomCellPadding * 2) + kGeomCellPaddingBottom);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.fetchedResultsController.sections.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
   
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    //this is setted in THDiaryEntry+CoreDataProperties.m
    //headerView.title = [sectionInfo name];
    NSString *sectionTitle = sectionInfo.name;
    
    TableViewHeaderView *headerView = [[TableViewHeaderView alloc] initWithSectionTitle:sectionTitle];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kGeomHeaderHeightInSection;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
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
                                              
                                              if (self.fetchedResultsController.sections.count <= 0) {
                                                  
                                                  if (_customToolBar.favoritesSelected) {
                                                      _placeHolderFavorite.hidden = NO;
                                                  } else {
                                                      _placeHolder.hidden = NO;
                                                  }
                                              }
                                          }];
    deleteButton.backgroundColor = [UIColor alertColor]; //arbitrary color
    
    return @[deleteButton];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DetailViewController *detailViewController = [DetailViewController new];
    detailViewController.entry = [self.fetchedResultsController objectAtIndexPath: indexPath];
    //UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    [self.navigationController pushViewController:detailViewController animated:true];
    
}

#pragma collectionview methods

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        SectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
     
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:indexPath.section];
        //this is setted in THDiaryEntry+CoreDataProperties.m
        NSString *sectionName = [sectionInfo name];
        
        headerView.titleLabel.text = sectionName;
 
        reusableview = headerView;
    }
    
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
        
        reusableview = footerview;
    }
    
    return reusableview;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  
    GridCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    THDiaryEntry *entry = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell configureGridCellForEntry:entry];    
    return cell;
}

#pragma segues

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
            filterVC.pickedImage = _pickedImage;
            filterVC.sourceType = _sourceType;
            filterVC.delegate = self;
        }
    });
}

#pragma camera actions

- (void)goToCameraActions {
    
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
    
    CGSize s = image.size;
    _pickedImage = [UIImage imageWithImage:image scaledToSize:CGSizeMake(kGeomUploadWidth, kGeomUploadWidth* s.height/s.width)];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeSavedPhotosAlbum) {
        _sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    } else if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        _sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    } else if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)   {
        _sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    
    __weak THEntrylistViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf dismissViewControllerAnimated:YES completion:^{
            [weakSelf performSegueWithIdentifier:@"filter" sender:weakSelf];
        }];
    });
}

- (void)filterPhotoCancelled:(FilterViewController *)filterVC getNewPhoto:(BOOL)getNewPhoto ofType:(NSInteger)type {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        if (getNewPhoto) {
            if (type == UIImagePickerControllerSourceTypeSavedPhotosAlbum ||
                type == UIImagePickerControllerSourceTypePhotoLibrary) {
                [self promptForPhotoRoll];
            } else {
                [self promptForCamera];
            }
        }
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_tableView fadeTopAndBottomCellsOnTableViewScroll:_tableView withModifier:1.0];
}













@end
