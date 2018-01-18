//
//  Photo360VRViewController.m
//  360player
//
//  Created by William Hass on 11/28/16.
//  Copyright © 2016 William. All rights reserved.
//

#import "Photo360VRViewController.h"
#import "GVRPanoramaView.h"

NSInteger const Photo360VRViewControllerSphericalIndex = 0;
NSInteger const Photo360VRViewControllerPanoramaIndex = 1;


@interface Photo360VRViewController ()

@property (weak, nonatomic) IBOutlet GVRPanoramaView *panoramaView;
@property (nonatomic, strong) IBOutlet UISegmentedControl *modeSegmentedControl;
@property (strong, nonatomic) UIImage *presentingImage;
@end

@implementation Photo360VRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.modeSegmentedControl removeAllSegments];
    [self.modeSegmentedControl insertSegmentWithTitle:NSLocalizedString(@"Spherical", @"Spherical") atIndex:Photo360VRViewControllerSphericalIndex animated:NO];
    [self.modeSegmentedControl insertSegmentWithTitle:NSLocalizedString(@"Panorama", @"Panorama") atIndex:Photo360VRViewControllerPanoramaIndex animated:NO];
    self.modeSegmentedControl.selectedSegmentIndex = 0;
    
    self.panoramaView.enableTouchTracking = YES;
    self.panoramaView.enableCardboardButton = YES;
    self.panoramaView.enableFullscreenButton = YES;

    self.navigationItem.titleView = self.modeSegmentedControl;
    
    [[PHImageManager defaultManager] requestImageForAsset:self.asset
                                               targetSize:PHImageManagerMaximumSize
                                              contentMode:PHImageContentModeDefault
                                                  options:nil
                                            resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                self.presentingImage = result;
                                                [self reloadPhotoWithType:kGVRPanoramaImageTypeMono];
                                            }];
}

- (void)reloadPhotoWithType:(GVRPanoramaImageType)imageType {
    [self.panoramaView loadImage:self.presentingImage ofType:imageType];
}

- (IBAction)modeSegmentedControlValueChanged:(id)sender {
    if (self.modeSegmentedControl.selectedSegmentIndex == Photo360VRViewControllerPanoramaIndex) {
        [self reloadPhotoWithType:kGVRPanoramaImageTypeStereoOverUnder];
    } else if (self.modeSegmentedControl.selectedSegmentIndex == Photo360VRViewControllerSphericalIndex) {
        [self reloadPhotoWithType:kGVRPanoramaImageTypeMono];
    }
}

@end
