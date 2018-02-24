//
//  FileModelIntTests.m
//  FileManagementTests
//
//  Created by Máté Horváth on 2018. 02. 11..
//  Copyright © 2018. Máté Horváth. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FileModel.h"

@interface FileModelIntTests : XCTestCase

@end

@implementation FileModelIntTests

- (void)setUp {
    [super setUp];
    
    [FileModel saveTestData];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testLoadAllData {
    NSInteger expectedCount = 5;
    
    NSDictionary *fileDict = [FileModel loadAllData];
    
    XCTAssertEqual([[fileDict allKeys]count], expectedCount);
    XCTAssertTrue([[fileDict allKeys]containsObject:@"Tom's Folder"]);
}


@end
