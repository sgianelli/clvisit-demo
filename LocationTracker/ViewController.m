//
//  ViewController.m
//  LocationTracker
//
//  Created by Shane Gianelli on 3/12/15.
//  Copyright (c) 2015 Dogfish Software. All rights reserved.
//

#import "ViewController.h"

#import "AppDelegate.h"

#import "LocationTracker-Swift.h"

@interface ViewController ()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
}

/**
 *  Whenever the app opens this view, we want to reload all the pins on the map to include
 *  visits that have happened while the phone was put away.
 */
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Location"];
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    for (Location *location in results) {
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.coordinate = CLLocationCoordinate2DMake(location.latitude.doubleValue, location.longitude.doubleValue);
        annotation.title = location.arrival.description;
        
        [self.mapView addAnnotation:annotation];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
