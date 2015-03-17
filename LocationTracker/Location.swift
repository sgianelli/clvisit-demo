//
//  Location.swift
//  LocationTracker
//
//  Created by Shane Gianelli on 3/12/15.
//  Copyright (c) 2015 Dogfish Software. All rights reserved.
//

import Foundation
import CoreData

class Location: NSManagedObject {

    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber
    @NSManaged var arrival: NSDate
    @NSManaged var departure: NSDate

}
