//
//  TSWebController.m
//  PetFriend
//
//  Created by liuhao on 2018/12/9.
//  Copyright © 2018 liuhao. All rights reserved.
//

#import "TSWebController.h"
#import <WebKit/WebKit.h>

static NSString *kTSWebControllerJScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";

static NSString *kWebViewStyle = @"<head>\
<script>document.documentElement.style.webkitUserSelect = document.documentElement.style.webkitTouchCallout='none';\
</script>\
<style>\
body{text-align:center}\
img{width:100% !important;margin: 0 auto;}\
p{color: #354048; font-family: \"PingFang SC\"; font-size: 16px;}\
a{color: #354048;text-decoration:none}\
a:hover{color: #354048}\
div{margin:15 auto;}\
</style>\
</head>";

@interface TSWebController () <WKNavigationDelegate, WKScriptMessageHandler, UIScrollViewDelegate>

/** WKWebView */
@property (nonatomic, strong) WKWebView *webView;

@end

@implementation TSWebController

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    [self addWebView];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (self.navigationController) {
        _webView.frame = self.view.bounds;
        return;
    }
    _webView.frame = CGRectMake(.0f, [UIView safeAreaTop], self.view.width, self.view.height - [UIView safeAreaBottom] - [UIView safeAreaTop]);
}

- (void)setupInit {
    if (self.title.length) {
        return;
    }
    self.title = @"浏览器";
}

#pragma mark - Public
- (instancetype)initWithUrl:(NSString *)url {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.url = url;
    [self addWebView];
    return self;
}

- (instancetype)initWithHtmlString:(NSString *)htmlString {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.htmlString = htmlString;
    [self addWebView];
    return self;
}

#pragma mark - WKScriptMessageHandler JS 调原生
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
//    if ([message.name isEqualToString:@"showImg"]) {
//
//    } else if ([message.name isEqualToString:@"imageLoadingCompleted"]) {
//        
//    }
}

#pragma mark 网页开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    SAFE_BLOCK(self.didLoadCompleteBlock, self);
    [LHHudTool hideHUD];
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSURLCredential *card = [[NSURLCredential alloc] initWithTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential,card);
    }
}

#pragma mark 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    SAFE_BLOCK(self.didLoadCompleteBlock, self);
    [LHHudTool hideHUD];
}

#pragma mark 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - Private

#pragma mark Add
- (void)addSubviews {
    
}

- (void)addWebView {
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:kTSWebControllerJScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];
    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    wkWebConfig.userContentController = wkUController;
    /// 注册JS方法
    [wkWebConfig.userContentController addScriptMessageHandler:self name:@"showImg"];//显示图片
    [wkWebConfig.userContentController addScriptMessageHandler:self name:@"imageLoadingCompleted"];//显示图片
    
    _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:wkWebConfig];
    _webView.navigationDelegate = self;
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.clipsToBounds = YES;
    _webView.scrollView.delegate = self;
    [self.view addSubview:_webView];
    
    NSURLRequest *req = nil;
    if (_url.length) {
        req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:_url]];
        [_webView loadRequest:req];
    } else if (_htmlString) {
        NSString *newHtml = [kWebViewStyle stringByAppendingString:[NSString stringWithFormat:@"<body><div>%@</div></body>", _htmlString]];
        [_webView loadHTMLString:newHtml baseURL:nil];
    }
    
}

@end
