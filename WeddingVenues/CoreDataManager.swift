//
//  CoreDataManager.swift
//  WeddingVenues
//
//  Created by Lauren Nicole Roth on 3/14/17.
//  Copyright © 2017 Lauren Nicole Roth. All rights reserved.
//

import AlecrimCoreData
import CoreData
import GoogleMaps
import GooglePlaces

class WeddingVenueManager {
    
    static let sharedInstance = WeddingVenueManager()
    let container = PersistentContainer(name: "DataModel")
    
    var weddingVenues : [WeddingVenue] {
        get {
            let context = container.viewContext
            let cWeddingVenues = context.venues
            
            var cVenues = [WeddingVenue]()
            
            for weddingVenue in cWeddingVenues {
                let wv = WeddingVenue()
                wv.name = "moopy"
                cVenues.append(wv)
            }
            return cVenues
        }
        
    }
    
    init() {
        
    }
    
    func addVenue(place: GMSPlace) {
        print("Place: ", place)
        let context = container.viewContext
        let cWeddingVenues = context.venues
        
        let venue = context.venues.create()
        
        venue.address = place.formattedAddress
        venue.latitude = place.coordinate.latitude
        venue.longitude = place.coordinate.longitude
        venue.name = place.name
    }
    
}

extension NSManagedObjectContext {
    var venues:  Table<Venue>     { return Table<Venue>(context: self) }
}
