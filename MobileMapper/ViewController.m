//
//  ViewController.m
//  MobileMapper
//
//  Created by Nicolas Semenas on 05/08/14.
//  Copyright (c) 2014 Nicolas Semenas. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "MyAnnotation.h"

@interface ViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *myMapView;
@property (nonatomic) MyAnnotation *mobileMakersAnnotation; //PIN ON THE MAP



@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = 41.89373987;
    coordinate.longitude = -87.63532979;
    self.mobileMakersAnnotation = [[MyAnnotation alloc] init];
    self.mobileMakersAnnotation.coordinate = coordinate;
    self.mobileMakersAnnotation.title = @"MOBILE MAKERS!";
    [self.myMapView addAnnotation:self.mobileMakersAnnotation];
    
    NSString * address = @"Mount Rushmore";
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        
        for (CLPlacemark *place in placemarks) {
            MyAnnotation *annotation = [[MyAnnotation alloc]init];
            annotation.image = [UIImage imageNamed:@"mount"];
            annotation.coordinate = place.location.coordinate;
            annotation.title = place.name;
            [self.myMapView addAnnotation:annotation];
        }
    }];
    
}


-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    
    
    if ([annotation isKindOfClass:[MyAnnotation class]]){
        
        MyAnnotation *myAnnotation = (MyAnnotation *)annotation;
        MKPinAnnotationView *pin = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:nil];
        pin.canShowCallout = YES;
        pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        pin.image = [(MyAnnotation *)annotation image];
    
        if (annotation == self.mobileMakersAnnotation){
            pin.image = [UIImage imageNamed:@"mobilemakers"];
        } else {
            pin.image = [UIImage imageNamed:@"mount"];
        }
        
        return pin;
    }
    else {
        return  nil;
    }
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    
    CLLocationCoordinate2D centerCoordinate = view.annotation.coordinate;
    MKCoordinateSpan coordinateSpan;
    coordinateSpan.latitudeDelta = 0.01;
    coordinateSpan.longitudeDelta = 0.01;
    MKCoordinateRegion region;
    region.center = centerCoordinate;
    region.span = coordinateSpan;
    
    [self.myMapView setRegion:region animated:YES];
    
    
}

@end
