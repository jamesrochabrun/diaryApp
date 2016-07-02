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


@interface THEntrylistViewController ()<NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation THEntrylistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //this performs the fetch request
    //step 4
    [self.fetchedResultsController performFetch:nil];

    self.title = @"My Diary";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;


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
}

//step 8
//delegate method
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

//this performs the animation
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        default:
            break;
    }
}

//if we dont use this method the app will crash when we delete tha last item
- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        default:
            break;
    }
}

#pragma tableView methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  self.fetchedResultsController.sections.count;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, tableView.frame.size.width, 32)];
    [label setFont:[UIFont MediumFont:20]];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

//step 6
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
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

//deleting cell methods
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

//deleting coredata method
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
}

//adding an extra button to the cell
-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *editButton = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Edit" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                        {

                                            
                                            THEntryViewcontroller *destinationController = [[THEntryViewcontroller alloc] init];
                                            destinationController.entry = [self.fetchedResultsController objectAtIndexPath:indexPath];
//                                            [self.navigationController pushViewController:destinationController animated:YES];
                                            NSLog(@" esto es %@",  destinationController.entry);
                                            [self performSegueWithIdentifier:@"edit" sender:self];
                                            
                                    }];
    editButton.backgroundColor = [UIColor mainColor]; //arbitrary color
    UITableViewRowAction *deleteButton = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                     {
                                         [self removeEntryFromCoreData:indexPath];
                                     }];
    deleteButton.backgroundColor = [UIColor alertColor]; //arbitrary color
    
    return @[editButton, deleteButton];
}

- (void)removeEntryFromCoreData:(NSIndexPath*)indexPath {
    THDiaryEntry *entry = [self.fetchedResultsController objectAtIndexPath:indexPath];
    THCoreDataStack *coreDataStack = [THCoreDataStack defaultStack];
    [[coreDataStack managedObjectContext] deleteObject:entry];
    [coreDataStack saveContext];
}


//cant perform action need to find the indexpath  reminder


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    

    if ([segue.identifier isEqual :@"edit"]) {

        UITableViewCell *cell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        UINavigationController *navigationController = segue.destinationViewController;
        THEntryViewcontroller *entryViewController = (THEntryViewcontroller*)navigationController.topViewController;
        entryViewController.entry = [self.fetchedResultsController objectAtIndexPath:indexPath];
        NSLog(@"edit   %@", entryViewController.entry);

        
    } else if ([segue.identifier isEqual :@"show"]) {
        UITableViewCell *cell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        UINavigationController *navigationController = segue.destinationViewController;
        DetailViewController *detailViewController = (DetailViewController*)navigationController.topViewController;
        detailViewController.entry = [self.fetchedResultsController objectAtIndexPath:indexPath];
        NSLog(@"show details %@", detailViewController.entry);
    }
}

























@end
