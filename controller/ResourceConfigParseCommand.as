package com.collectivecolors.extensions.flex3.resource.controller
{
  //----------------------------------------------------------------------------
  // Imports
  
  import com.collectivecolors.extensions.flex3.resource.ResourceFacade;
  import com.collectivecolors.extensions.flex3.resource.model.data.ResourceVO;
  import com.collectivecolors.utils.XMLParser;
  
  import org.puremvc.as3.interfaces.INotification;
  import org.puremvc.as3.patterns.command.SimpleCommand;

  //----------------------------------------------------------------------------

  public class ResourceConfigParseCommand extends SimpleCommand
  {
    //--------------------------------------------------------------------------
    // Overrides
    
    override public function execute( note : INotification ) : void
    {
      var config : XML = note.getBody( ) as XML;
      
      // Set locales ( multiple tags optional )
      
			ResourceFacade.resourceProxy.urls = XMLParser.parseMultiTagOptional( 
			  config[ ResourceFacade.NAME ], 
			  ResourceFacade.CONFIG_URL,
			  "Resource urls are incorrectly specified"			
			);			  
    }    
  }
}