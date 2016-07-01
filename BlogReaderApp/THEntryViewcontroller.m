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


@interface THEntryViewcontroller ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic, assign) enum  DiaryEntryMood pickedMood;
@property (weak, nonatomic) IBOutlet UIButton *badButton;
@property (weak, nonatomic) IBOutlet UIButton *averageButton;
@property (weak, nonatomic) IBOutlet UIButton *goodButton;
@property (strong, nonatomic) IBOutlet UIView *accesoryView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (nonatomic,strong) UIImage *pickedImage;
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,strong) NSString *location;
@property (weak, nonatomic) IBOutlet UIImageView *moodEntryImage;
@property (weak, nonatomic) IBOutlet UIButton *changeImageButton;

@end

@implementation THEntryViewcontroller

- (void)viewDidLoad {
    [super viewDidLoad];
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
    self.imageButton.titleLabel.font = [UIFont fontWithName:@"Gotham Narrow" size:13];
    [[self.imageButton layer] setBorderWidth:2.0f];
    [[self.imageButton layer] setBorderColor:[UIColor colorWithRed:0.114 green:0.5722 blue:0.7362 alpha:1.0].CGColor];
    [[self.changeImageButton layer] setBorderWidth:2.5f];
    [[self.changeImageButton layer] setBorderColor:[UIColor colorWithRed:0.114 green:0.5722 blue:0.7362 alpha:0.76].CGColor];
    self.dateLabel.font = [UIFont fontWithName:@"Gotham Narrow" size:15];
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
    
    if (self.textView.text.length != 0) {
        //creating a new coreDataStack entity (singleton)
        THCoreDataStack *coreDataStack = [THCoreDataStack defaultStack];
        THDiaryEntry *entry = [NSEntityDescription insertNewObjectForEntityForName:@"THDiaryEntry" inManagedObjectContext:coreDataStack.managedObjectContext];
        
        entry.body = self.textView.text;
        entry.date = [[NSDate date] timeIntervalSince1970];
        entry.mood = self.pickedMood;
        entry.image = UIImageJPEGRepresentation(self.pickedImage, 0.75);
        entry.location = self.location;
        NSLog(@"location: %@", self.location);
        
        if (self.location == nil) {
            NSLog(@"heloo");
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

#pragma camera actions

- (IBAction)imageButtonWasPressed:(id)sender {
    //this shows the image viewwhen the small image is tapped, presenting the next Viewcontroller
}

- (IBAction)changeImageButtonPressed:(UIButton *)sender {
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
    image =  [self squareImageWithImage:image scaledToSize:CGSizeMake(300, 1)];
    self.pickedImage = image;
    [self dismissViewControllerAnimated:YES completion:nil];
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

#pragma passing the image

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqual :@"showImage"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        ImageViewController *controller = (ImageViewController*)navigationController.topViewController;
        controller.pickedImage = self.entry.image;
    }
}








@end
