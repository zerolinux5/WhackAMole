//
//  MyScene.m
//  WhackAMole
//
//  Created by Jesus Magana on 7/6/14.
//  Copyright (c) 2014 ZeroLinux5. All rights reserved.
//

#import "MyScene.h"

#define IS_WIDESCREEN ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

const float kMoleHoleOffset = 155.0;

@implementation MyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        // Add background
        SKTextureAtlas *backgroundAtlas = [self textureAtlasNamed:@"background"];
        SKSpriteNode *dirt = [SKSpriteNode spriteNodeWithTexture:[backgroundAtlas textureNamed:@"bg_dirt"]];
        dirt.scale = 2.0;
        dirt.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        dirt.zPosition = 0;
        [self addChild:dirt];
        
        // Add foreground
        SKTextureAtlas *foregroundAtlas = [self textureAtlasNamed:@"foreground"];
        SKSpriteNode *upper = [SKSpriteNode spriteNodeWithTexture:[foregroundAtlas textureNamed:@"grass_upper"]];
        upper.anchorPoint = CGPointMake(0.5, 0.0);
        upper.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        upper.zPosition = 1;
        [self addChild:upper];
        
        SKSpriteNode *lower = [SKSpriteNode spriteNodeWithTexture:[foregroundAtlas textureNamed:@"grass_lower"]];
        lower.anchorPoint = CGPointMake(0.5, 1.0);
        lower.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        lower.zPosition = 3;
        [self addChild:lower];
        
        // Load sprites
        self.moles = [[NSMutableArray alloc] init];
        SKTextureAtlas *spriteAtlas = [self textureAtlasNamed:@"sprites"];
        self.moleTexture = [spriteAtlas textureNamed:@"mole_1.png"];
        
        
        float center = 240.0;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && IS_WIDESCREEN) {
            center = 284.0;
        }
        
        SKSpriteNode *mole1 = [SKSpriteNode spriteNodeWithTexture:self.moleTexture];
        mole1.position = [self convertPoint:CGPointMake(center - kMoleHoleOffset, 85.0)];
        mole1.zPosition = 2;
        mole1.name = @"Mole";
        mole1.userData = [[NSMutableDictionary alloc] init];
        [self addChild:mole1];
        [self.moles addObject:mole1];
        
        SKSpriteNode *mole2 = [SKSpriteNode spriteNodeWithTexture:self.moleTexture];
        mole2.position = [self convertPoint:CGPointMake(center, 85.0)];
        mole2.zPosition = 2;
        mole2.name = @"Mole";
        mole2.userData = [[NSMutableDictionary alloc] init];
        [self addChild:mole2];
        [self.moles addObject:mole2];
        
        SKSpriteNode *mole3 = [SKSpriteNode spriteNodeWithTexture:self.moleTexture];
        mole3.position = [self convertPoint:CGPointMake(center + kMoleHoleOffset, 85.0)];
        mole3.zPosition = 2;
        mole3.name = @"Mole";
        mole3.userData = [[NSMutableDictionary alloc] init];
        [self addChild:mole3];
        [self.moles addObject:mole3];
        
        self.laughAnimation = [self animationFromPlist:@"laughAnim"];
        self.hitAnimation = [self animationFromPlist:@"hitAnim"];
        
        // Add score label
        float margin = 10;
        
        self.scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        self.scoreLabel.text = @"Score: 0";
        self.scoreLabel.fontSize = [self convertFontSize:14];
        self.scoreLabel.zPosition = 4;
        self.scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        self.scoreLabel.position = CGPointMake(margin, margin);
        [self addChild:self.scoreLabel];
        
        self.laughSound = [SKAction playSoundFileNamed:@"laugh.caf" waitForCompletion:NO];
        self.owSound = [SKAction playSoundFileNamed:@"ow.caf" waitForCompletion:NO];
        
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"whack" withExtension:@"caf"];
        NSError *error = nil;
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        
        if (!self.audioPlayer) {
            NSLog(@"Error creating player: %@", error);
        }
        
        [self.audioPlayer play];
    }
    return self;
}

- (CGPoint)convertPoint:(CGPoint)point
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return CGPointMake(32 + point.x*2, 64 + point.y*2);
    } else {
        return point;
    }
}

- (SKTextureAtlas *)textureAtlasNamed:(NSString *)fileName
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        
        if (IS_WIDESCREEN) {
            // iPhone Retina 4-inch
            fileName = [NSString stringWithFormat:@"%@-568", fileName];
        } else {
            // iPhone Retina 3.5-inch
            fileName = fileName;
        }
        
    } else {
        fileName = [NSString stringWithFormat:@"%@-ipad", fileName];
    }
    
    SKTextureAtlas *textureAtlas = [SKTextureAtlas atlasNamed:fileName];
    
    return textureAtlas;
}

- (void)popMole:(SKSpriteNode *)mole
{
    if (self.totalSpawns > 50) return;
    self.totalSpawns++;
    
    // Reset texture of mole sprite
    mole.texture = self.moleTexture;
    
	SKAction *easeMoveUp = [SKAction moveToY:mole.position.y + mole.size.height duration:0.2f];
    easeMoveUp.timingMode = SKActionTimingEaseInEaseOut;
    SKAction *easeMoveDown = [SKAction moveToY:mole.position.y duration:0.2f];
    easeMoveDown.timingMode = SKActionTimingEaseInEaseOut;
    
    SKAction *setTappable = [SKAction runBlock:^{
        [mole.userData setObject:@1 forKey:@"tappable"];
    }];
    
    SKAction *unsetTappable = [SKAction runBlock:^{
        [mole.userData setObject:@0 forKey:@"tappable"];
    }];
    
    
    SKAction *sequence = [SKAction sequence:@[easeMoveUp, setTappable, self.laughSound, self.laughAnimation, unsetTappable, easeMoveDown]];
    [mole runAction:sequence completion:^{
        [mole removeAllActions];
    }];
}

- (SKAction *)animationFromPlist:(NSString *)animPlist
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:animPlist ofType:@"plist"]; // 1
    NSArray *animImages = [NSArray arrayWithContentsOfFile:plistPath]; // 2
    NSMutableArray *animFrames = [NSMutableArray array]; // 3
    for (NSString *imageName in animImages) { // 4
        [animFrames addObject:[SKTexture textureWithImageNamed:imageName]]; // 5
    }
    
    float framesOverOneSecond = 1.0f/(float)[animFrames count];
    
    return [SKAction animateWithTextures:animFrames timePerFrame:framesOverOneSecond resize:NO restore:YES]; // 6
}

- (float)convertFontSize:(float)fontSize
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return fontSize * 2;
    } else {
        return fontSize;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    
    SKNode *node = [self nodeAtPoint:touchLocation];
    if ([node.name isEqualToString:@"Mole"]) {
        SKSpriteNode *mole = (SKSpriteNode *)node;
        
        if (![[mole.userData objectForKey:@"tappable"] boolValue]) return;
        
        self.score += 10;
        
        [mole.userData setObject:@0 forKey:@"tappable"];
        [mole removeAllActions];
        
        SKAction *easeMoveDown = [SKAction moveToY:(mole.position.y - mole.size.height) duration:0.2f];
        easeMoveDown.timingMode = SKActionTimingEaseInEaseOut;
        
        // Slow down the animation by half
        easeMoveDown.speed = 0.5;
        
        SKAction *sequence = [SKAction sequence:@[self.owSound, self.hitAnimation, easeMoveDown]];
        [mole runAction:sequence];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    if (self.gameOver) return;
    
    if (self.totalSpawns >= 50) {
        
        SKLabelNode *gameOverLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        gameOverLabel.text = @"Level Complete!";
        gameOverLabel.fontSize = 48;
        gameOverLabel.zPosition = 4;
        gameOverLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                             CGRectGetMidY(self.frame));
        
        [gameOverLabel setScale:0.1];
        
        [self addChild:gameOverLabel];
        [gameOverLabel runAction:[SKAction scaleTo:1.0 duration:0.5]];
        
        self.gameOver = YES;
        return;
    }
    
    [self.scoreLabel setText:[NSString stringWithFormat:@"Score: %d", self.score]];
    /* Called before each frame is rendered */
    for (SKSpriteNode *mole in self.moles) {
        if (arc4random() % 3 == 0) {
            if (!mole.hasActions) {
                [self popMole:mole];
            }
        }
    }
}

@end
