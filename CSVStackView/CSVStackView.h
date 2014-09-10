/*
 * This file is part of the CSVStackView package.
 * (c) Evgenyi Tyulenev <9koks9@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <UIKit/UIKit.h>
@class CSVStackView;

NS_ENUM(NSInteger, CSVStackViewTypeSliding) {
    CSVStackViewTypeSlidingDefault,
    CSVStackViewTypeSlidingHorizontal
};

@protocol CSVStackViewDelegate <NSObject>
- (NSInteger)numberOfViews;
- (UIView *)stackView:(CSVStackView *)stackView viewForRowAtIndex:(NSInteger)index;
@optional
-(void)stackView:(CSVStackView *)stackView didSelectViewAtIndex:(NSInteger)index;
-(void)stackView:(CSVStackView *)stackView willChangeViewAtIndex:(NSInteger)index;
-(void)stackView:(CSVStackView *)stackView didChangeViewAtIndex:(NSInteger)index;
@end

@protocol CSVStackViewShiftDelegate <NSObject>
-(CGFloat)sizeOfShiftStack;
-(CGRect)stackItem:(UIView *)stackItem rectViewAtIndex:(NSInteger)index andShift:(CGFloat)shift;
@end

@interface CSVStackView : UIView
@property (weak, nonatomic) IBOutlet id<CSVStackViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet id<CSVStackViewShiftDelegate> shiftDelegate;

@property (nonatomic)                                      enum CSVStackViewTypeSliding typeSliding;
@property (nonatomic, getter = isSlidingTransparentEffect) BOOL slidingTransparentEffect;

-(void)reloadData;
@end