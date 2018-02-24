//
//  FileTableViewCell.h
//  FileManagement
//
//  Created by Máté Horváth on 2018. 02. 11..
//  Copyright © 2018. Máté Horváth. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FileTableViewCellDelegate <NSObject>
- (void)buttonFavoriteActionForItemText:(NSString *)itemText;
- (void)buttonLinkActionForItemText:(NSString *)itemText;
- (void)buttonTrashActionForItemText:(NSString *)itemText;
- (void)cellDidOpen:(UITableViewCell *)cell;
- (void)cellDidClose:(UITableViewCell *)cell;
@end

@interface FileTableViewCell : UITableViewCell <UIGestureRecognizerDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *fileTypeImageView;
@property (nonatomic, weak) IBOutlet UIImageView *coloredBarImageView;
@property (nonatomic, weak) IBOutlet UIImageView *folderMarkImageView;
@property (nonatomic, weak) IBOutlet UILabel *fileNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *modDateLabel;
@property (nonatomic, weak) IBOutlet UIButton *favoriteButton;
@property (nonatomic, weak) IBOutlet UIButton *linkButton;
@property (nonatomic, weak) IBOutlet UIButton *trashButton;

@property (nonatomic, strong) NSString *itemText;
@property (nonatomic, weak) id <FileTableViewCellDelegate> delegate;

@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, assign) CGPoint panStartPoint;
@property (nonatomic, assign) CGFloat startingRightLayoutConstraintConstant;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentViewRightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentViewLeftConstraint;
@property (nonatomic, weak) IBOutlet UIView *myContentView;

- (void)openCell;

@end
