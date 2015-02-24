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

@interface SplitViewController ()

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
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
