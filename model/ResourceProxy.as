package com.collectivecolors.extensions.flex3.resource.model
{
	//----------------------------------------------------------------------------
	// Imports
	
	import com.collectivecolors.extensions.as3.data.StatusVO;
	import com.collectivecolors.extensions.flex3.config.ConfigFacade;
	import com.collectivecolors.extensions.flex3.resource.ResourceFacade;
	import com.collectivecolors.extensions.flex3.resource.model.data.ResourceVO;
	
	import flash.events.IEventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.system.SecurityDomain;
	
	import mx.events.ResourceEvent;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
	//----------------------------------------------------------------------------
	
	public class ResourceProxy extends StartupProxy
	{
		//--------------------------------------------------------------------------
		// Constants
		
		public static const NAME : String = "resourceFacade_resourceProxy";
		
		//--------------------------------------------------------------------------
		// Constructor
		
		public function ResourceProxy( flashVars : Object = null )
		{
			super( NAME );
			
			// Loading of the application resources depends upon the configuration 
			// being loaded.
			addRequiredProxy( ConfigFacade.configProxy );
			
			setData( new ResourceVO( ResourceFacade.NAME ) );
			
			data.resourceManager = ResourceManager.getInstance( );
			
			data.applicationDomain = null;
			data.securityDomain    = SecurityDomain.currentDomain;
			
			data.location.allowedFileExtensions = [ 'swf' ];
		}
		
		//--------------------------------------------------------------------------
		// Accessors / Modifiers
		
		/**
		 * Get resource data object
		 */
		protected function get data( ) : ResourceVO
		{
		  return getData( ) as ResourceVO;
		}
		
		/**
		 * Get the status of the last resource load
		 */
		public function get status( ) : String
		{
		  return data.status;
		}
		
		/**
		 * Get the status message set when loading resources on application startup
		 */
		public function get message( ) : String
		{
			return data.message;
		}
		
		/**
		 * Get the resource manager for this application
		 */
		public function get resourceManager( ) : IResourceManager
		{
		  return data.resourceManager;
		}
		
		/**
		 * Set the locale chain for the application
		 */
		public function set localeChain( value : String ) : void
		{
		  data.resourceManager.localeChain = value;
		}
		
		/**
		 * Get the resource application domain for this resource extension
		 */
		public function get applicationDomain( ) : ApplicationDomain
		{
		  return data.applicationDomain;
		}
		
		/**
		 * Set the resource application domain for this resource extension
		 */
		public function set applicationDomain( value : ApplicationDomain ) : void
		{
		  data.applicationDomain = value;
		  sendNotification( ResourceFacade.UPDATED );
		}
		
		/**
		 * Get the resource security domain for this resource extension
		 */
		public function get securityDomain( ) : SecurityDomain
		{
		  return data.securityDomain;
		}
		
		/**
		 * Set the resource security domain for this resourcce extension
		 */
		public function set securityDomain( value : SecurityDomain ) : void
		{
		  data.securityDomain = value;
		  sendNotification( ResourceFacade.UPDATED );
		}
		
		/**
		 * Get the url locations of the resource files to import
		 */
		public function get urls( ) : Array
		{
		  return data.location.urls;
		}
		
		/**
		 * Set the url locations of the resource files to import
		 */
		public function set urls( values : Array ) : void
		{
		  data.location.urls = values;
		  sendNotification( ResourceFacade.UPDATED );
		}
		
		/**
		 * Add a url to the list of resource files to import
		 */
		public function addUrl( url : String ) : void
		{
		  data.location.addUrl( url );
		  sendNotification( ResourceFacade.UPDATED );
		}
		
		/**
		 * Remove a url from the list of resource files to import
		 */
		public function removeUrl( url : String ) : void
		{
		  data.location.removeUrl( url );
		  sendNotification( ResourceFacade.UPDATED );
		}
		
		/**
		 * Get whether or not this proxy has been loaded by the startup manager
		 */
		public function get initialized( ) : Boolean
		{
		  return data.initialized;
		}
		
		//--------------------------------------------------------------------------
		// Overrides
		
		/**
		 * Set the value of the failed startup notification name to our constant
		 * so it is easier to listen for in our mediators.
		 * 
		 * @see StartupProxy
		 */
		override protected function get failedNoteName( ) : String
		{
			return ResourceFacade.FAILED;
		}
		
		/**
		 * Set the value of the loaded startup notification name to our constant
		 * so it is easier to listen for in our mediators.
		 * 
		 * @see StartupProxy
		 */
		override protected function get loadedNoteName( ) : String
		{
			return ResourceFacade.LOADED;
		}
		
		/**
		 * Request resource SWF files from server and load them into application.
		 * 
		 * This method is automatically called by the StartupProxy's loadResources()
		 * method.
		 * 
		 * @see StartupProxy
		 */
		override public function load( ) : void
		{
			data.processed = 0;
			data.status    = StatusVO.NOTICE;
			data.message   = '';
			
			sendNotification( ResourceFacade.LOADING );
			
			for each ( var url : String in data.location.urls )
			{
				var manager : IEventDispatcher 
					= data.resourceManager.loadResourceModule( 
					    url, true, 
					    data.applicationDomain,
					    data.securityDomain
				);
					
				manager.addEventListener( ResourceEvent.ERROR, faultHandler );
				manager.addEventListener( ResourceEvent.COMPLETE, resultHandler );	
			}						
		}
		
		//--------------------------------------------------------------------------
		// Event handlers
		
		/**
		 * This is called if the stylesheet loading process encounters an error.
		 */
		private function faultHandler( event : ResourceEvent ) : void
		{
			data.status      = StatusVO.ERROR;
			data.message     = event.errorText;
			data.initialized = true;	
			
			sendFailedNotification( );	
		}
		
		/**
		 * This is called if the stylesheet loading is successful.
		 */
		private function resultHandler( event : ResourceEvent ) : void
		{
			data.processed++;
			
			if ( data.processed == data.location.urls.length )
			{			
				data.status      = StatusVO.SUCCESS;
				data.message     = "Application resources imported successfully";
				data.initialized = true;	
				
				sendLoadedNotification( );
			}	
		}
	}
}