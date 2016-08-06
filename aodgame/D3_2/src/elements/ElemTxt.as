/**
 * Created by alexo on 19-Jul-15.
 */
package elements
{
import flash.events.MouseEvent;
import flash.filters.GlowFilter;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.ui.Mouse;
import flash.ui.MouseCursor;

public class ElemTxt extends ParentElement
{
    public var pic:TextField;
    public var txt:String;

    public var wi:int=0;
    public var he:int=0;
    public var tColor:uint=0xFFFFFF;
    public var fColor:uint=0xFFFFFF;

    public var algn:String="center";
    public var bld:Boolean=false;
    public var size:int=0;

    private var glowFilter:GlowFilter;
    private var filter:Boolean;

    public var format:TextFormat = new TextFormat();

    public function ElemTxt(pics, picAddr, ii, typpe, moduleName, i)
    {
        creation(pics, picAddr, ii, typpe, moduleName, i);
    }

    override public function parse():void
    {
        var temp:String=tid;
        tid="";
        var currType:int=0;
        var color:String="";

        for (var i:int=0; i<temp.length; i++)
        {
            if (temp.charAt(i)!=":")
            {
                if (currType == 7)
                {
                    color += temp.charAt(i);
                }
                if (currType == 6)
                {
                    size = size * 10 + int(temp.charAt(i));
                }
                if (currType == 5)
                {
                    if (temp.charAt(i) == "f")
                    {
                        bld = false;
                    } else
                    {
                        bld = true;
                    }
                }
                if (currType == 4)
                {
                    if (temp.charAt(i) == "c")
                    {
                        algn = "center";
                    }
                    if (temp.charAt(i) == "l")
                    {
                        algn = "left";
                    }
                    if (temp.charAt(i) == "r")
                    {
                        algn = "right";
                    }
                }
                if (currType == 3)
                {
                    color += temp.charAt(i);
                }
                if (currType == 2)
                {
                    he = he * 10 + int(temp.charAt(i));
                }
                if (currType == 1)
                {
                    wi = wi * 10 + int(temp.charAt(i));
                }
                if (currType == 0)
                {
                    tid += temp.charAt(i);
                }
            }
            else
            {
                if (currType==7)
                {
                    filter=true;
                    fColor=uint(color);
                    color="";
                }
                if (currType==3)
                {
                    tColor=uint(color);
                    color="";
                }
                currType+=1;
            }
        }

        if (wi==0)
        {
            wi = 120;
        }
        if (he==0)
        {
            he = 30;
        }
        if (size==0)
        {
            size = 16;
        }
    }

    override public function fate(i):int
    {
        if (i==1)
        {
            //pic.buttonMode = pic.mouseEnabled = pic.useHandCursor = true;
            pic.addEventListener(MouseEvent.CLICK, clickClick);
            pic.addEventListener(MouseEvent.MOUSE_DOWN, downClick);
            pic.addEventListener(MouseEvent.MOUSE_OVER, overClick);
            pic.addEventListener(MouseEvent.MOUSE_OUT, outClick);
        }
        if (i==0)
        {
            pic.removeEventListener(MouseEvent.CLICK, clickClick);
            pic.removeEventListener(MouseEvent.MOUSE_DOWN, downClick);
            pic.removeEventListener(MouseEvent.MOUSE_OVER, overClick);
            pic.removeEventListener(MouseEvent.MOUSE_OUT, outClick);
            removeChild(pic);
        }

        return i;
    }

    public function makeFormat()
    {
        pic.width=wi;
        pic.height=he;
        pic.textColor=tColor;

        format.align=algn;
        format.bold=bld;
        format.size=size;
        pic.setTextFormat(format);
        if (filter)
        {
            glowFilter.color=fColor;
            pic.filters = [glowFilter];
        }
    }

    private function clickClick(event:MouseEvent):void
    {
        Mouse.cursor = MouseCursor.AUTO;
        trace("clickClick="+iii);

        bit.mouseClick=iii;
        bit.mouseParClick=parnt;
        trace("parClick="+bit.mouseParClick);
    }
    private function downClick(event:MouseEvent):void
    {
        Mouse.cursor = MouseCursor.BUTTON;
        //trace("downClick="+iii);
        bit.mouseDown=iii;
        bit.mouseParDown=parnt;
    }
    private function overClick(event:MouseEvent):void
    {
        if (pic.visible)
        {
            Mouse.cursor = MouseCursor.BUTTON;
            trace("txt overClick=" + iii);
            bit.mouseOver = iii;
            bit.mouseParOver = parnt;
        }
    }
    private function outClick(event:MouseEvent):void
    {
        Mouse.cursor = MouseCursor.AUTO;
        //trace("outClick="+iii);
        bit.mouseOut=iii;
        bit.mouseParOut=parnt;
    }

    override public function creation(pics, picAddr, ii, typpe, moduleName, i):void
    {
        super.creation(pics, picAddr, ii, typpe, moduleName, i);
        //trace("picAddr="+picAddr);
        pic = new TextField();
        pic.x=0;
        pic.y=0;

        tid="txt";
        txt="";
        pic.text=txt;
        pic.selectable=false;
        addChild(pic);

        pic.multiline=true;
        pic.wordWrap=true;
        pic.selectable=false;

        filter=false;
        glowFilter = new GlowFilter();
        glowFilter.color = fColor;
        glowFilter.strength=4;

        makeFormat();
        fate(1);
        ready=true;
    }
}
}
