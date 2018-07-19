//
//  ViewController.m
//  DetectPhotoWithIFace
//
//  Created by KHA on 7/19/18.
//  Copyright © 2018 Sycomore. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    manager = [AFHTTPSessionManager manager];

    // Do any additional setup after loading the view, typically from a nib.
    NSString *linkAllPerson = @"http://192.168.1.217:7010/get/allPersonName/";
    NSString *linkPerson = @"http://192.168.1.217:7010/get/allPersonFile/W_Ana Huynh";
    NSString *linkImgPerson = @"http://192.168.1.217:7010/W_Ana Huynh/W_Ana Huynh006.jpg";
    
    NSString *encodedURL = [linkImgPerson stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
//    [manager GET:encodedURL parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
////        NSLog(@"JSON: %@", (NSMutableArray*)responseObject);
//        NSLog(@"JSON: %@", (UIImage*)responseObject);
//
//    } failure:^(NSURLSessionTask *operation, NSError *error) {
//        NSLog(@"Error: %@", error.localizedDescription);
//    }];
    
    NSURL *filePath = [self getImgFrom:linkImgPerson];
    NSLog(@"File path image from url %@", filePath);
}

- (NSURL *) getImgFrom: (NSString *)link {
    NSURL *filePath;
    NSString *encodedURL = [link stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSURL *URL = [NSURL URLWithString:encodedURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        filePath = filePath;
        NSLog(@"File downloaded to: %@", filePath);
    }];
    [downloadTask resume];
    return filePath;
}

- (void)removeFileWith: (NSURL *)filePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager removeItemAtPath:filePath.path error:NULL]) {
        NSLog(@"Remove sucess---");
    } else {
        NSLog(@"Remove fail---");
    }
}

@end
