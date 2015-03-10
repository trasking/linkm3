//
//  ViewController.m
//  linkm3
//
//  Created by James Bradford Trask on 2/23/15.
//  Copyright (c) 2015 James Bradford Trask. All rights reserved.
//

#import "SplitViewController.h"
#import "LMCollectionViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>

NSString * const kPhotoCell = @"PhotoCell";
NSString * const kVideoCell = @"VideoCell";
NSString * const kThumbnailKey = @"thumbnail";
NSString * const kFullSizeKey = @"full";
int const kMaxPhotoCount = 161;

@interface SplitViewController () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *videoCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;
@property (strong, nonatomic) NSMutableArray *photos;
@property (strong, nonatomic) ALAssetsLibrary *library;

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

    [self retrieveSavedPhotos];

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
    if (self.photoCollectionView == collectionView) {
        return self.photos.count;
    }
    
    return kMaxPhotoCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = self.videoCollectionView == collectionView ? kVideoCell : kPhotoCell;
    LMCollectionViewCell *cell = (LMCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if (kVideoCell == cellIdentifier) {
        cell.label.text = [NSString stringWithFormat:@"%@%ld", @"V", (long)indexPath.row];
    } else {
        [self.library assetForURL:self.photos[indexPath.row] resultBlock:^(ALAsset *asset) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *image = self.videoCollectionView == collectionView ? nil : [UIImage imageWithCGImage:[asset thumbnail]];
                cell.imageView.image = image;
            });
        } failureBlock:^(NSError *error) {
            NSLog(@"ASSET FAIL: %@", error);
        }];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate

#pragma mark - Asset library

- (void)retrieveSavedPhotos
{
    self.library = [[ALAssetsLibrary alloc] init];
    self.photos = [NSMutableArray array];
    [self.library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (self.photos.count >= kMaxPhotoCount) {
            *stop = YES;
            NSLog(@"GROUPS FULL");
            return;
        }
        if (group) {
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (self.photos.count >= kMaxPhotoCount) {
                    *stop = YES;
                    NSLog(@"ASSETS FULL");
                    return;
                }
                if (result) {
                    NSString *url = [result valueForProperty:ALAssetPropertyAssetURL];
                    NSLog(@"ASSETS ADD: %@", url);
                    [self.photos addObject:url];
                } else {
                    NSLog(@"ASSETS DONE");
                    [self.photoCollectionView reloadData];
                }
            }];
        } else {
            NSLog(@"GROUPS DONE");
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"ASSET LIBRARY: %@", error);
    }];
}

@end
