//
//  FileTableViewController.m
//  FileManagement
//
//  Created by Máté Horváth on 2018. 02. 10..
//  Copyright © 2018. Máté Horváth. All rights reserved.
//

#import "FileTableViewController.h"
#import "FileModel.h"

@interface FileTableViewController ()
@property (nonatomic, strong) NSArray *files;
@property (nonatomic, strong) NSMutableSet *cellsCurrentlyEditing;
@end

@implementation FileTableViewController

@synthesize folderName = _folderName;

@synthesize files = _files;
@synthesize cellsCurrentlyEditing = _cellsCurrentlyEditing;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cellsCurrentlyEditing = [NSMutableSet new];
    
    self.tableView.estimatedRowHeight = 75.0;
    self.tableView.rowHeight = 75.0;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if([self.folderName length] == 0) {
        self.folderName = @"rootFolder";
    }
    
    self.title = self.folderName;
    self.files = [[FileModel loadAllData]valueForKey:self.folderName];
    
    //If used for the first time, create test data
   // if([self.files count] == 0) {
        [FileModel saveTestData];
    self.files = [[FileModel loadAllData]valueForKey:self.folderName];
    //}

}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.files.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FileCell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.delegate = self;
    
    FileModel *file = [self.files objectAtIndex:[indexPath row]];
    cell.itemText = file.fileName;
    
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
    
    if(file.isBlue && file.isOrange) {
        cell.coloredBarImageView.image = [UIImage imageNamed:@"bar_OrangeBlue"];
    } else if(file.isBlue && !file.isOrange) {
        cell.coloredBarImageView.image = [UIImage imageNamed:@"bar_Blue"];
    } else if(!file.isBlue && file.isOrange) {
        cell.coloredBarImageView.image = [UIImage imageNamed:@"bar_Orange"];
    } else {
        //
    }
    
    if(file.isFolder) {
        cell.folderMarkImageView.image = [UIImage imageNamed:@"bar_folderMark"];
    }
    
    cell.fileNameLabel.text = file.fileName;
    NSDateFormatter *formatter  = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM d,yyyy"];
    NSString *formattedDate = [formatter stringFromDate: file.modDate];
    cell.modDateLabel.text = [NSString stringWithFormat:@"modified %@", formattedDate];
    
    if ([self.cellsCurrentlyEditing containsObject:indexPath]) {
        [cell openCell];
    }
    
    return cell;
}

- (void)buttonFavoriteActionForItemText:(NSString *)itemText {
    NSLog(@"Clicked 'Favorite' button for '%@'", itemText);
}

- (void)buttonLinkActionForItemText:(NSString *)itemText {
    NSLog(@"Clicked 'Link' button for '%@'", itemText);
}

- (void)buttonTrashActionForItemText:(NSString *)itemText {
    NSLog(@"Clicked 'Trash' button for '%@'", itemText);
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}



- (void)cellDidOpen:(UITableViewCell *)cell {
    NSIndexPath *currentEditingIndexPath = [self.tableView indexPathForCell:cell];
    [self.cellsCurrentlyEditing addObject:currentEditingIndexPath];
}

- (void)cellDidClose:(UITableViewCell *)cell {
    [self.cellsCurrentlyEditing removeObject:[self.tableView indexPathForCell:cell]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FileModel *file = [self.files objectAtIndex:indexPath.row];
    if(file.isFolder) {
        [self showFolder:file.fileName];
    }
    else {
        NSLog(@"Tapped row with filename: %@", file.fileName);
    }
}

//Display a new tableview when selecting a folder
- (void)showFolder: (NSString *)folderName {
    //NSLog(@"Should go to folder '%@'", folderName);
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    FileTableViewController *folderTable = [storyboard instantiateViewControllerWithIdentifier:@"FileTableViewController"];
    folderTable.folderName = folderName;
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:folderTable];
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"‹ Back" style:UIBarButtonItemStyleDone target:self action:@selector(closeModal)];
    [folderTable.navigationItem setLeftBarButtonItem:back];
    [self presentViewController:navController animated:YES completion:NULL];
}

//Action for the Back button
- (void)closeModal
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

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
