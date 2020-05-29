//
//  ViewController.m
//  FMDBExample
//
//  Created by 牛新怀 on 2020/5/29.
//  Copyright © 2020 none. All rights reserved.
//
#define     LIBRARY_DIR             [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject]
#define  DATABASE_DIR                @"dataBase"
#define MAIN_DATABASE_NAME              @"db_20200529_encrypted.sqlite"

#import "ViewController.h"
#import <FMDB/FMDB.h>

@interface ViewController ()
{
    FMDatabaseQueue * _queue;
}

@end

static NSString * const encryptKeyValue = @"testkey";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self createDatabaseIfNeeded]) {
        _queue = [FMDatabaseQueue databaseQueueWithPath:[self currentDataBasePath]];
        [_queue inDatabase:^(FMDatabase * _Nonnull db) {
            [db setKey:encryptKeyValue];
        }];
        [self getObject];
    }
    
}

- (void)getObject {
    [_queue inDatabase:^(FMDatabase *db) {
//        [db setKey:encryptKeyValue];
        FMResultSet * rs = [db executeQuery:@"SELECT * FROM people WHERE id = 1"];
        while ([rs next]) {
            NSLog(@">>>>>>>>>>>data:%@",[rs stringForColumn:@"name"]);
        }
    }];
}

- (BOOL)createDatabaseIfNeeded
{
    BOOL success;
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *writableDBPath = [self currentDataBasePath];

    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success) return YES;
    // The writable database does not exist, so copy the default to the appropriate location.

    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:MAIN_DATABASE_NAME];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    
    if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
    return success;
}

/**
 获取数据库文件存储目录
 */
-(NSString *)getDataBaseDir
{
    NSString *path = [LIBRARY_DIR stringByAppendingPathComponent:DATABASE_DIR];
    NSLog(@"数据库路径是%@",path);
    if (![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:nil]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

-(NSString *)currentDataBasePath
{
    return [[self getDataBaseDir] stringByAppendingPathComponent:MAIN_DATABASE_NAME];
}

@end
