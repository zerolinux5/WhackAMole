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
        mole1.zPosition = 999;
        mole1.name = @"Mole";
        mole1.userData = [[NSMutableDictionary alloc] init];
        [self addChild:mole1];
        [self.moles addObject:mole1];
        
        SKSpriteNode *mole2 = [SKSpriteNode spriteNodeWithTexture:self.moleTexture];
        mole2.position = [self convertPoint:CGPointMake(center, 85.0)];
        mole2.zPosition = 999;
        mole2.name = @"Mole";
        mole2.userData = [[NSMutableDictionary alloc] init];
        [self addChild:mole2];
        [self.moles addObject:mole2];
        
        SKSpriteNode *mole3 = [SKSpriteNode spriteNodeWithTexture:self.moleTexture];
        mole3.position = [self convertPoint:CGPointMake(center + kMoleHoleOffset, 85.0)];
        mole3.zPosition = 999;
        mole3.name = @"Mole";
        mole3.userData = [[NSMutableDictionary alloc] init];
        [self addChild:mole3];
        [self.moles addObject:mole3];
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

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
