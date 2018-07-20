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
    listPerson = [[NSMutableArray alloc] init];
    listLinkPerson = [[NSMutableArray alloc] init];
    counter = 0;
}
- (IBAction)getAllPersonTapped:(id)sender {
    NSString *linkAllPerson = @"http://192.168.1.217:7010/get/allPersonName/";
    NSString *encodedURL = [linkAllPerson stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    [manager GET:encodedURL parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        self->listPerson = (NSMutableArray*)responseObject;
        NSLog(@"All persons---: %@", self->listPerson);
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
    }];
}
- (IBAction)getAllLinkPersonTapped:(id)sender {
    NSString *url = @"http://192.168.1.217:7010/get/allPersonFile/";
    for (int i = 0; i < listPerson.count; i++) {
        NSString *person = (NSString *)[listPerson objectAtIndex:i];
        NSString *linkPerson = [url stringByAppendingString:person];
        NSString *linkPerson2 = [linkPerson stringByAppendingString:@"/"];
        [listLinkPerson addObject:linkPerson2];
        NSLog(@"All link person---: %@", self->listLinkPerson);
    }
}
- (IBAction)getAllLinkImg:(id)sender {
    if (counter < listLinkPerson.count) {
        NSString *url = (NSString *)[listLinkPerson objectAtIndex:counter];
        NSString *encodedURL = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        [manager GET:encodedURL parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSMutableArray *listNameImg = (NSMutableArray*)responseObject;
            int temp = 0;
            while (temp < listNameImg.count) {
                NSString *nameImg = (NSString *)listNameImg[temp];
                NSString *linkImg = [url stringByAppendingString:nameImg];
                NSLog(@"All link img : %@", linkImg);
                temp++;
            }
            if (temp == listNameImg.count) {
                self->counter++;
                [self->_getArrLinkImgBtn sendActionsForControlEvents:(UIControlEventTouchUpInside)];
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error.localizedDescription);
        }];
    } else {
        NSLog(@"Counter----%d", counter);
    }
}

- (void)logListPerson {
    NSLog(@"listPerson %@", listPerson);
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
