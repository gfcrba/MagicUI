package by.gamefactory.utils;
import ru.stablex.ui.widgets.InputText;
import flash.display.Sprite;
import ru.stablex.ui.events.WidgetEvent;
import ru.stablex.ui.widgets.Text;
import ru.stablex.ui.widgets.Bmp;
import flash.Lib;
import flash.geom.Point;
import ru.stablex.ui.skins.Paint;
import flash.text.TextField;
import ru.stablex.ui.events.DndEvent;
import ru.stablex.ui.Dnd;
import flash.events.MouseEvent;
import ru.stablex.ui.widgets.Tip;
import ru.stablex.ui.UIBuilder;
import ru.stablex.ui.widgets.Widget;
import flash.display.DisplayObjectContainer;
import flash.display.DisplayObject;

class MagicUI {

    private static var victim:Widget;

    private static var changingWidth:Bool = false;

    private static var changingHeight:Bool = false;

    private static var previousMousePosition:Point = new Point(0,0);

    private static var currentControl:SizeControl;

    public static function makeItWhistle(content:Widget, generateBackground:Bool = false,recursive : Bool = false):Void
    {
        if(recursive)
        {
            for(i in 0...content.numChildren)
            {
                if(Std.is(content.getChildAt(i),Widget))
                {
                    makeItWhistle(cast(content.getChildAt(i),Widget),generateBackground,recursive);
                }
            }
        }

        content.tip = UIBuilder.create(Tip);
        generateTip(content);

        if( generateBackground == true
            && content.skin == null
            && !Std.is(content,Bmp)
        )
        {
            content.skin = new Paint();
            cast(content.skin,Paint).color = Math.floor(256 * Math.random())
                                           * Math.floor(256 * Math.random())
                                           * Math.floor(256 * Math.random());
            content.skin.apply(content);
         }

        content.addEventListener(MouseEvent.MOUSE_DOWN,drag);
        content.addEventListener(DndEvent.DROP,drop);
        content.addEventListener(MouseEvent.RIGHT_CLICK,showMenu);
        content.addEventListener(WidgetEvent.RESIZE,resizeControls);
        if(!Std.is(content,Text))
        {
            addControls(content);
        }
    }

    private static function resizeControls(e:WidgetEvent):Void
    {
        for(index in 0...e.widget.numChildren)
        {
            if( Std.is(e.widget.getChildAt(index),SizeControl)
                && cast(e.widget.getChildAt(index),SizeControl).type != currentControl.type)
            {
                 cast(e.widget.getChildAt(index),SizeControl).resize();
            }
        }
    }

    private static function showMenu(e:MouseEvent):Void
    {
        e.stopImmediatePropagation();
        trace(e.target.name);
    }

    private static function generateTip(item:Widget):Void
    {
        item.tip.text = '';

        item.tip.text += item.name + "\nTop: " + item.top + " Left: " + item.left +
                         "\nBottom: " + item.bottom + " Right: " + item.right +
                         "\nW: " + item.w +" H: " + item.h;
    }

    private static function addControls(target:Widget):Void
    {
        var widthControl:SizeControl = new SizeControl(target,SizeControlType.WidthControl);
        var heightControl:SizeControl = new SizeControl(target,SizeControlType.HeightControl);

        target.addChild(widthControl);
        target.addChild(heightControl);

        widthControl.addEventListener(MouseEvent.MOUSE_DOWN,changeWidth);
        heightControl.addEventListener(MouseEvent.MOUSE_DOWN,changeHeight);

        Lib.current.stage.addEventListener(MouseEvent.MOUSE_MOVE,mouseTracking);
        Lib.current.stage.addEventListener(MouseEvent.MOUSE_UP,releaseControl);
    }

    private static function mouseTracking(e:MouseEvent):Void
    {
        if(changingWidth)
        {
            victim.w = victim.w + e.stageX - previousMousePosition.x;
            currentControl.x = victim.w;
            generateTip(victim);
        } else if(changingHeight) {
            victim.h = victim.h + e.stageY - previousMousePosition.y;
            currentControl.y = victim.h;
            generateTip(victim);
        }
        previousMousePosition.x = e.stageX;
        previousMousePosition.y = e.stageY;
    }

    private static function drag(e:MouseEvent):Void
    {
        if(Std.is(e.target,TextField))
        {
            victim = cast(e.target.parent, Widget);
            Dnd.drag(victim);
        } else {
            if(Std.is(e.target,Widget))
            {
                victim = cast(e.target, Widget);
                Dnd.drag(victim);
            }
        }

    }

    private static function changeWidth(e:MouseEvent):Void
    {
        victim = e.target.parent;
        currentControl = e.target;
        changingWidth = true;
    }

    private static function changeHeight(e:MouseEvent):Void
    {
        victim = e.target.parent;
        currentControl = e.target;
        changingHeight = true;
    }

    private static function releaseControl(e:MouseEvent):Void
    {
        changingWidth = false;
        changingHeight = false;
    }

    public static function drop(e:DndEvent):Void
    {
        if(victim != null)
        {
            victim.tip.text = '';
            e.accept(victim.parent);
            victim.tip.text += victim.name +
                               "\nTop: " + victim.top + " Left: " + victim.left +
                               "\nBottom: " + victim.bottom + " Right: " + victim.right +
                               "\nW: " + victim.w +" H: " + victim.h;
        }

    }
}

class SizeControl extends Sprite
{

    public var type:SizeControlType;

    public var target:Widget;

    public function new(target:Widget, type:SizeControlType, ?size:Point)
    {
        super();
        this.target = target;
        this.type = type;
        if(size == null)
        {
            if(type == SizeControlType.WidthControl)
            {
                _drawRectControl(3, target.h/4);
            } else {
                _drawRectControl(target.h/4, 3);
            }
        }

        positionControl();
    }

    private function positionControl():Void
    {
        if(type == SizeControlType.WidthControl)
        {
            this.x = target.w;
            this.y = (target.h - this.height) / 2;
        } else {
            this.x = (target.w - this.width) / 2;
            this.y = target.h;
        }
    }

    public function resize():Void
    {
        if(type == SizeControlType.WidthControl)
        {
            _drawRectControl(3, target.h/4);
        } else {
            _drawRectControl(target.w/4, 3);
        }
        positionControl();
    }

    private function _drawRectControl(w:Float,h:Float):Void
    {
        this.graphics.clear();
        this.graphics.beginFill(0x999999);
        this.graphics.drawRect(0,0,w,h);
        this.graphics.endFill();
    }
}


class PropertiesEditor extends InputText
{
    private var properties:Map<String, Dynamic>;

    public function new()
    {
        super();
        setStyle();
        properties = new Map<String, Dynamic>();
    }

    private function setStyle():Void
    {
        visible = false;
        w = 200;
        h = 350;
        skin = new Paint();
        cast(skin, Paint).color = 0x333333;
        cast(skin, Paint).border = 1;
    }

    public function hide():Void
    {
        visible = false;
    }

    public function show():Void
    {
        visible = true;
    }

    private function applyProperties():Void
    {
        if(text != '')
        {
            var lines:Array<String> = text.split('\n');

            for(line in lines)
            {

            }
        }
    }
}

enum SizeControlType
{
    WidthControl;
    HeightControl;
}
