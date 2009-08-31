package com.collectivecolors.extensions.flex3.resource.controller
{
  //----------------------------------------------------------------------------
  // Imports
  
  import com.collectivecolors.extensions.flex3.resource.ResourceFacade;
  
  import org.puremvc.as3.interfaces.INotification;
  import org.puremvc.as3.patterns.command.SimpleCommand;

  //----------------------------------------------------------------------------

  public class ResourceReloadCommand extends SimpleCommand
  {
    //--------------------------------------------------------------------------
    // Overrides
    
    override public function execute( note : INotification ) : void
    {
      if ( ResourceFacade.resourceProxy.initialized )
      {
        // Reload the resources.
        ResourceFacade.resourceProxy.load( );
      }  
    }    
  }
}