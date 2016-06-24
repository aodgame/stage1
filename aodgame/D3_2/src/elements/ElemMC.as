package elements
{
import flash.display.MovieClip;
import flash.events.MouseEvent;
import flash.ui.Mouse;
import flash.ui.MouseCursor;

public class ElemMC  extends ParentElement
{
    public var pic:MovieClip;

    private var ww:int;
    private var hh:int;

    public function ElemMC(pics, picAddr, ii, typpe)
    {
        creation(pics, picAddr, ii, typpe);
    }

    override public function parse()
    {
        if (tid=="unselect")
        {
           pic.enabled=false;
           pic.mouseEnabled=false;
        }
    }

    public function sizes(sw, sh):void
    {
        var ww:int=0;
        if (sw!=0)
        {
            ww++;
            pic.scaleX=sw/100;
        }
        if (sh!=0)
        {
            ww++;
            pic.scaleY=sh/100;
        }
        if (ww>0)
        {
            pic.gotoAndStop(2);
        }
    }

    override public function fate(i):int
    {
        //trace("f");
        //pic.buttonMode = pic.mouseEnabled = pic.useHandCursor = true;
        pic.mouseChildren = false;
        pic.addEventListener(MouseEvent.CLICK, clickClick);
        pic.addEventListener(MouseEvent.MOUSE_DOWN, downClick);
        pic.addEventListener(MouseEvent.MOUSE_OVER, overClick);
        pic.addEventListener(MouseEvent.MOUSE_OUT, outClick);
        pic.addEventListener(MouseEvent.MOUSE_UP, upClick);

        return i;
    }

    private function scalaizing(z):void
    {
        /*trace("scalazing="+parnt);
        trace("specInfo.length="+specInfo.length);
        trace("specInfo.substr(0,3)="+specInfo.substr(0,3));
        trace(ww+":"+hh+":"+z);*/
        if (specInfo.length>=3 && specInfo.substr(0,3)=="btn")
        {
            pic.width=ww*z;
            pic.height=hh*z;
        }
    }

    private function upClick(event:MouseEvent):void
    {
        scalaizing(1);
        Mouse.cursor = MouseCursor.AUTO;
        bit.mouseUp=iii;
        bit.mouseParUp=parnt;
        trace("parUp="+bit.mouseParUp);
    }

    private function clickClick(event:MouseEvent):void
    {
        scalaizing(1.15);
        Mouse.cursor = MouseCursor.AUTO;
        trace("clickClick="+iii);

        bit.mouseClick=iii;
        bit.mouseParClick=parnt;
        trace("parClick="+bit.mouseParClick);
    }
    private function downClick(event:MouseEvent):void
    {
        scalaizing(1.3);
        Mouse.cursor = MouseCursor.BUTTON;
        //trace("downClick="+iii);
        bit.mouseDown=iii;
        bit.mouseParDown=parnt;
    }
    private function overClick(event:MouseEvent):void
    {
        //trace("timmmme");
        scalaizing(1.15);
        Mouse.cursor = MouseCursor.BUTTON;
        //trace("overClick="+iii);
        bit.mouseOver=iii;
        bit.mouseParOver=parnt;
    }
    private function outClick(event:MouseEvent):void
    {
        scalaizing(1);
        Mouse.cursor = MouseCursor.AUTO;
        trace("outClick="+iii);
        bit.mouseOut=iii;
        bit.mouseParOut=parnt;
    }

    override public function creation(pics, picAddr, ii, typpe):void
    {
        super.creation(pics, picAddr, ii, typpe);
        pic=pics.takeYourMovie(picAddr);
        //trace("picAddr="+picAddr);
        pic.x=0;
        pic.y=0;
        ww=pic.width;
        hh=pic.height;
        pic.visible=false;
        pic.gotoAndStop(1);

        addChild(pic);
        //trace("vis!");

        if (tid!="unselect")
        {
            fate(1);
        }

        ready=true;
    }
}
}
