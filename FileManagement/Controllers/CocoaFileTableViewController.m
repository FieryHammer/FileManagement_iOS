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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 75.0;
    self.tableView.rowHeight = 75.0;
    
    if([self.folderName length] == 0) {
        self.folderName = @"rootFolder";
    }
    
    self.title = self.folderName;
    
    [FileModel saveTestData];
    self.files = [[FileModel loadAllData]valueForKey:self.folderName];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.files.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CocoaFileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FileCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[CocoaFileTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"FileCell"];
    }
    
    // Configure the cell...
    
    FileModel *file = [self.files objectAtIndex:[indexPath row]];
    
    UIImage *image = [[UIImage alloc] init];
    
    switch (file.fileType) {
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
    
    
//    if(file.isFolder) {
//        cell.folderMarkImageView.image = [UIImage imageNamed:@"bar_folderMark"];
//    }
    
    cell.fileNameLabel.text = file.fileName;
    NSDateFormatter *formatter  = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM d,yyyy"];
    NSString *formattedDate = [formatter stringFromDate: file.modDate];
    cell.modDateLabel.text = [NSString stringWithFormat:@"modified %@", formattedDate];
    
    cell.rightButtons = @[ [MGSwipeButton buttonWithTitle:@"" icon:[UIImage imageNamed:@"icon_Bin_small"] backgroundColor:[UIColor whiteColor]],
                          [MGSwipeButton buttonWithTitle:@"" icon:[UIImage imageNamed:@"icon_Link_small"] backgroundColor:[UIColor whiteColor]],
                         [MGSwipeButton buttonWithTitle:@"" icon:[UIImage          imageNamed:@"icon_Favorite_small"] backgroundColor:[UIColor whiteColor]]];

    cell.rightSwipeSettings.transition = MGSwipeTransitionDrag;
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
