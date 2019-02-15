//
//  KFAAttributeLabel.m
//  KFACommonLibDemo
//
//  Created by KFAaron on 2019/2/13.
//  Copyright © 2019 KFAaron. All rights reserved.
//

#import "KFAAttributeLabel.h"
#import <CoreText/CoreText.h>

void bpvDeallocCallback(void* ref) {
    
}

CGFloat bpvAscentCallback(void *ref) {
    KFAAttributeLabelAttachment *attachment = (__bridge KFAAttributeLabelAttachment *)ref;
    CGFloat ascent = 0;
    CGFloat height = [attachment boxSize].height;
    switch (attachment.alignment) {
        case KFAAttributeAlignmentTop:
            ascent = attachment.fontAscent;
            break;
        case KFAAttributeAlignmentCenter:
        {
            CGFloat fontAscent  = attachment.fontAscent;
            CGFloat fontDescent = attachment.fontDescent;
            CGFloat baseLine = (fontAscent + fontDescent) / 2 - fontDescent;
            ascent = height / 2 + baseLine;
        }
            break;
        case KFAAttributeAlignmentButtom:
            ascent = height - attachment.fontDescent;
            break;
        default:
            break;
    }
    return ascent;
}

CGFloat bpvDescentCallback(void *ref) {
    KFAAttributeLabelAttachment *attachment = (__bridge KFAAttributeLabelAttachment *)ref;
    CGFloat descent = 0;
    CGFloat height = [attachment boxSize].height;
    switch (attachment.alignment)
    {
        case KFAAttributeAlignmentTop:
        {
            descent = height - attachment.fontAscent;
            break;
        }
        case KFAAttributeAlignmentCenter:
        {
            CGFloat fontAscent  = attachment.fontAscent;
            CGFloat fontDescent = attachment.fontDescent;
            CGFloat baseLine = (fontAscent + fontDescent) / 2 - fontDescent;
            descent = height / 2 - baseLine;
        }
            break;
        case KFAAttributeAlignmentButtom:
        {
            descent = attachment.fontDescent;
            break;
        }
        default:
            break;
    }
    
    return descent;
    
}

CGFloat bpvWidthCallback(void* ref) {
    KFAAttributeLabelAttachment *attachment  = (__bridge KFAAttributeLabelAttachment *)ref;
    return [attachment boxSize].width;
}

static NSString* const kEllipsesCharacter = @"\u2026"; // @"..."

@interface KFAAttributeLabel ()
{
    CTFrameRef _textFrame;
    CTFrameRef _attachmentFrame;
    KFAAttributeLabelAttachment *_attachment;
    CGFloat _fontAscent;
    CGFloat _fontDescent;
}

@property (nonatomic, strong) NSMutableAttributedString *attributedString;    //富文本

@end

@implementation KFAAttributeLabel

- (void)dealloc {
    if (_textFrame) {
        CFRelease(_textFrame);
    }
    if (_attachmentFrame) {
        CFRelease(_attachmentFrame);
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initData];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initData];
    }
    return self;
}

- (void)initData {
    
    _attributedString = [[NSMutableAttributedString alloc] init];
    _attachment = nil;
    _textFrame = nil;
    _attachmentFrame = nil;
    _font = [UIFont systemFontOfSize:15];
    _textColor = [UIColor blackColor];
    _lineSpacing = 0.0;
    _paragraphSpacing = 0.0;
    
    if (nil == self.backgroundColor) {
        self.backgroundColor = [UIColor whiteColor];
    }
    
    self.userInteractionEnabled = YES;
    [self resetFont];
}

- (void)setFont:(UIFont *)font {
    if (font && _font != font) {
        _font = font;
        
        [self setFont:font forString:_attributedString];
        [self resetFont];
        _attachment.fontAscent = _fontAscent;
        _attachment.fontDescent = _fontDescent;
        [self resetTextFrame];
    }
}

- (void)setTextColor:(UIColor *)textColor {
    if (textColor && _textColor != textColor) {
        _textColor = textColor;
        
        [self setColor:textColor forString:_attributedString];
        [self resetTextFrame];
    }
}

- (void)setFrame:(CGRect)frame {
    CGRect oldRect = self.bounds;
    [super setFrame:frame];
    if (!CGRectEqualToRect(self.bounds, oldRect)) {
        [self resetTextFrame];
    }
}

- (void)setText:(NSString *)text {
    
    NSAttributedString *attributedText = [self attributedString:text];
    _attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:attributedText];
    [self cleanAll];
}

- (NSAttributedString *)attributedString:(NSString *)text {
    if ([text length]) {
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:text];
        [self setFont:self.font forString:string];
        [self setColor:self.textColor forString:string];
        return string;
    } else {
        return [[NSAttributedString alloc]init];
    }
}

- (void)setFont:(UIFont *)font forString:(NSMutableAttributedString *)string {
    
    [string removeAttribute:(NSString*)kCTFontAttributeName range:NSMakeRange(0, string.length)];
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)font.fontName, font.pointSize, nil);
    if (nil != fontRef) {
        [string addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)fontRef range:NSMakeRange(0, string.length)];
        CFRelease(fontRef);
    }
}

- (void)setColor:(UIColor *)color forString:(NSMutableAttributedString *)string {
    
    if (color.CGColor) {
        [string removeAttribute:(NSString *)kCTForegroundColorAttributeName range:NSMakeRange(0, string.length)];
        [string addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)color.CGColor range:NSMakeRange(0, string.length)];
    }
}

- (void)appendView:(UIView *)view margin:(UIEdgeInsets)margin alignment:(KFAAttributeAlignment)alignment {
    
    KFAAttributeLabelAttachment *attachment = [KFAAttributeLabelAttachment attachmentWith:view margin:margin alignment:alignment];
    attachment.fontAscent = _fontAscent;
    attachment.fontDescent = _fontDescent;
    unichar objectReplacementChar = 0xFFFC;
    NSString *objectReplacementString = [NSString stringWithCharacters:&objectReplacementChar length:1];
    NSMutableAttributedString *attachText = [[NSMutableAttributedString alloc] initWithString:objectReplacementString];
    
    CTRunDelegateCallbacks callbacks;
    callbacks.version = kCTRunDelegateVersion1;
    callbacks.getAscent = bpvAscentCallback;
    callbacks.getDescent = bpvDescentCallback;
    callbacks.getWidth = bpvWidthCallback;
    callbacks.dealloc = bpvDeallocCallback;
    CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, (void *)attachment);
    NSDictionary *attr = [NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)delegate,kCTRunDelegateAttributeName, nil];
    [attachText setAttributes:attr range:NSMakeRange(0, 1)];
    CFRelease(delegate);
    
    _attachment = attachment;
    [_attributedString appendAttributedString:attachText];
    [self resetTextFrame];
}

- (void)cleanAll {
    _attachment = nil;
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    [self resetTextFrame];
}

- (void)resetTextFrame {
    if (_textFrame) {
        CFRelease(_textFrame);
        _textFrame = nil;
    }
    if (_attachmentFrame) {
        CFRelease(_attachmentFrame);
        _attachmentFrame = nil;
    }
    if ([NSThread isMainThread]) {
        [self setNeedsDisplay];
    }
}

- (void)resetFont {
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)self.font.fontName, self.font.pointSize, NULL);
    if (fontRef) {
        _fontAscent = CTFontGetAscent(fontRef);
        _fontDescent = CTFontGetDescent(fontRef);
        CFRelease(fontRef);
    }
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    if (ctx == nil)
    {
        return;
    }
    CGContextSaveGState(ctx);
    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformMakeTranslation(0, self.bounds.size.height), 1.f, -1.f);
    CGContextConcatCTM(ctx, transform);
    
    NSAttributedString *drawString = [self attributedStringForDraw];
    if (drawString) {
        [self prepareTextFrame:drawString rect:rect];
        [self drawAttachment];
        [self drawText:drawString
                  rect:rect
               context:ctx];
    }
    CGContextRestoreGState(ctx);
}

- (NSAttributedString *)attributedStringForDraw {
    if (nil == _attributedString) {
        return nil;
    }
    
    NSMutableAttributedString *drawString = [_attributedString mutableCopy];
    //如果LineBreakMode为TranncateTail,那么默认排版模式改成kCTLineBreakByCharWrapping,使得尽可能地显示所有文字
    CTLineBreakMode lineBreakMode = _numberOfLines == 1 ? kCTLineBreakByCharWrapping : kCTLineBreakByWordWrapping;
    CGFloat fontLineHeight = self.font.lineHeight;  //使用全局fontHeight作为最小lineHeight
    
    CTParagraphStyleSetting settings[] =
    {
        {kCTParagraphStyleSpecifierAlignment,sizeof(_textAlignment),&_textAlignment},
        {kCTParagraphStyleSpecifierLineBreakMode,sizeof(lineBreakMode),&lineBreakMode},
        {kCTParagraphStyleSpecifierMaximumLineSpacing,sizeof(_lineSpacing),&_lineSpacing},
        {kCTParagraphStyleSpecifierMinimumLineSpacing,sizeof(_lineSpacing),&_lineSpacing},
        {kCTParagraphStyleSpecifierParagraphSpacing,sizeof(_paragraphSpacing),&_paragraphSpacing},
        {kCTParagraphStyleSpecifierMinimumLineHeight,sizeof(fontLineHeight),&fontLineHeight},
        {kCTParagraphStyleSpecifierMaximumLineHeight,sizeof(fontLineHeight),&fontLineHeight},
    };
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings,sizeof(settings) / sizeof(settings[0]));
    [drawString addAttribute:(id)kCTParagraphStyleAttributeName
                       value:(__bridge id)paragraphStyle
                       range:NSMakeRange(0, [drawString length])];
    CFRelease(paragraphStyle);
    
    return drawString;
}

- (void)prepareTextFrame:(NSAttributedString *)string rect:(CGRect)rect {
    
    if (nil == _textFrame) {
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)string);
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, nil,rect);
        _textFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
        CGPathRelease(path);
        CFRelease(framesetter);
    }
    if (nil == _attachmentFrame) {
        CGRect tempRect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, CGFLOAT_MAX);
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)string);
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, nil,tempRect);
        _attachmentFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
        CGPathRelease(path);
        CFRelease(framesetter);
    }
}

- (void)drawAttachment {
    if (nil == _attachment) {
        return;
    }
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    if (nil == ctx) {
        return;
    }
    
    CFArrayRef textLines = CTFrameGetLines(_textFrame);
    CFArrayRef attachmentlines = CTFrameGetLines(_attachmentFrame);
    const void * lastValue = CFArrayGetValueAtIndex(attachmentlines, CFArrayGetCount(attachmentlines)-1);
    CFMutableArrayRef lines = CFArrayCreateMutableCopy(kCFAllocatorDefault, 0, textLines);
    CFArrayReplaceValues(lines, CFRangeMake(CFArrayGetCount(lines)-1, 1), &lastValue, 1);
    
    CFIndex lineCount = CFArrayGetCount(lines);
    CGPoint lineOrigins[lineCount];
    CTFrameGetLineOrigins(_textFrame, CFRangeMake(0, 0), lineOrigins);
    NSInteger numberOfLines = [self numberOfDisplayedLines];
    
    CTLineRef line = CFArrayGetValueAtIndex(lines, numberOfLines-1);
    CFArrayRef runs = CTLineGetGlyphRuns(line);
    CFIndex runCount = CFArrayGetCount(runs);
    CGPoint lineOrigin = lineOrigins[numberOfLines-1];
    CGFloat lineAscent;
    CGFloat lineDescent;
    CTLineGetTypographicBounds(line, &lineAscent, &lineDescent, NULL);
    CGFloat lineHeight = lineAscent + lineDescent;
    CGFloat lineBottomY = lineOrigin.y - lineDescent;
    
    CTRunRef run = CFArrayGetValueAtIndex(runs, runCount-1);
    
    CGFloat ascent = 0.0f;
    CGFloat descent = 0.0f;
    CGFloat width = (CGFloat)CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL);
    
    CGFloat attachmentHeight = [_attachment boxSize].height;
    CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, nil);
    if (CFArrayGetCount(attachmentlines) > lineCount) {
        xOffset = self.bounds.size.width-width;
    }
    
    CGFloat attachmentOriginY = 0.0f;
    switch (_attachment.alignment) {
        case KFAAttributeAlignmentTop:
            attachmentOriginY = lineBottomY + (lineHeight - attachmentHeight);
            break;
        case KFAAttributeAlignmentCenter:
            attachmentOriginY = lineBottomY + (lineHeight - attachmentHeight) / 2.0;
            break;
        case KFAAttributeAlignmentButtom:
            attachmentOriginY = lineBottomY;
    }
    CGRect rect = CGRectMake(lineOrigin.x + xOffset, attachmentOriginY, width, attachmentHeight);
    
    // 待确认目的
    UIEdgeInsets flippedMargins = _attachment.margin;
    CGFloat top = flippedMargins.top;
    flippedMargins.top = flippedMargins.bottom;
    flippedMargins.bottom = top;
    
    CGRect attachmentRect = UIEdgeInsetsInsetRect(rect, flippedMargins);
    
    if (_attachment.content.superview == nil) {
        [self addSubview:_attachment.content];
    }
    CGRect viewFrame = CGRectMake(attachmentRect.origin.x,
                                  self.bounds.size.height - attachmentRect.origin.y - attachmentRect.size.height,
                                  attachmentRect.size.width,
                                  attachmentRect.size.height);
    _attachment.content.frame = viewFrame;
}

- (void)drawText:(NSAttributedString *)attributedString rect:(CGRect)rect context:(CGContextRef)context {
    if (nil == _textFrame) {
        return;
    }
    NSInteger numberOfLines = [self numberOfDisplayedLines];
    if (numberOfLines > 0) {
        CFArrayRef lines = CTFrameGetLines(_textFrame);
        
        CGPoint lineOrigins[numberOfLines];
        CTFrameGetLineOrigins(_textFrame, CFRangeMake(0, numberOfLines), lineOrigins);
        
        for (CFIndex lineIndex = 0; lineIndex < numberOfLines; lineIndex++) {
            CGPoint lineOrigin = lineOrigins[lineIndex];
            CGContextSetTextPosition(context, lineOrigin.x, lineOrigin.y);
            CTLineRef line = CFArrayGetValueAtIndex(lines, lineIndex);
            
            CGFloat descent = 0.0f;
            CTLineGetTypographicBounds((CTLineRef)line, NULL, &descent, NULL);
            
            BOOL shouldDrawLine = YES;
            if (lineIndex == numberOfLines - 1) {
                CFRange lastLineRange = CTLineGetStringRange(line);
                if (lastLineRange.location + lastLineRange.length < attributedString.length) {
                    
                    CFIndex replaceNum = _attachment?4:1;
                    
                    CTLineTruncationType truncationType = kCTLineTruncationEnd;
                    NSUInteger truncationAttributePosition = lastLineRange.location + lastLineRange.length - replaceNum;
                    NSDictionary *tokenAttributes = [attributedString attributesAtIndex:truncationAttributePosition effectiveRange:NULL];
                    NSAttributedString *tokenString = [[NSAttributedString alloc] initWithString:kEllipsesCharacter attributes:tokenAttributes];
                    CTLineRef truncationToken = CTLineCreateWithAttributedString((CFAttributedStringRef)tokenString);
                    NSMutableAttributedString *truncationString = [[attributedString attributedSubstringFromRange:NSMakeRange(lastLineRange.location, lastLineRange.length)] mutableCopy];
                    if (lastLineRange.length > 0) {
                        [truncationString deleteCharactersInRange:NSMakeRange(lastLineRange.length-replaceNum, replaceNum)];
                    }
                    [truncationString appendAttributedString:tokenString];
                    
                    CTLineRef truncationLine = CTLineCreateWithAttributedString((CFAttributedStringRef)truncationString);
                    CTLineRef truncatedLine = CTLineCreateTruncatedLine(truncationLine, rect.size.width, truncationType, truncationToken);
                    if (!truncatedLine) {
                        truncatedLine = CFRetain(truncationToken);
                    }
                    
                    CGContextSetTextPosition(context, lineOrigin.x, lineOrigin.y - descent - _font.descender);
                    CTLineDraw(truncatedLine, context);
                    
                    CFRelease(truncationLine);
                    CFRelease(truncationToken);
                    CFRelease(truncatedLine);
                    shouldDrawLine = NO;
                }
            }
            if (shouldDrawLine) {
                CGContextSetTextPosition(context, lineOrigin.x, lineOrigin.y - descent - _font.descender);
                CTLineDraw(line, context);
            }
        }
    } else {
        CTFrameDraw(_textFrame, context);
    }
}

- (NSInteger)numberOfDisplayedLines {
    CFArrayRef lines = CTFrameGetLines(_textFrame);
    return _numberOfLines > 0 ? MIN(CFArrayGetCount(lines),_numberOfLines) : CFArrayGetCount(lines);
}

@end


@implementation KFAAttributeLabelAttachment

+ (KFAAttributeLabelAttachment *)attachmentWith:(UIView *)content margin:(UIEdgeInsets)margin alignment:(KFAAttributeAlignment)alignment {
    KFAAttributeLabelAttachment *attachment = [[KFAAttributeLabelAttachment alloc] init];
    attachment.content = content;
    attachment.margin = margin;
    attachment.alignment = alignment;
    return attachment;
}

- (CGSize)boxSize {
    CGSize contentSize = _content.bounds.size;
    return CGSizeMake(contentSize.width + _margin.left + _margin.right,
                      contentSize.height + _margin.top + _margin.bottom);
}

@end

