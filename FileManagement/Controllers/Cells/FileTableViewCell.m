//
//  FileTableViewCell.m
//  FileManagement
//
//  Created by Máté Horváth on 2018. 02. 11..
//  Copyright © 2018. Máté Horváth. All rights reserved.
//

#import "FileTableViewCell.h"
static CGFloat const kBounceValue = 20.0f;

@implementation FileTableViewCell

@synthesize fileTypeImageView = _fileTypeImageView;
@synthesize coloredBarImageView = _coloredBarImageView;
@synthesize fileNameLabel = _fileNameLabel;
@synthesize modDateLabel = _modDateLabel;
@synthesize favoriteButton = _favoriteButton;
@synthesize linkButton = _linkButton;
@synthesize trashButton = _trashButton;

@synthesize itemText = _itemText;
@synthesize delegate = _delegate;

@synthesize panRecognizer = _panRecognizer;
@synthesize panStartPoint = _panStartPoint;
@synthesize startingRightLayoutConstraintConstant = _startingRightLayoutConstraintConstant;
@synthesize contentViewRightConstraint = _contentViewRightConstraint;
@synthesize contentViewLeftConstraint = _contentViewLeftConstraint;
@synthesize myContentView = _myContentView;

//Source: https://www.raywenderlich.com/62435/make-swipeable-table-view-cell-actions-without-going-nuts-scroll-views

- (IBAction)buttonClicked:(id)sender {
    if(sender == self.favoriteButton) {
        [self.delegate buttonFavoriteActionForItemText:self.itemText];
    }else if(sender == self.linkButton) {
        [self.delegate buttonLinkActionForItemText:self.itemText];
    }else if(sender == self.trashButton) {
        [self.delegate buttonTrashActionForItemText:self.itemText];
    }
}

- (void)openCell {
    [self setConstraintsToShowAllButtons:NO notifyDelegateDidOpen:NO];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panThisCell:)];
    self.panRecognizer.delegate = self;
    [self.myContentView addGestureRecognizer:self.panRecognizer];
}

- (void)panThisCell:(UIPanGestureRecognizer *)recognizer {
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            self.panStartPoint = [recognizer translationInView:self.myContentView];
            self.startingRightLayoutConstraintConstant = self.contentViewRightConstraint.constant;
            break;
        case UIGestureRecognizerStateChanged: {
            CGPoint currentPoint = [recognizer translationInView:self.myContentView];
            CGFloat deltaX = currentPoint.x - self.panStartPoint.x;
            BOOL panningLeft = NO;
            if (currentPoint.x < self.panStartPoint.x) {  //1
                panningLeft = YES;
            }
            
                if (self.startingRightLayoutConstraintConstant == 0) { //2
                    //The cell was closed and is now opening
                    if (!panningLeft) {
                        CGFloat constant = MAX(-deltaX, 0); //3
                        if (constant == 0) { //4
                            [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:NO];
                        } else { //5
                            self.contentViewRightConstraint.constant = constant;
                        }
                    } else {
                        CGFloat constant = MIN(-deltaX, [self buttonTotalWidth]); //6
                        if (constant == [self buttonTotalWidth]) { //7
                            [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:NO];
                        } else { //8
                            self.contentViewRightConstraint.constant = constant;
                        }
                    }
                }else {
                    //The cell was at least partially open.
                    CGFloat adjustment = self.startingRightLayoutConstraintConstant - deltaX; //1
                    if (!panningLeft) {
                        CGFloat constant = MAX(adjustment, 0); //2
                        if (constant == 0) { //3
                            [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:NO];
                        } else { //4
                            self.contentViewRightConstraint.constant = constant;
                        }
                    } else {
                        CGFloat constant = MIN(adjustment, [self buttonTotalWidth]); //5
                        if (constant == [self buttonTotalWidth]) { //6
                            [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:NO];
                        } else { //7
                            self.contentViewRightConstraint.constant = constant;
                        }
                    }
                }
            
            self.contentViewLeftConstraint.constant = -self.contentViewRightConstraint.constant; //8
        }
            break;
        case UIGestureRecognizerStateEnded:
            if (self.startingRightLayoutConstraintConstant == 0) { //1
                //Cell was opening
                //CGFloat halfOfButtonOne = CGRectGetWidth(self.button1.frame) / 2; //2
                CGFloat openLimit = CGRectGetWidth(self.trashButton.frame);
                if (self.contentViewRightConstraint.constant >= openLimit) { //3
                    //Open all the way
                    [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:YES];
                } else {
                    //Re-close
                    [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:YES];
                }
            } else {
                //Cell was closing
                //CGFloat buttonOnePlusHalfOfButton2 = CGRectGetWidth(self.button1.frame) + (CGRectGetWidth(self.button2.frame) / 2);
                CGFloat closeLimit = CGRectGetWidth(self.trashButton.frame) + (CGRectGetWidth(self.linkButton.frame) / 2);
                //4
                if (self.contentViewRightConstraint.constant >= closeLimit) { //5
                    //Re-open all the way
                    [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:YES];
                } else {
                    //Close
                    [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:YES];
                }
            }
            break;
        case UIGestureRecognizerStateCancelled:
            if (self.startingRightLayoutConstraintConstant == 0) {
                //Cell was closed - reset everything to 0
                [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:YES];
            } else {
                //Cell was open - reset to the open state
                [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:YES];
            }
            break;
        default:
            break;
    }
}

- (void)updateConstraintsIfNeeded:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    float duration = 0;
    if (animated) {
        duration = 0.1;
    }
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self layoutIfNeeded];
    } completion:completion];
}

- (CGFloat)buttonTotalWidth {
    //return CGRectGetWidth(self.frame) - CGRectGetMinX(self.button1.frame);
    return CGRectGetWidth(self.frame) - CGRectGetMinX(self.favoriteButton.frame);
}

- (void)resetConstraintContstantsToZero:(BOOL)animated notifyDelegateDidClose:(BOOL)notifyDelegate {
    if (notifyDelegate) {
        [self.delegate cellDidClose:self];
    }
    
    if (self.startingRightLayoutConstraintConstant == 0 &&
        self.contentViewRightConstraint.constant == 0) {
        //Already all the way closed, no bounce necessary
        return;
    }
    
    self.contentViewRightConstraint.constant = -kBounceValue;
    self.contentViewLeftConstraint.constant = kBounceValue;
    
    [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
        self.contentViewRightConstraint.constant = 0;
        self.contentViewLeftConstraint.constant = 0;
        
        [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
            self.startingRightLayoutConstraintConstant = self.contentViewRightConstraint.constant;
        }];
    }];
}

- (void)setConstraintsToShowAllButtons:(BOOL)animated notifyDelegateDidOpen:(BOOL)notifyDelegate {
    if (notifyDelegate) {
        [self.delegate cellDidOpen:self];
    }
    
    //1
    if (self.startingRightLayoutConstraintConstant == [self buttonTotalWidth] &&
        self.contentViewRightConstraint.constant == [self buttonTotalWidth]) {
        return;
    }
    //2
    self.contentViewLeftConstraint.constant = -[self buttonTotalWidth] - kBounceValue;
    self.contentViewRightConstraint.constant = [self buttonTotalWidth] + kBounceValue;
    
    [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
        //3
        self.contentViewLeftConstraint.constant = -[self buttonTotalWidth];
        self.contentViewRightConstraint.constant = [self buttonTotalWidth];
        
        [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
            //4
            self.startingRightLayoutConstraintConstant = self.contentViewRightConstraint.constant;
        }];
    }];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self resetConstraintContstantsToZero:NO notifyDelegateDidClose:NO];
}
@end
