#import "MyContactListener.h"
#import "Box2D.h"
#import "b2Contact.h"
#import "BasicLevelScene.h"
// Implement contact listener.
MyContactListener::MyContactListener(){};

void MyContactListener::BeginContact(b2Contact* contact)
{
	// Box2d objects that collided
	b2Fixture* fixtureA = contact->GetFixtureA();
	b2Fixture* fixtureB = contact->GetFixtureB();
	// Sprites that collided
	CCSprite* actorA = (CCSprite*) fixtureA->GetBody()->GetUserData();
	CCSprite* actorB = (CCSprite*)  fixtureB->GetBody()->GetUserData();
    
	// This is only true if for example a sprite touched something in your box2d simulation that was not a sprite such as the ground
	// You may not want to return here, so keep that in mind
	if(actorA == nil || actorB == nil)
        [[GameLevelLayer sharedGameLayer] bodyContactWithBody:fixtureA->GetBody() andBody:fixtureB->GetBody()];
    
	// Information about the collision, such as where it hit exactly on each body
	b2WorldManifold* worldManifold = new b2WorldManifold();
	contact->GetWorldManifold(worldManifold);
    
	// Maybe you wanna handle it differently but for this example, we're going to simply use our global object (see previous post)
	// To store the gamescene where these bodies exist and tell it they collided
	[[GameLevelLayer sharedGameLayer] beginContactBetweenSprite:actorA andSprite:actorB];
}

// Implement contact listener.
void MyContactListener::EndContact(b2Contact* contact)
{
	// Box2d objects that collided
	b2Fixture* fixtureA = contact->GetFixtureA();
	b2Fixture* fixtureB = contact->GetFixtureB();
	// Sprites that collided
	CCSprite* actorA = (CCSprite*) fixtureA->GetBody()->GetUserData();
	CCSprite* actorB = (CCSprite*)  fixtureB->GetBody()->GetUserData();
    
	// This is only true if for example a sprite touched something in your box2d simulation that was not a sprite such as the ground
	// You may not want to return here, so keep that in mind
	if(actorA == nil || actorB == nil) return;
    
	// Information about the collision, such as where it hit exactly on each body
	b2WorldManifold* worldManifold = new b2WorldManifold();
	contact->GetWorldManifold(worldManifold);
    
	// Maybe you wanna handle it differently but for this example, we're going to simply use our global object (see previous post)
	// To store the gamescene where these bodies exist and tell it they collided
	//[[GameLevelLayer sharedGameLayer] beginContactBetweenSprite:actorA andSprite:actorB];
}