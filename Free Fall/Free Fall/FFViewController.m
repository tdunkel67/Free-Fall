//
//  FFViewController.m
//  Free Fall
//
//  Created by DIVMS on 4/6/14.
//  Copyright (c) 2014 Tyler Dunkel. All rights reserved.
//

#import "FFViewController.h"
#import "FFMyScene.h"
#import "CoreMotion/CoreMotion.h"

@interface FFViewController()

@property (nonatomic,strong) CMMotionManager *motionManager;
@property (nonatomic) CGPoint previousLocation;
@end

@implementation FFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.motionManager = [[CMMotionManager alloc] init];
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    SKScene * scene = [FFMyScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
   
    if(self.motionManager.deviceMotionAvailable)
    {
        self.motionManager.deviceMotionUpdateInterval = 1.0f/2.0f;
    
        [self.motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXMagneticNorthZVertical toQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion *motion,NSError *error)
         {
             [scene enumerateChildNodesWithName:@"character" usingBlock:^(SKNode *node,BOOL *stop)
             {
                 if(motion.attitude.roll > 0)
                     node.physicsBody.velocity = CGVectorMake(25,0);
                 else if(motion.attitude.roll < 0)
                     node.physicsBody.velocity = CGVectorMake(-25,0);
                 else
                     node.physicsBody.velocity = CGVectorMake(0,0);
             }];
             NSLog(@"%f",motion.attitude.roll);
             
        
         }];
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

@end
