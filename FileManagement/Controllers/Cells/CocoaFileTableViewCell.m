//
//  CocoaFileTableViewCell.m
//  FileManagement
//
//  Created by Máté Horváth on 2018. 02. 25..
//  Copyright © 2018. Máté Horváth. All rights reserved.
//

#import "CocoaFileTableViewCell.h"

@implementation CocoaFileTableViewCell

@synthesize fileTypeImageView = _fileTypeImageView;
@synthesize fileNameLabel = _fileNameLabel;
@synthesize modDateLabel = _modDateLabel;
@synthesize folderBar = _folderBar;
@synthesize topColoredBar = _topColoredBar;
@synthesize bottomColoredBar = _bottomColoredBar;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
