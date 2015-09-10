//
//  AppDelegate.m
//  GeniusWatch
//
//  Created by clei on 15/8/21.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "AppDelegate.h"

#import "IndexViewController.h"
//#import "SliderViewController.h"
#import "MainSideViewController.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "MainViewController.h"
#import "BMapKit.h"
#import "LoginViewController.h"



@interface AppDelegate()<BMKGeneralDelegate>
{
    BMKMapManager *mapManager;
}
@property (nonatomic, strong) NSString *tokenString;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window.backgroundColor = [UIColor whiteColor];
    // Override point for customization after application launch.

    
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //注册百度地图
    mapManager = [[BMKMapManager alloc] init];
    [mapManager start:BAIDU_MAP_KEY generalDelegate:self];
    
    self.window =[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    [self addLoginView];
    
    //添加登录成功,注销通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSucess:) name:@"LoginSucess" object:nil];
    
    return YES;
}

#pragma mark 添加主视图
- (void)addMainview
{
    LeftViewController *leftViewController = [[LeftViewController alloc] init];
    MainViewController *mainViewController = [[MainViewController alloc] init];
    RightViewController *rightViewController = [[RightViewController alloc] init];
    MainSideViewController *sideViewController = [MainSideViewController sharedSliderController];
    sideViewController.leftViewShowWidth = LEFT_SIDE_WIDTH;
    sideViewController.rightViewShowWidth = RIGHT_SIDE_WIDTH;
    [sideViewController setNeedSwipeShowMenu:NO];
    [sideViewController setLeftViewController:leftViewController];
    [sideViewController setRootViewController:mainViewController];
    [sideViewController setRightViewController:rightViewController];
    
//    [SliderViewController sharedSliderController].LeftVC = leftViewController;
//    [SliderViewController sharedSliderController].MainVC = mainViewController;
//    [SliderViewController sharedSliderController].RightVC = rightViewController;
//    [SliderViewController sharedSliderController].LeftSContentOffset = LeftContentOffset;
//    [SliderViewController sharedSliderController].LeftContentViewSContentOffset = LeftContentViewOffset;
//    [SliderViewController sharedSliderController].LeftSContentScale = 0.75;
//    [SliderViewController sharedSliderController].LeftSJudgeOffset = LeftJudgeOffset;
//    [SliderViewController sharedSliderController].changeLeftView = ^(CGFloat sca, CGFloat transX)
//    {
//        CGAffineTransform ltransS = CGAffineTransformMakeScale(sca, sca);
//        CGAffineTransform ltransT = CGAffineTransformMakeTranslation(transX, 0);
//        CGAffineTransform lconT = CGAffineTransformConcat(ltransT, ltransS);
//        leftViewController.contentView.transform = lconT;
//    };
//    [SliderViewController sharedSliderController].RightSContentOffset = RIGHTContentOffset;
//    [SliderViewController sharedSliderController].RightSContentScale = 1;
//    [SliderViewController sharedSliderController].RightSJudgeOffset = LeftJudgeOffset;
   
    
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:sideViewController];
    self.window.rootViewController = navVC;
}

- (void)addLoginView
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSString *userName = [userDefault objectForKey:@"username"];
    if (userName)
    {
        [self addMainview];
        return;
    }
    
    NSString *isFirst =  [userDefault objectForKey:@"isFirst"];
    UIViewController *viewController;
    if (!isFirst)
    {
        viewController = [[IndexViewController alloc] init];
    }
    else
    {
        viewController = [[LoginViewController alloc] init];
        ((LoginViewController *)viewController).isShowBackItem = NO;
    }
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:viewController];
    self.window.rootViewController = navVC;
    
    [userDefault setObject:@"0" forKey:@"isFirst"];
    [userDefault synchronize];
}

#pragma mark 登录成功通知方法
- (void)loginSucess:(NSNotification *)notification
{
    [self addMainview];
}


#pragma mark 百度SDK启动地图认证Delegate
- (void)onGetNetworkState:(int)iError
{
    if (0 == iError)
    {
        NSLog(@"联网成功");
    }
    else
    {
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError)
    {
        NSLog(@"授权成功");
    }
    else
    {
        NSLog(@"onGetPermissionState %d",iError);
    }
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [BMKMapView willBackGround];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [BMKMapView didForeGround];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.chenlei.GeniusWatch" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"GeniusWatch" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"GeniusWatch.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
