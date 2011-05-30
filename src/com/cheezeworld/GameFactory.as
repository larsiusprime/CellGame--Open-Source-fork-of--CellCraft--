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
package com.cheezeworld
{
	
	import com.cheezeworld.entity.Entity;
	import com.cheezeworld.entity.EntityParams;
	import com.cheezeworld.entity.GameWorld;
	import com.cheezeworld.entity.ICollisionResponse;
	import com.cheezeworld.entity.MovingEntity;
	import com.cheezeworld.math.Vector2D;
	import com.cheezeworld.rendering.ARenderer;
	import com.cheezeworld.rendering.GameWorldRenderer;
	
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;
	
	public class GameFactory
	{		
		public function GameFactory()
		{
			m_paramMap = new Dictionary();
			m_globalForces = new Dictionary();
		}
	 	// ------------------------------------------------------------
	 	
	 	public function getEntityParams( a_type:String ) : EntityParams
	 	{
	 		if( m_paramMap[ a_type ] == null )
	 		{
	 			throw new Error( "<GameFactory> Type not recognized!" );
	 		}
	 		return m_paramMap[ a_type ];
	 	}
	 	
	 	public function createGameworld( a_worldSize:Vector2D, a_cameraSize:Vector2D, a_renderSurface:DisplayObjectContainer, a_collisionResponse:ICollisionResponse = null ) : GameWorld
	 	{
	 		m_world = new GameWorld( a_worldSize, a_cameraSize, a_collisionResponse );
	 		m_gwRenderer = new GameWorldRenderer( m_world, a_renderSurface );
	 		return m_world;
	 	}
	 	
	 	public function registerEntityType( a_params:EntityParams ) : void
	 	{
	 		if( a_params.type == null )
	 		{
	 			throw new Error( "<GameFactory> a_params.type must be non null!" );
	 		}
	 		m_paramMap[ a_params.type ] = a_params;
	 	}
	 	
	 	/**
	 	 * Will add a constant force to all entities of type MovingEntity
	 	 */ 		
	 	public function addGlobalForce( a_force:Vector2D, a_name:String ) : void
	 	{
	 		m_globalForces[ a_name ] = a_force;
	 		m_globalForces[ a_force ] = a_name;
	 	}
	 	
	 	/**
	 	 *  This does NOT remove the force from any entities that were created
	 	 *  using it! To do that you must remove the force by calling the appropriate
	 	 *  function on the entities themselves.
	 	 */ 		
	 	public function removeGlobalForce( a_name:String ) : void
	 	{
	 		var force:Vector2D = m_globalForces[ a_name ];
	 		delete m_globalForces[ force ];
	 		m_globalForces[ force ] = null;
	 		delete m_globalForces[ a_name ];
	 		m_globalForces[ a_name ] = null;
	 	}
	 	
	 	public function getEntity( a_type:String, a_parent:Entity=null ) : Entity
	 	{
	 		var params:EntityParams;
	 		var renderer:ARenderer;
	 		var entity:Entity;
	 		
	 		params = m_paramMap[ a_type ];
	 		if( params == null )
			{
				throw new Error( "<GameFactory> " + a_type + " is not a registered Entity type!" );
			}
			
	 		switch( a_type )
	 		{
	 			default:
					
					entity = new params.customClass( params );
					a_parent.addChild( entity );
					
					if( entity is MovingEntity )
					{
						for each( var obj:Object in m_globalForces )
						{
							if( obj is Vector2D )
							{
								var force:Vector2D = obj as Vector2D;
								MovingEntity( entity ).addConstantForce( force, m_globalForces[ force ] );
							}
						}
					}
					
					if( params.rendererClass != null )
					{
						getRenderer( entity, params.rendererClass, params.rendererData );	
					}
					
					return entity;
	 				break;
	 		}
	 	}
	 	
	 	
	 	public function getRenderer( a_entity:Entity, a_renderer:Class, a_data:Object=null ):ARenderer
	 	{ 	
	 		if( m_world == null || m_gwRenderer == null )
	 		{
	 			throw new Error( "<GameFactory> GameWorld and GameWorldRenderer must be initialized before calling getRenderer!" );
	 		}
	 		return new a_renderer( a_entity, m_world.camera, m_gwRenderer.getLayer( a_entity.layer ), ( a_data == null ? new Object() : a_data ) ); 
	 	}
	 	
	 	public function dispose() : void
	 	{
	 		for( var key:Object in m_paramMap )
	 		{
	 			delete m_paramMap[ key ];
	 		}
	 		m_paramMap = null;
	 		for( key in m_globalForces )
	 		{
	 			delete m_globalForces[ key ];
	 		}
	 		m_globalForces = null;
	 		m_world = null;
	 		m_gwRenderer = null;
	 	}
	 	
		private var m_paramMap:Dictionary;
		private var m_globalForces:Dictionary;
		private var m_world:GameWorld;
		private var m_gwRenderer:GameWorldRenderer;
	}
}


