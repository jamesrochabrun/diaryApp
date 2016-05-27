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

@interface THEntryViewcontroller ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic, assign) enum  DiaryEntryMood pickedMood;
@property (weak, nonatomic) IBOutlet UIButton *badButton;
@property (weak, nonatomic) IBOutlet UIButton *averageButton;
@property (weak, nonatomic) IBOutlet UIButton *goodButton;
@property (strong, nonatomic) IBOutlet UIView *accesoryView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (nonatomic,strong) UIImage *pickedImage;

@end

@implementation THEntryViewcontroller

- (void)viewDidLoad {
    [super viewDidLoad];
    //if theres not an entry create it with the textfield
    NSDate *date;
    if (self.entry != nil) {
        self.textView.text = self.entry.body;
        self.pickedMood = self.entry.mood;
        date = [NSDate dateWithTimeIntervalSince1970:self.entry.date];
    } else {
        self.pickedMood = DiaryEntryMoodGood;
        date = [NSDate date];
    }
    
    if (self.entry.image != nil) {
        UIImage *image = [UIImage imageWithData:self.entry.image];
        [self.imageButton setImage:image forState:UIControlStateNormal];
    }
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"EEEE MMMM d, YYYY"];
    self.dateLabel.text = [dateFormatter stringFromDate:date];
    
    self.textView.inputAccessoryView = self.accesoryView;
    self.imageButton.layer.cornerRadius = CGRectGetWidth(self.imageButton.frame) / 2.0f;
}


- (void)viewWillAppear:(BOOL)animated {
    [self.textView becomeFirstResponder];
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
    
    entry.body = self.textView.text;
    entry.date = [[NSDate date] timeIntervalSince1970];
    entry.mood = self.pickedMood;
    entry.image = UIImageJPEGRepresentation(self.pickedImage, 0.75);

    [coreDataStack saveContext];
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

- (IBAction)imageButtonWasPressed:(id)sender {
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self promptForSource];
    } else{
        [self promptForPhotoRoll];
    }
}

#pragma camera actions

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
                                                             [self dismissViewControllerAnimated:YES completion:nil];
                                                             NSLog(@"photo dont saved");
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
- (void)setPickedImage:(UIImage *)pickedImage {
    _pickedImage = pickedImage;
    
    if (pickedImage == nil) {
        [self.imageButton setImage:[UIImage imageNamed:@"icn_noimage"] forState:UIControlStateNormal];
    } else {
        [self.imageButton setImage:pickedImage forState:UIControlStateNormal];
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.pickedImage = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}






















@end
