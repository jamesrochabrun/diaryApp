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
//    [self.view endEditing:YES];
}

- (IBAction)editEntryButtonTapped:(UIBarButtonItem *)sender {
 
//    [self performSegueWithIdentifier:@"" sender:self];
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    THEntryViewcontroller *destinationController = [[THEntryViewcontroller alloc] init];
    destinationController.entry = self.entry;
    destinationController.test = @"hello";
    //                                            [self.navigationController pushViewController:destinationController animated:YES];
    NSLog(@" esto es hey hey segue :%@",  self.entry.body);
    
    
    
}



@end
