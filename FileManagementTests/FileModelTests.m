//
//  FileModelTests.m
//  FileManagementTests
//
//  Created by Máté Horváth on 2018. 02. 11..
//  Copyright © 2018. Máté Horváth. All rights reserved.
//


#import <XCTest/XCTest.h>
#import "FileModel.h"
#import <OCMock/OCMock.h>


@interface FileModelTests : XCTestCase

@end

@implementation FileModelTests
{
    NSString *_fileName;
    BOOL _isFolder;
    NSDate *_modDate;
    FileTypeEnum _fileType;
    BOOL _isOrange;
    BOOL _isBlue;
}

-(void)setUp
{
    [super setUp];

    NSDateComponents *comps = NSDateComponents.new;
    [comps setDay:11];
    [comps setMonth:2];
    [comps setYear:2018];

    _fileName = @"Dummy file";
    _isFolder = FALSE;
    _modDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
    _fileType = FileImage;
    _isOrange = FALSE;
    _isBlue = TRUE;
}

-(void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testInitWithNameType
{
    FileModel *file = [FileModel.alloc initWithNameType:_fileName
                                               fileType:_fileType];

    XCTAssertEqualObjects(file.fileName, _fileName);
    XCTAssertEqual(file.fileType, _fileType);

}

-(void)testInitWithNameAndAll
{
    FileModel *file = [FileModel.alloc initWithNameAndAll:_fileName
                                                 isFolder:_isFolder
                                                  modDate:_modDate
                                                 fileType:_fileType
                                                 isOrange:_isOrange
                                                   isBlue:_isBlue];

    XCTAssertEqualObjects(file.fileName, _fileName);
    XCTAssertEqual(file.isFolder, _isFolder);
    XCTAssertEqualObjects(file.modDate, _modDate);
    XCTAssertEqual(file.fileType, _fileType);
    XCTAssertEqual(file.isOrange, _isOrange);
    XCTAssertEqual(file.isBlue, _isBlue);

}

-(void)testFileModelComplexConvenienceInitializer
{
    FileModel *file = [FileModel.alloc initWithNameAndAll:_fileName
                                                 isFolder:_isFolder
                                                  modDate:_modDate
                                                 fileType:_fileType
                                                 isOrange:_isOrange
                                                   isBlue:_isBlue];

    XCTAssertEqualObjects(file.fileName, _fileName);
    XCTAssertEqual(file.isFolder, _isFolder);
    XCTAssertEqualObjects(file.modDate, _modDate);
    XCTAssertEqual(file.fileType, _fileType);
    XCTAssertEqual(file.isOrange, _isOrange);
    XCTAssertEqual(file.isBlue, _isBlue);

}

-(void)testAdoptNSCoding
{
    FileModel *file = [FileModel.alloc initWithNameType:_fileName
                                               fileType:_fileType];

    XCTAssertTrue([file conformsToProtocol:@protocol(NSCoding)], @"FileModel does not adopt NSCoding.");
}

-(void)testInitWithCoder
{

    id stubCoder = [OCMockObject mockForClass:[NSCoder class]];

    NSInteger localfileType = (NSInteger)_fileType;

    [[[stubCoder stub] andReturn:_fileName] decodeObjectForKey:@"fileName"];
    [[[stubCoder stub] andReturnValue:OCMOCK_VALUE(_isFolder)] decodeBoolForKey:@"isFolder"];
    [[[stubCoder stub] andReturn:_modDate] decodeObjectForKey:@"modDate"];
    [[[stubCoder stub] andReturnValue:OCMOCK_VALUE(localfileType)] decodeIntegerForKey:@"fileType"];
    [[[stubCoder stub] andReturnValue:OCMOCK_VALUE(_isOrange)] decodeBoolForKey:@"isOrange"];
    [[[stubCoder stub] andReturnValue:OCMOCK_VALUE(_isBlue)] decodeBoolForKey:@"isBlue"];

    FileModel *file = [FileModel.alloc initWithCoder:stubCoder];

    XCTAssertEqualObjects(file.fileName, _fileName);
    XCTAssertEqual(file.isFolder, _isFolder);
    XCTAssertEqualObjects(file.modDate, _modDate);
    XCTAssertEqual(file.fileType, _fileType);
    XCTAssertEqual(file.isOrange, _isOrange);
    XCTAssertEqual(file.isBlue, _isBlue);

    XCTAssertTrue(TRUE);

}

-(void) testEncodeWithCoder
{
    id mockCoder = [OCMockObject mockForClass:[NSCoder class]];

    [[mockCoder expect] encodeObject:_fileName
                              forKey:@"fileName"];
    [[mockCoder expect] encodeBool:_isFolder
                            forKey:@"isFolder"];
    [[mockCoder expect] encodeObject:_modDate
                              forKey:@"modDate"];
    [[mockCoder expect] encodeInteger:_fileType
                               forKey:@"fileType"];
    [[mockCoder expect] encodeBool:_isOrange
                            forKey:@"isOrange"];
    [[mockCoder expect] encodeBool:_isBlue
                            forKey:@"isBlue"];

    FileModel *file = [FileModel.alloc initWithNameAndAll:_fileName
                                                 isFolder:_isFolder
                                                  modDate:_modDate
                                                 fileType:_fileType
                                                 isOrange:_isOrange
                                                   isBlue:_isBlue];
    [file encodeWithCoder:mockCoder];

    [mockCoder verify];
}

-(void)testAdoptNSCopying
{
    FileModel *file = [FileModel.alloc initWithNameType:_fileName
                                               fileType:_fileType];

    XCTAssertTrue([file conformsToProtocol:@protocol(NSCopying)], @"FileModel does not adopt NSCopying.");
}

-(void)testNSCopying
{
    FileModel *fileOrig = [FileModel.alloc initWithNameAndAll:_fileName
                                                     isFolder:_isFolder
                                                      modDate:_modDate
                                                     fileType:_fileType
                                                     isOrange:_isOrange
                                                       isBlue:_isBlue];

    FileModel *fileCopy = [fileOrig copy];

    XCTAssertEqualObjects(fileCopy.fileName, _fileName);
    XCTAssertEqual(fileCopy.isFolder, _isFolder);
    XCTAssertEqualObjects(fileCopy.modDate, _modDate);
    XCTAssertEqual(fileCopy.fileType, _fileType);
    XCTAssertEqual(fileCopy.isOrange, _isOrange);
    XCTAssertEqual(fileCopy.isBlue, _isBlue);
}


@end
