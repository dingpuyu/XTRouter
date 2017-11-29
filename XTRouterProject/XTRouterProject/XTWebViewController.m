//
//  XTWebViewController.m
//  XTRouterProject
//
//  Created by 丁璞玉 on 2017/11/29.
//  Copyright © 2017年 xiaotei. All rights reserved.
//

#import "XTWebViewController.h"
#import <WebKit/WKWebView.h>
#import "NSString+URL.h"
@interface XTWebViewController ()

@property (nonatomic,weak)WKWebView* wkWebView;

@property (nonatomic,strong)WKWebViewConfiguration* configureation;

@end

@implementation XTWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    [self initData];
}

- (void)initUI{
    self.title = @"网页展示";
}

- (void)initData{
    if (_contentURLString.length > 0) {
        //链接已经经过编码，需要时需要解码
        NSURL* url = [NSURL URLWithString:[_contentURLString URLDecodedString]];
        if (url) {
            NSURLRequest* request = [NSURLRequest requestWithURL:url];
            [self.wkWebView loadRequest:request];
        }
    }
}


#pragma mark - getter
- (WKWebView *)wkWebView{
    if (!_wkWebView) {
        WKWebView* webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:webView];
        _wkWebView = webView;
    }
    return _wkWebView;
}


@end
