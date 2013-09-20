//
//  CSEEmboss.m
//  CocosShaderEffects
//
//  Created by Ray Wenderlich on 3/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CSEEmboss.h"

@implementation CSEEmboss {
    CCSprite *sprite;  //1
    int timeUniformLocation;
    float totalTime;
}

- (id)init
{
    self = [super init];
    if (self) {
        // 1
        sprite = [CCSprite spriteWithFile:@"Default.png"];
        sprite.anchorPoint = CGPointZero;
        sprite.rotation = 90;
        sprite.position = ccp(0, 320);
        [self addChild:sprite];
        
        // 2
        const GLchar * fragmentSource = (GLchar*) [[NSString stringWithContentsOfFile:[CCFileUtils fullPathFromRelativePath:@"CSEEmboss.fsh"] encoding:NSUTF8StringEncoding error:nil] UTF8String];
        sprite.shaderProgram = [[CCGLProgram alloc] initWithVertexShaderByteArray:ccPositionTextureA8Color_vert
                                                          fragmentShaderByteArray:fragmentSource];
        [sprite.shaderProgram addAttribute:kCCAttributeNamePosition index:kCCVertexAttrib_Position];
        [sprite.shaderProgram addAttribute:kCCAttributeNameTexCoord index:kCCVertexAttrib_TexCoords];
        [sprite.shaderProgram link];
        [sprite.shaderProgram updateUniforms];
        
        // 3
		timeUniformLocation = glGetUniformLocation(sprite.shaderProgram->program_, "u_time");
        
		// 4
		[self scheduleUpdate];
        
        // 5
        [sprite.shaderProgram use];
        
    }
    return self;
}

- (void)update:(float)dt
{
    totalTime += dt;
    [sprite.shaderProgram use];
    glUniform1f(timeUniformLocation, totalTime);
}

@end
