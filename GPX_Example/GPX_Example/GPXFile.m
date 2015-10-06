//
//  GPXFile.m
//  GPX_Example
//
//  Created by Sarojraman on 21/09/15.
//  Copyright (c) 2015 Sarojraman. All rights reserved.
//

#import "GPXFile.h"
#import "GPXRoute+MapKit.h"
#import "GPXTrack+MapKit.h"
#import "GPXWaypoint+MapKit.h"

@implementation GPXFile

+ (NSString *)gpxFilePath
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setTimeStyle:NSDateFormatterFullStyle];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    
    NSString *fileName = [NSString stringWithFormat:@"log_%@.gpx", dateString];
    return [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
}


+ (NSString *)createGPXFile:(NSMutableArray*)_locationsArray withWaypointArray:(NSMutableArray*)_wayPointArray
{
    // gpx
    GPXRoot *gpx = [GPXRoot rootWithCreator:@"GPSLogger"];
    
    // gpx > trk
    GPXTrack *gpxTrack = [gpx newTrack];
    //gpxTrack.name = @"New Track";
    
    // gpx > trk > trkseg > trkpt
    for (CLLocation *location in _locationsArray) {
        
        GPXTrackPoint *gpxTrackPoint = [gpxTrack newTrackpointWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
        gpxTrackPoint.elevation = location.altitude;
        gpxTrackPoint.time = location.timestamp;
        
    }
    
    
    for (Location* location in _wayPointArray)
    {
        
        
        GPXWaypoint *gpxWayPoint = [gpx newWaypointWithLatitude:[location.latitude doubleValue] longitude:[location.longitude doubleValue]];
        gpxWayPoint.name = location.name;
        gpxWayPoint.comment = location.comment;
    
    }
    
    
    NSString *gpxString = gpx.gpx;
    
    // write gpx to file
    NSError *error;
    NSString *filePath = [self gpxFilePath];
    if (![gpxString writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error]) {
        if (error) {
            NSLog(@"error, %@", error);
        }
        
        return nil;
    }
    
    return filePath;
}

+ (NSString *)createGPXString:(NSMutableArray*)_locationsArray withWaypointArray:(NSMutableArray*)_wayPointArray
{
    // gpx
    GPXRoot *gpx = [GPXRoot rootWithCreator:@"GPSLogger"];
    
    // gpx > trk
    GPXTrack *gpxTrack = [gpx newTrack];
    //gpxTrack.name = @"New Track";
    
    // gpx > trk > trkseg > trkpt
    for (CLLocation *location in _locationsArray) {
        
        GPXTrackPoint *gpxTrackPoint = [gpxTrack newTrackpointWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
        gpxTrackPoint.elevation = location.altitude;
        gpxTrackPoint.time = location.timestamp;
        
    }
    
    
    for (Location* location in _wayPointArray)
    {
        
        
        GPXWaypoint *gpxWayPoint = [gpx newWaypointWithLatitude:[location.latitude doubleValue] longitude:[location.longitude doubleValue]];
        gpxWayPoint.name = location.name;
        gpxWayPoint.comment = location.comment;
        
    }
    
    return gpx.gpx;
}

+(NSDictionary*)getAnnotationAndOverlaysArrayFromGPXRoot:(NSString*)_gpxString
{
    
    GPXRoot* __gpx = [GPXParser parseGPXWithString:_gpxString];
    
    NSMutableArray *annotations = [NSMutableArray array];
    NSMutableArray *overlays = [NSMutableArray array];
    
    // add waypoints
    for (GPXWaypoint *waypoint in __gpx.waypoints) {
        MKShape *annotation = waypoint.annotation;
        if (annotation) {
            [annotations addObject:annotation];
        }
    }
    
    // add routes
    for (GPXRoute *route in __gpx.routes) {
        MKShape *annotation = route.annotation;
        if (annotation) {
            [annotations addObject:annotation];
        }
        
        MKPolyline *line = route.overlay;
        if (line) {
            [overlays addObject:line];
        }
    }
    
    // add tracks
    for (GPXTrack *track in __gpx.tracks) {
        MKShape *annotation = track.annotation;
        if (annotation) {
            [annotations addObject:annotation];
        }
        
        [overlays addObjectsFromArray:track.overlays];
    }
    
   return [NSDictionary dictionaryWithObjectsAndKeys:annotations,@"annotations",overlays,@"overlays", nil];
    
}


+(GPXRoot*)getGPXroot:(NSString*)_gpxPath
{
    
     return [GPXParser parseGPXAtPath:_gpxPath];
}




@end
