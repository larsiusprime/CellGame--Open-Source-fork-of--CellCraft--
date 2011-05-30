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
	
 	import com.cheezeworld.math.AABBox;
 	import com.cheezeworld.math.Vector2D;
 	
 	import flash.display.*;
 	import flash.events.EventDispatcher;
 	import flash.utils.Dictionary;

	 public class Entity extends EventDispatcher
	 { 
	 	public function get scale():Number{ return m_scale; }
	 	public function set scale( a_value:Number ):void
	 	{
	 		m_scale = a_value;
	 		dispatchEvent( new EntityEvent( EntityEvent.CHANGE_SCALE, a_value ) );
	 	}
	 	
	 	public function get id():String{ return m_id; }
	 	public function get type():String{ return _type; }
	 	public function get parent():Entity{ return _parent; }
	 	public function set parent( a_value:Entity ) : void 
	 	{ 
	 		if( _parent == a_value ) { return; }
	 		
	 		if( _parent ) // if parent exists
	 		{
	 			_parent.removeChild( id );
	 		}
	 		
	 		_parent = a_value;
	 		
	 		if( _parent && _parent.getChildByID( m_id ) == null ) // if parent is not null and does not contain this entity
			{
				_parent.addChild(this);
			} 
	 	}
	 	
	 	public function get layer() : int
 		{
 			if( m_layer == -1 )
 			{
 				throw new Error( "<Entity> " + id + " cannot get layer. It has not been declared!" );
 			}
 			return m_layer;
 		} 		
	 	
	 	/**
	 	 * NOTES:	The following variables are left open rather than using getter/setters because they are accessed
	 	 * 			often and thus this VASTLY improves performance.
	 	 * 
	 	 * 			newPos and actualPos ( have to use these since we don't do getter/setter )
	 	 * 		 	newPos var should be what you change if you wish to change pos externally.
	 	 */ 		
	 	public var newPos:Vector2D; 
	 	public var actualPos:Vector2D;
	 	public var rotation:Number; 
	 	public var radius:Number; 		
	 	public var bounds:AABBox; 	
	 	public var isCollidable:Boolean;
	 	
	 	/**
	 	 * ID's are assigned automatically. If it is necessary to force an ID then set it
	 	 * in the parameter file passed through the constructor.
	 	 * 
	 	 */ 		
	 	
	 	public function Entity( a_params:EntityParams )
	 	{	
	 		actualPos = new Vector2D();
	 		newPos = actualPos.copy();
			_entityMap = new Dictionary();
			_gameObjects = [];
			
			scale = a_params.scale;
	 		radius = a_params.radius; 
	 		rotation = a_params.rotation;
	 		m_layer = a_params.layer;
	 		isCollidable = a_params.isCollidable;	
	 		
	 		bounds = new AABBox( actualPos, radius, radius );
	 		
	 		_type = a_params.type;
	 		if( a_params.forcedId == null ){ m_id = ""+m_nextID++ + "-" + _type; }
	 		else{ m_id = a_params.forcedId; }		
	 	} 		
	 	
	 	public function update( a_timePassed:int ):void
	 	{
	 		setInitialValues( a_timePassed );
	 		
	 		updateChildren( a_timePassed );
	 	}
	 	
	 	public function dispose():void
	 	{
	 		newPos = null;
	 		actualPos = null;
	 		bounds = null;
	 		
			for ( var key:Object in _entityMap  )
			{
				_entityMap[ key ].dispose();
				delete _entityMap[ key ];				
			}			
			_entityMap = null;
			
			for( var i:int = 0; i < _gameObjects.length; i++ )
			{
				_gameObjects[ i ].dispose();
			}
			
			_gameObjects = null;
			
	 		_parent = null;
	 		
	 		dispatchEvent( new EntityEvent ( EntityEvent.DISPOSE ) );
	 	}
	 	
	 	public function isOverlapping( a_entity:Entity ):Boolean
	 	{
	 		var distSq:Number = actualPos.distanceSqTo( a_entity.actualPos );
	 		var range:Number = radius + a_entity.radius;
	 		if( distSq < range * range )
	 		{
	 			return true;
	 		}
	 		return false;
	 	}
	 	
	 	public function isOverlappingCircle( a_pos:Vector2D, a_radius:Number ) : Boolean
	 	{
	 		var distSq:Number = actualPos.distanceSqTo( a_pos );
	 		var range:Number = radius + a_radius;
	 		if( distSq < range * range )
	 		{
	 			return true;
	 		}
	 		return false;
	 	}
	 	
	 	public function addChild( a_entity:Entity ):void
	 	{	 			
			if( _entityMap[ a_entity.id ] != null )
			{
				throw new Error( "<Entity> There is an entity with this id already. Ensure ids are unique." );
				return;
			}
			
			_entityMap[ a_entity.id ] = a_entity;
			a_entity.parent = this;
	 		dispatchEvent( new EntityEvent( EntityEvent.ADD_ENTITY, a_entity ) );
	 	}
	 	
	 	public function removeChild( a_id:String ):void
	 	{
	 		
			if( Entity( _entityMap[ a_id ] ) == null )
			{
				throw new Error( "<Entity> There was no entity with a matching id." );
				return;
			}
			
			_entityMap[ a_id ].dispose();
			delete _entityMap[ a_id ];
	 	}
	 	
	 	public function clearChildren( a_classType:Class = null ) : void
	 	{
			for each( var entity:Entity in _entityMap )
			{
				if( a_classType ){ if( !( entity is a_classType ) ){ continue; } }
				delete _entityMap[ entity.id ];
				entity.dispose();
			}
	 	}
	 	
	 	public function getChildByID( a_id:String ):Entity{ return Entity( _entityMap[ a_id ] ); }
	 	
	 	public function getChildren() : Array
	 	{
	 		var tempArray:Array = [];
	 		
	 		for each ( var entity:Entity in _entityMap )
	 		{
 				tempArray.push( entity );
	 		}
	 		
	 		return tempArray;
	 	}
	 	
	 	public function addGameObject( a_gameObject:IGameObject ):void
	 	{
	 		
	 		if( _gameObjects.indexOf( a_gameObject ) >= 0 )
	 		{
	 			throw new Error( "<Entity> That Game Object already exists!" );
	 		}
	 		
	 		_gameObjects.push( a_gameObject );
	 	}
	 	
	 	public function getGameObjects() : Array
	 	{
	 		return _gameObjects;
	 	}
	 	
	 	public function removeGameObject( a_object:IGameObject ):void
	 	{
	 		var removalIndex : int = _gameObjects.indexOf( a_object );
			if( removalIndex >= 0 )
			{
				_gameObjects.splice( removalIndex, 1 );
			}
			a_object.dispose();
	 	}
	 	
	 	override public function toString():String
	 	{
	 		return ( "<"+id+">" );
	 	}
	 	
	  	// -- PRIVATE --
	  	
	  	protected function updateChildren( a_timePassed:Number ):void
	  	{
	  		for each ( var entity:Entity in _entityMap )
	 		{
	 			entity.update( a_timePassed );
	 		}
	 		for( var i:int = 0; i < _gameObjects.length; i++ )
	 		{
	 			IGameObject( _gameObjects[ i ] ).update( a_timePassed );
	 		}
	  	}
	  	
	  	protected function setInitialValues( a_timePassed:int ):void
	  	{
	  		_stepSize = a_timePassed * 0.001;
	 		actualPos.x = newPos.x;
	 		actualPos.y = newPos.y;
	 		
	 		// .. Update bounds ...
	 		bounds.center.x = actualPos.x
			bounds.center.y = actualPos.y;
			bounds.left = bounds.center.x - bounds.halfWidth;
			bounds.right = bounds.center.x + bounds.halfWidth;
			bounds.top = bounds.center.y - bounds.halfHeight;
			bounds.bottom = bounds.center.y + bounds.halfHeight;
			bounds.topLeft.x = bounds.left; 
			bounds.topLeft.y = bounds.top;
			bounds.bottomRight.x = bounds.right; 
			bounds.bottomRight.y = bounds.bottom;
			bounds.topRight.x = bounds.right; 
			bounds.topRight.y = bounds.top;
			bounds.bottomLeft.x = bounds.left; 
			bounds.bottomLeft.y = bounds.bottom;
	  	}
	  	
	  	protected var _stepSize:Number;
	  	protected var _parent:Entity;
	  	protected var _entityMap:Dictionary;
	 	protected var _gameObjects:Array;
	 	protected var _type:String;
	  	
	  	private static var m_nextID:int = 0;
	  	private var m_scale:Number;
	  	private var m_id:String;
	 	private var m_layer:int;
	 	
	 }
}
