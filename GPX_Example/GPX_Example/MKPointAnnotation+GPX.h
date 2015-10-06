//
//  MKPointAnnotation+GPX.h
//  GPXViewer
//
//  Created by NextBusinessSystem on 12/01/26.
//  Copyright (c) 2012 NextBusinessSystem Co., Ltd. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "GPXElement.h"

@interface MKPointAnnotation (GPX)

- (GPXElement *)GPXElement;
- (void)setGPXElement:(GPXElement *)element;

@end
