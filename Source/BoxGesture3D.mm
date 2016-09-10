//
//  Gesture3D.mm
//  Toolbox
//
//  Created by Gérald Guyomard on 11/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BoxGesture3D.h"
#import "Box3D.h"
#import "Ray3D.h"
#import "GLView.h"
#import "Camera3D.h"

using namespace Toolbox;

@implementation BoxGesture3D

+(id) boxGestureWithGLView:(GLView*)iGLView andBox3D:(Toolbox::Box3D&)iBox3D
{
	return [[[BoxGesture3D alloc] initWithGLView:iGLView andBox3D:iBox3D] autorelease];	
}

-(id) initWithGLView:(GLView*)iView andBox3D:(Toolbox::Box3D&)iBox3D
{
	if (self = [super initWithGLView:iView andNode3D:iBox3D])
	{
		
	}
	
	return self;
}

-(Toolbox::Box3D*) box3D
{
	return (Toolbox::Box3D*) _Target.object();	
}

-(BOOL) touchesbegan:(NSSet*)touches withEvent:(UIEvent*)event
{
	[super touchesbegan:touches withEvent:event];
	
	// Determine the plane being hit
	UITouch* touch = [touches anyObject];
	Ray3D globalRay = [_GLView ray:touch];
	TB_ASSERT(!globalRay.isNull());
	
	Box3D* box3D = [self box3D];
	TB_ASSERT(NULL != box3D);
	
	Ray3D localRay;
	box3D->globalToLocal(globalRay, localRay);
	const AABoxf& box = box3D->box();
	
	Plane3D localPlanes[AABoxf::ePlaneCount];
	box.planes(localPlanes);
	
	Float32 minCoeff = FLT_MAX;
	Int32 planeIndex = -1;
	
	for (Uint32 i=0; i < AABoxf::ePlaneCount; ++i)
	{
		Float32 coeff;
		if (localRay.intersectsWith(localPlanes[i], &coeff) && (coeff < minCoeff))
		{
			_InitialHitPoint = localRay.pointAt(coeff);
			if (box.contains(_InitialHitPoint))
			{
				minCoeff = coeff;
				planeIndex = i;		
			}
		}
	}
	
	if (planeIndex >= 0)
	{
		AABoxf::EPlaneID planeID = (AABoxf::EPlaneID) planeIndex;
		NSLog(@"Touched Plane:%d", planeID);
		
		Vector3f vertices[4];
		box.pointsOfPlane(planeID, vertices);
		
		const Matrix44f& globalMatrix = box3D->globalMatrix();
		
		globalMatrix.transformPoints(vertices, 4, vertices);
		
		// Project the edges
		Camera3D* cam = [_GLView.delegate camera];
		TB_ASSERT(NULL != cam);
		
		Vector2f p2D[4];
		cam->projectPoints(vertices, p2D, 4);
		
		Vector2f pt = [touch locationInView:_GLView];
		float squareDist;
		
		// Find the closest edge
		float minSquareDistEdge = FLT_MAX;
		Int32 closestEdgeIndex = -1;
		
		for (Uint32 i=0; i < 3; ++i)
		{
			if (Vector2f::squareDistance(p2D[i], p2D[i + 1], pt, squareDist) && (squareDist < minSquareDistEdge))
			{
				minSquareDistEdge = squareDist;
				closestEdgeIndex = i;
			}
		}
		
		// Close the quad
		if (Vector2f::squareDistance(p2D[3], p2D[0], pt, squareDist) && (squareDist < minSquareDistEdge))
		{
			minSquareDistEdge = squareDist;
			closestEdgeIndex = 3;
		}
		
		TB_ASSERT(closestEdgeIndex >= 0);
		
		// Find the closest vertex
		float minSquareDistPt = FLT_MAX;
		Int32 closestPointIndex = -1;
		
		for (Uint32 i=0; i <= 3; ++i)
		{
			const float sd = (p2D[i] - pt).squareLength();
			if (sd < minSquareDistPt)
			{
				minSquareDistPt = sd;
				closestPointIndex = i;
			}
		}
		
		const float kMinPtDistance = 16.f;
		
		if (minSquareDistPt < kMinPtDistance * kMinPtDistance)
		{
			// Near a point
			NSLog(@"Near point:%d", closestPointIndex);
			
			// Define the translation plane				
			_WorkingPlane.createWithNormalAndPoint(Vector3f::kY, vertices[closestPointIndex]);
			
			float coeff;
			if (globalRay.intersectsWith(_WorkingPlane, &coeff))
			{
				// Translation
				_Type = eTranslateNode3D;
				
				_InitialHitPoint = globalRay.pointAt(coeff);
				_InitialPosition = globalMatrix.translation();
			}	
		}
		
		return YES;
	}
	
	return NO;
}

-(void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{	
	[super touchesMoved:touches withEvent:event];
	
	if (_Type == eTranslateNode3D)
	{
		// Move along the plane
		UITouch* touch = [touches anyObject];
		Ray3D globalRay = [_GLView ray:touch];
		TB_ASSERT(!globalRay.isNull());
		
		float coeff;
		if (globalRay.intersectsWith(_WorkingPlane, &coeff))
		{
			Vector3f hitPoint = globalRay.pointAt(coeff);
			Vector3f newPos = _InitialPosition + (hitPoint - _InitialHitPoint);
			
			Box3D* box3D = [self box3D];
			TB_ASSERT(NULL != box3D);
			
			box3D->setLocalPosition(newPos);
		}
	}
}

-(void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
	[super touchesEnded:touches withEvent:event];
}

@end
