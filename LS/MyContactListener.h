#import "Box2D.h"
#import "b2Contact.h"
#import "BasicLevelScene.h"

class MyContactListener : public b2ContactListener
{
public:
	MyContactListener();
    
	void* userData; /// Use this to store application specific body data.
	void BeginContact(b2Contact* contact); // When we first contact
	void EndContact(b2Contact* contact); // When we end contact
};