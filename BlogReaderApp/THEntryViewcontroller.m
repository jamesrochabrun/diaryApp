//
//  THNewEntryViewcontroller.m
//  BlogReaderApp
//
//  Created by James Rochabrun on 26-05-16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import "THEntryViewcontroller.h"
#import "THCoreDataStack.h"
#import "THDiaryEntry.h"
#import <CoreLocation/CoreLocation.h>
#import "ImageViewController.h"
#import "UIColor+CustomColor.h"
#import "UIFont+CustomFont.h"
#import "Common.h"
#import "CommonUIConstants.h"
#import "LocationManager.h"


@interface THEntryViewcontroller ()<UINavigationControllerDelegate, CLLocationManagerDelegate,UITextViewDelegate,LocationManagerDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, assign) enum  DiaryEntryMood pickedMood;
@property (weak, nonatomic) IBOutlet UIButton *badButton;
@property (weak, nonatomic) IBOutlet UIButton *averageButton;
@property (weak, nonatomic) IBOutlet UIButton *goodButton;
@property (strong, nonatomic) IBOutlet UIView *accesoryView;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic,strong) NSString *location;
@property (nonatomic, strong) UIImageView *moodEntryImage;
@property (nonatomic, strong) UIImageView *thumbnail;
@property (nonatomic, strong) UILabel *counterLabel;
@property (nonatomic, strong) LocationManager *locationManager;
@end

@implementation THEntryViewcontroller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _counterLabel = [UILabel new];
    [_counterLabel setFont:[UIFont regularFont:15]];
    [_counterLabel setTextColor:[UIColor newGrayColor]];
    _counterLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:_counterLabel];
    
    _dateLabel = [UILabel new];
    [_dateLabel setFont:[UIFont regularFont:15]];
    [_dateLabel setTextColor:[UIColor newGrayColor]];
    [self.view addSubview:_dateLabel];
    
    _thumbnail = [UIImageView new];
    _thumbnail.clipsToBounds = YES;
    _thumbnail.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_thumbnail];

    _textView = [UITextView new];
    _textView.scrollEnabled = YES;
    _textView.userInteractionEnabled = YES;
    _textView.font = [UIFont regularFont:17];
    _textView.textColor = [UIColor newGrayColor];
    _textView.delegate = self;
    [self.view addSubview:_textView];
    
    _moodEntryImage = [UIImageView new];
    _moodEntryImage.clipsToBounds = YES;
    _moodEntryImage.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:_moodEntryImage];
    
    //[self.locationManager requestAlwaysAuthorization];
    //if theres not an entry create it with the textfield
    _locationManager = [LocationManager new];
    _locationManager.delegate = self;

    NSDate *date;
    if (self.entry != nil) {
        self.textView.text = self.entry.body;
        self.pickedMood = self.entry.mood;
        self.thumbnail.image = [UIImage imageWithData:self.entry.image];
        date = [NSDate dateWithTimeIntervalSince1970:self.entry.date];
        if(self.entry.mood == DiaryEntryMoodGood) {
            self.moodEntryImage.image = [UIImage imageNamed:@"icn_happy"];
        } else if (self.entry.mood == DiaryEntryMoodAverage) {
            self.moodEntryImage.image = [UIImage imageNamed:@"icn_average"];
        } else if (self.entry.mood == DiaryEntryMoodBad) {
            self.moodEntryImage.image = [UIImage imageNamed:@"icn_bad"];
        }
    } else {
        self.pickedMood = DiaryEntryMoodGood;
        self.moodEntryImage.image = [UIImage imageNamed:@"icn_happy"];
        date = [NSDate date];
        //we only want to load location for a new entry
      //  [self l];
    }
    
    if (self.pickedImage != nil) {
        self.thumbnail.image = _pickedImage;
    }
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"EEEE MMMM d, YYYY"];
    _dateLabel.text = [dateFormatter stringFromDate:date];
    
    //this line performs the appereance of the mood buttons view in th keyboard;
    //reminder : also drag the view outside the hierarchy of the storyboard
    self.textView.inputAccessoryView = self.accesoryView;
    //appereance
    //setting the counter
    self.counterLabel.text = [NSString stringWithFormat:@"%lu / max 210", (unsigned long)self.textView.text.length ];
}

//delegate methods of LocationManager
- (void)displayAlertInVC:(UIAlertController *)alertController {
    
    __weak THEntryViewcontroller *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf presentViewController:alertController animated:YES completion:nil];
    });
}

- (void)setlocationString:(NSString *)location {
    self.location = location;
}

////////////////

- (void)setPickedImage:(UIImage *)pickedImage {
    
    if (_pickedImage == pickedImage) return;
    _pickedImage = pickedImage;
}

- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    
    CGRect frame = _thumbnail.frame;
    frame.size.width = 100;
    frame.size.height = 100;
    frame.origin.x = 0;
    frame.origin.y = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    _thumbnail.frame = frame;
    
    frame = _moodEntryImage.frame;
    frame.size.height = 20;
    frame.size.width = 20;
    frame.origin.x = CGRectGetMaxX(_thumbnail.frame) - 10;
    frame.origin.y = CGRectGetMaxY(_thumbnail.frame) - 10;
    _moodEntryImage.frame = frame;
    
    frame = _textView.frame;
    frame.size.height = 100;
    frame.size.width = width(self.view) - width(_thumbnail);
    frame.origin.x = CGRectGetMaxX(_thumbnail.frame);
    frame.origin.y = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    _textView.frame = frame;
    
    frame = _counterLabel.frame;
    frame.size.height = 20;
    frame.size.width = 250;
    frame.origin.x = CGRectGetMaxX(self.view.frame) - frame.size.width - kGeomMarginBig;
    frame.origin.y = CGRectGetMaxY(_textView.frame) + kGeomSpaceEdge;
    _counterLabel.frame = frame;
    
    [_dateLabel sizeToFit];
    frame = _dateLabel.frame;
    frame.origin.x = CGRectGetMaxX(self.view.frame) - width(_dateLabel) - kGeomMarginBig;
    frame.origin.y = CGRectGetMaxY(_counterLabel.frame) + kGeomMarginBig;
    _dateLabel.frame = frame;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self.textView becomeFirstResponder];
}

- (IBAction)cancelWasPressed:(UIBarButtonItem *)sender {
    
    if (_editMode) {
        [self dismissSelf];
        [self.view endEditing:YES];
    } else {
    [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)doneWasPressed:(id)sender {
    
    if (self.entry != nil) {
        [self updateDiaryEntry];
    }else {
        [self insertDiaryEntry];
    }
    [self dismissSelf];
    [self.view endEditing:YES];
}

- (void)dismissSelf {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

//step 1 insert data and save it 
- (void)insertDiaryEntry {
    
    if (self.pickedImage != nil) {
        //creating a new coreDataStack entity (singleton)
        THCoreDataStack *coreDataStack = [THCoreDataStack defaultStack];
        THDiaryEntry *entry = [NSEntityDescription insertNewObjectForEntityForName:@"THDiaryEntry" inManagedObjectContext:coreDataStack.managedObjectContext];
        
        entry.body = self.textView.text;
        entry.date = [[NSDate date] timeIntervalSince1970];
        entry.mood = self.pickedMood;
        entry.image = UIImageJPEGRepresentation(self.pickedImage, 0.75);
        entry.location = self.location;
        BOOL myBool = NO;
        entry.isFavorite = [NSNumber numberWithBool:myBool];
        
        UIImageWriteToSavedPhotosAlbum(self.pickedImage, nil, nil, nil);
        
        if (self.location == nil) {
            NSLog(@"location not added");
        }
        
        [coreDataStack saveContext];
    }
}


- (void)updateDiaryEntry {
    
    self.entry.body = self.textView.text;
    self.entry.mood = self.pickedMood;
//    if (self.pickedImage != nil) {
//        self.entry.image = UIImageJPEGRepresentation(self.pickedImage, 0.75);
//    }
    THCoreDataStack *coreDataStack = [THCoreDataStack defaultStack];
    [coreDataStack saveContext];
}

- (IBAction)badWasPressed:(UIButton *)sender {
    self.pickedMood = DiaryEntryMoodBad;
    self.moodEntryImage.image = [UIImage imageNamed:@"icn_bad"];
}
- (IBAction)averageWasPressed:(UIButton *)sender {
    self.pickedMood = DiaryEntryMoodAverage;
    self.moodEntryImage.image = [UIImage imageNamed:@"icn_average"];
}

- (IBAction)goodWasPressed:(UIButton *)sender {
    self.pickedMood = DiaryEntryMoodGood;
    self.moodEntryImage.image = [UIImage imageNamed:@"icn_happy"];
}

//creating a setter for pickedMood
- (void)setPickedMood:(enum DiaryEntryMood)pickedMood {
    _pickedMood = pickedMood;
   
    self.averageButton.alpha = 0.3f;
    self.goodButton.alpha = 0.3f;
    self.badButton.alpha = 0.3f;

    switch (pickedMood) {
        case DiaryEntryMoodGood:
            self.goodButton.alpha = 1.0f;
            break;
        case DiaryEntryMoodAverage:
            self.averageButton.alpha = 1.0f;
            break;
        case DiaryEntryMoodBad:
            self.badButton.alpha = 1.0f;
            break;
        default:
            break;
    }
}

#pragma textview delegate max characters

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    _counterLabel.text = [NSString stringWithFormat:@"%lu / max 210", (unsigned long)textView.text.length ];
    
    BOOL maxCounter = textView.text.length + (text.length - range.length) <= 210;

    return maxCounter;
}












@end
