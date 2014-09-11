CustomStackView
===============

### Installation with CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries like CustomStackView in your projects.

#### Podfile

```ruby
platform :ios, '7.0'
pod "CustomStackView", "~> 1.0.1"
```

### Initialization
```objective-c
#import "CSVViewController.h"
#import "CSVStackView.h"

@interface CSVViewController ()<CSVStackViewDelegate, CSVStackViewShiftDelegate>
@property (weak, nonatomic) IBOutlet CSVStackView *stack;
@end

//init
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_stack setDelegate:self];
    [_stack setShiftDelegate:self];
    [_stack setSlidingTransparentEffect:YES];
    [_stack setTypeSliding:CSVStackViewTypeSlidingHorizontal];
}

//reloadData after loading of the representation
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_stack reloadData];
}
```

### CSVStackViewDelegate

```objective-c

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
    
    //Magic text scale
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[self imageFromView:label]];
    [imageV setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [view addSubview:imageV];
    
    return view;
}

-(void)stackView:(CSVStackView *)stackView didSelectViewAtIndex:(NSInteger)index {
    NSLog(@"didSelectViewAtIndex: %@", @(index));
}

-(void)stackView:(CSVStackView *)stackView willChangeViewAtIndex:(NSInteger)index {
    NSLog(@"willChangeViewAtIndex: %@", @(index));
}

-(void)stackView:(CSVStackView *)stackView didChangeViewAtIndex:(NSInteger)index {
    NSLog(@"didChangeViewAtIndex: %@", @(index));
}

```

### CSVStackViewShiftDelegate

```objective-c

#pragma mark - CSVStackViewShiftDelegate

-(CGFloat)sizeOfShiftStack {
    return 20.0f;
}

-(CGRect)stackItem:(UIView *)stackItem rectViewAtIndex:(NSInteger)index andShift:(CGFloat)shift {
    CGSize newSize = [self sizeByShiftWidth:shift * index andSize:stackItem.frame.size];
    CGPoint newPoint = [self pointByShift:shift * index andPoint:stackItem.center];
    return CGRectMake(newPoint.x - (newSize.width / 2), newPoint.y - (newSize.height / 2), newSize.width, newSize.height);
}

```

<p align="center" >
  <img src="https://raw.githubusercontent.com/Djecksan/CustomStackView/master/Images/defaultAlpha.gif" alt="CustomStackView" title="CustomStackView">
</p>

<p align="center" >
  <img src="https://raw.githubusercontent.com/Djecksan/CustomStackView/master/Images/default.gif" alt="CustomStackView" title="CustomStackView">
</p>

<p align="center" >
  <img src="https://raw.githubusercontent.com/Djecksan/CustomStackView/master/Images/horizontalAlpha.gif" alt="CustomStackView" title="CustomStackView">
</p>

<p align="center" >
  <img src="https://raw.githubusercontent.com/Djecksan/CustomStackView/master/Images/horizontalNoAlpha.gif" alt="CustomStackView" title="CustomStackView">
</p>

<p align="center" >
  <img src="https://raw.githubusercontent.com/Djecksan/CustomStackView/master/Images/noShiftHorizontalAlpha.gif" alt="CustomStackView" title="CustomStackView">
</p>
