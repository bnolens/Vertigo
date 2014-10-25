// TGRImageZoomTransition.m
//
// Copyright (c) 2013 Guillermo Gonzalez
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "TGRImageViewController.h"
#import "ILTranslucentView.h"

@interface TGRImageViewController ()

@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *singleTapGestureRecognizer;
@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *doubleTapGestureRecognizer;

@end

@implementation TGRImageViewController

- (id)initWithImageView:(UIImageView *)imageView {
    if (self = [super init]) {
        _refImageView = imageView;
    }
    
    return self;
}

- (id)initWithImage:(UIImage *)image {
    if (self = [super init]) {
        _refImageView = [[UIImageView alloc] initWithImage:image];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ILTranslucentView *bg = [[ILTranslucentView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    bg.translucentAlpha = .85;
    bg.translucentStyle = UIBarStyleBlack;
    bg.translucentTintColor = [UIColor blackColor];
    bg.translucent = YES;
    bg.backgroundColor = [UIColor clearColor];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self.view insertSubview:bg atIndex:0];
    
    if (!self.enableZoom) {
        _scrollView.minimumZoomScale = 1;
        _scrollView.maximumZoomScale = 1;
        _scrollView.scrollEnabled = NO;
        _scrollView.delaysContentTouches = NO;
    }
    
    if(self.enableZoom)[self.singleTapGestureRecognizer requireGestureRecognizerToFail:self.doubleTapGestureRecognizer];
    self.imageView.image = _refImageView.image;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - UIScrollViewDelegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.scrollView.zoomScale == self.scrollView.minimumZoomScale) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Private methods

- (IBAction)handleSingleTap:(UITapGestureRecognizer *)tapGestureRecognizer {
    if (!self.enableZoom || (self.enableZoom && self.scrollView.zoomScale == self.scrollView.minimumZoomScale)) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        // Zoom out
        [self.scrollView zoomToRect:self.scrollView.bounds animated:YES];
    }
}

- (IBAction)handleDoubleTap:(UITapGestureRecognizer *)tapGestureRecognizer {
    if (self.scrollView.zoomScale == self.scrollView.minimumZoomScale) {
        // Zoom in
        CGPoint center = [tapGestureRecognizer locationInView:self.scrollView];
        CGSize size = CGSizeMake(self.scrollView.bounds.size.width / self.scrollView.maximumZoomScale,
                                 self.scrollView.bounds.size.height / self.scrollView.maximumZoomScale);
        CGRect rect = CGRectMake(center.x - (size.width / 2.0), center.y - (size.height / 2.0), size.width, size.height);
        [self.scrollView zoomToRect:rect animated:YES];
    }
    else {
        // Zoom out
        [self.scrollView zoomToRect:self.scrollView.bounds animated:YES];
    }
}

@end
