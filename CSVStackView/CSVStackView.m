/*
 * This file is part of the CSVStackView package.
 * (c) Evgenyi Tyulenev <9koks9@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "CSVStackView.h"

@interface CSVStackView()<UIGestureRecognizerDelegate>

@property (nonatomic, strong)    UIPanGestureRecognizer * panRecognizer;
@property (nonatomic, strong)    UITapGestureRecognizer * tapRecognizer;
@property (nonatomic, strong)    NSMutableArray *viewRects;
@property (nonatomic)            NSInteger countOfViews;
@property (nonatomic)            NSInteger currentIndex;
@property (nonatomic)            CGFloat firstX;
@property (nonatomic)            CGFloat firstY;
@property (nonatomic)            CGFloat shift;

@end

@implementation CSVStackView

-(id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]){
        _panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        _viewRects = [NSMutableArray array];
    }
    return self;
}

#pragma mark - public methods

-(void)reloadData {
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _currentIndex = 0;
    _countOfViews = [_delegate numberOfViews];
    
    if([_shiftDelegate respondsToSelector:@selector(sizeOfShiftStack)]){
        _shift = [_shiftDelegate sizeOfShiftStack];
    }
    
    [_viewRects removeAllObjects];
    
    for (NSInteger i = 0; i < _countOfViews; i++) {
        UIView *stackView = [_delegate stackView:self viewForRowAtIndex:i];
        [self insertViewInStackWithView:stackView andIndex:i];
    }
    
    [self gestureUpdate];
}

-(void)insertViewInStackWithView:(UIView*)view andIndex:(NSInteger)index {

    if(_shift && [_shiftDelegate respondsToSelector:@selector(stackItem:rectViewAtIndex:andShift:)]) {
        CGRect frame = [_shiftDelegate stackItem:view rectViewAtIndex:index andShift:_shift];
        [view setFrame:frame];
    }
    
    [_viewRects insertObject:NSStringFromCGRect(view.frame) atIndex:0];
    [self insertSubview:view atIndex:0];
}

-(void)gestureUpdate {
    [[[self subviews] lastObject] addGestureRecognizer:_panRecognizer];
    [[[self subviews] lastObject] addGestureRecognizer:_tapRecognizer];
}

#pragma mark - UIPanGestureRecognizer

- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer {
    
    __block CGPoint translation = [recognizer translationInView:recognizer.view];
    
    if([recognizer state] == UIGestureRecognizerStateBegan) {
        _firstX = [recognizer.view center].x;
        _firstY = [recognizer.view center].y;
    }
    
    translation = CGPointMake(_firstX+translation.x, _firstY+translation.y);
    [recognizer.view setCenter:translation];
    
    if([recognizer state] == UIGestureRecognizerStateEnded) {
        
        BOOL isSliding = NO;
        
        CGFloat distance = [self distanceBetweenTwoPoints:CGPointMake(_firstX, _firstY) toPoint:translation];
        if (distance > MIN(CGRectGetHeight(recognizer.view.frame), CGRectGetWidth(recognizer.view.frame)) / 2) {
            [self insertSubview:recognizer.view atIndex:0];
            _currentIndex = _currentIndex >= (_countOfViews - 1) ? 0 : _currentIndex + 1;
            isSliding = YES;
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            
            if(_shift && isSliding) {
                for (NSInteger i = 0; i < [[self subviews] count]; i++) {
                    CGRect rect = CGRectFromString(_viewRects[i]);
                    UIView *view = [self subviews][i];
                    [view setFrame:rect];
                }
            } else {
                translation = CGPointMake(_firstX, _firstY);
                [recognizer.view setCenter:translation];
            }
            
        } completion:^(BOOL finished) {
             [self gestureUpdate];
        }];
    }
}

- (IBAction)handleTap:(UIPanGestureRecognizer *)recognizer {
    if([_delegate respondsToSelector:@selector(stackView:didSelectViewAtIndex:)])
        [_delegate stackView:self didSelectViewAtIndex:_currentIndex];
}

#pragma mark - CGPoint helper

- (CGFloat)distanceBetweenTwoPoints:(CGPoint)fromPoint toPoint:(CGPoint)toPoint
{
    float xDist = fromPoint.x - toPoint.x;
    float yDist = fromPoint.y - toPoint.y;
    
    float result = sqrt( pow(xDist,2) + pow(yDist,2) );
    return result;
}

@end
