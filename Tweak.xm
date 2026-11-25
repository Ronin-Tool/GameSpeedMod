#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

static void showSpeedNotice(NSString *text) {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        if (!window) return;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 250, 60)];
        label.center = CGPointMake(window.center.x, window.center.y);
        label.text = text;
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.cornerRadius = 12;
        label.clipsToBounds = YES;
        label.font = [UIFont boldSystemFontOfSize:16];
        label.tag = 999999;
        [window addSubview:label];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [label removeFromSuperview];
        });
    });
}

%hook WKWebView

- (void)didMoveToWindow {
    %orig;
    if (self.window) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSString *jsCode = @"\
                (function(){\
                    const SPEED_MULTIPLIER = 2;\
                    function setSpeed(){\
                        if(window.egret && egret.ticker){\
                            egret.ticker.scale = SPEED_MULTIPLIER;\
                            return true;\
                        }\
                        return false;\
                    }\
                    if(!setSpeed()){\
                        setInterval(setSpeed, 500);\
                    }\
                })();";
                [self evaluateJavaScript:jsCode completionHandler:^(id _, NSError *error) {
                    if (!error) {
                        NSLog(@"✅ Speed Mod Injected Successfully");
                        showSpeedNotice(@"✅ Speed: 2x Active");
                    }
                }];
            });
        });
    }
}

%end

__attribute__((constructor))
static void init(void) {
    NSLog(@"✅ GameSpeedMod Loaded");
}
