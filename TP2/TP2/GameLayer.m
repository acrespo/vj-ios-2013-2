//
//  HelloWorldLayer.m
//  Tale
//
//  Created by AdminMacLC04 on 10/24/13.
//  Copyright AdminMacLC04 2013. All rights reserved.
//

#import "GameLayer.h"
#import "AppDelegate.h"
#import "GameObject.h"
#import "Player.h"
#import "Graph.h"
#import "MyDebugRenderer.h"
#import "SimpleAudioEngine.h"
#import "ObjectiveChipmunk.h"
#import "ChipmunkAutoGeometry.h"
#import "Enemy.h"

@implementation GameLayer

+ (CCScene *)scene {
    CCScene *scene = [CCScene node];
    GameLayer *layer = [GameLayer node];
    
    // add layer as a child to scene
    [scene addChild: layer];
    
    
    HudLayer *hud = [HudLayer node];
    [scene addChild:hud];
    layer->_hud = hud;
    
    // return the scene
    return scene;
}

- (id)init {
    self = [super initWithColor:ccc4(255,255,255,255)];
    
    if (self != nil) {
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        // At top of init for HelloWorldLayer
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"pickup.caf"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"hit.caf"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"move.caf"];
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"TileMap.caf"];
        
        _tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"TileMap.tmx"];
        [self addChild:_tileMap];
        _background = [_tileMap layerNamed:@"Background"];
        _foreground = [_tileMap layerNamed:@"Foreground"];
        
        _meta = [_tileMap layerNamed:@"Meta"];
//        _meta.visible = NO;
        
        
        _space = [[ChipmunkSpace alloc] init];
        
        // Add a CCPhysicsDebugNode to draw the space.
        CCPhysicsDebugNode *debugNode = [CCPhysicsDebugNode debugNodeForChipmunkSpace:_space];
        [self addChild:debugNode];
        
        
        // create the player
        _player = [[Player alloc] initWithLayer:self];
        [self addChild:_player];

        
        // init the game object arrays
        _enemies = [[NSMutableArray alloc] init];
        
        // set the intervals
        [self schedule:@selector(update:)];
        
        // enable touch
        [self setTouchEnabled:YES];
        
        CCTMXObjectGroup *objectGroup = [_tileMap objectGroupNamed:@"Objects"];
        NSAssert(objectGroup != nil, @"tile map has no objects object layer");
        
        NSDictionary *spawnPoint = [objectGroup objectNamed:@"SpawnPoint"];
        int x = [spawnPoint[@"x"] integerValue];
        int y = [spawnPoint[@"y"] integerValue];
        
        uint32_t tileGID = [_background tileGIDAt:CGPointMake(3, 0)];
        NSDictionary* properties = [_tileMap propertiesForGID:tileGID];
        
        NSLog(@"%@", properties);
        
        _player.chipmunkBody.pos = ccp(x,y);
        [self setViewPointCenter:_player.position];
        _graph = [[Graph alloc] initWithMap:_tileMap];
        
        MyDebugRenderer* renderer = [[MyDebugRenderer alloc] initWithGraph:_graph tileSize:_tileMap.tileSize];
        [self addChild:renderer];
        self.touchEnabled = YES;
        
        [self createTerrainGeometry];
        // add some crates, it's not a video game without crates!
        for(int i=0; i<16; i++){
            float dist = 50.0f;
            [self makeBoxAtX: x + (i % 4) * dist + 200 y: y + ( i / 4) * dist - 200];
        }
        
        for (spawnPoint in [objectGroup objects]) {
            if ([[spawnPoint valueForKey:@"Enemy"] intValue] == 1){
                x = [[spawnPoint valueForKey:@"x"] intValue];
                y = [[spawnPoint valueForKey:@"y"] intValue];
                [self addEnemyAtX:x y:y];
            }
        }
        
    }
    
    return self;
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    _mousePos = [self convertTouchToNodeSpace:touch];
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    _mousePos = [self convertTouchToNodeSpace:touch];
    _mouseDown = YES;
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    _mousePos = [self convertTouchToNodeSpace:touch];
    _mouseDown = NO;
    
    CGPoint touchLocation = [touch locationInView:touch.view];
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    touchLocation = [self convertToNodeSpace:touchLocation];
    
    CGPoint playerPos = _player.position;
    
    NSMutableArray* path = [self findPathFrom:playerPos to:touchLocation];
    
    [_graph printPath:path];
    [_player setPath:path];
    
//    CCLOG(@"playerPos %@",CGPointCreateDictionaryRepresentation(playerPos));
    [self setViewPointCenter:_player.position];
    
}

- (void)update:(ccTime)dt {
    _time += dt;
    
    NSMutableArray *inactive = [[NSMutableArray alloc] init];
    
    // update enemies
    for (GameObject *enemy in _enemies) {
        [enemy update:dt];
        
        if (!enemy.active) {
            [inactive addObject:enemy];
        }
    }
    
    // remove inactive game objects
    for (GameObject *gameObject in inactive) {
        if ([gameObject isKindOfClass:[GameObject class]]) {
            [_enemies removeObject:gameObject];
            [self removeChild:gameObject cleanup:YES];
        }
    }
    [_space step:dt];
}

-(NSMutableArray*) findPathFrom:(CGPoint)fromPos to:(CGPoint)toPos {
    
    Node* from  = [self nodeForPosition:fromPos];
    Node* to =  [self nodeForPosition:toPos];
    
//    CCLOG(@"fromCoord %@",CGPointCreateDictionaryRepresentation([self tileCoordForPosition:fromPos]));
    if (to == nil || to == (id)[NSNull null]) {
        CGPoint destCoordinate = [self tileCoordForPosition:toPos];
//        CCLOG(@"destCoordinate %@",CGPointCreateDictionaryRepresentation(destCoordinate));
        to = [[Node alloc] initWith:destCoordinate];
    }
    
    return [_graph findPathFrom:from to:to];
}
/* Private methods */

-(void)setPlayerPosition:(CGPoint)position {
	
    CGPoint tileCoord = [self tileCoordForPosition:position];
    tileCoord = ccp(tileCoord.x, _tileMap.mapSize.height - 1 - tileCoord.y);
    int tileGid = [_meta tileGIDAt:tileCoord];
    if (tileGid) {
        NSDictionary *properties = [_tileMap propertiesForGID:tileGid];
        if (properties) {
            
            NSString *collision = properties[@"Collidable"];
            if (collision && [collision isEqualToString:@"True"]) {
                [[SimpleAudioEngine sharedEngine] playEffect:@"hit.caf"];
                return;
            }
            
            NSString *collectible = properties[@"Collectable"];
            if (collectible && [collectible isEqualToString:@"True"]) {
                [[SimpleAudioEngine sharedEngine] playEffect:@"pickup.caf"];
                _numCollected++;
                [_hud numCollectedChanged:_numCollected];
                
                [_meta removeTileAt:tileCoord];
                [_foreground removeTileAt:tileCoord];
            }
        }
    }
    [[SimpleAudioEngine sharedEngine] playEffect:@"move.caf"];
    _player.position = position;
}

-(Node*)nodeForPosition:(CGPoint)position {
    int col = position.x/_tileMap.tileSize.width;
    int row = position.y/_tileMap.tileSize.height;
    return [_graph nodeForIndex:col*_tileMap.mapSize.height + row];
}

-(Node*)nodeForTile:(CGPoint)tilePosition {
    int col = tilePosition.x;
    int row = tilePosition.y;
    return [_graph nodeForIndex:col*_tileMap.mapSize.height + row];
}

-(CGPoint)tileCoordForPosition:(CGPoint)position {
    return ccp(floor(position.x/_tileMap.tileSize.width), floor(position.y/_tileMap.tileSize.height));
}

- (void)setViewPointCenter:(CGPoint) position {
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    int x = MAX(position.x, winSize.width/2);
    int y = MAX(position.y, winSize.height/2);
    x = MIN(x, (_tileMap.mapSize.width * _tileMap.tileSize.width) - winSize.width / 2);
    y = MIN(y, (_tileMap.mapSize.height * _tileMap.tileSize.height) - winSize.height/2);
    CGPoint actualPosition = ccp(x, y);
    
    CGPoint centerOfView = ccp(winSize.width/2, winSize.height/2);
    CGPoint viewPoint = ccpSub(centerOfView, actualPosition);
    self.position = viewPoint;
}

- (void)win {
    //CCScene *gameOverScene = [GameOverLayer sceneWithWon:YES];
    //[[CCDirector sharedDirector] replaceScene:gameOverScene];
}

- (void)createTerrainGeometry
{
    int tileCountW = _meta.layerSize.width;
    int tileCountH = _meta.layerSize.height;
    
    cpBB sampleRect = cpBBNew(-0.5, -0.5, tileCountW + 0.5, tileCountH + 0.5);
    
    ChipmunkBlockSampler *sampler = [[ChipmunkBlockSampler alloc] initWithBlock:^(cpVect point){
        
        point = cpBBClampVect(cpBBNew(0.5, 0.5, tileCountW - 0.5, tileCountH - 0.5), point);
        int x = point.x;
        int y = point.y;
        
        y = tileCountH - 1 - y;
        
        NSDictionary *properties = [_tileMap propertiesForGID:[_meta tileGIDAt:ccp(x, y)]];
        BOOL collidable = [[properties valueForKey:@"Collidable"] isEqualToString:@"True"];
        return (collidable ? 1.0f : 0.0f);
    }];
    
    ChipmunkPolylineSet * polylines = [sampler march:sampleRect xSamples:tileCountW + 2 ySamples:tileCountH + 2 hard:TRUE];
    
    cpFloat tileSize = _tileMap.tileSize.height;
    
    for(ChipmunkPolyline * line in polylines){
        ChipmunkPolyline * simplified = [line simplifyCurves:0.0f];
        
        for(int i=0; i<simplified.count-1; i++){
            
            cpVect a = cpvmult(simplified.verts[  i], tileSize);
            cpVect b = cpvmult(simplified.verts[i+1], tileSize);
            
            ChipmunkShape *seg = [_space add:[ChipmunkSegmentShape segmentWithBody:_space.staticBody from:a to:b radius:1.0f]];
            seg.friction = 1.0;
        }
    }
    
    // add left wall
    ChipmunkShape *segLeft = [ChipmunkSegmentShape segmentWithBody:_space.staticBody from:cpv(0, 0) to:cpv(0, tileCountH * tileSize) radius:1.0f];
//    segLeft.layers = COLLISION_TERRAIN_ONLY | COLLISION_TERRAIN;
    [_space add:segLeft];
    
    // add top wall
    ChipmunkShape *segTop = [ChipmunkSegmentShape segmentWithBody:_space.staticBody from:cpv(0, tileCountH * tileSize) to:cpv(tileCountW * tileSize, tileCountH * tileSize) radius:1.0f];
//    segTop.layers = COLLISION_TERRAIN_ONLY | COLLISION_TERRAIN;
    [_space add:segTop];
    
    // add right wall
    ChipmunkShape *segRight = [ChipmunkSegmentShape segmentWithBody:_space.staticBody from:cpv(tileCountW * tileSize, tileCountH * tileSize) to:cpv(tileCountW * tileSize, 0) radius:1.0f];
//    segRight.layers = COLLISION_TERRAIN_ONLY | COLLISION_TERRAIN;
    [_space add:segRight];
    
    // add bottom wall
    ChipmunkShape *segBottom = [ChipmunkSegmentShape segmentWithBody:_space.staticBody from:cpv(tileCountW * tileSize, 0) to:cpv(0, 0) radius:1.0f];
//    segBottom.layers = COLLISION_TERRAIN_ONLY | COLLISION_TERRAIN;
    [_space add:segBottom];
}

- (ChipmunkBody*)makeBoxAtX:(int)x y:(int)y
{
    float mass = 0.3f;
    float size = 27.0f;
    
    ChipmunkBody* body = [ChipmunkBody bodyWithMass:mass andMoment:cpMomentForBox(mass, size, size)];
    
    CCPhysicsSprite * boxSprite = [CCPhysicsSprite spriteWithFile:@"crate.png"];
    boxSprite.chipmunkBody = body;
    boxSprite.position = cpv(x,y);
    
    ChipmunkShape* boxShape = [ChipmunkPolyShape boxWithBody:body width: size height: size];
    boxShape.friction = 1.0f;
    
    [_space add:boxShape];
    [_space add:body];
    [self addChild:boxSprite];

    ChipmunkPivotJoint* pj = [_space add: [ChipmunkPivotJoint pivotJointWithBodyA:
                                          [_space staticBody] bodyB:body anchr1:cpvzero anchr2:cpvzero]];
    
    pj.maxForce = 1000.0f; // emulate linear friction
    pj.maxBias = 0; // disable joint correction, don't pull it towards the anchor.
    
    // Then use a gear to fake an angular friction (slow rotating boxes)
    ChipmunkGearJoint* gj = [_space add: [ChipmunkGearJoint gearJointWithBodyA:[_space staticBody] bodyB:body phase:0.0f ratio:1.0f]];
    
    gj.maxForce = 5000.0f;
    gj.maxBias = 0.0f;
    return body;
}

-(void)addEnemyAtX:(int)x y:(int)y {
//    CCSprite *enemy = [CCSprite spriteWithFile:@"enemy1.png"];
    Enemy *enemy = [[Enemy alloc ] initWithLayer:self];
    enemy.position = ccp(x, y);
    
    [_enemies addObject:enemy];
    
    [self addChild:enemy];
}

@end
