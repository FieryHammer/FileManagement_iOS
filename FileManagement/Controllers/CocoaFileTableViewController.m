//
//  CocoaFileTableViewController.m
//  FileManagement
//
//  Created by Máté Horváth on 2018. 02. 25..
//  Copyright © 2018. Máté Horváth. All rights reserved.
//


#import "CocoaFileTableViewController.h"
#import "FileModel.h"


@interface CocoaFileTableViewController ()
@property (nonatomic, strong) NSArray *files;

@end

@implementation CocoaFileTableViewController

@synthesize folderName = _folderName;

@synthesize files = _files;

-(void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.estimatedRowHeight = 75.0;
    self.tableView.rowHeight = 75.0;

    if (self.folderName.length == 0)
    {
        self.folderName = @"rootFolder";
    }

    self.title = self.folderName;

    [FileModel saveTestData];
    self.files = [[FileModel loadAllData]valueForKey:self.folderName];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = false;

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


#pragma mark - Table view data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.files.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FileModel *file = [self.files objectAtIndex:indexPath.row];
    if (file.isFolder)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle:nil];
        CocoaFileTableViewController *dest = [storyboard instantiateViewControllerWithIdentifier:@"FileTableViewController"];
        dest.folderName = file.fileName;
        dest.title = self.folderName;
        [self.navigationController pushViewController:dest
                                             animated:true];
    }
    else
    {
        NSLog(@"Clicked on file: %@", file.fileName);
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CocoaFileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FileCell"
                                                                   forIndexPath:indexPath];

    // Configure the cell...

    FileModel *file = [self.files objectAtIndex:indexPath.row];

    UIImage *image = UIImage.new;

    switch (file.fileType)
    {
        case FileFolder:
            image = [UIImage imageNamed:@"icon_Folder"];
            break;
        case FileDocument:
        case FilePPT:
        case FilePDF:
            image = [UIImage imageNamed:@"icon_Document"];
            break;
        case FileImage:
            image = [UIImage imageNamed:@"icon_Image"];
            break;
        case FileMovie:
            image = [UIImage imageNamed:@"icon_Movie"];
            break;
        case FileMusic:
            image = [UIImage imageNamed:@"icon_Music"];
            break;
        default:
            image = [UIImage imageNamed:@"icon_Folder"];
            break;
    }

    cell.fileTypeImageView.image = image;

    cell.folderBar.hidden = !file.isFolder;

    cell.topColoredBar.backgroundColor = (  file.isOrange
                                          ?[  UIColor colorNamed:@"Color_OrangeBar"]
                                          :  (  file.isBlue
                                              ?  [UIColor colorNamed:@"Color_BlueBar"]
                                              :  UIColor.clearColor));
    cell.bottomColoredBar.backgroundColor = (  file.isBlue
                                             ?  [UIColor colorNamed:@"Color_BlueBar"]
                                             :  (  file.isOrange
                                                 ?  [UIColor colorNamed:@"Color_OrangeBar"]
                                                 :  UIColor.clearColor));
    cell.fileNameLabel.text = file.fileName;
    NSDateFormatter *formatter = NSDateFormatter.new;
    [formatter setDateFormat:@"MMMM d,yyyy"];
    NSString *formattedDate = [formatter stringFromDate:file.modDate];
    cell.modDateLabel.text = [NSString stringWithFormat:@"modified %@", formattedDate];

    cell.delegate = (id<MGSwipeTableCellDelegate>)self;

    cell.rightButtons = @[ [MGSwipeButton buttonWithTitle:@""
                                                     icon:[UIImage imageNamed:@"icon_Bin_small"]
                                          backgroundColor:UIColor.clearColor],
                           [MGSwipeButton buttonWithTitle:@""
                                                     icon:[UIImage imageNamed:@"icon_Link_small"]
                                          backgroundColor:UIColor.clearColor],
                           [MGSwipeButton buttonWithTitle:@""
                                                     icon:[UIImage imageNamed:@"icon_Favorite_small"]
                                          backgroundColor:UIColor.clearColor]];

    cell.rightSwipeSettings.transition = MGSwipeTransitionStatic;
    return cell;
}

-(BOOL) swipeTableCell:(nonnull MGSwipeTableCell *) cell tappedButtonAtIndex:(NSInteger) index direction:(MGSwipeDirection)direction fromExpansion:(BOOL) fromExpansion
{

    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];

    FileModel *file = [self.files objectAtIndex:indexPath.row];
    switch (index)
    {
        case 2:
            NSLog(@"Favorite button pressed at file %@", file.fileName);
            break;
        case 1:
            NSLog(@"Share button pressed at file %@", file.fileName);
            break;
        case 0:
            NSLog(@"Bin button pressed at file %@", file.fileName);
            break;
        default:
            break;

    }
    return true; //true to close swipe menu, false to keep it open.
}


@end
