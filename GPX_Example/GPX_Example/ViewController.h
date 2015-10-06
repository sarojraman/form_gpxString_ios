//
//  ViewController.h
//  GPX_Example
//
//  Created by Sarojraman on 21/09/15.
//  Copyright (c) 2015 Sarojraman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Location.h"
#import "GPXFile.h"


@interface ViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate>

{
    MKMapView* _mapView;
    
    CLLocationManager *locationManager;
    NSMutableArray *locationsArray;
    NSMutableArray *wayPointsArray;
    
    BOOL isStartingPointAdded;
}



@end

