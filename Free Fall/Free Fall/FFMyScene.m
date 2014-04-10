//
//  FFMyScene.m
//  Free Fall
//
//  Created by DIVMS on 4/6/14.
//  Copyright (c) 2014 Tyler Dunkel. All rights reserved.
//

#import "FFMyScene.h"

@interface FFMyScene() <SKPhysicsContactDelegate>

@property const uint8_t characterBitMask;
@property const uint8_t obstacleBitMask;
@property const uint8_t powerUpBitMask;
@property const uint8_t cloudBitMask;

@end

@implementation FFMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here*/
        
        self.characterBitMask = 0x01;
        self.obstacleBitMask = 0x02;
        self.powerUpBitMask = 0x04;
        self.cloudBitMask = 0x08;
        
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"background"];
        background.size = self.size;
        background.position = CGPointMake(self.size.width/2,self.size.height/2);
        [self addChild:background];
        
        SKSpriteNode *character = [SKSpriteNode spriteNodeWithImageNamed:@"character"];
        character.position = CGPointMake(self.frame.size.width/2,self.frame.size.height-75);
        character.size = CGSizeMake(65,70);
        character.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(character.size.width, character.size.height-5)];
        
        character.physicsBody.categoryBitMask = self.characterBitMask;
        character.physicsBody.contactTestBitMask = self.obstacleBitMask;
        character.physicsBody.collisionBitMask = 0;
        character.physicsBody.allowsRotation = NO;
        character.name = @"character";
        character.zPosition = 0;
        
        self.physicsWorld.contactDelegate = self;
        
        [self addChild:(character)];
        
        self.physicsWorld.gravity = CGVectorMake(0,0);
        
        [NSTimer scheduledTimerWithTimeInterval:45.0 target:self selector:@selector(sendPowerUp) userInfo:nil repeats:YES];
        
        [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(sendCloud) userInfo:nil repeats:YES];
        
        [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(sendObstacle) userInfo:nil repeats:YES];
    }
    return self;
}

-(void) sendObstacle
{
    int random = arc4random() % 15;
    SKSpriteNode *obstacle;
    SKAction *rotation = [SKAction rotateByAngle:M_PI duration:3.0];
    rotation = [SKAction repeatActionForever:rotation];
#warning Change the physics body rectangle to match the specific object. Same with size of object. Make plane bigger and less likely to appear by using a scaling factor on the random generator
    switch (random)
    {
        case 0:
            obstacle = [SKSpriteNode spriteNodeWithImageNamed:@"plane"];
            obstacle.size = CGSizeMake(150,70);
            obstacle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(150,70)];
            break;
        case 1:
        case 2:
        case 3:
            obstacle = [SKSpriteNode spriteNodeWithImageNamed:@"rock"];
            obstacle.size = CGSizeMake(100,70);
            obstacle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(100,70)];
            [obstacle runAction:rotation];
            break;
        case 4:
        case 5:
        case 6:
        case 7:
        case 8:
            obstacle = [SKSpriteNode spriteNodeWithImageNamed:@"dynamite"];
            obstacle.size = CGSizeMake(50,50);
            obstacle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(35,50)];
            break;
        default:
            obstacle = [SKSpriteNode spriteNodeWithImageNamed:@"crate"];
            obstacle.size = CGSizeMake(80,50);
            obstacle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(80,50)];
            break;
    }
    
    random = arc4random() % (int)self.frame.size.width;
    obstacle.position = CGPointMake(random,-50);
    obstacle.name = @"object";
    
    obstacle.physicsBody.categoryBitMask = self.obstacleBitMask;
    obstacle.physicsBody.contactTestBitMask = self.characterBitMask;
    obstacle.physicsBody.velocity = CGVectorMake(0,125);
    obstacle.physicsBody.friction = 0.0;
    obstacle.physicsBody.collisionBitMask = 0;
    
    if(obstacle.position.x < obstacle.size.width)
        obstacle.position = CGPointMake(obstacle.size.width,-50);
    else if(obstacle.position.x > self.frame.size.width - obstacle.size.width)
        obstacle.position = CGPointMake(self.frame.size.width - obstacle.size.width,-50);
    
    [self addChild:obstacle];
}

-(void) sendPowerUp
{
    int random = arc4random() % 3;
    SKSpriteNode *powerUp;
    
    switch (random)
    {
        case 0:
            powerUp = [SKSpriteNode spriteNodeWithImageNamed:@"fire"];
            break;
        case 1:
            powerUp = [SKSpriteNode spriteNodeWithImageNamed:@"lightning"];
            break;
        case 2:
            powerUp = [SKSpriteNode spriteNodeWithImageNamed:@"wind"];
            break;
    }
    
    random = arc4random() % (int)self.frame.size.width;
    powerUp.position = CGPointMake(random,-50);
    powerUp.size = CGSizeMake(30,30);
    powerUp.name = @"object";
    
    powerUp.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:15];
    powerUp.physicsBody.categoryBitMask = self.powerUpBitMask; // Change bit mask for each power up
    powerUp.physicsBody.contactTestBitMask = self.characterBitMask;
    powerUp.physicsBody.velocity = CGVectorMake(0,125);
    powerUp.physicsBody.friction = 0.0;
    powerUp.physicsBody.collisionBitMask = 0;
    
    if(powerUp.position.x < powerUp.size.width)
        powerUp.position = CGPointMake(powerUp.size.width,-50);
    else if(powerUp.position.x > self.frame.size.width - powerUp.size.width)
        powerUp.position = CGPointMake(self.frame.size.width - powerUp.size.width,-50);
    
    [self addChild:powerUp];
}

-(void) sendCloud
{
    int randomCloud = arc4random() % 4;
    SKSpriteNode *cloud;
    if(randomCloud == 0)
        cloud = [SKSpriteNode spriteNodeWithImageNamed:@"cloud"];
    else
        cloud = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"cloud%d",randomCloud]];
    
    cloud.position = CGPointMake(arc4random() % (int)self.size.width,-50);
    cloud.size = CGSizeMake(150,100);
    cloud.alpha = .1*(arc4random()%10);
    cloud.name = @"object";
    
    cloud.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(150,100)];
    cloud.physicsBody.categoryBitMask = 0;
    cloud.physicsBody.contactTestBitMask = 0;
    cloud.physicsBody.velocity = CGVectorMake(0,125);
    cloud.physicsBody.friction = 0.0;
    cloud.physicsBody.collisionBitMask = 0;
    
    if(cloud.position.x < cloud.size.width)
        cloud.position = CGPointMake(cloud.size.width,-50);
    else if(cloud.position.x > self.frame.size.width - cloud.size.width)
        cloud.position = CGPointMake(self.frame.size.width - cloud.size.width,-50);
    
    [self addChild:cloud];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins*/
    
}

-(void)update:(CFTimeInterval)currentTime
{
    [self enumerateChildNodesWithName:@"object" usingBlock:^(SKNode *node,BOOL *stop)
    {
        if(node.position.y > self.frame.size.height + node.frame.size.height)
            [node removeFromParent];
    }];
}

-(void)didBeginContact:(SKPhysicsContact*) contact
{
    SKPhysicsBody *firstBody,*secondBody;
    if(contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if((firstBody.categoryBitMask & self.characterBitMask) != 0)
    {
        if((secondBody.categoryBitMask & self.obstacleBitMask) != 0)
            NSLog(@"Game Over");
        else
        {
            [secondBody.node removeFromParent];
            NSLog(@"Power-up");
        }
    }
    
}
@end
