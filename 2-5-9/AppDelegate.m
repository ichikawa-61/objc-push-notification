//
//  AppDelegate.m
//  2-5-9
//
//  Created by Manami Ichikawa on 4/6/17.
//  Copyright © 2017 Manami Ichikawa. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>


@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            if(!error){
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            }
        }];
    
    return YES;
}






// DeviceToken受信成功
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString *token = deviceToken.description;
    
    //これがないと<>と空白が入った状態でdevice token　を取得することになる
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"deviceToken: %@", token);
    
    [self sendProviderDeviceToken:token];
}

// DeviceToken受信失敗 シミュレーションだとdevice tokenの取得に失敗する
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"deviceToken error: %@", [error description]);
}




//-----------------------------------------------------------


//phpにdevice tokenを送る
- (void)sendProviderDeviceToken:(NSString *)token

{
    
    NSURL *URL = [NSURL URLWithString:@"http://localhost/"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      NSLog(@"ok");
                                  }];
    
    [task resume];

    
}

//-----------------------------------------------------------





// 通常のPush通知の受信　foreground
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    NSLog(@"おおおお");
      
    NSDictionary *aps      = [userInfo objectForKey:@"aps"];
    NSString *alertMessage = [aps objectForKey:@"alert"];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"test"
                                                                             message:alertMessage
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [self.viewController presentViewController:alertController animated:YES completion:nil];
}

// BackgroundFetchによるバックグラウンドの受信
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"pushInfo in Background: %@", [userInfo description]);
    completionHandler(UIBackgroundFetchResultNoData | UNAuthorizationOptionAlert);
    
    
    NSDictionary *aps      = [userInfo objectForKey:@"aps"];
    NSString *alertMessage = [aps objectForKey:@"alert"];
    
    NSLog(@"%@",alertMessage);


    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"test"
                                                                             message:alertMessage
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    

    [self.viewController presentViewController:alertController animated:YES completion:nil];
    
 }





//ユーザーの選択をアプリに知らせるために呼ばれるメソッド
//Called to let your app know which action was selected by the user for a given notification.
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    NSLog(@"User Info : %@",response.notification.request.content.userInfo);
    completionHandler();
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}




- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
