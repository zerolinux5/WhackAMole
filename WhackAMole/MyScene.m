//
//  MyScene.m
//  WhackAMole
//
//  Created by Jesus Magana on 7/6/14.
//  Copyright (c) 2014 ZeroLinux5. All rights reserved.
//

#import "MyScene.h"

#define IS_WIDESCREEN ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

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
        
        // Add more here later...
    }
    return self;
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
