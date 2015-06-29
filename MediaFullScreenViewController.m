//
//  MediaFullScreenViewController.m
//  Blocstagram_V3
//
//  Created by Diego Aguirre on 5/28/15.
//  Copyright (c) 2015 Diego Aguirre. All rights reserved.
//

#import "MediaFullScreenViewController.h"
#import "Media.h"

@interface MediaFullScreenViewController () <UIScrollViewDelegate>

@property (nonatomic,strong) UITapGestureRecognizer *tap;
@property (nonatomic,strong) UITapGestureRecognizer *doubleTap;

@end

@implementation MediaFullScreenViewController

- (instancetype) initWithMedia:(Media *)media{

    self = [super init];
    
    if (self) {
        self.media = media;
    }
    
    return self;
}

- (void) viewDidLoad {

    [super viewDidLoad];
    
    //#1
    self.scrollView = [UIScrollView new];
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.scrollView];
    
    //#2
    self.imageView = [UIImageView new];
    self.imageView.image = self.media.image;
    
    [self.scrollView addSubview:self.imageView];
    
    //#3
    self.scrollView.contentSize = self.media.image.size;
    
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFired:)];
    
    self.doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapFired:)];
    self.doubleTap.numberOfTapsRequired = 2;
    
    
    [self.tap requireGestureRecognizerToFail:self.doubleTap];
    
    [self.scrollView addGestureRecognizer:self.tap];
    [self.scrollView addGestureRecognizer:self.doubleTap];
    
    //add share button - Name, type and title
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [shareButton addTarget:self action:@selector(shareButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [shareButton setTitle:@"Share" forState:UIControlStateNormal];
    shareButton.frame = CGRectMake(290, 10, 100, 50);
    //add button to view
    [self.view addSubview:shareButton];
    
    
    
    
}

// add method to respond to button tap

- (void) shareButtonTapped {
    NSMutableArray *itemsToShare = [NSMutableArray array];
    
    if (self.media.image) {
        [itemsToShare addObject:self.media.image];
    }
    
    if (itemsToShare.count > 0 ) {
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
        [self presentViewController:activityVC animated:YES completion:nil];
    }
}


- (void) viewWillLayoutSubviews {

    [super viewWillLayoutSubviews];
    
    //#4
    self.scrollView.frame = self.view.bounds;
    [self recalculateZoomScale];
   
}

- (void) recalculateZoomScale {
    CGSize scrollViewFrameSize = self.scrollView.frame.size;
    CGSize scrollViewContentSize = self.scrollView.contentSize;
    
        scrollViewContentSize.height /= self.scrollView.zoomScale;
        scrollViewContentSize.width /= self.scrollView.zoomScale;
    
    CGFloat scaleWidth = scrollViewFrameSize.width / scrollViewContentSize.width;
    CGFloat scaleHeight = scrollViewFrameSize.height / scrollViewContentSize.height;
    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    
    self.scrollView.minimumZoomScale = minScale;
    self.scrollView.maximumZoomScale = 1;
    
}

- (void) viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [self centerScrollView];
}

- (void) centerScrollView {

    [self.imageView sizeToFit];
    
    CGSize boundSize = self.scrollView.bounds.size;
    CGRect contentsFrame = self.imageView.frame;
    
    if (contentsFrame.size.width < boundSize.width) {
        contentsFrame.origin.x = (boundSize.width - CGRectGetWidth(contentsFrame)) / 2;
    }else {
    
        contentsFrame.origin.x = 0;
    }
    
    if (contentsFrame.size.height < boundSize.height) {
        contentsFrame.origin.y = (boundSize.height - CGRectGetHeight(contentsFrame)) / 2;
    }else{
    
        contentsFrame.origin.y = 0;
    }
    
    self.imageView.frame = contentsFrame;
}


#pragma mark - UIScrollViewDelegate

// #6

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{

    return self.imageView;
}

// #7

- (void) scrollViewDidZoom:(UIScrollView *)scrollView{

    [self centerScrollView];
}

#pragma mark - Gesture Recognizers

- (void) tapFired:(UIGestureRecognizer *)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) doubleTapFired:(UIGestureRecognizer *)sender {
    
    if (self.scrollView.zoomScale == self.scrollView.minimumZoomScale) {
     

    //#8
    
    CGPoint locationPoint = [sender locationInView:self.imageView];
    
    CGSize scrollViewSize = self.scrollView.bounds.size;
    
    CGFloat width = scrollViewSize.width / self.scrollView.maximumZoomScale;
    CGFloat height = scrollViewSize.height / self.scrollView.maximumZoomScale;
    CGFloat x = locationPoint.x - (width / 2);
    CGFloat y = locationPoint.y - (height / 2);
    
    [self.scrollView zoomToRect:CGRectMake(x, y, width, height) animated:YES];
    
    }else {
        //#9
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
        
    }
    
}




































@end
