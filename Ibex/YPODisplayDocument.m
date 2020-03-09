//
//  YPODisplayDocument.m
//  Ibex
//
//  Created by Ahmed Durrani on 27/09/2017.
//  Copyright © 2017 Sajid Saeed. All rights reserved.
//

#import "YPODisplayDocument.h"
#import "Utility.h"
#import "Constant.h"
#import "SVProgressHUD.h"
@interface YPODisplayDocument ()<UIWebViewDelegate , UIDocumentInteractionControllerDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property(nonatomic,assign)NSURL *newsUrl;
@property (strong, nonatomic) IBOutlet UILabel *lblDocument;
@property (strong, nonatomic) IBOutlet UIButton *btnBack;

@end

@implementation YPODisplayDocument

- (void)viewDidLoad {
    [super viewDidLoad];
    _webView.delegate = self;

    if (_allSupportableobj){
        if ([_allSupportableobj.esFileType isEqualToString:@".pdf"]){
            
            _lblDocument.text = _allSupportableobj.esFileName ;
            NSString *pathOfPdf  = [NSString stringWithFormat:WEBSERVICE_DOMAIN_URL@"%@", [_allSupportableobj.esFilePath stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
            NSURL *URL =  [NSURL URLWithString:pathOfPdf] ;
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:URL];
            [_webView loadRequest:urlRequest];
        } else {
            _lblDocument.text = _allSupportableobj.esFileName ;

            NSString *pathOfPdf  = [NSString stringWithFormat:WEBSERVICE_DOMAIN_URL@"%@", [_allSupportableobj.esFilePath stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
            NSURL *URL =  [NSURL URLWithString:pathOfPdf] ;
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:URL];
            [_webView loadRequest:urlRequest];
        }
    } else {
        if ([_detailOfNewsLetter.newsletterFileType isEqualToString:@".pdf"] || [_detailOfNewsLetter.newsletterFileType isEqualToString:@".docx"] || [_detailOfNewsLetter.newsletterFileType isEqualToString:@".xlsx"] ){
            
            _lblDocument.text = _detailOfNewsLetter.newsletterFileName ;

            NSString *pathOfPdf  = [NSString stringWithFormat:WEBSERVICE_DOMAIN_URL@"%@", [_detailOfNewsLetter.newsletterFilePath stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
            NSURL *URL =  [NSURL URLWithString:pathOfPdf] ;
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:URL];
            [_webView loadRequest:urlRequest];
    }
}
    


    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName
           value:@"Documents Media Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnBack_Pressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [SVProgressHUD show];
    [_btnBack setUserInteractionEnabled:false];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [SVProgressHUD dismiss];
    [_btnBack setUserInteractionEnabled:true];


}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
    
}



@end
