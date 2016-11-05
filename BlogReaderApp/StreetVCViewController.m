//
//  StreetVCViewController.m
//  momentum
//
//  Created by James Rochabrun on 11/4/16.
//  Copyright © 2016 James Rochabrun. All rights reserved.
//

#import "StreetVCViewController.h"
#import "THDiaryEntry.h"
#import "DirectionsCell.h"

@interface StreetVCViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;


@end

@implementation StreetVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (_street) {
        [self streetViewMode];

    } else {
        _tableView = [UITableView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [self.view addSubview:_tableView];
        NSLog(@"ARRAY %@", self.steps);
        
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _tableView.frame = self.view.bounds;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSDictionary *stepDict = [self.steps objectAtIndex:indexPath.row];
    NSString *direction = [stepDict valueForKey:@"html_instructions"];
    cell.textLabel.text = direction;
    
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.steps.count;
}


- (void)streetViewMode {
    
    GMSPanoramaService *service = [GMSPanoramaService new];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([self.entry.latitude doubleValue], [self.entry.longitude doubleValue]);
    [service requestPanoramaNearCoordinate:coordinate callback:^(GMSPanorama * _Nullable panorama, NSError * _Nullable error) {
        
        if (panorama) {
            
            GMSPanoramaCamera *camera = [GMSPanoramaCamera cameraWithHeading:180
                                                                       pitch:0
                                                                        zoom:1
                                                                         FOV:90];
            GMSPanoramaView *panoView = [GMSPanoramaView new];
            panoView.camera = camera;
            panoView.panorama = panorama;
            self.view = panoView;
            
        } else {
            
            [self alertUserNoRouteAvailable];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissView:(id)sender {
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)alertUserNoRouteAvailable {
    
    __weak StreetVCViewController *weakSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No data Available" message:@"Sorry, Google can't show data for this point." preferredStyle:UIAlertControllerStyleAlert];
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf presentViewController:alert animated:YES completion:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissViewControllerAnimated:YES completion:^{
                 [weakSelf.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            }];
        });
    });
}

@end
