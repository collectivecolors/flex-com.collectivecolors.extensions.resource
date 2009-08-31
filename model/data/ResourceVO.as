package com.collectivecolors.extensions.flex3.resource.model.data
{
  //----------------------------------------------------------------------------
  // Imports
  
  import com.collectivecolors.data.URLSet;
  import com.collectivecolors.extensions.as3.data.StatusVO;
  
  import flash.system.ApplicationDomain;
  import flash.system.SecurityDomain;
  
  import mx.resources.IResourceManager;
  
  //----------------------------------------------------------------------------
  
  public class ResourceVO extends StatusVO
  {
    //--------------------------------------------------------------------------
    // Properties
    
    public var resourceManager : IResourceManager;
    
    public var applicationDomain : ApplicationDomain;
    public var securityDomain : SecurityDomain;
    
    public var location : URLSet;
    
    public var initialized : Boolean = false;
    
    private var _processed : int = 0;    
        
    //--------------------------------------------------------------------------
    // Constructor
    
    public function ResourceVO( extensionName : String = null )
    {
      super( extensionName );
      
      location = new URLSet( );  
    }
    
    //--------------------------------------------------------------------------
    // Accessors / modifiers
    
    //-----------------------
    // property : processed
    
    public function get processed( ) : int
    {
      return _processed;
    }
    
    public function set processed( value : int ) : void
    {
      _processed = ( value != null && value >= 0 ? value : 0 );
    }   
  }
}