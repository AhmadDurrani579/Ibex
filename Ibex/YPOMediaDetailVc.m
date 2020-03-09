//
//  YPOMediaDetailVc.m
//  Ibex
//
//  Created by Ahmed Durrani on 25/09/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "YPOMediaDetailVc.h"
#import "MediaCollectionCell.h"
#import "AppDelegate.h"
#import "UIImageView+AFNetworking.h"
#import "Utility.h"
#import "ImagesCollectionCell.h"
#import "MOGetAllSupportingObject.h"
#import "YPOPhotoDetailVc.h"
#import "EventSupportModel.h"
@interface YPOMediaDetailVc ()<UICollectionViewDelegate , UICollectionViewDataSource>
{
    __weak IBOutlet UICollectionView *collectionViewOfImages;

    IBOutlet UILabel *lblTitleOfImage;
}
@end

@implementation YPOMediaDetailVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    lblTitleOfImage.text = _supportingList.eventName ;
    _images = [[NSMutableArray alloc] init] ;
    
    NSMutableArray *arrayOfFile  = [[NSMutableArray alloc] init];
    for (EventSupportModel *obj in self.supportingList.supportingContentList)
         {
             if ([obj.esFileType isEqualToString:@".jpg"] || [obj.esFileType isEqualToString:@".png"] || [obj.esFileType isEqualToString:@".PNG"] )
             {
                 [arrayOfFile addObject:obj];
             }
         }
        _images = [arrayOfFile mutableCopy] ;

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnBack_Pressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:true];
 }

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    collectionViewOfImages.delegate = self ;
    collectionViewOfImages.dataSource = self ;
    
    
    
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    NSInteger numOfSections = 0;
    if (_images.count >0)
    {
        numOfSections                = 1;
        collectionViewOfImages.backgroundView = nil;
    }
    else
    {
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, collectionViewOfImages.bounds.size.width, collectionViewOfImages.bounds.size.height)];
        [noDataLabel setNumberOfLines:10];
        noDataLabel.font = [UIFont fontWithName:@"Axiforma-Book" size:14];
        noDataLabel.text             = @"There are currently no data.";
        noDataLabel.textColor        = [UIColor colorWithRed:119.0/255.0 green:119.0/255.0 blue:119.0/255.0 alpha:1.0];
        noDataLabel.textAlignment    = NSTextAlignmentCenter;
        collectionViewOfImages.backgroundView = noDataLabel;
//        collectionViewOfImages.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return numOfSections;
    

}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _images.count ;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"ImagesCollectionCell";
    
    EventSupportModel *obj = (EventSupportModel *)[_images objectAtIndex:indexPath.row];
    
    ImagesCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
//        NSString *imageURLString = [Utility getProductUrlForProductImagePath:obj.esFilePath];
//       NSURL *imageURL ;
     id  thumbnailImage = obj.esFilePath ;
    
    if (thumbnailImage != [NSNull null]) {
        NSString *imageURLString = [NSString stringWithFormat:@"%@%@", WEBSERVICE_DOMAIN_URL,[obj.esFilePath stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
//        imageURL = [NSURL URLWithString:imageURLString];
        NSURL *imageURL = [NSURL URLWithString:imageURLString];
        NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
        [cell.activityIndicatorView startAnimating];
        [cell.imageOfCollection setImageWithURLRequest:request
                                      placeholderImage:[UIImage imageNamed:@""]
                                               success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                   [cell.activityIndicatorView stopAnimating];
                                                   cell.imageOfCollection.image = image;
                                               }
                                               failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                   [cell.activityIndicatorView stopAnimating];
                                               }];
        
    }
        cell.eventName.text = self.supportingList.eventName  ;
        cell.fileName.text = obj.esFileName ;
    
        
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    YPOPhotoDetailVc *vc  = [self.storyboard instantiateViewControllerWithIdentifier: @"YPOPhotoDetailVc"] ;
    EventSupportModel *obj = (EventSupportModel *)[_images objectAtIndex:indexPath.row];
    vc.imagesToScroll = _images  ;
    vc.objFile = obj ;
    [self.navigationController pushViewController:vc animated:true];
    
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float cellWidth = collectionView.frame.size.width / 4   ;

    CGSize wdth = CGSizeMake(cellWidth, 100);
    
    return wdth ;
    
    
    
    
}



//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
//{
//    return  self.images.count ;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
//{
//    MediaCollectionCell *cell = (MediaCollectionCell *)[tableView dequeueReusableCellWithIdentifier:@"MediaCollectionCell"];
//    NSString *imagePath = [self.images objectAtIndex:indexPath.row] ;
//    NSString *imageURLString = [Utility getProductUrlForProductImagePath:imagePath];
//    NSURL *imageURL = [NSURL URLWithString:imageURLString];
//    
//    if (self.valueChange == 0 )
//    {
//        [cell.webView setHidden:true];
//        [cell.imageOfListes setHidden:false];
//        [cell.imageOfListes setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@""]];
//    }
//    else
//    {
//        [cell.webView setHidden:false];
//        [cell.imageOfListes setHidden:true];
//
//    }
//    
//
//    return cell ;
//    
//}


@end
