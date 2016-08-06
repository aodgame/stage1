/**
 * Created by alexo on 19-Jun-15.
 */
package elements
{
import flash.display.MovieClip;
import flash.events.MouseEvent;

public class ElemMCLow extends ParentElement
{
    public var pic:MovieClip;

    public function ElemMCLow(pics, picAddr, ii, typpe, moduleName, i)
    {
        creation(pics, picAddr, ii, typpe, moduleName, i);
    }

    override public function fate(i):int
    {
        if (i==1)
        {
            //trace("f");
            //pic.buttonMode = pic.mouseEnabled = pic.useHandCursor = true;
            pic.mouseChildren = false;
            pic.addEventListener(MouseEvent.CLICK, clickClick);
        }
        if (i==0)
        {
            pic.removeEventListener(MouseEvent.CLICK, clickClick);
            removeChild(pic);
        }
        return i;
    }

    private function clickClick(event:MouseEvent):void
    {
        trace("clickClick="+iii);
        bit.mouseClick=iii;
        bit.mouseParClick=parnt;
        trace("parClick="+bit.mouseParClick);
    }

    override public function creation(pics, picAddr, ii, typpe, moduleName, i):void
    {
        super.creation(pics, picAddr, ii, typpe, moduleName, i);
        pic=pics.takeYourMovie(picAddr);
        pic.x=0;
        pic.y=0;
        pic.visible=false;
        pic.gotoAndStop(1);

        addChild(pic);
        //trace("vis!");

        fate(1);

        ready=true;
    }
}
}
