//
//  AppDelegate.h
//  FanweO2O
//
//  Created by mac on 16/12/7.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "BaseAppDelegate.h"
@interface AppDelegate : BaseAppDelegate <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

