//
//  MyScene.h
//  WhackAMole
//

//  Copyright (c) 2014 ZeroLinux5. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MyScene : SKScene

@property (strong, nonatomic) NSMutableArray *moles;
@property (strong, nonatomic) SKTexture *moleTexture;

@property (strong, nonatomic) SKAction *laughAnimation;
@property (strong, nonatomic) SKAction *hitAnimation;

@property (strong, nonatomic) SKLabelNode *scoreLabel;
@property (nonatomic) NSInteger score;
@property (nonatomic) NSInteger totalSpawns;
@property (nonatomic) BOOL gameOver;

@end