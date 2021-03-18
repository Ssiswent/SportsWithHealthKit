//
//  UIScrollView+NoData.m
//  PPF_Start
//
//  Created by 孟子弘 on 2017/10/20.
//  Copyright © 2017年 SunKing. All rights reserved.
//

#import "UIScrollView+NoData.h"
#import <MJRefresh/MJRefresh.h>

static char backView;
@implementation UIScrollView (NoData)
- (void)setBackgroundView:(UIView *)backgroundView
{
    objc_setAssociatedObject(self, &backView, backgroundView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)backgroundView
{
    return objc_getAssociatedObject(self, &backView);
}
- (void)viewDisplayImageWithMsg:(NSString *) message lottieStr:(NSString*)lottieStr action:(void(^)())action IfNecessaryForRowCount:(NSInteger)rowCount{
   
    if (rowCount == 0) {
        if (!self.backgroundView) {
            SSEmptyView *noDataView = [[SSEmptyView alloc]initWithFrame:self.bounds lottieStr:lottieStr title:message action:action];
            self.backgroundView = noDataView;
        }
        if (self.mj_footer) {
            self.mj_footer.hidden = YES;
        }
        
    } else {
        if (self.mj_footer) {
            self.mj_footer.hidden = NO;
        }
        self.backgroundView = nil;
    }
    
    self.backgroundView.backgroundColor = UIColor.clearColor;
}
@end
