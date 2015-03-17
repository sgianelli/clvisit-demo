//
//  LocationManager.m
//  LocationTracker
//
//  Created by Shane Gianelli on 3/12/15.
//  Copyright (c) 2015 Dogfish Software. All rights reserved.
//

#import "LocationManager.h"

#import "LocationTracker-Swift.h"

@interface LocationManager ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation LocationManager

- (instancetype)init {
    if (self = [super init]) {
        _locationManager = [[CLLocationManager alloc] init];
        
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        /**
         *  Must remember that iOS 8 adds a silent requirement of having one of the following
         *  keys in the Info.plist file when requesting location information:
         *
         *  NSLocationAlwaysUsageDescription ~> [self.locationManager requestAlwaysAuthorization]*
         *  NSLocationWhenInUseUsageDescription ~> [self.locationManager requestWhenInUseAuthorization]
         */
        if (CLLocationManager.authorizationStatus == kCLAuthorizationStatusNotDetermined) {
            [self.locationManager requestAlwaysAuthorization];
        }
        
        self.dateFormatter = [[NSDateFormatter alloc] init];
        
        self.dateFormatter.timeStyle = NSDateFormatterMediumStyle;
        self.dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    }
    
    return self;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            [self.locationManager startMonitoringVisits];
            
            break;
            
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted:
            NSLog(@"User has not given access to location data");
            
            break;
            
        case kCLAuthorizationStatusNotDetermined:
            [self.locationManager requestAlwaysAuthorization];
            
            break;
            
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didVisit:(CLVisit *)visit {
    /**
     *  Make sure that we can actually send the user local notifications before scheduling any
     */
    if ([[UIApplication sharedApplication] currentUserNotificationSettings].types & UIUserNotificationTypeAlert) {
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.alertTitle = @"Visit";
        localNotification.alertBody = [NSString stringWithFormat:@"From: %@\nTo: %@\nLocation: (%f, %f)",
                                       [self.dateFormatter stringFromDate:visit.arrivalDate],
                                       [self.dateFormatter stringFromDate:visit.departureDate],
                                       visit.coordinate.latitude,
                                       visit.coordinate.longitude];
        localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:15];
        localNotification.category = @"GLOBAL"; // Lazy categorization
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
    
    /**
     *  Store the visit event into the database so we can plot it later
     */
    Location *location = [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:self.managedObjectContext];
    location.arrival = visit.arrivalDate;
    location.departure = visit.departureDate;
    location.latitude = @(visit.coordinate.latitude);
    location.longitude = @(visit.coordinate.longitude);
    
    [self.managedObjectContext save:nil];
}

@end
