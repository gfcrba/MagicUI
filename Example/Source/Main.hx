package;


import ru.stablex.ui.widgets.Widget;
import flash.events.MouseEvent;
import flash.display.DisplayObjectContainer;
import by.gamefactory.utils.MagicUI;
import ru.stablex.ui.UIBuilder;
import flash.display.DisplayObject;
import openfl.display.Sprite;


class Main extends Sprite {

    private var _dispalyContent:DisplayObject = null;
	
	public function new () {
		
		super ();
		UIBuilder.init();
        	UIBuilder.regSkins('skins.xml');
		_dispalyContent = addChild( UIBuilder.buildFn('testDialog.xml')());
		MagicUI.makeItWhistle(cast(_dispalyContent,Widget),true);
	}
	
	
}
