//
//  BFBranchViewController.m
//  OpenShop
//
//  Created by Jirka Apps
//  Copyright (c) 2015 Business Factory. All rights reserved.
//

#import "BFBranchViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <POP.h>
#import "BFAlignedImageButton.h"
#import "BFButton.h"
#import "BFBranch.h"
#import "BFBranchTransport.h"
#import "BFBranchOpeningHours.h"
#import "NSArray+Map.h"

/**
 * The page control pop animation starting margin.
 */
static CGFloat const pageControlPopAnimationMargin        = 30.0f;
/**
 * The page control pop animation bounciness.
 */
static CGFloat const pageControlPopAnimationBounciness    = 14.0f;
/**
 * The page control pop animation identification.
 */
static NSString *const pageControlPopAnimationKey         = @"viewTranslateSpringAnimation";
/**
 * The shop branch info labels fade animation duration.
 */
static CGFloat const labelFadeAnimationDuration           = 0.5f;
/**
 * The shop branch info labels fade animation identificatiom.
 */
static NSString *const labelFadeAnimationKey              = @"fadeAnimation";
/**
 * The shop branch transition duration.
 */
static CGFloat const branchTransitionDuration             = 0.3f;
/**
 * The shop branch map annotation reuse identifier.
 */
static NSString *const mapAnnotationReuseIdentifier       = @"BFBranchMapAnnotationReuseIdentifier";
/**
 * The shop branch map region latitudal metres.
 */
static CLLocationDistance const mapRegionLatitudalMeters  = 1000;
/**
 * The shop branch map region longitudal metres.
 */
static CLLocationDistance const mapRegionLongitudalMeters = 1000;



@interface BFBranchViewController ()

/**
 * The shop branch pages control.
 */
@property (nonatomic, weak) IBOutlet UIPageControl *pageControl;
/**
 * The shop branch location coordinates map view.
 */
@property (nonatomic, weak) IBOutlet MKMapView *mapView;
/**
 * The shop branch title label.
 */
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
/**
 * The shop branch subtitle label.
 */
@property (nonatomic, weak) IBOutlet UILabel *subtitleLabel;
/**
 * The shop branch notes label.
 */
@property (nonatomic, weak) IBOutlet UILabel *noteLabel;
/**
 * The shop branch map annotation.
 */
@property (nonatomic, strong) MKPointAnnotation *mapAnnotation;

/**
 * The shop branch selection button.
 */
@property (nonatomic, weak) IBOutlet BFAlignedImageButton *selectButton;
/**
 * The shop branches dismiss button.
 */
@property (nonatomic, weak) IBOutlet BFButton *closeButton;
/**
 * The shop branch transport options.
 */
@property (nonatomic, strong) IBOutletCollection(BFBranchTransportView) NSArray *transportViews;

/**
 * The shop branch info view elements contraints used to control info view changes.
 */
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *selectButtonTopConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *selectButtonHeightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *noteLabelBottomConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *noteLabelHeightConstraint;
/**
 * Initial shop branch info view elements contraints values.
 */
@property (nonatomic, assign) CGFloat selectButtonTopValue;
@property (nonatomic, assign) CGFloat selectButtonHeightValue;
/**
 * Initial shop branch info view elements contraints values.
 */
@property (nonatomic, assign) CGFloat noteLabelBottomValue;
@property (nonatomic, assign) CGFloat noteLabelHeightValue;


@end


@implementation BFBranchViewController


#pragma mark - Initialization

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self)
    {
        [self setDefaults];
    }
    return self;
}

- (void)setDefaults {
    // properties
    _currentIndex = 0;
}


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    // default contraint values
    self.selectButtonTopValue = self.selectButtonTopConstraint.constant;
    self.selectButtonHeightValue = self.selectButtonHeightConstraint.constant;
    self.noteLabelBottomValue = self.noteLabelBottomConstraint.constant;
    self.noteLabelHeightValue = self.noteLabelHeightConstraint.constant;
    // transport views
    [self.transportViews makeObjectsPerformSelector:@selector(didLoad)];
    
    // page control customization
    self.pageControl.numberOfPages = self.branches.count;
    // branch info update
    [self updateInfoWithBranch:[self currentBranch] animated:false];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // selection and close button visibility
    self.closeButton.hidden = !_showsCloseButton;
    self.selectButtonTopConstraint.constant = _showsSelectionButton ? self.selectButtonTopValue : 0;
    self.selectButtonHeightConstraint.constant = _showsSelectionButton ? self.selectButtonHeightValue : 0;
    [self.view layoutIfNeeded];

    // page control animation
    [self popPageControl];
}


#pragma mark - Animations

- (void)fadeAnimationForLayer:(CALayer *)layer {
    CATransition *transitionAnimation = [CATransition animation];
    // fade effect
    [transitionAnimation setType:kCATransitionFade];
    [transitionAnimation setDuration:labelFadeAnimationDuration];
    [transitionAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [transitionAnimation setFillMode:kCAFillModeBoth];
    // add animation
    [layer addAnimation:transitionAnimation forKey:labelFadeAnimationKey];
}


#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation {
    MKAnnotationView *annotationView = (MKAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:mapAnnotationReuseIdentifier];
    
    if (annotationView == nil) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:mapAnnotationReuseIdentifier];
    }
    
    // map pin
    UIImage *image = [UIImage imageNamed:@"MapPin"];
    annotationView.image = image;
    annotationView.annotation = annotation;
//    annotationView.centerOffset = CGPointMake(-image.size.width/2, -image.size.height/2);
    annotationView.canShowCallout = YES;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:view.annotation.coordinate addressDictionary:nil];
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    [mapItem setName:((id <MKAnnotation>)view.annotation).subtitle];
    
    // launch apple maps with directions
    NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
    MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
    [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem] launchOptions:launchOptions];
}


#pragma mark - Properties Setters

- (void)setCurrentIndex:(NSUInteger)currentIndex {
    _currentIndex = currentIndex < self.branches.count ? currentIndex : 0;
    // branch info update
    [self updateInfoWithBranch:[self currentBranch] animated:true];
}


#pragma mark - Branch Info

- (void)updateInfoWithBranch:(BFBranch *)branch animated:(BOOL)animated {
    // update elements visibility
    [self clearInfo];
    // set current branch
    if(branch) {
        // page control page
        self.pageControl.currentPage = _currentIndex;
        
        // branch transport options
        [self updateTransportsInfo:[branch.transports allObjects]];
        // branch info
        [self updateBranchInfo:branch];
        
        // update with optional animation
        if(animated) {
            [UIView animateWithDuration:branchTransitionDuration animations:^{
                [self.view layoutIfNeeded];
            }];
        }
        else {
            [self.view layoutIfNeeded];
        }
        
        // mapview annotation
        if(!self.mapAnnotation) {
            self.mapAnnotation = [[MKPointAnnotation alloc] init];
            self.mapAnnotation.title = BFLocalizedString(kTranslationNavigateToBranch, @"Navigate to this branch");
            [self.mapView addAnnotation:self.mapAnnotation];
        }
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([branch.latitude doubleValue], [branch.longitude doubleValue]);
        self.mapAnnotation.coordinate = coordinate;
        self.mapAnnotation.subtitle = branch.address;
        // mapview region
        [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(coordinate, mapRegionLatitudalMeters, mapRegionLongitudalMeters) animated:YES];
    }
}

- (void)updateBranchInfo:(BFBranch *)branch {
    // fade animations
    if(branch.name && branch.name.length) {
        [self fadeAnimationForLayer:self.titleLabel.layer];
    }
    if(branch.address && branch.address.length) {
        [self fadeAnimationForLayer:self.subtitleLabel.layer];
    }
    if(branch.note && branch.note.length) {
        [self fadeAnimationForLayer:self.noteLabel.layer];
    }
    // branch info
    self.titleLabel.text = branch.name;
    self.subtitleLabel.text = branch.address;
    self.noteLabel.text = branch.note;
    
    // layout updates
    self.noteLabelHeightConstraint.constant = (branch.note && branch.note.length) ? self.noteLabelHeightValue : 0;
    self.noteLabelBottomConstraint.constant = (branch.note && branch.note.length) ? self.noteLabelBottomValue : 0;
    
    // transport views
    for(BFBranchTransportView *transportView in self.transportViews  ) {
        // Opening hours
        if(transportView.transportIndex == 0) {
            NSArray *openingHoursArray = [branch.openingHours array];
            BOOL visible = openingHoursArray && openingHoursArray.count;
            // fade animations
            [self fadeAnimationForLayer:transportView.descriptionLabel.layer];
            [self fadeAnimationForLayer:transportView.icon.layer];
            
            // transport option info
            NSString *openingHoursString = @"";
            openingHoursArray = [openingHoursArray mapObjectsUsingBlock:^id(id obj, NSUInteger idx) {
                BFBranchOpeningHours *openingHours = (BFBranchOpeningHours *)obj;
                return [NSString stringWithFormat:@"%@: %@", openingHours.day, openingHours.opening];
            }];
            openingHoursString = [openingHoursArray componentsJoinedByString:@"\n"];
            transportView.descriptionLabel.text = openingHoursString;
            [transportView.icon setImage:[UIImage imageNamed:@"OpeningHoursIcon"]];
            [transportView.icon setHidden:!visible];
            
            // transport option visibility
            [transportView setVisibility:visible];
        }
    }

}

- (void)updateTransportsInfo:(NSArray *)transports {
    // transport views
    for(BFBranchTransportView *transportView in self.transportViews) {
        if(transportView.transportIndex > 0) {
            BOOL visible = (transportView.transportIndex <= transports.count);
            if(visible) {
                BFBranchTransport *transport = [transports objectAtIndex:transportView.transportIndex-1];
                // fade animations
                [self fadeAnimationForLayer:transportView.descriptionLabel.layer];
                [self fadeAnimationForLayer:transportView.icon.layer];
                
                transportView.descriptionLabel.text = transport.text;
                if (transport.iconURL) {
                    [transportView.icon setImageWithURL:(NSURL *)[NSURL URLWithString:(NSString *)transport.iconURL]];
                }
                
                transportView.icon.hidden = (transport.iconURL == nil);
            }
            
            [transportView setVisibility:visible];
        }
    }
}

- (void)clearInfo {
    // branch info
    self.titleLabel.text = @"";
    self.subtitleLabel.text = @"";
    self.noteLabel.text = @"";
    
    // transports info
    for(BFBranchTransportView *transportView in self.transportViews) {
        transportView.icon.hidden = true;
        transportView.descriptionLabel.text = @"";
    }
}

- (BFBranch *)currentBranch {
    if(_currentIndex < self.branches.count) {
        // currently displayed branch
        return [self.branches objectAtIndex:_currentIndex];
    }
    return nil;
}


#pragma mark - Page Control

- (void)popPageControl {
    // translation animation
    POPSpringAnimation *viewTranslateSpringAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerTranslationX];
    // final position
    viewTranslateSpringAnimation.toValue = @(-CGRectGetMaxX(self.pageControl.frame)-pageControlPopAnimationMargin);
    // animation properties
    viewTranslateSpringAnimation.removedOnCompletion = YES;
    viewTranslateSpringAnimation.autoreverses = YES;
    viewTranslateSpringAnimation.springBounciness = pageControlPopAnimationBounciness;
    [self.pageControl.layer pop_addAnimation:viewTranslateSpringAnimation forKey:pageControlPopAnimationKey];
}

- (IBAction)pageChanged:(UIPageControl *)sender {
    [self setCurrentIndex:sender.currentPage];
}


#pragma mark - UIButton Actions

- (IBAction)closeButtonClicked:(id)sender {
    [self dismissFormSheetWithCompletionHandler:nil animated:YES];
}

- (IBAction)selectButtonClicked:(id)sender {
    [self dismissFormSheetWithCompletionHandler:^{
        if (self.selectionHandler) {
            self.selectionHandler([self currentBranch]);
        }
    } animated:YES];
}


#pragma mark - Swipe Gestures

- (IBAction)swipeGesturePerformed:(UISwipeGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateChanged || gesture.state == UIGestureRecognizerStateEnded) {
        if(gesture.direction == UISwipeGestureRecognizerDirectionLeft) {
            if (self.pageControl.currentPage < self.branches.count-1) {
                // move forward
                self.pageControl.currentPage += 1;
                [self setCurrentIndex:self.pageControl.currentPage];
            }
        }
        else if(gesture.direction == UISwipeGestureRecognizerDirectionRight) {
            if (self.pageControl.currentPage > 0) {
                // move backward
                self.pageControl.currentPage -= 1;
                [self setCurrentIndex:self.pageControl.currentPage];
            }
        }
    }
}




@end


