//
//  Location.h
//  GPX_Example
//
//  Created by Sarojraman on 21/09/15.
//  Copyright (c) 2015 Sarojraman. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface Location : NSObject

{
    NSString*  altitude;
    NSString*  date;
    NSString*  latitude;
    NSString*  longitude;
    NSString* speed;
    NSString* name;
    NSString* comment;
}

@property (nonatomic, retain) NSString * altitude;
@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSString * longitude;
@property (nonatomic, retain) NSString * speed;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * comment;

@end

