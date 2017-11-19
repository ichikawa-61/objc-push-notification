//
//  AppDelegate.h
//  2-5-9
//
//  Created by Manami Ichikawa on 4/6/17.
//  Copyright © 2017 Manami Ichikawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import "ViewController.h"

@interface AppDelegate : UIResponder <UNUserNotificationCenterDelegate,UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ViewController *viewController;

@end

