//
//  GPXWaypoint+MapKit.h
//  GPXViewer
//
//  Created by NextBusinessSystem on 12/01/26.
//  Copyright (c) 2012 NextBusinessSystem Co., Ltd. All rights reserved.
//

#import "GPXWaypoint.h"
#import <MapKit/MapKit.h>

@interface GPXWaypoint (MapKit)

- (MKPointAnnotation *)annotation;

@end
