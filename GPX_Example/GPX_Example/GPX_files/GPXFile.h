//
//  GPXFile.h
//  GPX_Example
//
//  Created by Sarojraman on 21/09/15.
//  Copyright (c) 2015 Sarojraman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "GPX/GPX.h"
#import "Location.h"


@interface GPXFile : NSObject

//========== create GPX file  or GPX string from locations array ==============

//to create GPX file from location and waypoint array
+ (NSString *)createGPXFile:(NSMutableArray*)_locationsArray withWaypointArray:(NSMutableArray*)_wayPointArray;

//to create GPX string from location and waypoint array
+ (NSString *)createGPXString:(NSMutableArray*)_locationsArray withWaypointArray:(NSMutableArray*)_wayPointArray;

//to get GPXRoot from the the filepath
+(GPXRoot*)getGPXroot:(NSString*)_gpxPath;


//========== convert GPXRoot to overlays and Annotations array - which can b used to load map ==============

//to get annotation and overlays array from GPXString
+(NSDictionary*)getAnnotationAndOverlaysArrayFromGPXRoot:(NSString*)_gpxString;

@end
