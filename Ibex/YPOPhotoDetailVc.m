//
//  YPOPhotoDetailVc.m
//  Ibex
//
//  Created by Ahmed Durrani on 28/09/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "YPOPhotoDetailVc.h"
#import "UIImageView+AFNetworking.h"
#import "Utility.h"
#import "MOGetAllSupportingObject.h"
#import "EventSupportModel.h"
#import "PhotoLoadCel.h"
#import "TAPageControl.h"

@interface YPOPhotoDetailVc () <UIScrollViewDelegate, TAPageControlDelegate , UICollectionViewDelegate , UICollectionViewDataSource>
{
    NSTimer *timer;

    NSInteger index;

    IBOutlet UICollectionView *collectionOfPic;
    __weak IBOutlet UILabel *lblDetail;
    __weak IBOutlet UIImageView *imageOfPhoto;
}
@property (strong, nonatomic) IBOutlet UIScrollView *scrollImages;
@property (strong, nonatomic) TAPageControl *customPageControl2;

@end

@implementation YPOPhotoDetailVc

- (void)viewDidLoad {
    [super viewDidLoad];

    lblDetail.text = self.objFile.esFileName ;
    [collectionOfPic registerNib:[UINib nibWithNibName:@"PhotoLoadCel" bundle:nil] forCellWithReuseIdentifier:@"PhotoLoadCel"];

    for(int i=0; i<self.imagesToScroll.count;i++){
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) * i, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.scrollImages.frame))];
         EventSupportModel *obj = (EventSupportModel *)[_imagesToScroll objectAtIndex: i];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        NSString *imageURLString = [NSString stringWithFormat:@"%@%@", WEBSERVICE_DOMAIN_URL,[obj.esFilePath stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];

//        NSString *imageURLString = [Utility getProductUrlForProductImagePath: obj.esFilePath];
        NSURL *imageURL = [NSURL URLWithString:imageURLString];
        [imageView setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@""]];
//        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [self.scrollImages addSubview:imageView];
    }
    self.scrollImages.delegate = self;
    index=0;
    
    
    // Progammatically init a TAPageControl with a custom dot view.
    self.customPageControl2 = [[TAPageControl alloc] initWithFrame:CGRectMake(20,self.scrollImages.frame.origin.y+self.scrollImages.frame.size.height,self.scrollImages.frame.size.width,40)];//CGRectMake(0, CGRectGetMaxY(self.scrollView.frame) - 100, CGRectGetWidth(self.scrollView.frame), 40)
    // Example for touch bullet event
    self.customPageControl2.delegate      = self;
    self.customPageControl2.numberOfPages = self.imagesToScroll.count;
    self.customPageControl2.dotSize       = CGSizeMake(20, 20);
    self.scrollImages.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame) * self.imagesToScroll.count, CGRectGetHeight(self.scrollImages.frame));
    [self.view addSubview:self.customPageControl2];
  
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    collectionOfPic.delegate = self ;
    collectionOfPic.dataSource = self ;
    [collectionOfPic reloadData];
    
    
}
//-(void)viewDidAppear:(BOOL)animated{
////    timer=[NSTimer scheduledTimerWithTimeInterval:40 target:self selector:@selector(runImages) userInfo:nil repeats:YES];
//}

//-(void)viewDidDisappear:(BOOL)animated{
//    if (timer) {
//        [timer invalidate];
//        timer=nil;
//    }
//}

//-(void)runImages{
//    self.customPageControl2.currentPage=index;
//    if (index==self.imagesToScroll.count-1) {
//        index=0;
//    }else{
//        index++;
//    }
//    [self TAPageControl:self.customPageControl2 didSelectPageAtIndex:index];
//}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    
}

-(void) setupScrollView {
    //add the scrollview to the view
//    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,
//                                                                     self.view.frame.size.width,
//                                                                     self.view.frame.size.height)];
  
    //add the scrollview to this view
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName
           value:@"Images Media Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    
}

#pragma mark - ScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger pageIndex = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    self.customPageControl2.currentPage = pageIndex;
    index=pageIndex;
}
// Example of use of delegate for second scroll view to respond to bullet touch event
- (void)TAPageControl:(TAPageControl *)pageControl didSelectPageAtIndex:(NSInteger)currentIndex
{
    index=currentIndex;
    [self.scrollImages scrollRectToVisible:CGRectMake(CGRectGetWidth(self.view.frame) * currentIndex, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.scrollImages.frame)) animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnBack_Pressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _imagesToScroll.count ;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"PhotoLoadCel";
    
    EventSupportModel *obj = (EventSupportModel *)[_imagesToScroll objectAtIndex:indexPath.row];
    
    PhotoLoadCel *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    NSString *imageURLString = [Utility getProductUrlForProductImagePath: obj.esFilePath];
    NSURL *imageURL = [NSURL URLWithString:imageURLString];
    [cell.imageOfMorePhoto setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@""]];
    [Utility setViewCornerRadius:cell.imageOfMorePhoto radius:cell.imageOfMorePhoto.frame.size.width/2 - 2];

    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float cellWidth = collectionView.frame.size.width / 8   ;
    
    CGSize wdth = CGSizeMake(cellWidth, cellWidth);
    
    return wdth ;
    
    
    
    
}


@end
