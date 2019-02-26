//
//  CBSegmentView2.h
//  GardenCoceral
//
//  Created by shiliuhua on 2018/4/17.
//  Copyright © 2018年 tongna. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^titleChooseBlock)(NSInteger x);

typedef NS_ENUM(NSInteger, CBSegmentStyle2) {
    /**
     * By default, there is a slider on the bottom.
     */
    CBSegmentStyleSlider2 = 0,
    /**
     * This flag will zoom the selected text label.
     */
    CBSegmentStyleZoom2   = 1,
};

@interface CBSegmentView2 : UIScrollView

@property (nonatomic, copy) titleChooseBlock titleChooseReturn;
/**
 * Set segment titles and titleColor.
 *
 * @param titleArray The titles segment will show.
 */
- (void)setTitleArray:(NSArray<NSString *> *)titleArray;

/**
 * Set segment titles and titleColor.
 *
 * @param titleArray The titles segment will show.
 * @param style The segment style.
 */
- (void)setTitleArray:(NSArray<NSString *> *)titleArray withStyle:(CBSegmentStyle2)style;

/**
 * Set segment titles and titleColor.
 *
 * @param titleArray The titles segment will show.
 * @param titleColor The normal title color.
 * @param selectedColor The selected title color.
 * @param style The segment style.
 */
- (void)setTitleArray:(NSArray<NSString *> *)titleArray
            titleFont:(CGFloat)font
           titleColor:(UIColor *)titleColor
   titleSelectedColor:(UIColor *)selectedColor
            withStyle:(CBSegmentStyle2)style;

@end

@interface UIView (CBViewFrame)

@property (nonatomic, assign) CGFloat cb_Width;

@property (nonatomic, assign) CGFloat cb_Height;

@property (nonatomic, assign) CGFloat cb_CenterX;

@property (nonatomic, assign) CGFloat cb_CenterY;


@end
