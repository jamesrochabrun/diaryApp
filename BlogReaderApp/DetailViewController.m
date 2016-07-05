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

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *entryImage;
@property (weak, nonatomic) IBOutlet UILabel *entryLabel;


@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.entryImage.image = [UIImage imageWithData:self.entry.image];
    self.entryLabel.text = self.entry.body;
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



@end
