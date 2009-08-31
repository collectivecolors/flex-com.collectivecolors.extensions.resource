package com.collectivecolors.extensions.flex3.resource
{
  //----------------------------------------------------------------------------
  // Imports
  
  import com.collectivecolors.emvc.patterns.extension.Extension;
  import com.collectivecolors.extensions.as3.data.StatusVO;
  import com.collectivecolors.extensions.flex3.config.ConfigFacade;
  import com.collectivecolors.extensions.flex3.resource.controller.ResourceConfigParseCommand;
  import com.collectivecolors.extensions.flex3.resource.controller.ResourceReloadCommand;
  import com.collectivecolors.extensions.flex3.resource.controller.ResourceStartupCommand;
  import com.collectivecolors.extensions.flex3.resource.model.ResourceProxy;
  import com.collectivecolors.extensions.flex3.startup.StartupFacade;
  
  //----------------------------------------------------------------------------

  public class ResourceFacade extends Extension
  {
    //--------------------------------------------------------------------------
    // Constants
    
    public static const NAME : String = "resourceFacade";
    
    // Notifications
    
    public static const UPDATED : String = "resourceFacadeUpdated";
    public static const LOAD : String    = "resourceFacadeLoad"; 
    
    public static const LOADING : String = "resourceFacadeLoading";
		public static const LOADED : String  = "resourceFacadeLoaded";
		public static const FAILED : String  = "resourceFacadeFailed";
		
		//---------------------    
    // Configuration tags
    
    public static const CONFIG_URL : String = "resourceUrl";
    
		// Status types ( for status information )
		
		public static const STATUS_SUCCESS : String = StatusVO.SUCCESS;
		public static const STATUS_NOTICE : String  = StatusVO.NOTICE;
		public static const STATUS_ERROR : String   = StatusVO.ERROR;
    
    //--------------------------------------------------------------------------
    // Constructor
    
    public function ResourceFacade( )
    {
      super( NAME );
    }
    
    //--------------------------------------------------------------------------
    // Overrides
    
    override public function onRegister( ) : void
    {
      if ( ! core.hasExtension( ConfigFacade.NAME ) )
      {
        core.registerExtension( new ConfigFacade( ) );
      }  
    }
    
    //--------------------------------------------------------------------------
    // Accessors
    
    public static function get resourceProxy( ) : ResourceProxy
    {
      return core.retrieveProxy( ResourceProxy.NAME ) as ResourceProxy;
    }
    
    //--------------------------------------------------------------------------
    // eMVC hooks
    
    public function initializeController( ) : void
    {
      core.registerCommand( StartupFacade.REGISTER_RESOURCES, ResourceStartupCommand );
      core.registerCommand( ConfigFacade.PARSE, ResourceConfigParseCommand );
      core.registerCommand( LOAD, ResourceReloadCommand ); 
    }    
  }
}