//
//  AppDelegate.m
//  Bingo
//
//  Created by 1500244 on 2015/5/25.
//  Copyright (c) 2015年 andychan. All rights reserved.
//

#import "BingoDelegate.h"

@interface BingoDelegate ()
{
    UIApplicationState state;
}

@end

@implementation BingoDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //App啟動後，需要執行或詢問的事情
    NSLog(@"App啟動後，需要執行或詢問的事情");
    state=[[UIApplication sharedApplication] applicationState];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    //從啟動狀態轉為非啟動狀態，如：返回桌面，或切換至其他App
    NSLog(@"將從啟動狀態轉為非啟動狀態，如：返回桌面（單擊ＨＯＭＥ鍵），或切換至其他App（雙擊ＨＯＭＥ鍵）");
    state=[[UIApplication sharedApplication] applicationState];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    //程式進入後台（背景），需要切換到其他螢幕
    NSLog(@"程式進入後台（背景），需要切換到其他螢幕，關閉也算");
    state=[[UIApplication sharedApplication] applicationState];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    //程式將進入前台（激活），第一次開啟不動作
    NSLog(@"程式將進入前台（激活），需要為進入後台狀態");
    state=[[UIApplication sharedApplication] applicationState];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    //程式進入前台（已激活）
    NSLog(@"程式進入前台（已激活）");
    state=[[UIApplication sharedApplication] applicationState];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    //完全結束，已進入後臺就不作用，但直接連動有反應（雙擊home鍵拉除）
    NSLog(@"完全結束，已進入後臺就不作用，但直接連動有反應（雙擊home鍵拉除）");
    state=[[UIApplication sharedApplication] applicationState];
}

@end
