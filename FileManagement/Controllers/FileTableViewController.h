//
//  FileTableViewController.h
//  FileManagement
//
//  Created by Máté Horváth on 2018. 02. 10..
//  Copyright © 2018. Máté Horváth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileTableViewCell.h"

@interface FileTableViewController : UITableViewController <FileTableViewCellDelegate>

@property (nonatomic, copy) NSString *folderName;

@end
