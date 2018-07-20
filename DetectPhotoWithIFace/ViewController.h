//
//  ViewController.h
//  DetectPhotoWithIFace
//
//  Created by KHA on 7/19/18.
//  Copyright © 2018 Sycomore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"

@interface ViewController : UIViewController
{
    AFHTTPSessionManager *manager;
    NSMutableArray *listPerson;
    NSMutableArray *listLinkPerson;
    int counter;
}

@property (weak, nonatomic) IBOutlet UIButton *getArrLinkImgBtn;
@end

