//
//  ViewController.m
//  linkm3
//
//  Created by James Bradford Trask on 2/23/15.
//  Copyright (c) 2015 James Bradford Trask. All rights reserved.
//

#import "SplitViewController.h"
#import "LMCollectionViewCell.h"

NSString * const kPhotoCell = @"PhotoCell";
NSString * const kVideoCell = @"VideoCell";

@interface SplitViewController () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *videoCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;

@end

@implementation SplitViewController

#pragma mark - Initialization

- (void)viewDidLoad {
    self.photoCollectionView.delegate = self;
    self.photoCollectionView.dataSource = self;
    self.videoCollectionView.delegate = self;
    self.videoCollectionView.dataSource = self;
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(photoDrag:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void) photoDrag:(UIPanGestureRecognizer *) gesture
{
    CGPoint location = [gesture locationInView:self.videoCollectionView];
    if ([gesture state] == UIGestureRecognizerStateBegan) {
        NSLog(@"START: %.0f, %.0f", location.x, location.y);
    } else if ([gesture state] == UIGestureRecognizerStateChanged) {
        NSLog(@"DRAG: %.0f, %.0f", location.x, location.y);
    } else if ([gesture state] == UIGestureRecognizerStateEnded) {
        NSLog(@"STOP: %.0f, %.0f", location.x, location.y);
    }
    NSIndexPath *indexPath = [self.videoCollectionView indexPathForItemAtPoint:location];
    if (indexPath) {
        NSLog(@"%@", indexPath);
    } else {
        NSLog(@"NO CELL");
    }
    
}

#pragma mark - UICollectionViewDataSource


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 50;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = self.videoCollectionView == collectionView ? kVideoCell : kPhotoCell;
    NSString *label = self.videoCollectionView == collectionView ? @"V" : @"P";
    LMCollectionViewCell *cell = (LMCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.label.text = [NSString stringWithFormat:@"%@%ld", label, (long)indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegate

@end
