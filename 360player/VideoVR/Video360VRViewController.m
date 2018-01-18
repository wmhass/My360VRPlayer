//
//  Video360VRViewController.m
//  360player
//
//  Created by William Hass on 11/28/16.
//  Copyright © 2016 William. All rights reserved.
//

#import "Video360VRViewController.h"
#import "GVRWidgetView.h"
#import "GVRVideoView.h"
#import "_60player-Swift.h"

NSInteger const Video360VRViewControllerSphericalIndex = 0;
NSInteger const Video360VRViewControllerPanoramaIndex = 1;

@interface Video360VRViewController () <GVRVideoViewDelegate>

@property (nonatomic, weak) IBOutlet GVRVideoView *videoViewViewer;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *toolbarPlayButtonItem;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *toolbarPauseButtonItem;
@property (nonatomic, strong) IBOutlet UISlider *videoProgressSlider;
@property (nonatomic, strong) IBOutlet UILabel *currentProgressLabel;
@property (nonatomic, strong) IBOutlet UILabel *maxProgressLabel;
@property (nonatomic, strong) IBOutlet UISegmentedControl *modeSegmentedControl;
@property (nonatomic) BOOL isPaused;
@property (strong, nonatomic) NSURL *presentingVideoURL;

@end

@implementation Video360VRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setToolbarHidden:NO animated:YES];
    
    self.navigationItem.titleView = self.modeSegmentedControl;
    
    [self.modeSegmentedControl removeAllSegments];
    [self.modeSegmentedControl insertSegmentWithTitle:NSLocalizedString(@"Spherical", @"Spherical") atIndex:Video360VRViewControllerSphericalIndex animated:NO];
    [self.modeSegmentedControl insertSegmentWithTitle:NSLocalizedString(@"Panorama", @"Panorama") atIndex:Video360VRViewControllerPanoramaIndex animated:NO];
    self.modeSegmentedControl.selectedSegmentIndex = 0;
    
    _videoViewViewer.delegate = self;
    _videoViewViewer.enableFullscreenButton = YES;
    _videoViewViewer.enableCardboardButton = YES;
    _videoViewViewer.enableTouchTracking = YES;
    _videoViewViewer.userInteractionEnabled = YES;
    _videoViewViewer.volume = 1.0;
    
    [self.videoProgressSlider setContinuous:YES];
    
    [self setVideoPausedStatus];
    
    if (self.asset != nil && self.asset.mediaType == PHAssetMediaTypeVideo) {
        [[PHImageManager defaultManager] requestAVAssetForVideo:self.asset options:nil resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            
            if ([asset isKindOfClass:[AVURLAsset class]]) {
                self.presentingVideoURL = [(AVURLAsset *)asset URL];
                [self reloadVideoWithType:kGVRVideoTypeMono];
            }
            
        }];
    }
}

- (void)reloadVideoWithType:(GVRVideoType)videoType {
    [self.videoViewViewer loadFromUrl:self.presentingVideoURL ofType:videoType];
}

- (void)setVideoPlayingStatus {
    NSMutableArray *toolbarItems = [self.toolbarItems mutableCopy];
    [toolbarItems removeObject:self.toolbarPlayButtonItem];
    if (![toolbarItems containsObject:self.toolbarPauseButtonItem]) {
        [toolbarItems insertObject:self.toolbarPauseButtonItem atIndex:1];
    }
    self.toolbarItems = toolbarItems;
}

- (void)setVideoPausedStatus {
    NSMutableArray *toolbarItems = [self.toolbarItems mutableCopy];
    [toolbarItems removeObject:self.toolbarPauseButtonItem];
    if (![toolbarItems containsObject:self.toolbarPlayButtonItem]) {
        [toolbarItems insertObject:self.toolbarPlayButtonItem atIndex:1];
    }
    self.toolbarItems = toolbarItems;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (IBAction)modeSegmentedControlValueChanged:(id)sender {
    if (self.modeSegmentedControl.selectedSegmentIndex == Video360VRViewControllerPanoramaIndex) {
        [self reloadVideoWithType:kGVRVideoTypeStereoOverUnder];
    } else if (self.modeSegmentedControl.selectedSegmentIndex == Video360VRViewControllerSphericalIndex) {
        [self reloadVideoWithType:kGVRVideoTypeMono];
    }
}

- (IBAction)btnPauseTouched:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.isPaused = YES;
        [self.videoViewViewer pause];
        [self setVideoPausedStatus];
    });
}

- (IBAction)btnPlayTouched:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.isPaused = NO;
        [self.videoViewViewer play];
        [self setVideoPlayingStatus];
    });
}

- (IBAction)sliderVideoProgressValueChanged:(id)sender {
    [self.videoViewViewer seekTo:self.videoProgressSlider.value/100];
}

- (IBAction)videoDurationSliderTouchDown {
    [self.videoViewViewer pause];
}

- (IBAction)videoDurationSliderTouchUpInside {
    if (!self.isPaused) {
        [self.videoViewViewer play];
    }
}

- (IBAction)videoDurationSliderTouchUpOutside {
    if (!self.isPaused) {
        [self.videoViewViewer play];
    }
}

#pragma mark - GVRVideoViewDelegate

- (void)widgetViewDidTap:(GVRWidgetView *)widgetView {
    if (self.isPaused) {
        [self.videoViewViewer play];
        [self setVideoPlayingStatus];
    } else {
        [self.videoViewViewer pause];
        [self setVideoPausedStatus];
    }
    self.isPaused = !self.isPaused;
}

- (void)widgetView:(GVRWidgetView *)widgetView didLoadContent:(id)content {
    NSLog(@"Finished loading video");
    [self setVideoPlayingStatus];
    self.isPaused = NO;
    
    self.videoProgressSlider.minimumValue = 0;
    self.videoProgressSlider.maximumValue = self.videoViewViewer.duration * 100;
    
    self.maxProgressLabel.text = [TimeIntervalHelper timeVideoDurationStringFromTimeInterval:self.videoViewViewer.duration];
    self.currentProgressLabel.text = @"0:00";
}

- (void)widgetView:(GVRWidgetView *)widgetView didFailToLoadContent:(id)content withErrorMessage:(NSString *)errorMessage {
    NSLog(@"Failed to load video: %@", errorMessage);
}

- (void)videoView:(GVRVideoView*)videoView didUpdatePosition:(NSTimeInterval)position {
    // Loop the video when it reaches the end.
    if (position == videoView.duration && (videoView.displayMode == kGVRWidgetDisplayModeFullscreen || videoView.displayMode == kGVRWidgetDisplayModeFullscreenVR)) {
        [_videoViewViewer seekTo:0];
        [_videoViewViewer play];
    }
    self.videoProgressSlider.value = position * 100;
    self.currentProgressLabel.text = [TimeIntervalHelper timeVideoDurationStringFromTimeInterval: position];
}

- (void)widgetView:(GVRWidgetView *)widgetView didChangeDisplayMode:(GVRWidgetDisplayMode)displayMode {
    NSLog(@"Did change mode");
}

@end
