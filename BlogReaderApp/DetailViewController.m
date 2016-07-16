//
//  DetailViewController.m
//  secretdiary
//
//  Created by James Rochabrun on 01-07-16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import "DetailViewController.h"
#import "THDiaryEntry.h"
#import "THEntryViewcontroller.h"
#import "ImageViewController.h"
#import "DoubleTapImage.h"
#import "THCoreDataStack.h"

@interface DetailViewController ()<DoubleTapImagedelegate>
@property (weak, nonatomic) IBOutlet UILabel *entryLabel;
@property (weak, nonatomic) IBOutlet UIImageView *moodImage;

@property (weak, nonatomic) IBOutlet UIButton *isFavoriteButton;
@property (weak, nonatomic) IBOutlet DoubleTapImage *doubleTapImage;


@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showEntryData];
}

- (void)viewWillAppear:(BOOL)animated {
    [self showEntryData];
}

- (void)showEntryData {
    self.doubleTapImage.image = [UIImage imageWithData:self.entry.image];
    [self.isFavoriteButton setImage:[UIImage imageNamed:@"favorite"] forState:UIControlStateNormal];
    [self.isFavoriteButton setImage:[UIImage imageNamed:@"favoriteFull"] forState:UIControlStateSelected];
    self.entryLabel.text = self.entry.body;
    
    if(self.entry.mood == DiaryEntryMoodGood) {
        self.moodImage.image = [UIImage imageNamed:@"icn_happy"];
    } else if (self.entry.mood == DiaryEntryMoodAverage) {
        self.moodImage.image = [UIImage imageNamed:@"icn_average"];
    } else if (self.entry.mood == DiaryEntryMoodBad) {
        self.moodImage.image = [UIImage imageNamed:@"icn_bad"];
    }
    
    self.doubleTapImage.delegate = self;
    
    BOOL isFavorite = [self.entry.isFavorite boolValue];
    
    if (isFavorite) {
        [self.isFavoriteButton setSelected:YES];
    } else {
        [self.isFavoriteButton setSelected:NO];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissView:(UIBarButtonItem *)sender {
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

//remeber with buttons the file dont need ibactions just define the segue identifiers to perform the action (pass the data);
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqual :@"image"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        ImageViewController *controller = (ImageViewController*)navigationController.topViewController;
        controller.pickedImage = self.entry.image;
    } else {
        UINavigationController *navigationController = segue.destinationViewController;
        THEntryViewcontroller *entryViewController = (THEntryViewcontroller*)navigationController.topViewController;
        entryViewController.entry = self.entry;
    }
}

- (IBAction)onFavoritebuttonPressed:(UIButton *)sender {
    
    BOOL isFavorite = [self.entry.isFavorite boolValue];
    if (!isFavorite) {
        [sender setSelected:YES];
        [self changingIsFavoriteToTrue];
    } else {
        [sender setSelected:NO];
        [self changingIsFavoriteToFalse];
    }
}

- (void)changingIsFavoriteToTrue {
    
    BOOL myBool = YES;
    self.entry.isFavorite = [NSNumber numberWithBool:myBool];
    
    THCoreDataStack *coreDataStack = [THCoreDataStack defaultStack];
    [coreDataStack saveContext];
    
    UIAlertController *alertSaved = [UIAlertController alertControllerWithTitle:@"Added to favorite moments!" message:@"You can revisit this entry in your favorites section" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertSaved animated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alertSaved dismissViewControllerAnimated:YES completion:nil];
    });
}

- (void)changingIsFavoriteToFalse {
   
    BOOL myBool = NO;
    self.entry.isFavorite = [NSNumber numberWithBool:myBool];
    
    THCoreDataStack *coreDataStack = [THCoreDataStack defaultStack];
    [coreDataStack saveContext];
}


- (void)didImageDoubleTapped {
    
    BOOL isFavorite = [self.entry.isFavorite boolValue];
    if (!isFavorite) {
        [self.isFavoriteButton setSelected:YES];
        [self changingIsFavoriteToTrue];
    } else {
        [self.isFavoriteButton setSelected:NO];
        [self changingIsFavoriteToFalse];
    }
}











@end
