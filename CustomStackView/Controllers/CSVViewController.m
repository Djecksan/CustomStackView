/*
 * This file is part of the CSVStackView package.
 * (c) Evgenyi Tyulenev <9koks9@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "CSVViewController.h"
#import "CSVStackView.h"

@interface CSVViewController ()<CSVStackViewDelegate, CSVStackViewShiftDelegate>
@property (weak, nonatomic) IBOutlet CSVStackView *stack;
@end

@implementation CSVViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_stack setShiftDelegate:self];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_stack reloadData];
   
}

#pragma mark - CSVStackViewDelegate

-(NSInteger)numberOfViews {
    return 4;
}

-(UIView *)stackView:(CSVStackView *)stackView viewForRowAtIndex:(NSInteger)index {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 300)];
    [view setCenter:CGPointMake(stackView.center.x, stackView.center.y) ];
    [view setBackgroundColor:[UIColor blueColor]];
    view.layer.borderColor = [UIColor whiteColor].CGColor;
    view.layer.borderWidth = 1.0f;
    
    view.layer.shadowOffset = CGSizeMake(-5, -5);
    view.layer.shadowRadius = 3;
    view.layer.shadowOpacity = 0.1;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 300)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor whiteColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setText:[NSString stringWithFormat:@"%@", @(index)]];
    [label setFont:[UIFont fontWithName:@"HelveticaNeue" size:50]];
    
    [view addSubview:label];
    
    return view;
}

-(void)stackView:(CSVStackView *)stackView didSelectViewAtIndex:(NSInteger)index {
    NSLog(@"Вы тапнули на View под индексом: %@", @(index));
}

#pragma mark - CSVStackViewShiftDelegate

-(CGFloat)sizeOfShiftStack {
    return 20.0f;
}

-(CGRect)stackItem:(UIView *)stackItem rectViewAtIndex:(NSInteger)index andShift:(CGFloat)shift {
    CGSize newSize = [self sizeByShiftWidth:shift * index andSize:stackItem.frame.size];
    CGPoint newPoint = [self pointByShift:shift * index andPoint:stackItem.center];
    return CGRectMake(newPoint.x - (newSize.width / 2), newPoint.y - (newSize.height / 2), newSize.width, newSize.height);
}

-(CGPoint)pointByShift:(CGFloat)shift andPoint:(CGPoint)point {
    return CGPointMake(point.x, point.y - shift * 1.3);
}

-(CGSize)sizeByShiftWidth : (CGFloat)shift andSize:(CGSize)size {
    
    CGFloat k = (size.width - shift) / size.width;
    CGFloat new_width = k * size.width;
    CGFloat new_height = k * size.height;
    
    return CGSizeMake(new_width, new_height);
}

@end