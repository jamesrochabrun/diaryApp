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

@interface THEntryViewcontroller ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, assign) enum  DiaryEntryMood pickedMood;
@property (weak, nonatomic) IBOutlet UIButton *badButton;
@property (weak, nonatomic) IBOutlet UIButton *averageButton;
@property (weak, nonatomic) IBOutlet UIButton *goodButton;
@property (strong, nonatomic) IBOutlet UIView *accesoryView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation THEntryViewcontroller

- (void)viewDidLoad {
    [super viewDidLoad];
    //if theres not an entry create it with the textfield
    NSDate *date;
    if (self.entry != nil) {
        self.textField.text = self.entry.body;
        self.pickedMood = self.entry.mood;
        date = [NSDate dateWithTimeIntervalSince1970:self.entry.date];
    } else {
        self.pickedMood = DiaryEntryMoodGood;
        date = [NSDate date];
    }
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"EEEE MMMM d, YYYY"];
    self.dateLabel.text = [dateFormatter stringFromDate:date];
    
    self.textField.inputAccessoryView = self.accesoryView;
}



- (IBAction)cancelWasPressed:(UIBarButtonItem *)sender {
    [self dismissSelf];
}

- (IBAction)doneWasPressed:(id)sender {
    
    if (self.entry != nil) {
        [self updateDiaryEntry];
    }else {
        [self insertDiaryEntry];
    }
    
    [self dismissSelf];
}

- (void)dismissSelf {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


- (void)insertDiaryEntry {
    //creating a new coreDataStack entity (singleton)
    THCoreDataStack *coreDataStack = [THCoreDataStack defaultStack];
    THDiaryEntry *entry = [NSEntityDescription insertNewObjectForEntityForName:@"THDiaryEntry" inManagedObjectContext:coreDataStack.managedObjectContext];
    
    entry.body = self.textField.text;
    entry.date = [[NSDate date] timeIntervalSince1970];
    entry.mood = self.pickedMood;

    [coreDataStack saveContext];
}

- (void)updateDiaryEntry {
    
    self.entry.body = self.textField.text;
    self.entry.mood = self.pickedMood; //Add this line
    THCoreDataStack *coreDataStack = [THCoreDataStack defaultStack];
    [coreDataStack saveContext];
}

- (IBAction)badWasPressed:(UIButton *)sender {
    self.pickedMood = DiaryEntryMoodBad;
}
- (IBAction)averageWasPressed:(UIButton *)sender {
    self.pickedMood = DiaryEntryMoodAverage;
}

- (IBAction)goodWasPressed:(UIButton *)sender {
    self.pickedMood = DiaryEntryMoodGood;
}

//creating a setter for pickedMood
- (void)setPickedMood:(enum DiaryEntryMood)pickedMood {
    _pickedMood = pickedMood;
   
    self.averageButton.alpha = 0.5f;
    self.goodButton.alpha = 0.5f;
    self.badButton.alpha = 0.5f;

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












@end
