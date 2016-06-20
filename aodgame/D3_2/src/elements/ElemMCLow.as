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

    public function ElemMCLow(pics, picAddr, ii, typpe)
    {
        creation(pics, picAddr, ii, typpe);
    }

    override public function fate(i):int
    {
        //pic.buttonMode = pic.mouseEnabled = pic.useHandCursor = true;
        pic.mouseChildren = false;
        pic.addEventListener(MouseEvent.CLICK, clickClick);
        return i;
    }

    private function clickClick(event:MouseEvent):void
    {
        trace("clickClick="+iii);
        bit.mouseClick=iii;
        bit.mouseParClick=parnt;
        trace("parClick="+bit.mouseParClick);
    }

    override public function creation(pics, picAddr, ii, typpe):void
    {
        super.creation(pics, picAddr, ii, typpe);
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
