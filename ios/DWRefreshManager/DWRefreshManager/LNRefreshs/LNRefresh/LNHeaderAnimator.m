//
//  LNHeaderAnimator.m
//  LNRefresh
//
//  Created by vvusu on 7/13/17.
//  Copyright © 2017 vvusu. All rights reserved.
//

#import "LNHeaderAnimator.h"
#import "LNRefreshHandler.h"
#import <React/RCTConvert.h>

#define FinishImg [NSString stringWithFormat:@"%@finish.png",imgPath]
#define ArrowImg [NSString stringWithFormat:@"%@refresh_arrow.png",imgPath]

@interface LNHeaderAnimator()
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) NSTimeInterval arrowTime;
@property (nonatomic, strong) NSMutableDictionary *stateImages;       //所有状态对应的动画图片
@property (nonatomic, strong) NSMutableDictionary *stateDurations;    //所有状态对应的动画时间
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView; //UIActivityIndicatorView
@property (copy, nonatomic) NSString *strRefreshTime;

@property (copy, nonatomic) NSString *strTitlePull;
@property (copy, nonatomic) NSString *strTitleRefreshing;
@property (copy, nonatomic) NSString *strTitleRelease;
@property (copy, nonatomic) NSString *strTitleComplete;
@property (strong, nonatomic) UIColor *titleColor;
@property (strong, nonatomic) UIColor *timeColor;
@property (strong, nonatomic) UIColor *indicatorColor;



@end

@implementation LNHeaderAnimator

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    if (self == [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(changeHeaderAnimatorTyoe:)
                                                     name:LNRefreshChangeNotification object:nil];
    }
    return self;
}

- (void)setOption:(NSDictionary *)option{
    _strTitlePull = [option objectForKey:@"strTitlePull"] ? [option objectForKey:@"strTitlePull"]:@"下拉刷新";
    _strTitleRelease = [option objectForKey:@"strTitleRelease"] ? [option objectForKey:@"strTitleRelease"]:@"释放刷新";
    _strTitleRefreshing = [option objectForKey:@"strTitleRefreshing"] ? [option objectForKey:@"strTitleRefreshing"]:@"加载中...";
    _strTitleComplete = [option objectForKey:@"strTitleComplete"] ? [option objectForKey:@"strTitleComplete"]:@"刷新完成";
    NSString *strTitleColor =  [option objectForKey:@"titleColor"];
    _titleColor = strTitleColor ? [RCTConvert UIColor:strTitleColor]:[UIColor blackColor];
    NSString *strTimeColor = [option objectForKey:@"timeColor"];
    _timeColor = strTimeColor ? [RCTConvert UIColor:strTimeColor]:[UIColor grayColor];
    NSString *strIndicatorColor = [option objectForKey:@"activityIndicatorViewColor"];
    _indicatorColor = strIndicatorColor ? [RCTConvert UIColor:strIndicatorColor]:[UIColor grayColor];
    _option = option;
}

- (NSMutableDictionary *)stateImages {
    if (!_stateImages) {
        _stateImages = [NSMutableDictionary dictionary];
    }
    return _stateImages;
}

- (NSMutableDictionary *)stateDurations {
    if (!_stateDurations) {
        _stateDurations = [NSMutableDictionary dictionary];
    }
    return _stateDurations;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = _titleColor;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text =  _strTitlePull;
    }
    return _titleLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _timeLabel.font = [UIFont systemFontOfSize:10];
        _timeLabel.textColor = _timeColor;
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        if ([[self.option objectForKey:@"isShowLastTime"] intValue]) {
            NSString *strLastTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"DWRefreshTime"];
            _timeLabel.text =  strLastTime ? strLastTime : @"";
        }
    }
    return _timeLabel;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _imageView.image = [UIImage imageNamed:ArrowImg];
    }
    return _imageView;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [_bgImageView setContentMode:UIViewContentModeScaleAspectFill];
        _bgImageView.clipsToBounds = YES;
    }
    return _bgImageView;
}

- (UIImageView *)gifView {
    if (!_gifView) {
        _gifView = [[UIImageView alloc]initWithFrame:CGRectZero];
    }
    return _gifView;
}

- (UIActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_indicatorView setColor:_indicatorColor];
        _indicatorView.hidden = YES;
    }
    return _indicatorView;
}

#pragma mark - Action

- (void)changeHeaderAnimatorTyoe:(NSNotification *)notification {
    if (!self.ignoreGlobSetting) {
        [self setupSubViews];
        if (self.state == LNRefreshState_Refreshing) {
            self.state = LNRefreshState_Normal;
            [self refreshView:nil state:LNRefreshState_Refreshing];
        }
    }
}

- (void)setupHeaderAnimator {
    if ([LNRefreshHandler defaultHandler].headerType >= 0) {
        self.headerType = [LNRefreshHandler defaultHandler].headerType;
        if (self.headerType == LNRefreshHeaderType_DIY) {
            [LNRefreshHandler defaultHandler].refreshTime = LNRefreshDIYRefreshTime;
        }
    }
    if ([LNRefreshHandler defaultHandler].bgImage) {
        self.bgImageView.image = [LNRefreshHandler defaultHandler].bgImage;
    } else {
        self.bgImageView.image = nil;
    }
    if ([LNRefreshHandler defaultHandler].incremental > 0) {
        self.incremental = [LNRefreshHandler defaultHandler].incremental;
    }
    NSMutableDictionary *allStateImageDic = [LNRefreshHandler defaultHandler].stateImages;
    if (allStateImageDic.count > 0) {
        for (NSString *key in allStateImageDic.allKeys) {
            NSDictionary *dic = [allStateImageDic valueForKey:key];
            NSArray *images = [dic valueForKey:@"images"];
            NSNumber *duration = [dic valueForKey:@"duration"];
            [self setImages:images duration:duration.floatValue forState:(LNRefreshState)key.integerValue];
        }
    }
}

- (void)updateAnimationView {
    [super updateAnimationView];
}

- (void)changeHeaderType:(LNRefreshHeaderType)type {
    self.headerType = type;
    [self setupSubViews];
}

- (void)setupSubViews {
    [super setupSubViews];
    dispatch_async(dispatch_get_main_queue(), ^{
        [LNRefreshHandler defaultHandler].refreshTime = self.finishTime;
        if (!self.ignoreGlobSetting) {
            [self setupHeaderAnimator];
        }
        [self.animatorView addSubview:self.bgImageView];
        switch (self.headerType) {
            case LNRefreshHeaderType_NOR:
                [self setupSubViews_NOR];
                break;
            case LNRefreshHeaderType_GIF:
                [self setupSubViews_GIF];
                break;
            case LNRefreshHeaderType_DIY:
                [self setupHeaderView_DIY];
                break;
        }
        [self layoutSubviews];
    });
}

- (void)layoutSubviews {
    CGSize size = self.animatorView.bounds.size;
    CGFloat viewW = size.width;
    CGFloat bgImageH = self.bgImageView.image.size.height;
    CGFloat bgImageY = self.incremental < bgImageH ? self.incremental - bgImageH : 0;
    self.bgImageView.frame = CGRectMake(0, bgImageY, viewW, bgImageH);
    [UIView performWithoutAnimation:^{
        switch (self.headerType) {
            case LNRefreshHeaderType_NOR:
                [self layoutHeaderView_NOR];
                break;
            case LNRefreshHeaderType_GIF:
                [self layoutHeaderView_GIF];
                break;
            case LNRefreshHeaderType_DIY:
                [self layoutHeaderView_DIY];
                break;
        }
    }];
}

- (void)refreshView:(LNRefreshComponent *)view state:(LNRefreshState)state {
    if (self.state == state) { return; }
    self.state = state;
    switch (self.headerType) {
        case LNRefreshHeaderType_NOR: {
            switch (state) {
                case LNRefreshState_Normal:{
                    self.imageView.image = [UIImage imageNamed:ArrowImg];
                    self.timeLabel.text = _strRefreshTime;
                }
                case LNRefreshState_PullToRefresh:
                    [self endRefreshAnimation_NOR];
                    break;
                case LNRefreshState_EndRefresh:
                    [self endRefreshAnimation_End];
                    break;
                case LNRefreshState_WillRefresh: {
                    self.titleLabel.text = _strTitleRelease;
                    [UIView animateWithDuration:0.2 animations:^{
                        self.arrowTime = 0.2;
                        self.imageView.transform = CGAffineTransformRotate(self.imageView.transform, M_PI);
                    }];
                }
                    break;
                case LNRefreshState_Refreshing:
                    [self startRefreshAnimation_NOR];
                    break;
                case LNRefreshState_NoMoreData:
                    self.titleLabel.text =  @"没有更多内容";
                    break;
            }
        }
            break;
        case LNRefreshHeaderType_GIF: {
            switch (state) {
                case LNRefreshState_Normal:
                case LNRefreshState_PullToRefresh:
                case LNRefreshState_EndRefresh:
                    [self endRefreshAnimation_GIF:view];
                    break;
                case LNRefreshState_WillRefresh:
                case LNRefreshState_Refreshing:
                    [self startRefreshAnimation_GIF:state];
                    break;
                case LNRefreshState_NoMoreData:
                    self.gifView.hidden = YES;
                    break;
            }
        }
            break;
        case LNRefreshHeaderType_DIY:
            [self refreshHeaderView_DIY:view state:state];
            break;
    }
    [self layoutSubviews];
}

- (void)refreshView:(LNRefreshComponent *)view progress:(CGFloat)progress {
    [super refreshView:view progress:progress];
    switch (self.headerType) {
        case LNRefreshHeaderType_NOR:
            break;
        case LNRefreshHeaderType_GIF:
            [self refreshView_GIF:view progress:progress];
            break;
        case LNRefreshHeaderType_DIY:
            [self refreshView_DIY:view progress:progress];
            break;
    }
}

# pragma mark - NOR Action
- (void)setupSubViews_NOR {
    [self.animatorView addSubview:self.titleLabel];
    [self.animatorView addSubview:self.timeLabel];
    [self.animatorView addSubview:self.imageView];
    [self.animatorView addSubview:self.indicatorView];
}

- (void)layoutHeaderView_NOR {
    CGSize size = self.animatorView.bounds.size;
    CGFloat viewW = size.width;
    CGFloat viewH = size.height;
    [self.titleLabel sizeToFit];
    [self.timeLabel sizeToFit];
    self.titleLabel.center = CGPointMake(viewW/2.0, viewH/2.0 );
    self.timeLabel.center = CGPointMake(viewW/2.0, viewH/2.0 + 20);
    self.imageView.frame = CGRectMake(0, 0, 18, 18);
    CGFloat maxMin = 70;
    if (self.titleLabel.frame.size.width * 0.5 > maxMin) {
        self.indicatorView.center = CGPointMake(self.titleLabel.frame.origin.x - 36.0, viewH/2.0);
        self.imageView.center = CGPointMake(self.titleLabel.frame.origin.x - 36.0, viewH/2.0);
    }else{
        CGFloat pointX = [UIScreen mainScreen].bounds.size.width * 0.5 - maxMin - 10;
        self.indicatorView.center = CGPointMake(pointX, viewH/2.0);
        self.imageView.center = CGPointMake(pointX, viewH/2.0);
    }

}

- (void)startRefreshAnimation_NOR {
    [self.indicatorView startAnimating];
    self.imageView.hidden = YES;
    self.indicatorView.hidden = NO;
    self.titleLabel.text =  _strTitleRefreshing;
    self.imageView.transform = CGAffineTransformRotate(self.imageView.transform, M_PI);
    if ([[self.option objectForKey:@"isShowLastTime"] intValue]) {
        _strRefreshTime = [NSString stringWithFormat:@"上次更新时间:%@",[self getCurrentTimes]];
        [[NSUserDefaults standardUserDefaults] setObject:_strRefreshTime forKey:@"DWRefreshTime"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

#pragma mark ---- 将时间戳转换成时间
- (NSString*)getCurrentTimes{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *datenow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    return currentTimeString;
}


- (void)endRefreshAnimation_NOR {
    [self.indicatorView stopAnimating];
    self.imageView.hidden = NO;
    self.indicatorView.hidden = YES;
    self.titleLabel.text =  _strTitlePull;
    [UIView animateWithDuration:self.arrowTime animations:^{
        self.arrowTime = 0.0;
        self.imageView.transform = CGAffineTransformIdentity;
    }];
}

- (void)endRefreshAnimation_End{
    [self.indicatorView stopAnimating];
    self.imageView.hidden = NO;
    self.imageView.image = [UIImage imageNamed:FinishImg];
    self.indicatorView.hidden = YES;
    self.titleLabel.text =  _strTitleComplete;
    [UIView animateWithDuration:self.arrowTime animations:^{
        self.arrowTime = 0.0;
        self.imageView.transform = CGAffineTransformIdentity;
    }];
}

# pragma mark - GIF Action
- (void)setImages:(NSArray *)images forState:(LNRefreshState)state {
    [self setImages:images duration:images.count * 0.02 forState:state];
}

- (void)setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(LNRefreshState)state {
    if (images == nil) return;
    self.stateImages[@(state)] = images;
    self.stateDurations[@(state)] = @(duration);
    UIImage *image = [images firstObject];
    if (image.size.height > self.incremental - 10) {
        self.incremental = image.size.height + 10;
    }
}

- (void)setupSubViews_GIF {
    [self.animatorView addSubview:self.gifView];
    [self endRefreshAnimation_GIF:nil];
}

- (void)layoutHeaderView_GIF {
    self.gifView.frame = self.animatorView.bounds;
    self.gifView.contentMode = UIViewContentModeCenter | UIViewContentModeBottom;
}

- (void)startRefreshAnimation_GIF:(LNRefreshState)state {
    NSArray *images = self.stateImages[@(state)];
    if (images.count == 0) return;
    self.gifView.hidden = NO;
    [self.gifView stopAnimating];
    if (images.count == 1) {
        self.gifView.image = [images lastObject];
    } else {
        self.gifView.animationImages = images;
        self.gifView.animationDuration = [self.stateDurations[@(state)] doubleValue];
        [self.gifView startAnimating];
    }
}

- (void)endRefreshAnimation_GIF:(LNRefreshComponent *)view {
    [self.gifView stopAnimating];
    if (self.stateImages.count > 0) {
        NSArray *images = self.stateImages[@(0)];
        self.gifView.image = images.firstObject;
    }
    [self refreshView:(LNRefreshComponent *)self.animatorView progress:0];
}

- (void)refreshView_GIF:(LNRefreshComponent *)view progress:(CGFloat)progress {
    NSArray *images = self.stateImages[@(LNRefreshState_Normal)];
    if (self.state != LNRefreshState_PullToRefresh || images.count == 0 || self.state !=  LNRefreshState_EndRefresh ) return;
    [self.gifView stopAnimating];
    NSUInteger index = images.count * progress;
    if (index >= images.count) index = images.count - 1;
    self.gifView.image = images[index];
}

- (void)gifViewReStartAnimation {
    [self.gifView startAnimating];
}

# pragma mark - DIY Action
- (void)setupHeaderView_DIY {}
- (void)layoutHeaderView_DIY {}
- (void)refreshView_DIY:(LNRefreshComponent *)view progress:(CGFloat)progress {}
- (void)refreshHeaderView_DIY:(LNRefreshComponent *)view state:(LNRefreshState)state {}
@end
