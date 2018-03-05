//
//  FileModel.m
//  FileManagement
//
//  Created by Máté Horváth on 2018. 02. 10..
//  Copyright © 2018. Máté Horváth. All rights reserved.
//


#import "FileModel.h"

#define FILE_NAME_KEY  @"fileName"
#define IS_FOLDER_KEY  @"isFolder"
#define MOD_DATE_KEY   @"modDate"
#define FILE_TYPE_KEY  @"fileType"
#define IS_ORANGE_KEY  @"isOrange"
#define IS_BLUE_KEY    @"isBlue"


@implementation FileModel

@synthesize fileName = _fileName;
@synthesize isFolder = _isFolder;
@synthesize modDate = _modDate;
@synthesize fileType = _fileType;
@synthesize isOrange = _isOrange;
@synthesize isBlue = _isBlue;

+(id)fileModelWithNameType: (NSString *) fileName fileType: (FileTypeEnum) fileType
{
    return [[[self class] alloc] initWithNameType:fileName
                                         fileType:fileType];
}

-(id)initWithNameType: (NSString *) fileName fileType: (FileTypeEnum) fileType
{
    self = [super init];
    if (self)
    {
        self.fileName = fileName;
        self.fileType = fileType;
    }
    return self;
}

+(id)fileModelWithNameAndEverything:(NSString *) fileName isFolder: (BOOL)isFolder modDate: (NSDate *)modDate fileType:(FileTypeEnum) fileType isOrange: (BOOL)isOrange isBlue: (BOOL)isBlue
{
    return [[[self class] alloc] initWithNameAndAll:fileName
                                           isFolder:isFolder
                                            modDate:modDate
                                           fileType:fileType
                                           isOrange:isOrange
                                             isBlue:isBlue];
}

-(id)initWithNameAndAll: (NSString *) fileName isFolder: (BOOL)isFolder modDate: (NSDate *)modDate fileType:(FileTypeEnum) fileType isOrange: (BOOL)isOrange isBlue: (BOOL)isBlue
{
    self = [super init];
    if (self)
    {
        self.fileName = fileName;
        self.isFolder = isFolder;
        self.modDate = modDate;
        self.fileType = fileType;
        self.isOrange = isOrange;
        self.isBlue = isBlue;
    }
    return self;
}

-(NSString *)description
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    NSString *formattedDate = [formatter stringFromDate:self.modDate];
    
    return [NSString stringWithFormat:@"FileName: %@ \nIsFolder: %@ \nModified Date: %@ \nFile Type: %lu \nIsOrange: %@ \nIsBlue: %@ \n", self.fileName, self.isFolder
            ? @"YES"
                                     : @"NO", formattedDate, (unsigned long)self.fileType, self.isOrange
            ? @"YES"
                                     : @"NO", self.isBlue
            ? @"YES"
                                     : @"NO"];
}

//Get the fileURL for the stored data
+(NSURL *)fileManagerDataURL
{
    NSArray *urls = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                           inDomains:NSUserDomainMask];
    return [[urls lastObject] URLByAppendingPathComponent:@"fileManager.data"];
}

//Loads all stored data
+(NSDictionary *) loadAllData
{
    NSData *data = [NSData dataWithContentsOfURL:[self fileManagerDataURL]];
    if (!data)
    {
        return [NSMutableDictionary dictionary];
    }
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

+(BOOL)saveData: (NSMutableDictionary *)dict
{
    NSData *fileData = [NSKeyedArchiver archivedDataWithRootObject:dict];
    return [fileData writeToURL:[[self class]fileManagerDataURL]
                     atomically:YES];
}

//Generates and stores test data
+(void)saveTestData
{
    //NSDictionary *fileHierarchy = [[NSDictionary alloc] init];
    //[fileHierarchy allKeysForObject:
    
    NSMutableArray *rootFolder = [NSMutableArray array];
    NSMutableArray *familySharedFolder = [NSMutableArray array];
    NSMutableArray *forWorkFolder = [NSMutableArray array];
    NSMutableArray *tomsFolder = [NSMutableArray array];
    NSMutableArray *homeworkFolder = [NSMutableArray array];
    //NSMutableArray *fileSystem = [NSMutableArray array];
    
    NSMutableDictionary *fileSystemDict = [NSMutableDictionary dictionary];
    FileModel *file = [[FileModel alloc] init];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    file.fileName = @"Family Shared";
    file.isFolder = TRUE;
    [comps setDay:5];
    [comps setMonth:6];
    [comps setYear:2014];
    file.modDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
    file.fileType = FileFolder;
    file.isOrange = FALSE;
    file.isBlue = FALSE;
    [rootFolder addObject:[file copy]];
    
    file.fileName = @"For Work";
    file.isFolder = TRUE;
    [comps setDay:2];
    [comps setMonth:7];
    [comps setYear:2014];
    file.modDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
    file.fileType = FileFolder;
    file.isOrange = TRUE;
    file.isBlue = FALSE;
    [rootFolder addObject:[file copy]];
    
    file.fileName = @"WorkPowerpoint.pptx";
    file.isFolder = FALSE;
    [comps setDay:2];
    [comps setMonth:7];
    [comps setYear:2014];
    file.modDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
    file.fileType = FileDocument;
    file.isOrange = FALSE;
    file.isBlue = FALSE;
    [rootFolder addObject:[file copy]];
    
    file.fileName = @"Speech.docx";
    file.isFolder = FALSE;
    [comps setDay:1];
    [comps setMonth:7];
    [comps setYear:2014];
    file.modDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
    file.fileType = FileDocument;
    file.isOrange = FALSE;
    file.isBlue = TRUE;
    [rootFolder addObject:[file copy]];
    
    file.fileName = @"Tom's Folder";
    file.isFolder = TRUE;
    [comps setDay:1];
    [comps setMonth:7];
    [comps setYear:2014];
    file.modDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
    file.fileType = FileFolder;
    file.isOrange = FALSE;
    file.isBlue = FALSE;
    [rootFolder addObject:[file copy]];
    
    file.fileName = @"DSC119.jpg";
    file.isFolder = FALSE;
    [comps setDay:1];
    [comps setMonth:7];
    [comps setYear:2014];
    file.modDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
    file.fileType = FileImage;
    file.isOrange = TRUE;
    file.isBlue = TRUE;
    [rootFolder addObject:[file copy]];
    
    //[FileModel saveData:rootFolder];
    
    //Family Shared folder
    file.fileName = @"EmilyWithDog.jpg";
    file.isFolder = FALSE;
    [comps setDay:2];
    [comps setMonth:8];
    [comps setYear:2014];
    file.modDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
    file.fileType = FileImage;
    file.isOrange = FALSE;
    file.isBlue = TRUE;
    [familySharedFolder addObject:[file copy]];
    
    file.fileName = @"Mom's Recipes.docx";
    file.isFolder = FALSE;
    [comps setDay:22];
    [comps setMonth:9];
    [comps setYear:2013];
    file.modDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
    file.fileType = FileDocument;
    file.isOrange = FALSE;
    file.isBlue = FALSE;
    [familySharedFolder addObject:[file copy]];
    
    file.fileName = @"Our Summer 2013.pptx";
    file.isFolder = FALSE;
    [comps setDay:13];
    [comps setMonth:8];
    [comps setYear:2013];
    file.modDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
    file.fileType = FilePPT;
    file.isOrange = TRUE;
    file.isBlue = FALSE;
    [familySharedFolder addObject:[file copy]];
    
    file.fileName = @"2014 Christmas.mp4";
    file.isFolder = FALSE;
    [comps setDay:25];
    [comps setMonth:12];
    [comps setYear:2014];
    file.modDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
    file.fileType = FileMovie;
    file.isOrange = FALSE;
    file.isBlue = FALSE;
    [familySharedFolder addObject:[file copy]];
    
    //For Work folder
    file.fileName = @"ToDoList.doc";
    file.isFolder = FALSE;
    [comps setDay:20];
    [comps setMonth:9];
    [comps setYear:2014];
    file.modDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
    file.fileType = FileDocument;
    file.isOrange = TRUE;
    file.isBlue = FALSE;
    [forWorkFolder addObject:[file copy]];
    
    file.fileName = @"LogoDesigns_pres.ppt";
    file.isFolder = FALSE;
    [comps setDay:21];
    [comps setMonth:9];
    [comps setYear:2014];
    file.modDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
    file.fileType = FilePPT;
    file.isOrange = FALSE;
    file.isBlue = TRUE;
    [forWorkFolder addObject:[file copy]];
    
    //Tom's Folder
    file.fileName = @"Homework";
    file.isFolder = TRUE;
    [comps setDay:10];
    [comps setMonth:1];
    [comps setYear:2011];
    file.modDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
    file.fileType = FileFolder;
    file.isOrange = FALSE;
    file.isBlue = FALSE;
    [tomsFolder addObject:[file copy]];
    
    file.fileName = @"My Puppy.jpeg";
    file.isFolder = FALSE;
    [comps setDay:16];
    [comps setMonth:5];
    [comps setYear:2012];
    file.modDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
    file.fileType = FileImage;
    file.isOrange = TRUE;
    file.isBlue = FALSE;
    [tomsFolder addObject:[file copy]];
    
    file.fileName = @"Rock music.mp3";
    file.isFolder = FALSE;
    [comps setDay:16];
    [comps setMonth:5];
    [comps setYear:2012];
    file.modDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
    file.fileType = FileMusic;
    file.isOrange = FALSE;
    file.isBlue = TRUE;
    [tomsFolder addObject:[file copy]];
    
    //Homework folder
    file.fileName = @"Shakespeare Biography.docx";
    file.isFolder = FALSE;
    [comps setDay:10];
    [comps setMonth:1];
    [comps setYear:2011];
    file.modDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
    file.fileType = FileDocument;
    file.isOrange = TRUE;
    file.isBlue = FALSE;
    [homeworkFolder addObject:[file copy]];
    
    file.fileName = @"French Essay.docx";
    file.isFolder = FALSE;
    [comps setDay:10];
    [comps setMonth:1];
    [comps setYear:2011];
    file.modDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
    file.fileType = FileDocument;
    file.isOrange = FALSE;
    file.isBlue = FALSE;
    [homeworkFolder addObject:[file copy]];
    
    FileModel *file2 = [FileModel fileModelWithNameAndEverything:@"Violet Mountains"
                                                        isFolder:NO
                                                         modDate:[[NSCalendar currentCalendar] dateFromComponents:comps]
                                                        fileType:FileImage
                                                        isOrange:TRUE
                                                          isBlue:FALSE];
    
    [familySharedFolder addObject:[file2 copy]];
    
    //    [tomsFolder addObject:[homeworkFolder copy]];
    //
    //    [fileSystem addObject:[rootFolder copy]];
    //    [fileSystem addObject:[familySharedFolder copy]];
    //    [fileSystem addObject:[forWorkFolder copy]];
    //    [fileSystem addObject:[tomsFolder copy]];
    
    //    [FileModel saveData:fileSystem];
    
    [fileSystemDict setObject:[rootFolder copy]
                       forKey:@"rootFolder"];
    [fileSystemDict setObject:[familySharedFolder copy]
                       forKey:@"Family Shared"];
    [fileSystemDict setObject:[forWorkFolder copy]
                       forKey:@"For Work"];
    [fileSystemDict setObject:[tomsFolder copy]
                       forKey:@"Tom's Folder"];
    [fileSystemDict setObject:[homeworkFolder copy]
                       forKey:@"Homework"];
    
    [FileModel saveData:fileSystemDict];
    
}

-(void)encodeWithCoder:(nonnull NSCoder *)aCoder
{
    [aCoder encodeObject:self.fileName
                  forKey:FILE_NAME_KEY];
    [aCoder encodeBool:self.isFolder
                forKey:IS_FOLDER_KEY];
    [aCoder encodeObject:self.modDate
                  forKey:MOD_DATE_KEY];
    [aCoder encodeInteger:self.fileType
                   forKey:FILE_TYPE_KEY];
    [aCoder encodeBool:self.isOrange
                forKey:IS_ORANGE_KEY];
    [aCoder encodeBool:self.isBlue
                forKey:IS_BLUE_KEY];
}

-(nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self.fileName = [aDecoder decodeObjectForKey:FILE_NAME_KEY];
        self.isFolder = [aDecoder decodeBoolForKey:IS_FOLDER_KEY];
        self.modDate = [aDecoder decodeObjectForKey:MOD_DATE_KEY];
        self.fileType = [aDecoder decodeIntegerForKey:FILE_TYPE_KEY];
        self.isOrange = [aDecoder decodeBoolForKey:IS_ORANGE_KEY];
        self.isBlue = [aDecoder decodeBoolForKey:IS_BLUE_KEY];
    }
    return self;
}

-(nonnull id)copyWithZone:(nullable NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    
    if (copy)
    {
        [copy setFileName:[[self fileName] copy]];
        [copy setIsFolder:[self isFolder]];
        [copy setModDate:[[self modDate] copy]];
        [copy setFileType:[self fileType]];
        [copy setIsOrange:[self isOrange]];
        [copy setIsBlue:[self isBlue]];
    }
    return copy;
}


@end
