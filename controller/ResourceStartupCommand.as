package com.collectivecolors.extensions.flex3.resource.controller
{
  //----------------------------------------------------------------------------
  // Imports
  
  import com.collectivecolors.extensions.flex3.resource.model.ResourceProxy;
  
  import org.puremvc.as3.interfaces.INotification;
  import org.puremvc.as3.patterns.command.SimpleCommand;

  //----------------------------------------------------------------------------

  public class ResourceStartupCommand extends SimpleCommand
  {
    //--------------------------------------------------------------------------
    // Overrides
    
    override public function execute( note : INotification ) : void
    {
      // Load resources  	
      facade.registerProxy( new ResourceProxy( note.getBody( ) ) );  
    }    
  }
}