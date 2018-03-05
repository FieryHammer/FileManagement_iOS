//
//  CocoaFileTableViewCell.h
//  FileManagement
//
//  Created by Máté Horváth on 2018. 02. 25..
//  Copyright © 2018. Máté Horváth. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"


@interface CocoaFileTableViewCell : MGSwipeTableCell

@property (nonatomic, weak) IBOutlet UIImageView *fileTypeImageView;
@property (nonatomic, weak) IBOutlet UILabel *fileNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *modDateLabel;
@property (nonatomic, weak) IBOutlet UIStackView *folderBar;
@property (nonatomic, weak) IBOutlet UIView *topColoredBar;
@property (nonatomic, weak) IBOutlet UIView *bottomColoredBar;


@end
