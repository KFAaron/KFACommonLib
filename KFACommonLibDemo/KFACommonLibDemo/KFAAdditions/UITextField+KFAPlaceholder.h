//
//  UITextField+KFAPlaceholder.h
//  KFACommonLibDemo
//
//  Created by KFAaron on 2020/7/29.
//  Copyright © 2020 KFAaron. All rights reserved.
//
//  说明：
//  这里属性要生效必须在设置placeholder之后设置。
//  一旦使用了这里的属性，占位字展示的则为attributedPlaceholder，不再是placeholder

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (KFAPlaceholder)

@property(nullable, nonatomic,strong) UIColor                *placeholderColor;            // default is nil. use system default color for placeholder
@property(nullable, nonatomic,strong) UIFont                 *placeholderFont;                 // default is nil. use system default font for placeholder

@end

NS_ASSUME_NONNULL_END
