//
//  ViewController.m
//  GPX_Example
//
//  Created by Sarojraman on 21/09/15.
//  Copyright (c) 2015 Sarojraman. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    locationsArray = [NSMutableArray array];
    wayPointsArray = [NSMutableArray array];
    isStartingPointAdded = NO;
    
    
    
    _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(10, 20, [[UIScreen mainScreen] bounds].size.width-20, [[UIScreen mainScreen] bounds].size.height-20)];
    _mapView.delegate =self;
    _mapView.showsUserLocation = YES;
    [_mapView setMapType:MKMapTypeStandard];
    [_mapView setZoomEnabled:YES];
    [_mapView setScrollEnabled:YES];
    [self.view addSubview:_mapView];
    
    [self settingLocation];
    
    UIButton* wayPointButton = [[UIButton alloc] initWithFrame:CGRectMake((_mapView.frame.size.width - 50),_mapView.frame.size.height-100, 30, 30)];
    [wayPointButton setBackgroundImage:[UIImage imageNamed:@"waypoint"] forState:UIControlStateNormal];
    wayPointButton.layer.cornerRadius = 20;
    wayPointButton.layer.masksToBounds = true;
    [wayPointButton addTarget:self action:@selector(AddWaypoint:) forControlEvents:UIControlEventTouchUpInside];
    [_mapView addSubview:wayPointButton];
    
    
    UIBarButtonItem* formGPXString = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(formGPXString)];
    self.navigationItem.rightBarButtonItem = formGPXString;

    [self performSelector:@selector(zoomInMap) withObject:nil afterDelay:3.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) settingLocation
{
    // Create the location manager if this object does not
    // already have one.
    if (locationManager == nil) {
        locationManager = [[CLLocationManager alloc] init];
    }
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.activityType = CLActivityTypeFitness;
    [locationManager requestAlwaysAuthorization];
    
    
    
    // Movement threshold for new events.
    locationManager.distanceFilter = 10; // meters
    [locationManager startUpdatingLocation];
}

-(void) zoomInMap
{
    MKUserLocation *userLocation = _mapView.userLocation;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance (userLocation.location.coordinate, 50, 50);
    region.span.longitudeDelta  = 0.005;
    region.span.latitudeDelta  = 0.005;
    [_mapView setRegion:region animated:NO];
}

- (void)AddWaypoint:(id)sender {
    
    [self addCheckInWaypoints:[locationsArray lastObject] withComment:@"WayPoint"];
    
}

-(void) addCheckInWaypoints:(CLLocation*)_location withComment:(NSString*)_comment
{
    Location* location = [[Location alloc] init];
    
    CLLocationCoordinate2D coord = [_location coordinate];
    
    //to find the location name
    CLGeocoder* geoCoder = [[CLGeocoder alloc]init];
    
    [geoCoder reverseGeocodeLocation:_location completionHandler:^(NSArray *placemarks, NSError *error){
        CLPlacemark *placemark = placemarks[0];
        
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        point.coordinate = coord;
        point.title = placemark.name;
        point.subtitle = _comment;
        
        location.name = placemark.name;
        location.comment = point.subtitle;
        
        
        [_mapView addAnnotation:point];
        [_mapView selectAnnotation:point animated:YES];
        
    }];
    
    location.altitude = [NSString stringWithFormat:@"%f",_location.altitude];
    location.longitude = [NSString stringWithFormat:@"%f",_location.coordinate.longitude];
    location.latitude = [NSString stringWithFormat:@"%f",_location.coordinate.latitude];
    location.date = [NSString stringWithFormat:@"%@",_location.timestamp];
    location.speed = [NSString stringWithFormat:@"%f",_location.speed];
    
    [wayPointsArray addObject:location];
}

-(void) formGPXString
{
    NSString* gpxString = [GPXFile createGPXString:self->locationsArray withWaypointArray:wayPointsArray];
    
    NSLog(@"gpx string: %@",gpxString);

}


// to load the map using gpx String
-(void) reloadMapView:(NSString*)_gpxString
{
    [_mapView addAnnotations:[[GPXFile getAnnotationAndOverlaysArrayFromGPXRoot:_gpxString] objectForKey:@"annotations"]];
    [_mapView addOverlays:[[GPXFile getAnnotationAndOverlaysArrayFromGPXRoot:_gpxString] objectForKey:@"overlays"]];
    
    
    // set zoom in next run loop.
    dispatch_async(dispatch_get_main_queue(), ^{
        
        MKMapRect zoomRect = MKMapRectNull;
        for (id <MKAnnotation> annotation in _mapView.annotations)
        {
            MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
            MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
            if (MKMapRectIsNull(zoomRect)) {
                zoomRect = pointRect;
            } else {
                zoomRect = MKMapRectUnion(zoomRect, pointRect);
            }
        }
        
        [_mapView setVisibleMapRect:zoomRect edgePadding:UIEdgeInsetsMake(30, 10, 10, 10) animated:YES];
        
        //        [_mapView setVisibleMapRect:zoomRect animated:YES];
    });
    
}



#pragma mark - Location Manager Delegate

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    
    for (CLLocation *newLocation in locations) {
        if (newLocation.horizontalAccuracy < 20) {
            
            
            [locationsArray addObject:newLocation];
            
        }
    }
    
    
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error: %@", error.description);
}

#pragma mark - Mapview Delegate

// to set the pin point
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    // make the line(s!) on the map
    [_mapView addOverlay:[self polyLine]];
    
    CLLocationCoordinate2D coord;
    
    if (locationsArray.firstObject) {
    
        coord = [locationsArray.firstObject coordinate];
    }
    
    if (!isStartingPointAdded && locationsArray.count>0) {
        
        isStartingPointAdded = YES;
        
        [self addCheckInWaypoints:[locationsArray firstObject] withComment:@"Current Location"];
    }

}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolyline *polyLine = (MKPolyline *)overlay;
        MKPolylineRenderer *aRenderer = [[MKPolylineRenderer alloc] initWithPolyline:polyLine];
        aRenderer.strokeColor = [UIColor blackColor];
        aRenderer.lineWidth = 3;
        return aRenderer;
    }
    
    return nil;
}

- (MKPolyline *)polyLine {
    
    CLLocationCoordinate2D coords[locationsArray.count];
    
    for (int i = 0; i < locationsArray.count; i++) {
        CLLocationCoordinate2D coord;
        //        coord.longitude = [[self.locations objectAtIndex:i] coordinate].longitude;
        //        coord.latitude = [[self.locations objectAtIndex:i] coordinate].latitude;
        coord = [[locationsArray objectAtIndex:i] coordinate];
        
        coords[i] = coord;
    }
    
    
    return [MKPolyline polylineWithCoordinates:coords count:locationsArray.count];
}


@end
