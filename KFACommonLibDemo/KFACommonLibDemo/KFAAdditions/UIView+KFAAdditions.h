//
//  UIView+KFAAdditions.h
//  KFACommonLibDemo
//
//  Created by KFAaron on 2019/2/14.
//  Copyright © 2019 KFAaron. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (KFAAdditions)

@property (nonatomic) CGFloat kfa_top;
@property (nonatomic) CGFloat kfa_left;
@property (nonatomic) CGFloat kfa_bottom;
@property (nonatomic) CGFloat kfa_right;
@property (nonatomic) CGFloat kfa_width;
@property (nonatomic) CGFloat kfa_height;

@end

NS_ASSUME_NONNULL_END
