//
//  FileModel.h
//  FileManagement
//
//  Created by Máté Horváth on 2018. 02. 10..
//  Copyright © 2018. Máté Horváth. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface FileModel : NSObject <NSCoding, NSCopying>

typedef NS_ENUM (NSUInteger, FileTypeEnum)
{
    FileFolder,
    FileDocument,
    FileImage,
    FileMusic,
    FileMovie,
    FilePPT,
    FilePDF
};

@property (nonatomic, copy)   NSString *fileName;
@property (nonatomic, assign) BOOL          isFolder;
@property (nonatomic, strong) NSDate *modDate;
@property (nonatomic, assign) FileTypeEnum  fileType;
@property (nonatomic, assign) BOOL          isOrange;
@property (nonatomic, assign) BOOL          isBlue;


-(id)initWithNameType: (NSString *) fileName fileType: (FileTypeEnum) fileType;
-(id)initWithNameAndAll:(NSString *) fileName isFolder: (BOOL)isFolder modDate: (NSDate *)modDate fileType:(FileTypeEnum) fileType isOrange: (BOOL)isOrange isBlue: (BOOL)isBlue;

+(NSDictionary *)loadAllData;
+(void)saveTestData;


@end
