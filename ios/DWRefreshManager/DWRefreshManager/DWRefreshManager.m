//
//  DWRefreshManager.m
//  DWRefreshManager
//
//  Created by Dowin on 2018/3/20.
//  Copyright © 2018年 Dowin. All rights reserved.
//

#import "DWRefreshManager.h"
#import "DWRefreshControl.h"
#import <React/RCTScrollView.h>
#import <React/RCTUIManager.h>
#import <React/RCTConvert.h>
#import "LNRefresh.h"

@interface DWRefreshManager()

@property (assign, nonatomic) NSInteger myType;//类型

@end

@implementation DWRefreshManager

@synthesize bridge = _bridge;

RCT_EXPORT_MODULE()

- (dispatch_queue_t)methodQueue {
    return self.bridge.uiManager.methodQueue;
}

RCT_EXPORT_METHOD(configure:(NSNumber *__nonnull)reactTag options:(NSDictionary *)options callback:(RCTResponseSenderBlock)callback){
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
        __weak typeof(self)weakSelf = self;
        UIView *view = viewRegistry[reactTag];
        if (!view) {
            RCTLogError(@"Cannot find view with tag #%@", reactTag);
            return;
        }
        UIScrollView *scrollView = ((RCTScrollView *)view).scrollView;
        NSString *type = options[@"type"];//类型
        CGFloat incremental = [options[@"incremental"] floatValue];
        self.myType = type ? [type integerValue] : 0;
        switch (_myType) {
            case 1:{//普通刷新
                [scrollView addPullToRefreshWithOptions:options block:^{
                    [weakSelf pullToRefreshAndReactTag:reactTag];
                }];
            }
                break;
            default:{
                DWRefreshControl *refreshControl = [[DWRefreshControl alloc] initInScrollView:scrollView];
                refreshControl.dropRelease = ^(DWRefreshControl *control) {
                    [weakSelf dropViewDidBeginRefreshing:control];
                };
                refreshControl.tag = [reactTag integerValue]; // Maybe something better
                NSString *tintColor = options[@"tintColor"];
                // TODO: activityIndicatorViewStyle
                NSString *activityIndicatorViewColor = options[@"activityIndicatorViewColor"];
                if (tintColor) refreshControl.tintColor = [RCTConvert UIColor:tintColor];
                refreshControl.OpenedViewHeight = incremental ? incremental : 44;
                if (activityIndicatorViewColor) refreshControl.activityIndicatorViewColor = [RCTConvert UIColor:activityIndicatorViewColor];
//                [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
            }
                break;
        }
        scrollView.ln_header.animator.incremental = incremental ? incremental : 80;//刷新动画高度
        callback(@[[NSNull null], reactTag]);
    }];
}

RCT_EXPORT_METHOD(beginRefreshing:(NSNumber *__nonnull)reactTag) {
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
        
        UIView *view = viewRegistry[reactTag];
        if (!view) {
            RCTLogError(@"Cannot find view with tag #%@", reactTag);
            return;
        }
        
        UIScrollView *scrollView = ((RCTScrollView *)view).scrollView;
        if(_myType > 0) {
            [scrollView startRefreshing];
        }else{
            DWRefreshControl *refreshControl = (DWRefreshControl *)[scrollView viewWithTag:[reactTag integerValue]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [refreshControl beginRefreshing];
            });
        }
    }];
}

RCT_EXPORT_METHOD(endRefreshing:(NSNumber *__nonnull)reactTag) {
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
        UIView *view = viewRegistry[reactTag];
        if (!view) {
            RCTLogError(@"Cannot find view with tag #%@", reactTag);
            return;
        }
        UIScrollView *scrollView = ((RCTScrollView *)view).scrollView;
        if(_myType > 0) {
            [scrollView endRefreshing];
        }else{
            DWRefreshControl *refreshControl = (DWRefreshControl *)[scrollView viewWithTag:[reactTag integerValue]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [refreshControl endRefreshing];
            });
        }
    }];
}

- (NSDictionary *)constantsToExport {
    return @{@"UIActivityIndicatorViewStyleWhiteLarge": @(UIActivityIndicatorViewStyleWhiteLarge),
             @"UIActivityIndicatorViewStyleWhite": @(UIActivityIndicatorViewStyleWhite),
             @"UIActivityIndicatorViewStyleGray": @(UIActivityIndicatorViewStyleGray)};
}

- (void)dropViewDidBeginRefreshing:(DWRefreshControl *__nonnull)refreshControl {
    [self.bridge.eventDispatcher sendDeviceEventWithName:@"dropViewDidBeginRefreshing"
                                                    body:@(refreshControl.tag)];
    
    /*
     double delayInSeconds = 3.0;
     dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
     dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
     [refreshControl endRefreshing];
     }); */
}

- (void)pullToRefreshAndReactTag:(NSNumber *)reatTag {
    NSLog(@"下拉刷新");
    [self.bridge.eventDispatcher sendDeviceEventWithName:@"dropViewDidBeginRefreshing"
                                                    body:@([reatTag integerValue])];
}

@end
