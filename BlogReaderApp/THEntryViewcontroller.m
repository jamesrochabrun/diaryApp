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


@interface THEntryViewcontroller ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, assign) enum  DiaryEntryMood pickedMood;
@property (weak, nonatomic) IBOutlet UIButton *badButton;
@property (weak, nonatomic) IBOutlet UIButton *averageButton;
@property (weak, nonatomic) IBOutlet UIButton *goodButton;
@property (strong, nonatomic) IBOutlet UIView *accesoryView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *imageButton;
//@property (nonatomic,strong) UIImage *pickedImage;
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,strong) NSString *location;
@property (weak, nonatomic) IBOutlet UIImageView *moodEntryImage;
@property (weak, nonatomic) IBOutlet UILabel *counterLabel;



@end

@implementation THEntryViewcontroller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"the imag %@", _pickedImage);
    //if theres not an entry create it with the textfield
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }

    NSDate *date;
    if (self.entry != nil) {
        self.textView.text = self.entry.body;
        self.pickedMood = self.entry.mood;
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
        [self loadLocation];
    }
    
    if (self.entry.image != nil) {
        UIImage *image = [UIImage imageWithData:self.entry.image];
        [self.imageButton setImage:image forState:UIControlStateNormal];
    }
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"EEEE MMMM d, YYYY"];
    self.dateLabel.text = [dateFormatter stringFromDate:date];
    
    //this line performs the appereance of the mood buttons view in th keyboard;
    //reminder : also drag the view outside the hierarchy of the storyboard
    self.textView.inputAccessoryView = self.accesoryView;
    //appereance
    self.imageButton.layer.cornerRadius = CGRectGetWidth(self.imageButton.frame) / 2.0f;
    self.imageButton.titleLabel.font = [UIFont regularFont:13];
    [[self.imageButton layer] setBorderWidth:2.0f];
    [[self.imageButton layer] setBorderColor:(__bridge CGColorRef _Nullable)([UIColor mainColor])];
    self.dateLabel.font = [UIFont regularFont:15];
    
    //setting the counter
    self.counterLabel.text = [NSString stringWithFormat:@"%lu / max 210", (unsigned long)self.textView.text.length ];
}

- (void)loadLocation {
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = 1000;
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    [self.locationManager stopUpdatingLocation];
    CLLocation *location = [locations firstObject];
    CLGeocoder *geocoer = [[CLGeocoder alloc]init];
    [geocoer reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *placeMark = [placemarks firstObject];
        self.location = placeMark.name;
    }];
}


- (void)viewWillAppear:(BOOL)animated {
    [self.textView becomeFirstResponder];
}

- (IBAction)cancelWasPressed:(UIBarButtonItem *)sender {
    [self dismissSelf];
    [self.view endEditing:YES];

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
        
        if (self.location == nil) {
            NSLog(@"location not added");
        }
        
        [coreDataStack saveContext];
    }
}


- (void)updateDiaryEntry {
    
    self.entry.body = self.textView.text;
    self.entry.mood = self.pickedMood;
    if (self.pickedImage != nil) {
        self.entry.image = UIImageJPEGRepresentation(self.pickedImage, 0.75);
    }
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
    
    self.counterLabel.text = [NSString stringWithFormat:@"%lu / max 210", (unsigned long)self.textView.text.length ];
    
    BOOL maxCounter = textView.text.length + (text.length - range.length) <= 210;

    return maxCounter;
}












@end
