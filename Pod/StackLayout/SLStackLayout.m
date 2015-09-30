//  Copyright © 2015 Bridger Maxwell. All rights reserved.

#import "SLStackLayout.h"
#import "UIView+StackLayout.h"

NS_ASSUME_NONNULL_BEGIN

@implementation UIView (StackLayoutInternal)

- (NSLayoutConstraint *)sl_constraintAligningAttribute:(NSLayoutAttribute)attribute withView:(UIView *)view
{
    return [NSLayoutConstraint constraintWithItem:self attribute:attribute relatedBy:NSLayoutRelationEqual toItem:view attribute:attribute multiplier:1.0 constant:0];
}

- (NSLayoutConstraint *)sl_constraintWithSpace:(CGFloat)space followedByView:(UIView *)view isHorizontal:(BOOL)isHorizontal
{
    NSLayoutAttribute leadingAttribute = isHorizontal ? NSLayoutAttributeLeading : NSLayoutAttributeTop;
    NSLayoutAttribute trailingAttribute = isHorizontal ? NSLayoutAttributeTrailing : NSLayoutAttributeBottom;
    
    // view.leading = self.trailing + space
    return [NSLayoutConstraint constraintWithItem:view attribute:leadingAttribute relatedBy:NSLayoutRelationEqual toItem:self attribute:trailingAttribute multiplier:1.0 constant:space];
}

@end


@interface SLStackLayoutBase ()

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

@property (nonatomic) SLAlignment majorAlignment;
@property (nonatomic) SLAlignment minorAlignment;



// These are all the public properties that have just been marked readwrite
@property (readwrite) NSArray<UIView *> *views;
@property (readwrite, weak, nullable) UIView *superview;

// These are implemented by this base class but are only exposed in the two subclasses
- (instancetype)setSpacing:(CGFloat)spacing;
@property (nonatomic, readonly) CGFloat spacing;
- (instancetype)setSpacingPriority:(UILayoutPriority)priority;
@property (nonatomic, readonly) UILayoutPriority spacingPriority;
- (instancetype)setAlignmentPriority:(UILayoutPriority)priority;
@property (nonatomic, readonly) UILayoutPriority alignmentPriority;
- (instancetype)setLayoutMarginsRelativeArrangement:(BOOL)layoutMarginsRelativeArrangement;
@property(nonatomic, getter=isLayoutMarginsRelativeArrangement, readonly) BOOL layoutMarginsRelativeArrangement;
- (instancetype)setAdjustsPreferredMaxLayoutWidthOnSubviews:(BOOL)adjustValues;
@property (nonatomic, readonly) BOOL adjustsPreferredMaxLayoutWidthOnSubviews;

@end

@implementation SLStackLayoutBase

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
        _spacingPriority = UILayoutPriorityRequired;
        _adjustsPreferredMaxLayoutWidthOnSubviews = YES;
        
        [self rebuildSpacingConstraints];
        [self rebuildMajorLeadingConstraint];
        [self rebuildMajorTrailingConstraint];
        [self rebuildMinorLeadingConstraints];
        [self rebuildMinorTrailingConstraints];
    }
    return self;
}

- (void)rebuildSpacingConstraints
{
    for (NSLayoutConstraint *constraint in self.spacingConstraints) {
        constraint.active = false;
    }
    
    NSMutableArray *spacingConstraints = [NSMutableArray new];
    UIView *previousSubview = nil;
    for (UIView *subview in self.views) {
        if (previousSubview) {
            // subview.leading = previousSubview.trailing + spacing
            NSLayoutConstraint *spaceConstraint = [previousSubview sl_constraintWithSpace:self.spacing followedByView:subview isHorizontal:self.isHorizontal];
            spaceConstraint.priority = self.spacingPriority;
            [spacingConstraints addObject:spaceConstraint];
            spaceConstraint.active = true;
        }
        previousSubview = subview;
    }
    self.spacingConstraints = spacingConstraints;
}

- (instancetype)setSpacingPriority:(UILayoutPriority)priority
{
    if (_spacingPriority != priority) {
        _spacingPriority = priority;
        [self rebuildSpacingConstraints];
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

- (void)setMajorAlignment:(SLAlignment)majorAlignment
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
            case SLAlignmentNone: {
                // No constraints to make
                break;
            }
            case SLAlignmentLeading: {
                // leadingView.leading = superview.leading
                [constraints addObject:[self.leadingView sl_constraintAligningAttribute:self.majorLeadingAttribute withView:self.superview]];
                
                break;
            }
            case SLAlignmentTrailing: {
                // superview.trailing = trailingView.trailing
                [constraints addObject:[self.superview sl_constraintAligningAttribute:self.majorTrailingAttribute withView:self.trailingView]];
                
                break;
            }
            case SLAlignmentFill: {
                // Make both the leading and trailing subviews try to hug the edges
                
                // leadingView.leading = superview.leading
                [constraints addObject:[self.leadingView sl_constraintAligningAttribute:self.majorLeadingAttribute withView:self.superview]];
                // superview.trailing = trailingView.trailing
                [constraints addObject:[self.superview sl_constraintAligningAttribute:self.majorTrailingAttribute withView:self.trailingView]];
                break;
            }
            case SLAlignmentCenter: {
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

- (void)setMinorAlignment:(SLAlignment)minorAlignment
{
    if (_minorAlignment != minorAlignment) {
        _minorAlignment = minorAlignment;
        
        // We can't change these on the fly so we need to remove them and rebuild them
        for (NSLayoutConstraint *constraint in self.minorAlignmentConstraints) {
            constraint.active = false;
        }
        
        NSMutableArray *constraints = [NSMutableArray array];
        switch (self.minorAlignment) {
            case SLAlignmentNone: {
                // No constraints to make
                break;
            }
            case SLAlignmentLeading: {
                for (UIView *subview in self.views) {
                    // subview.leading = superview.leading
                    [constraints addObject:[subview sl_constraintAligningAttribute:self.minorLeadingAttribute withView:self.superview]];
                }
                
                break;
            }
            case SLAlignmentTrailing: {
                for (UIView *subview in self.views) {
                    // superview.trailing = subview.trailing
                    [constraints addObject:[self.superview sl_constraintAligningAttribute:self.minorTrailingAttribute withView:subview]];
                }
                
                break;
            }
            case SLAlignmentFill: {
                // Make both the leading and trailing subviews try to hug the edges
                
                for (UIView *subview in self.views) {
                    // subview.leading = superview.leading
                    [constraints addObject:[subview sl_constraintAligningAttribute:self.minorLeadingAttribute withView:self.superview]];
                    // superview.trailing = subview.trailing
                    [constraints addObject:[self.superview sl_constraintAligningAttribute:self.minorTrailingAttribute withView:subview]];
                }
                
                break;
            }
            case SLAlignmentCenter: {
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
        SLAlignment majorAlignment = self.majorAlignment;
        self.majorAlignment = SLAlignmentNone;
        self.majorAlignment = majorAlignment;
        
        SLAlignment minorAlignment = self.minorAlignment;
        self.minorAlignment = SLAlignmentNone;
        self.minorAlignment = minorAlignment;
    }
    return self;
}

- (instancetype)setAdjustsPreferredMaxLayoutWidthOnSubviews:(BOOL)adjustValues
{
    _adjustsPreferredMaxLayoutWidthOnSubviews = adjustValues;
    return self;
}

- (void)subviewsLaidOut
{
    if (!self.adjustsPreferredMaxLayoutWidthOnSubviews) {
        return;
    }
    for (UIView *subview in self.views) {
        if ([subview respondsToSelector:@selector(setPreferredMaxLayoutWidth:)]) {
            CGFloat layoutWidth = subview.frame.size.width;
            [(id)subview setPreferredMaxLayoutWidth:layoutWidth];
            
            [subview updateConstraintsIfNeeded];
        }
    }
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
- (instancetype)setHorizontalMargins:(CGFloat)margin
{
    self.majorTrailingMargin = margin;
    self.majorLeadingMargin = margin;
    return self;
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
- (instancetype)setVerticalMargins:(CGFloat)margin
{
    self.minorTrailingMargin = margin;
    self.minorLeadingMargin = margin;
    return self;
}

- (instancetype)setHorizontalAlignment:(SLAlignment)alignment
{
    self.majorAlignment = alignment;
    return self;
}
- (SLAlignment)horizontalAlignment
{
    return self.majorAlignment;
}

- (instancetype)setVerticalAlignment:(SLAlignment)alignment
{
    self.minorAlignment = alignment;
    return self;
}
- (SLAlignment)verticalAlignment
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

- (instancetype)setHorizontalMargins:(CGFloat)margin
{
    self.minorTrailingMargin = margin;
    self.minorLeadingMargin = margin;
    return self;
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

- (instancetype)setVerticalMargins:(CGFloat)margin
{
    self.majorTrailingMargin = margin;
    self.majorLeadingMargin = margin;
    return self;
}

- (instancetype)setHorizontalAlignment:(SLAlignment)alignment
{
    self.minorAlignment = alignment;
    return self;
}
- (SLAlignment)horizontalAlignment
{
    return self.minorAlignment;
}

- (instancetype)setVerticalAlignment:(SLAlignment)alignment
{
    self.majorAlignment = alignment;
    return self;
}
- (SLAlignment)verticalAlignment
{
    return self.majorAlignment;
}

@end


NS_ASSUME_NONNULL_END