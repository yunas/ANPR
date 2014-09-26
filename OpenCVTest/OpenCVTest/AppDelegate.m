//
//  AppDelegate.m
//  OpenCVTest
//
//  Created by Muhammad Rashid on 03/09/2014.
//  Copyright (c) 2014 Muhammad Rashid. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)renameFilesAndSaveInsideFolder:(NSString*)folder prefix:(NSString*)prefix suffix:(NSString*)ext {
    NSBundle* myBundle = [NSBundle mainBundle];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *myImages = [myBundle URLsForResourcesWithExtension:@"JPG" subdirectory:nil];
    
    NSError *error = nil;
    
    NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:folder];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
    
    NSURL *finalURL = [NSURL fileURLWithPath:dataPath];
    
    NSInteger count = 161;
    
    for (NSURL *url in myImages) {
        
        NSString *filename = [url lastPathComponent];
        
        //change the suffix to what you are looking for
        if ([filename hasSuffix:ext]) {
            
            NSURL *newURL = [finalURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%d%@",count,ext]];
            [manager moveItemAtURL:url toURL:newURL error:&error];
            count++;
            
            if (error) {
                NSLog(@"%@",[error localizedDescription]);
            }
        }
        else {
            NSLog(@"filename:%@",filename);
        }
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    [self renameFilesAndSaveInsideFolder:@"LNPR_Full_images" prefix:@"NEWIMG_" suffix:@".JPG"];
    
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application {
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
