//
//  CBSegmentView2.m
//  GardenCoceral
//
//  Created by shiliuhua on 2018/4/17.
//  Copyright © 2018年 tongna. All rights reserved.
//

#import "CBSegmentView2.h"

@interface CBSegmentView2 ()<UIScrollViewDelegate>
/**
 *  configuration.
 */
{
    CGFloat _HeaderH;
    UIColor *_titleColor;
    UIColor *_titleSelectedColor;
    CBSegmentStyle2 _SegmentStyle;
    CGFloat _titleFont;
}
/**
 *  The bottom red slider.
 */
@property (nonatomic, weak) UIView *slider;

@property (nonatomic, strong) NSMutableArray *titleWidthArray;

@property (nonatomic, weak) UIButton *selectedBtn;

@end

#define CBColorA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define CBScreenH [UIScreen mainScreen].bounds.size.height
#define CBScreenW [UIScreen mainScreen].bounds.size.width
@implementation CBSegmentView2

#pragma mark - delayLoading
- (NSMutableArray *)titleWidthArray {
    if (!_titleWidthArray) {
        _titleWidthArray = [NSMutableArray new];
    }
    return _titleWidthArray;
}

#pragma mark - Initialization
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.bounces = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.scrollEnabled = NO;
        self.layer.borderColor = CBColorA(204, 204, 204, 1).CGColor;
        self.layer.borderWidth = 0.5;
        
        _HeaderH = frame.size.height;
        _SegmentStyle = CBSegmentStyleSlider2;
        _titleColor = [UIColor darkTextColor];
        _titleSelectedColor = CBColorA(199, 13, 23, 1);
        _titleFont = 15;
    }
    return self;
}

- (void)setTitleArray:(NSArray<NSString *> *)titleArray {
    [self setTitleArray:titleArray withStyle:0];
}

- (void)setTitleArray:(NSArray<NSString *> *)titleArray withStyle:(CBSegmentStyle2)style {
    [self setTitleArray:titleArray titleFont:0 titleColor:nil titleSelectedColor:nil withStyle:style];
}

- (void)setTitleArray:(NSArray<NSString *> *)titleArray
            titleFont:(CGFloat)font
           titleColor:(UIColor *)titleColor
   titleSelectedColor:(UIColor *)selectedColor
            withStyle:(CBSegmentStyle2)style {
    
    //    set style
    if (style != 0) {
        _SegmentStyle = style;
    }
    if (font != 0) {
        _titleFont = font;
    }
    if (titleColor) {
        _titleColor = titleColor;
    }
    if (selectedColor) {
        _titleSelectedColor = selectedColor;
    }
    
    if (style == CBSegmentStyleSlider2) {
        UIView *slider = [[UIView alloc]init];
        slider.frame = CGRectMake(0, _HeaderH-2, 0, 2);
        slider.backgroundColor = _titleSelectedColor;
        [self addSubview:slider];
        self.slider = slider;
    }
    
    [self.titleWidthArray removeAllObjects];
    CGFloat totalWidth = 15;
    CGFloat btnSpace = 15;
    for (NSInteger i = 0; i<titleArray.count; i++) {
        //        cache title width
        CGFloat titleWidth = [self widthOfTitle:titleArray[i] titleFont:_titleFont];
        [self.titleWidthArray addObject:[NSNumber numberWithFloat:titleWidth]];
        //        creat button
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:btn];
        CGFloat btnW = (CBScreenW - (titleArray.count + 1) * btnSpace) / titleArray.count ;
        btn.frame =  CGRectMake(totalWidth, 0.5, btnW, _HeaderH-0.5-2);
        btn.contentMode = UIViewContentModeCenter;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.tag = i;
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:_titleColor forState:UIControlStateNormal];
        [btn setTitleColor:_titleSelectedColor forState:UIControlStateSelected];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:_titleFont]];
        [btn addTarget:self action:@selector(titleButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        totalWidth = totalWidth+btnW+btnSpace;
        
        if (i == 0) {
            btn.selected = YES;
            self.selectedBtn = btn;
            if (_SegmentStyle == CBSegmentStyleSlider2) {
                self.slider.cb_Width = titleWidth;
                self.slider.cb_CenterX = btn.cb_CenterX;
            }else if (_SegmentStyle == CBSegmentStyleZoom2) {
                self.selectedBtn.transform = CGAffineTransformMakeScale(1.3, 1.3);
            }
        }
    }
    totalWidth = totalWidth+btnSpace;
    self.contentSize = CGSizeMake(totalWidth, 0);
}

//  button click
- (void)titleButtonSelected:(UIButton *)btn {
    self.selectedBtn.selected = NO;
    btn.selected = YES;
    if (_SegmentStyle == CBSegmentStyleSlider2) {
        NSNumber* sliderWidth = self.titleWidthArray[btn.tag];
        [UIView animateWithDuration:0.2 animations:^{
            self.slider.cb_Width = sliderWidth.floatValue;
            self.slider.cb_CenterX = btn.cb_CenterX;
        }];
    }else if (_SegmentStyle == CBSegmentStyleZoom2) {
        [UIView animateWithDuration:0.2 animations:^{
            self.selectedBtn.transform = CGAffineTransformIdentity;
            btn.transform = CGAffineTransformMakeScale(1.3, 1.3);
            
        }];
    }
    self.selectedBtn = btn;
    CGFloat offsetX = btn.cb_CenterX - self.frame.size.width*0.5;
    if (offsetX<0) {
        offsetX = 0;
    }
//    if (offsetX>self.contentSize.width-self.frame.size.width) {
//        offsetX = self.contentSize.width-self.frame.size.width;
//    }
    if (self.contentSize.width>self.frame.size.width) {
        if (offsetX>self.contentSize.width-self.frame.size.width) {
            offsetX = self.contentSize.width-self.frame.size.width;
            
        }
    }
  //  [self setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    if (self.titleChooseReturn) {
        self.titleChooseReturn(btn.tag);
    }
}
//  cache title width
- (CGFloat)widthOfTitle:(NSString *)title titleFont:(CGFloat)titleFont {
    CGSize titleSize = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, _HeaderH-2)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:titleFont] forKey:NSFontAttributeName]
                                           context:nil].size;
    return titleSize.width;
}

@end

@implementation UIView (CBViewFrame)

- (void)setCb_Width:(CGFloat)cb_Width {
    CGRect frame = self.frame;
    frame.size.width = cb_Width;
    self.frame = frame;
}

- (CGFloat)cb_Width {
    return self.frame.size.width;
}

- (void)setCb_Height:(CGFloat)cb_Height {
    CGRect frame = self.frame;
    frame.size.height = cb_Height;
    self.frame = frame;
}

- (CGFloat)cb_Height {
    return self.frame.size.height;
}

- (void)setCb_CenterX:(CGFloat)cb_CenterX {
    CGPoint center = self.center;
    center.x = cb_CenterX;
    self.center = center;
}

- (CGFloat)cb_CenterX {
    return self.center.x;
}

- (void)setCb_CenterY:(CGFloat)cb_CenterY {
    CGPoint center = self.center;
    center.y = cb_CenterY;
    self.center = center;
}

- (CGFloat)cb_CenterY {
    return self.center.y;
}

@end
