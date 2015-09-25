//  Copyright © 2015 Bridger Maxwell. All rights reserved.

#import "SLStackLayout.h"
#import "UIView+StackLayout.h"

NS_ASSUME_NONNULL_BEGIN

@interface SLStackLayout ()

@property (readonly) BOOL isHorizontal;
@property (readonly) NSLayoutAttribute majorLeadingAttribute;
@property (readonly) NSLayoutAttribute majorTrailingAttribute;
@property (readonly) NSLayoutAttribute majorLeadingMarginAttribute;
@property (readonly) NSLayoutAttribute majorTrailingMarginAttribute;

@property (readonly) NSLayoutAttribute minorLeadingAttribute;
@property (readonly) NSLayoutAttribute minorTrailingAttribute;
@property (readonly) NSLayoutAttribute minorLeadingMarginAttribute;
@property (readonly) NSLayoutAttribute minorTrailingMarginAttribute;

@property (readonly) NSLayoutAttribute majorSizeAttribute;
@property (readonly) NSLayoutAttribute majorCenterAttribute;

@property (readonly) NSLayoutAttribute minorSizeAttribute;
@property (readonly) NSLayoutAttribute minorCenterAttribute;

@property (readonly) UIView *leadingView;
@property (readonly) UIView *trailingView;

@property (nonatomic) NSArray *spacingConstraints;
@property (nonatomic) NSLayoutConstraint *majorLeadingMarginConstraint;
@property (nonatomic) NSLayoutConstraint *majorTrailingMarginConstraint;
@property (nonatomic) NSArray<NSLayoutConstraint *> *minorLeadingMarginConstraints;
@property (nonatomic) NSArray<NSLayoutConstraint *> *minorTrailingMarginConstraints;

@property (nonatomic, nullable) NSArray<NSLayoutConstraint *> *majorAlignmentConstraints;
@property (nonatomic, nullable) NSArray<UIView *> *majorAlignmentHelperViews;
@property (nonatomic) NSArray<NSLayoutConstraint *> *minorAlignmentConstraints;

@property (nonatomic) CGFloat majorLeadingMargin;
@property (nonatomic) CGFloat majorTrailingMargin;
@property (nonatomic) CGFloat minorLeadingMargin;
@property (nonatomic) CGFloat minorTrailingMargin;

@property (nonatomic) ALAlignment majorAlignment;
@property (nonatomic) ALAlignment minorAlignment;

// These are all the public properties that have just been marked readwrite
@property (readwrite) NSArray<UIView *> *views;
@property (readwrite, weak, nullable) UIView *superview;

@end

@implementation SLStackLayout

- (BOOL)isHorizontal
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (NSLayoutAttribute)majorLeadingAttribute
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (NSLayoutAttribute)majorTrailingAttribute
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (NSLayoutAttribute)majorLeadingMarginAttribute
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (NSLayoutAttribute)majorTrailingMarginAttribute
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (NSLayoutAttribute)minorLeadingAttribute
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (NSLayoutAttribute)minorTrailingAttribute
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (NSLayoutAttribute)minorLeadingMarginAttribute
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (NSLayoutAttribute)minorTrailingMarginAttribute
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (NSLayoutAttribute)majorSizeAttribute
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (NSLayoutAttribute)majorCenterAttribute
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (NSLayoutAttribute)minorSizeAttribute
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (NSLayoutAttribute)minorCenterAttribute
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (instancetype)initWithViews:(NSArray<UIView *> *)subviews inSuperview:(UIView *)superview
{
    if (subviews.count == 0) {
        [NSException raise:NSInvalidArgumentException format:@"there must be at least one view in a layout"];
    }
    
    if (self = [super init]) {
        self.views = subviews;
        self.superview = superview;
        
        // The alignment priority is high, but not required. This is so it very strongly tries to align,
        // but won't override the margin constraints (which are required)
        _alignmentPriority = UILayoutPriorityDefaultHigh;
        
        NSMutableArray *spacingConstraints = [NSMutableArray new];
        UIView *previousSubview = nil;
        for (UIView *subview in self.views) {
            if (previousSubview) {
                // subview.leading = previousSubview.trailing + spacing
                NSLayoutConstraint *spaceConstraint = [previousSubview sl_constraintWithSpace:self.spacing followedByView:subview isHorizontal:self.isHorizontal];
                [spacingConstraints addObject:spaceConstraint];
                spaceConstraint.active = true;
            }
            previousSubview = subview;
        }
        self.spacingConstraints = spacingConstraints;
        
        [self rebuildMajorLeadingConstraint];
        [self rebuildMajorTrailingConstraint];
        [self rebuildMinorLeadingConstraints];
        [self rebuildMinorTrailingConstraints];
    }
    return self;
}

- (void)rebuildMajorLeadingConstraint
{
    self.majorLeadingMarginConstraint.active = false;

    NSLayoutAttribute marginAttribute = (self.isLayoutMarginsRelativeArrangement
                                              ? self.majorLeadingMarginAttribute
                                              : self.majorLeadingAttribute);
    
    // leadingView.leading >= superview.leadingMargin + margin
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.leadingView attribute:self.majorLeadingAttribute relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.superview attribute:marginAttribute multiplier:1.0 constant:self.majorLeadingMargin];
    constraint.active = true;
    
    self.majorLeadingMarginConstraint = constraint;
}

- (void)rebuildMajorTrailingConstraint
{
    self.majorTrailingMarginConstraint.active = false;
    
    NSLayoutAttribute marginAttribute = (self.isLayoutMarginsRelativeArrangement
                                              ? self.majorTrailingMarginAttribute
                                              : self.majorTrailingAttribute);
    
    // superview.trailingMargin >= trailingView.trailing + margin
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.superview attribute:marginAttribute relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.trailingView attribute:self.majorTrailingAttribute multiplier:1.0 constant:self.majorTrailingMargin];
    constraint.active = true;
    
    self.majorTrailingMarginConstraint = constraint;
}

- (void)rebuildMinorLeadingConstraints
{
    for (NSLayoutConstraint *constraint in self.minorLeadingMarginConstraints) {
        constraint.active = false;
    }
    
    NSLayoutAttribute marginAttribute = (self.isLayoutMarginsRelativeArrangement
                                         ? self.minorLeadingMarginAttribute
                                         : self.minorLeadingAttribute);
    
    NSMutableArray<NSLayoutConstraint *> *constraints = [NSMutableArray array];
    for (UIView *subview in self.views) {
        //subview.leading >= superview.leadingMargin + margin
        [constraints addObject:[NSLayoutConstraint constraintWithItem:subview attribute:self.minorLeadingAttribute relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.superview attribute:marginAttribute multiplier:1.0 constant:self.minorLeadingMargin]];
        constraints.lastObject.active = true;
    }
    
    self.minorLeadingMarginConstraints = constraints;
}


- (void)rebuildMinorTrailingConstraints
{
    for (NSLayoutConstraint *constraint in self.minorTrailingMarginConstraints) {
        constraint.active = false;
    }
    
    NSLayoutAttribute marginAttribute = (self.isLayoutMarginsRelativeArrangement
                                         ? self.minorTrailingMarginAttribute
                                         : self.minorTrailingAttribute);
    
    NSMutableArray<NSLayoutConstraint *> *constraints = [NSMutableArray array];
    for (UIView *subview in self.views) {
        //superview.trailing >= subview.trailingMargin + margin
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.superview attribute:self.minorTrailingAttribute relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:subview attribute:marginAttribute multiplier:1.0 constant:self.minorTrailingMargin]];
        constraints.lastObject.active = true;
    }
    
    self.minorTrailingMarginConstraints = constraints;
}

- (UIView *)leadingView
{
    return self.views.firstObject;
}

- (UIView *)trailingView
{
    return self.views.lastObject;
}

- (instancetype)setSpacing:(CGFloat)spacing
{
    if (_spacing != spacing) {
        _spacing = spacing;
        for (NSLayoutConstraint *spacingConstraint in self.spacingConstraints) {
            spacingConstraint.constant = spacing;
        }
    }
    return self;
}

- (void)setMajorLeadingMargin:(CGFloat)majorLeadingMargin
{
    self.majorLeadingMarginConstraint.constant = majorLeadingMargin;
}

- (void)setMajorTrailingMargin:(CGFloat)majorTrailingMargin
{
    self.majorTrailingMarginConstraint.constant = majorTrailingMargin;
}

- (void)setMinorLeadingMargin:(CGFloat)majorLeadingMargin
{
    for (NSLayoutConstraint *constraint in self.minorLeadingMarginConstraints) {
        constraint.constant = majorLeadingMargin;
    }
}

- (void)setMinorTrailingMargin:(CGFloat)majorTrailingMargin
{
    for (NSLayoutConstraint *constraint in self.minorTrailingMarginConstraints) {
        constraint.constant = majorTrailingMargin;
    }
}

- (instancetype)setLayoutMarginsRelativeArrangement:(BOOL)layoutMarginsRelativeArrangement
{
    if (_layoutMarginsRelativeArrangement != layoutMarginsRelativeArrangement) {
        _layoutMarginsRelativeArrangement = layoutMarginsRelativeArrangement;
        
        [self rebuildMajorLeadingConstraint];
        [self rebuildMajorTrailingConstraint];
        [self rebuildMinorLeadingConstraints];
        [self rebuildMinorTrailingConstraints];
    }
    return self;
}

- (void)setMajorAlignment:(ALAlignment)majorAlignment
{
    if (_majorAlignment != majorAlignment) {
        _majorAlignment = majorAlignment;
        
        // We can't change these on the fly so we need to remove them and rebuild them
        for (NSLayoutConstraint *constraint in self.majorAlignmentConstraints) {
            constraint.active = false;
        }
        for (UIView *helperView in self.majorAlignmentHelperViews) {
            [helperView removeFromSuperview];
        }
        self.majorAlignmentHelperViews = nil;
        
        NSMutableArray *constraints = [NSMutableArray array];
        switch (self.majorAlignment) {
            case ALAlignmentNone: {
                // No constraints to make
                break;
            }
            case ALAlignmentLeading: {
                // leadingView.leading = superview.leading
                [constraints addObject:[self.leadingView sl_constraintAligningAttribute:self.majorLeadingAttribute withView:self.superview]];
                
                break;
            }
            case ALAlignmentTrailing: {
                // superview.trailing = trailingView.trailing
                [constraints addObject:[self.superview sl_constraintAligningAttribute:self.majorTrailingAttribute withView:self.trailingView]];
                
                break;
            }
            case ALAlignmentFill: {
                // Make both the leading and trailing subviews try to hug the edges
                
                // leadingView.leading = superview.leading
                [constraints addObject:[self.leadingView sl_constraintAligningAttribute:self.majorLeadingAttribute withView:self.superview]];
                // superview.trailing = trailingView.trailing
                [constraints addObject:[self.superview sl_constraintAligningAttribute:self.majorTrailingAttribute withView:self.trailingView]];
                break;
            }
            case ALAlignmentCenter: {
                // This one is tricky. We place hidden "helper" views on either side of the subviews and constrain them to have equal widths
                UIView *helperLeadingView = [[UIView alloc] init];
                helperLeadingView.translatesAutoresizingMaskIntoConstraints = false;
                helperLeadingView.hidden = YES;
                
                UIView *helperTrailingView = [[UIView alloc] init];
                helperTrailingView.translatesAutoresizingMaskIntoConstraints = false;
                helperTrailingView.hidden = YES;
                
                [self.superview addSubview:helperLeadingView];
                [self.superview addSubview:helperTrailingView];
                
                // |[helperLeadingView][firstView]
                [constraints addObject:[helperLeadingView sl_constraintAligningAttribute:self.majorLeadingAttribute withView:self.superview]];
                [constraints addObject:[helperLeadingView sl_constraintWithSpace:0 followedByView:self.leadingView isHorizontal:self.isHorizontal]];

                // [trailingView][helperTrailingView]|
                [constraints addObject:[self.trailingView sl_constraintWithSpace:0 followedByView:helperTrailingView isHorizontal:self.isHorizontal]];
                [constraints addObject:[helperTrailingView sl_constraintAligningAttribute:self.majorTrailingAttribute withView:self.superview]];
                
                [constraints addObject:[helperLeadingView sl_constraintAligningAttribute:self.majorSizeAttribute withView:helperTrailingView]];
                
                self.majorAlignmentHelperViews = @[helperLeadingView, helperTrailingView];
                
                break;
            }
        }
        for (NSLayoutConstraint *constraint in constraints) {
            constraint.priority = self.alignmentPriority;
            constraint.active = YES;
        }
        
        self.majorAlignmentConstraints = constraints;
        
    }
}

- (void)setMinorAlignment:(ALAlignment)minorAlignment
{
    if (_minorAlignment != minorAlignment) {
        _minorAlignment = minorAlignment;
        
        // We can't change these on the fly so we need to remove them and rebuild them
        for (NSLayoutConstraint *constraint in self.minorAlignmentConstraints) {
            constraint.active = false;
        }
        
        NSMutableArray *constraints = [NSMutableArray array];
        switch (self.minorAlignment) {
            case ALAlignmentNone: {
                // No constraints to make
                break;
            }
            case ALAlignmentLeading: {
                for (UIView *subview in self.views) {
                    // subview.leading = superview.leading
                    [constraints addObject:[subview sl_constraintAligningAttribute:self.minorLeadingAttribute withView:self.superview]];
                }
                
                break;
            }
            case ALAlignmentTrailing: {
                for (UIView *subview in self.views) {
                    // superview.trailing = subview.trailing
                    [constraints addObject:[self.superview sl_constraintAligningAttribute:self.minorTrailingAttribute withView:subview]];
                }
                
                break;
            }
            case ALAlignmentFill: {
                // Make both the leading and trailing subviews try to hug the edges
                
                for (UIView *subview in self.views) {
                    // subview.leading = superview.leading
                    [constraints addObject:[subview sl_constraintAligningAttribute:self.minorLeadingAttribute withView:self.superview]];
                    // superview.trailing = subview.trailing
                    [constraints addObject:[self.superview sl_constraintAligningAttribute:self.minorTrailingAttribute withView:subview]];
                }
                
                break;
            }
            case ALAlignmentCenter: {
                for (UIView *subview in self.views) {
                    // superview.center = subview.center
                    [constraints addObject:[self.superview sl_constraintAligningAttribute:self.minorCenterAttribute withView:subview]];
                }
                
                break;
            }
        }
        for (NSLayoutConstraint *constraint in constraints) {
            constraint.priority = self.alignmentPriority;
            constraint.active = YES;
        }
        
        self.minorAlignmentConstraints = constraints;
        
    }
}

- (instancetype)setAlignmentPriority:(UILayoutPriority)alignmentPriority
{
    if (_alignmentPriority != alignmentPriority) {
        // Trigger a rebuild of these constraints by setting and unsetting them
        ALAlignment majorAlignment = self.majorAlignment;
        self.majorAlignment = ALAlignmentNone;
        self.majorAlignment = majorAlignment;
        
        ALAlignment minorAlignment = self.minorAlignment;
        self.minorAlignment = ALAlignmentNone;
        self.minorAlignment = minorAlignment;
    }
    return self;
}

@end


@implementation SLHorizontalStackLayout

- (BOOL)isHorizontal
{
    return YES;
}

- (NSLayoutAttribute)majorLeadingAttribute
{
    return NSLayoutAttributeLeading;
}

- (NSLayoutAttribute)majorTrailingAttribute
{
    return NSLayoutAttributeTrailing;
}

- (NSLayoutAttribute)majorLeadingMarginAttribute
{
    return NSLayoutAttributeLeadingMargin;
}

- (NSLayoutAttribute)majorTrailingMarginAttribute
{
    return NSLayoutAttributeTrailingMargin;
}

- (NSLayoutAttribute)minorLeadingAttribute
{
    return NSLayoutAttributeTop;
}

- (NSLayoutAttribute)minorTrailingAttribute
{
    return NSLayoutAttributeBottom;
}

- (NSLayoutAttribute)minorLeadingMarginAttribute
{
    return NSLayoutAttributeTopMargin;
}

- (NSLayoutAttribute)minorTrailingMarginAttribute
{
    return NSLayoutAttributeBottomMargin;
}

- (NSLayoutAttribute)majorSizeAttribute
{
    return NSLayoutAttributeWidth;
}

- (NSLayoutAttribute)majorCenterAttribute
{
    return NSLayoutAttributeCenterX;
}

- (NSLayoutAttribute)minorSizeAttribute
{
    return NSLayoutAttributeHeight;
}

- (NSLayoutAttribute)minorCenterAttribute
{
    return NSLayoutAttributeCenterY;
}

- (instancetype)setLeadingMargin:(CGFloat)margin
{
    self.majorLeadingMargin = margin;
    return self;
}
- (CGFloat)leadingMargin
{
    return self.majorLeadingMargin;
}

- (instancetype)setTrailingMargin:(CGFloat)margin
{
    self.majorTrailingMargin = margin;
    return self;
}
- (CGFloat)trailingMargin
{
    return self.majorTrailingMargin;
}

- (instancetype)setTopMargin:(CGFloat)margin
{
    self.minorLeadingMargin = margin;
    return self;
}
- (CGFloat)topMargin
{
    return self.minorLeadingMargin;
}

- (instancetype)setBottomMargin:(CGFloat)margin
{
    self.minorTrailingMargin = margin;
    return self;
}
- (CGFloat)bottomMargin
{
    return self.minorTrailingMargin;
}

- (instancetype)setHorizontalAlignment:(ALAlignment)alignment
{
    self.majorAlignment = alignment;
    return self;
}
- (ALAlignment)horizontalAlignment
{
    return self.majorAlignment;
}

- (instancetype)setVerticalAlignment:(ALAlignment)alignment
{
    self.minorAlignment = alignment;
    return self;
}
- (ALAlignment)verticalAlignment
{
    return self.minorAlignment;
}


@end


@implementation SLVerticalStackLayout

- (BOOL)isHorizontal
{
    return NO;
}

- (NSLayoutAttribute)majorLeadingAttribute
{
    return NSLayoutAttributeTop;
}

- (NSLayoutAttribute)majorTrailingAttribute
{
    return NSLayoutAttributeBottom;
}

- (NSLayoutAttribute)majorLeadingMarginAttribute
{
    return NSLayoutAttributeTopMargin;
}

- (NSLayoutAttribute)majorTrailingMarginAttribute
{
    return NSLayoutAttributeBottomMargin;
}

- (NSLayoutAttribute)minorLeadingAttribute
{
    return NSLayoutAttributeLeading;
}

- (NSLayoutAttribute)minorTrailingAttribute
{
    return NSLayoutAttributeTrailing;
}

- (NSLayoutAttribute)minorLeadingMarginAttribute
{
    return NSLayoutAttributeLeadingMargin;
}

- (NSLayoutAttribute)minorTrailingMarginAttribute
{
    return NSLayoutAttributeTrailingMargin;
}

- (NSLayoutAttribute)majorSizeAttribute
{
    return NSLayoutAttributeHeight;
}

- (NSLayoutAttribute)majorCenterAttribute
{
    return NSLayoutAttributeCenterY;
}

- (NSLayoutAttribute)minorSizeAttribute
{
    return NSLayoutAttributeWidth;
}

- (NSLayoutAttribute)minorCenterAttribute
{
    return NSLayoutAttributeCenterX;
}

- (instancetype)setLeadingMargin:(CGFloat)margin
{
    self.minorLeadingMargin = margin;
    return self;
}
- (CGFloat)leadingMargin
{
    return self.minorLeadingMargin;
}

- (instancetype)setTrailingMargin:(CGFloat)margin
{
    self.minorTrailingMargin = margin;
    return self;
}
- (CGFloat)trailingMargin
{
    return self.minorTrailingMargin;
}

- (instancetype)setTopMargin:(CGFloat)margin
{
    self.majorLeadingMargin = margin;
    return self;
}
- (CGFloat)topMargin
{
    return self.majorLeadingMargin;
}

- (instancetype)setBottomMargin:(CGFloat)margin
{
    self.majorTrailingMargin = margin;
    return self;
}
- (CGFloat)bottomMargin
{
    return self.majorTrailingMargin;
}

- (instancetype)setHorizontalAlignment:(ALAlignment)alignment
{
    self.minorAlignment = alignment;
    return self;
}
- (ALAlignment)horizontalAlignment
{
    return self.minorAlignment;
}

- (instancetype)setVerticalAlignment:(ALAlignment)alignment
{
    self.majorAlignment = alignment;
    return self;
}
- (ALAlignment)verticalAlignment
{
    return self.majorAlignment;
}

@end


NS_ASSUME_NONNULL_END