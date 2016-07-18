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
#import "UIFont+CustomFont.h"
#import "UIColor+CustomColor.h"

@interface DetailViewController ()<DoubleTapImagedelegate>
@property UIButton *isFavoriteButton;
@property UIView *contentView;
@property UIImageView *mainImageView;
@property UIImageView *moodImageView;
@property UIButton *zoomButton;
@property UILabel *entryLabel;




@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.entry == nil) {
        NSLog(@"%@", self.entry);
    }
    [self displayContentInViewController];
    
}

- (void)displayContentInViewController {
    
    int mainViewWidth = self.view.frame.size.width;
    int mainViewHeight = self.view.frame.size.height;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, mainViewWidth, mainViewHeight)];
    [self.view addSubview:scrollView];
    [scrollView setContentSize:CGSizeMake(mainViewWidth, mainViewHeight *1.1)];
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainViewWidth, mainViewHeight*1.1)];
    [scrollView addSubview:self.contentView];
    
    self.mainImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, mainViewWidth, mainViewHeight*0.5)];
    self.mainImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.mainImageView];
    
    self.moodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 50, 50)];
    [self.mainImageView addSubview:self.moodImageView];
    
    self.isFavoriteButton = [[UIButton alloc]initWithFrame:CGRectMake(self.mainImageView.frame.size.width - 115,self.mainImageView.frame.size.height*0.95, 50, 50)];
    [self.isFavoriteButton setImage:[UIImage imageNamed:@"favorite"] forState:UIControlStateNormal];
    [self.isFavoriteButton setImage:[UIImage imageNamed:@"favoriteFull"] forState:UIControlStateSelected];
    [self.isFavoriteButton addTarget:self action:@selector(onFavoriteButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.isFavoriteButton];
    
    BOOL isFavorite = [self.entry.isFavorite boolValue];
    
    if (isFavorite) {
        [self.isFavoriteButton setSelected:YES];
    } else {
        [self.isFavoriteButton setSelected:NO];
    }
    
    self.zoomButton = [[UIButton alloc] initWithFrame:CGRectMake(self.mainImageView.frame.size.width - 60, self.mainImageView.frame.size.height *0.95, 50, 50)];
    [self.zoomButton setImage:[UIImage imageNamed:@"zoom"] forState:UIControlStateNormal];
    [self.zoomButton addTarget:self action:@selector(onZoomButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.zoomButton];
    
    self.entryLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, mainViewWidth*0.8, 200)];
    [self.entryLabel setFont:[UIFont regularFont:17]];
    [self.entryLabel setCenter:CGPointMake(mainViewWidth /2, self.mainImageView.frame.size.height + 105)];
    [self.entryLabel setTextColor:[UIColor newGrayColor]];
    self.entryLabel.numberOfLines = 0;
    [self.mainImageView addSubview:self.entryLabel];
    
}


- (void)displayData {
    
    self.mainImageView.image = [UIImage imageWithData:self.entry.image];
    
    if(self.entry.mood == DiaryEntryMoodGood) {
        self.moodImageView.image = [UIImage imageNamed:@"icn_happy"];
    } else if (self.entry.mood == DiaryEntryMoodAverage) {
        self.moodImageView.image = [UIImage imageNamed:@"icn_average"];
    } else if (self.entry.mood == DiaryEntryMoodBad) {
        self.moodImageView.image = [UIImage imageNamed:@"icn_bad"];
    }
    
    self.entryLabel.text = self.entry.body;

}

- (void)viewWillAppear:(BOOL)animated {
    dispatch_async(dispatch_get_main_queue(), ^(void){
    [self displayData];
    });
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
    
    if ([segue.identifier isEqual :@"showImage"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        ImageViewController *controller = (ImageViewController*)navigationController.topViewController;
        controller.entry = self.entry;
    } else {
        UINavigationController *navigationController = segue.destinationViewController;
        THEntryViewcontroller *entryViewController = (THEntryViewcontroller*)navigationController.topViewController;
        entryViewController.entry = self.entry;
    }
}

- (void)onFavoriteButtonPressed {
    
    BOOL isFavorite = [self.entry.isFavorite boolValue];
    if (!isFavorite) {
        [self.isFavoriteButton setSelected:YES];
        [self changingIsFavoriteToTrue];
    } else {
        [self.isFavoriteButton setSelected:NO];
        [self changingIsFavoriteToFalse];
    }
}

- (void)onZoomButtonPressed {
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self performSegueWithIdentifier:@"showImage" sender:self.zoomButton];
    });
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











@end
