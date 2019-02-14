//
//  UIView+KFAAdditions.m
//  KFACommonLibDemo
//
//  Created by KFAaron on 2019/2/14.
//  Copyright © 2019 KFAaron. All rights reserved.
//

#import "UIView+KFAAdditions.h"

@implementation UIView (KFAAdditions)

- (CGFloat)kfa_top {
    return self.frame.origin.y;
}

- (void)setKfa_top:(CGFloat)kfa_top {
    CGRect frame = self.frame;
    frame.origin.y = kfa_top;
    self.frame = frame;
}

- (CGFloat)kfa_left {
    return self.frame.origin.x;
}

- (void)setKfa_left:(CGFloat)kfa_left {
    CGRect frame = self.frame;
    frame.origin.x = kfa_left;
    self.frame = frame;
}

- (CGFloat)kfa_bottom {
    return self.frame.origin.y+self.frame.size.height;
}

- (void)setKfa_bottom:(CGFloat)kfa_bottom {
    CGRect frame = self.frame;
    frame.origin.y = kfa_bottom-frame.size.height;
    self.frame = frame;
}

- (CGFloat)kfa_right {
    return self.frame.origin.x+self.frame.size.width;
}

- (void)setKfa_right:(CGFloat)kfa_right {
    CGRect frame = self.frame;
    frame.origin.x = kfa_right-frame.size.width;
    self.frame = frame;
}

- (CGFloat)kfa_width {
    return self.frame.size.width;
}

- (void)setKfa_width:(CGFloat)kfa_width {
    CGRect frame = self.frame;
    frame.size.width = kfa_width;
    self.frame = frame;
}

- (CGFloat)kfa_height {
    return self.frame.size.height;
}

- (void)setKfa_height:(CGFloat)kfa_height {
    CGRect frame = self.frame;
    frame.size.height = kfa_height;
    self.frame = frame;
}

@end
