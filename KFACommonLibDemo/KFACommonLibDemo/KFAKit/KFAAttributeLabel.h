//
//  KFAAttributeLabel.h
//  KFACommonLibDemo
//
//  Created by KFAaron on 2019/2/13.
//  Copyright © 2019 KFAaron. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, KFAAttributeAlignment) {
    KFAAttributeAlignmentTop,
    KFAAttributeAlignmentCenter,
    KFAAttributeAlignmentButtom,
};

@interface KFAAttributeLabel : UIView

@property (nonatomic, strong) UIFont *font;                   //字体
@property (nonatomic, strong) UIColor *textColor;             //文字颜色
@property (nonatomic, assign) NSInteger numberOfLines;      //行数
@property (nonatomic, assign) CTTextAlignment textAlignment;  //文字排版样式
@property (nonatomic, assign) CGFloat lineSpacing;            //行间距
@property (nonatomic, assign) CGFloat paragraphSpacing;       //段间距

/**
 设置label文案
 
 @param text 文案
 */
- (void)setText:(NSString *)text;


/**
 添加attachment
 
 @param view attachment
 @param margin 边距
 @param alignment 布局类型
 */
- (void)appendView:(UIView *)view margin:(UIEdgeInsets)margin alignment:(KFAAttributeAlignment)alignment;

- (void)resetTextFrame;

@end

@interface KFAAttributeLabelAttachment : NSObject

@property (nonatomic, strong) UIView *content;
@property (nonatomic, assign) UIEdgeInsets margin;
@property (nonatomic, assign) KFAAttributeAlignment alignment;
@property (nonatomic, assign) CGFloat fontAscent;
@property (nonatomic, assign) CGFloat fontDescent;

+ (KFAAttributeLabelAttachment *)attachmentWith:(UIView *)content margin:(UIEdgeInsets)margin alignment:(KFAAttributeAlignment)alignment;
- (CGSize)boxSize;

@end

NS_ASSUME_NONNULL_END
