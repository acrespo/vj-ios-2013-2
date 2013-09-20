//
//  CSEColorRamp.m
//  CocosShaderEffects
//
//  Created by Ray Wenderlich on 3/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CSEColorRamp.h"


@implementation CSEColorRamp {
    CCSprite *sprite;  //1
    int colorRampUniformLocation;  //2
    CCTexture2D *colorRampTexture; //3
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
        const GLchar * fragmentSource = (GLchar*) [[NSString stringWithContentsOfFile:[CCFileUtils fullPathFromRelativePath:@"CSEColorRamp.fsh"] encoding:NSUTF8StringEncoding error:nil] UTF8String];
        sprite.shaderProgram = [[CCGLProgram alloc] initWithVertexShaderByteArray:ccPositionTextureA8Color_vert
                                       fragmentShaderByteArray:fragmentSource];
        [sprite.shaderProgram addAttribute:kCCAttributeNamePosition index:kCCVertexAttrib_Position];
        [sprite.shaderProgram addAttribute:kCCAttributeNameTexCoord index:kCCVertexAttrib_TexCoords];
        [sprite.shaderProgram link];
        [sprite.shaderProgram updateUniforms];
        
        // 3
        colorRampUniformLocation = glGetUniformLocation(sprite.shaderProgram->program_, "u_colorRampTexture");
        glUniform1i(colorRampUniformLocation, 1);
        
        // 4
        colorRampTexture = [[CCTextureCache sharedTextureCache] addImage:@"colorRamp.png"];
        [colorRampTexture setAliasTexParameters];
        
        // 5
        [sprite.shaderProgram use];
        glActiveTexture(GL_TEXTURE1);
        glBindTexture(GL_TEXTURE_2D, [colorRampTexture name]);
        glActiveTexture(GL_TEXTURE0);
    }
    return self;
}

@end
