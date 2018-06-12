//
//  XNPromptStatusLabel.m
//  TestChoose
//
//  Created by Ntalker on 16/3/11.
//  Copyright © 2016年 NTalker. All rights reserved.
//

#import "XNPromptStatusLabel.h"
#import <CoreText/CoreText.h>

@interface XNPromptStatusLabel ()

@property(nonatomic) NSRange highlightedRange;
@property (copy, nonatomic) clickedBlock clickedBlock;
@property (strong, nonatomic) NSMutableArray *clickTexts;

@end

@implementation XNPromptStatusLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.clickTexts = [[NSMutableArray alloc] init];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
        self.clickTexts = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    for (NSString *str in _clickTexts) {
        
        NSRange range = [self.text rangeOfString:str];
        
        CFIndex index = [self characterIndexAtPoint:point];
        if (index >= range.location && index <= range.location + range.length - 1) {
            [self highlightWordContainingCharacterAtRange:range];
            if (_clickedBlock) {
                self.clickedBlock(str);
            }
        }
    }
    [self performSelector:@selector(removeHighlight) withObject:nil afterDelay:0.5];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
}

- (void)removeHighlight {
    
    if (self.highlightedRange.location != NSNotFound) {
        
        //remove highlight from previously selected word
        NSMutableAttributedString* attributedString = [self.attributedText mutableCopy];
        [attributedString removeAttribute:NSBackgroundColorAttributeName range:self.highlightedRange];
        self.attributedText = attributedString;
        self.highlightedRange = NSMakeRange(NSNotFound, 0);
    }
}

- (void)highlightWordContainingCharacterAtRange:(NSRange)range {
    
    NSRange wordRange = range;
    
    if (wordRange.location == self.highlightedRange.location) {
        return; //this word is already highlighted
    }
    else {
        [self removeHighlight]; //remove highlight on previously selected word
    }
    
    self.highlightedRange = wordRange;
    
    //highlight selected word
    NSMutableAttributedString* attributedString = [self.attributedText mutableCopy];
    [attributedString addAttribute:NSBackgroundColorAttributeName value:[UIColor lightGrayColor] range:wordRange];
    self.attributedText = attributedString;
}

- (CGRect)textRect {
    
    CGRect textRect = [self textRectForBounds:self.bounds limitedToNumberOfLines:self.numberOfLines];
    textRect.origin.y = (self.bounds.size.height - textRect.size.height)/2;
    
    if (self.textAlignment == NSTextAlignmentCenter) {
        textRect.origin.x = (self.bounds.size.width - textRect.size.width)/2;
    }
    if (self.textAlignment == NSTextAlignmentRight) {
        textRect.origin.x = self.bounds.size.width - textRect.size.width;
    }
    
    return textRect;
}

- (CFIndex)characterIndexAtPoint:(CGPoint)point {
    NSMutableAttributedString* optimizedAttributedText = [self.attributedText mutableCopy];
    [self.attributedText enumerateAttribute:(NSString*)kCTParagraphStyleAttributeName
                                    inRange:NSMakeRange(0, [optimizedAttributedText length])
                                    options:0
                                 usingBlock:^(id value, NSRange range, BOOL *stop) {
                                     
                                     NSMutableParagraphStyle* paragraphStyle = [value mutableCopy];
                                     if ([paragraphStyle lineBreakMode] == kCTLineBreakByTruncatingTail) {
                                         [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
                                     }
                                     
                                     [optimizedAttributedText removeAttribute:(NSString*)kCTParagraphStyleAttributeName range:range];
                                     [optimizedAttributedText addAttribute:(NSString*)kCTParagraphStyleAttributeName value:paragraphStyle range:range];
                                     
                                 }];
    if (!CGRectContainsPoint(self.bounds, point)) {
        return NSNotFound;
    }
    
    CGRect textRect = [self textRect];
    
    if (!CGRectContainsPoint(textRect, point)) {
        return NSNotFound;
    }
    
    // Offset tap coordinates by textRect origin to make them relative to the origin of frame
    point = CGPointMake(point.x - textRect.origin.x, point.y - textRect.origin.y);
    // Convert tap coordinates (start at top left) to CT coordinates (start at bottom left)
    point = CGPointMake(point.x, textRect.size.height - point.y);
    
    //////
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)optimizedAttributedText);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, textRect);
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [self.attributedText length]), path, NULL);
    
    CFRelease(framesetter);
    
    if (frame == NULL) {
        CFRelease(path);
        return NSNotFound;
    }
    
    CFArrayRef lines = CTFrameGetLines(frame);
    
    NSInteger numberOfLines = self.numberOfLines > 0 ? MIN(self.numberOfLines, CFArrayGetCount(lines)) : CFArrayGetCount(lines);
    
    if (numberOfLines == 0) {
        CFRelease(frame);
        CFRelease(path);
        return NSNotFound;
    }
    
    NSUInteger idx = NSNotFound;
    
    CGPoint lineOrigins[numberOfLines];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, numberOfLines), lineOrigins);
    
    for (CFIndex lineIndex = 0; lineIndex < numberOfLines; lineIndex++) {
        
        CGPoint lineOrigin = lineOrigins[lineIndex];
        CTLineRef line = CFArrayGetValueAtIndex(lines, lineIndex);
        
        // Get bounding information of line
        CGFloat ascent, descent, leading, width;
        width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        CGFloat yMin = floor(lineOrigin.y - descent);
        CGFloat yMax = ceil(lineOrigin.y + ascent);
        
        // Check if we've already passed the line
        if (point.y > yMax) {
            break;
        }
        
        // Check if the point is within this line vertically
        if (point.y >= yMin) {
            
            // Check if the point is within this line horizontally
            if (point.x >= lineOrigin.x && point.x <= lineOrigin.x + width) {
                
                // Convert CT coordinates to line-relative coordinates
                CGPoint relativePoint = CGPointMake(point.x - lineOrigin.x, point.y - lineOrigin.y);
                idx = CTLineGetStringIndexForPosition(line, relativePoint);
                
                break;
            }
        }
    }
    
    CFRelease(frame);
    CFRelease(path);
    return idx - 1;
}

- (void)setNeedClickedArray:(NSArray *)needClickedArray
{
    if (!_needClickedArray) {
        self.clickTexts = [[NSMutableArray alloc] initWithArray:needClickedArray];
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
    NSParagraphStyle *style = [NSParagraphStyle defaultParagraphStyle];
    [attributedString addAttribute:(NSString*)kCTParagraphStyleAttributeName value:style range:NSMakeRange(0, self.text.length)];
    [attributedString addAttributes:@{NSFontAttributeName:self.font} range:NSMakeRange(0, self.text.length)];
    
    for (NSString *str in needClickedArray) {
        if ([str isKindOfClass:[NSString class]]) {
            if ([self.text rangeOfString:str].location != NSNotFound) {
                
                NSRange range = [self.text rangeOfString:str];
                
                [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:range];
            }
        }
    }
    
    self.attributedText = attributedString;
    self.textAlignment = NSTextAlignmentCenter;
    
    _needClickedArray = needClickedArray;
}

- (void)addBlock:(clickedBlock)block
{
    self.clickedBlock = block;
}

@end
