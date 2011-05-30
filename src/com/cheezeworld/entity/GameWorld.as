/* 
Copyright 2008 Cheezeworld.com 

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
*/
package com.cheezeworld.entity
{
	import com.cheezeworld.GameFactory;
	import com.cheezeworld.math.Vector2D;
	import com.cheezeworld.utils.*;
	
	import flash.display.*;
	import flash.events.*;
	
	public class GameWorld extends Entity
	{ 	
		public function set collisionResponse( a_value:ICollisionResponse ) : void { m_collisionResponse = a_value; }
	 	public var camera:GameCamera;
	 			
		public function GameWorld( a_worldSize:Vector2D, a_cameraSize:Vector2D, a_collisionResponse:ICollisionResponse = null )
		{ 
			var settings:EntityParams = new EntityParams();
			settings.forcedId = "GameWorld";
			super( settings );
		
			m_entitiesToAdd = [];
			m_entitiesToRemove = [];
	
			m_collisionResponse = a_collisionResponse;
			bounds.width = a_worldSize.x;
			bounds.height = a_worldSize.y;
			camera = new GameCamera( this, a_cameraSize.x, a_cameraSize.y );
			Input.instance.activateWorldMouse( this, 0, 0 );
		}
	 	
	 	public function setSize( a_width:int, a_height:int ) : void
	 	{
	 		bounds.setSize( a_width, a_height );
	 		dispatchEvent( new EntityEvent( EntityEvent.RESIZE, { width:a_width, height:a_height } ) );
	 	}
	 		 
	 	public override function update( a_timePassed:int ):void
	 	{
	 		updateChildren( a_timePassed );
	 		
	 		manageCollisions();
	 		
	 		processAddAndRemoves();
	 	}
	 	
	 	public override function dispose():void
	 	{
	 		processAddAndRemoves();
			
			m_entitiesToAdd = null;
			m_entitiesToRemove = null;
	 		camera = null;
	 		m_collisionResponse = null;
	 		
	 		super.dispose();		 
	 	}
	 	
	 	public override function addChild(a_entity:Entity):void
		{
			
			if( m_entitiesToAdd.indexOf( a_entity ) != -1 ) 
			{
				throw new Error( "<GameWorld> This entity is already queued for addition." );
				return;
			}
			if( getChildByID( a_entity.id ) != null )
			{
				throw new Error( "<GameWorld> There is an entity with this id already. Ensure ids are unique." );
				return;
			}
	
			var entityCount : int = m_entitiesToAdd.length;
			for( var entityIndex : int = entityCount - 1; entityIndex >= 0; entityIndex-- )
			{
				var ent : Entity = m_entitiesToAdd[ entityIndex ];
				if( ent.id == a_entity.id )
				{
					throw new Error( "<GameWorld> There is an entity with this id already. Ensure ids are unique." );				
					return;
				}
			}
		
			m_entitiesToAdd.push( a_entity );
	 	}
	 	
	 	public override function removeChild(a_id:String):void
	 	{
	 		var entity:Entity = getChildByID( a_id );
	 		if( m_entitiesToRemove.indexOf( entity ) != -1 ) 
			{
				throw new Error( "<GameWorld> This entity is already queued for removal." );
				return;
			}
			if( entity == null )
			{
				throw new Error( "<GameWorld> No entity matches id: " + a_id );
				return;
			}
			m_entitiesToRemove.push( entity );
	 	}
	 	
	 	// -- PRIVATE --
	 	
	 	private function manageCollisions():void
	 	{
	 		if( m_collisionResponse == null ) { return; }
	 		
	 		var entity1:Entity;
			var entity2:Entity;
			var entities:Array = getChildren();
			for ( var i:int = 0; i < entities.length; i++ )
			{
			 	entity1 = entities[ i ];	
			 
			 	if( !entity1.isCollidable )
			 	{
			 		continue;
			 	}
			 
			 	for ( var j:int = i + 1; j < entities.length; j++ )
			 	{
			 		entity2 = entities[ j ];
			 
			 		if( !entity2.isCollidable )
			 		{
			 			continue;
			 		}
			 
			 		if( entity1.isOverlapping( entity2 ) )
			 		{
			 			m_collisionResponse.handleCollision( entity1, entity2 );
			 		}
			 	}
			}
	 	}
	 	
	 	private function processAddAndRemoves() : void
		{
			addNewEntities();				
			removeOldEntities();
		}
		
		private function removeOldEntities() : void
		{
			var entityCount : int = m_entitiesToRemove.length;
			for( var entityIndex : int = entityCount - 1; entityIndex >= 0; entityIndex-- )
			{
				var entity : Entity = m_entitiesToRemove[ entityIndex ];				
				super.removeChild( entity.id );
			}
			
			m_entitiesToRemove.splice( 0 );
		}
		
		private function addNewEntities() : void
		{
			var entityCount:int = m_entitiesToAdd.length;
			for( var entityIndex:int = entityCount - 1; entityIndex >= 0; entityIndex-- )
			{
				var entity:Entity = m_entitiesToAdd[ entityIndex ];
				super.addChild( entity );
			}
			
			m_entitiesToAdd.splice( 0 );
		}
		
		private var m_collisionResponse:ICollisionResponse;
	 	private var m_entitiesToAdd:Array;
	 	private var m_entitiesToRemove:Array;
	 	
	}
}