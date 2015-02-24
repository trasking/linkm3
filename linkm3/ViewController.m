//
//  ViewController.m
//  linkm3
//
//  Created by James Bradford Trask on 2/23/15.
//  Copyright (c) 2015 James Bradford Trask. All rights reserved.
//

#import "ViewController.h"

NSString * const kPhotoCell = @"PhotoCell";
NSString * const kVideoCell = @"VideoCell";

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *videoCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;

@end

@implementation ViewController

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
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = self.videoCollectionView == collectionView ? kVideoCell : kPhotoCell;
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    return cell;
}

#pragma mark - UICollectionViewDelegate

@end
