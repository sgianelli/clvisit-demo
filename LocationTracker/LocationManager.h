//
//  LocationManager.h
//  LocationTracker
//
//  Created by Shane Gianelli on 3/12/15.
//  Copyright (c) 2015 Dogfish Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CoreLocation;
@import MapKit;

/**
 *  This class is just responsible for managing the CLLocationManager and recording
 *  all significant location events to the core data database.
 */
@interface LocationManager : NSObject<CLLocationManagerDelegate>

/**
 *  Location manager responsible for getting visit updates
 */
@property (nonatomic, strong, readonly) CLLocationManager *locationManager;

/**
 *  Database handle to store visit events in
 */
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
