//
//  UIScrollView+NoData.h
//  PPF_Start
//
//  Created by 孟子弘 on 2017/10/20.
//  Copyright © 2017年 SunKing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (NoData)
/** backgroundView */
@property (nonatomic, strong) UIView *backgroundView;



/** 提示图片 */
- (void)viewDisplayImageWithMsg:(NSString *) message lottieStr:(NSString*)lottieStr action:(void(^)())action IfNecessaryForRowCount:(NSInteger)rowCount;
@end
