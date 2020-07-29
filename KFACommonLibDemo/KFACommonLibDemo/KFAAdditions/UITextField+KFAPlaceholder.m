//
//  UITextField+KFAPlaceholder.m
//  KFACommonLibDemo
//
//  Created by KFAaron on 2020/7/29.
//  Copyright © 2020 KFAaron. All rights reserved.
//
//  说明：
//  这里属性要生效必须在设置placeholder之后设置。
//  一旦使用了这里的属性，占位字展示的则为attributedPlaceholder，不再是placeholder

#import "UITextField+KFAPlaceholder.h"
#import <objc/runtime.h>

@implementation UITextField (KFAPlaceholder)

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    objc_setAssociatedObject(self, @selector(placeholderColor), placeholderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self refreshAttributePlaceholder];
}

- (UIColor *)placeholderColor {
    return objc_getAssociatedObject(self, @selector(placeholderColor));
}

- (void)setPlaceholderFont:(UIFont *)placeholderFont {
    objc_setAssociatedObject(self, @selector(placeholderFont), placeholderFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self refreshAttributePlaceholder];
}

- (UIFont *)placeholderFont {
    return objc_getAssociatedObject(self, @selector(placeholderFont));
}

- (void)refreshAttributePlaceholder {
    if ((!self.placeholderColor && !self.placeholderFont) || !self.placeholder) {
        return;
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.placeholder];
    if (self.placeholderColor) {
        [attributedString addAttribute:NSForegroundColorAttributeName value:self.placeholderColor range:NSMakeRange(0, self.placeholder.length)];
    }
    if (self.placeholderFont) {
        [attributedString addAttribute:NSFontAttributeName value:self.placeholderFont range:NSMakeRange(0, self.placeholder.length)];
    }
    self.attributedText = attributedString;
}

@end
