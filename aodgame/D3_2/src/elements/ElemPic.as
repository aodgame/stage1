/**
 * Created by alexo on 25-May-15.
 */
package elements
{
import flash.display.MovieClip;
import flash.events.MouseEvent;

public class ElemPic extends ParentElement
{
    public var pic:MovieClip;

    public function ElemPic(pics, picAddr, ii, typpe)
    {
        creation(pics, picAddr, ii, typpe);
    }

    override public function fate(i):int
    {
        //pic.buttonMode = pic.mouseEnabled = pic.useHandCursor = true;
        pic.mouseChildren = false;
        //pic.addEventListener(MouseEvent.CLICK, overClick);

        return i;
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

    /*function overClick(event:MouseEvent):void
    {
        trace("221");
    }*/

    override public function creation(pics, picAddr, ii, typpe):void
    {
        super.creation(pics, picAddr, ii, typpe);
        //trace("picAddr="+picAddr);
        pic=pics.takeYourMovie(picAddr);
        pic.x=0;
        pic.y=0;
        //pic.visible=false;
        pic.gotoAndStop(1);

        addChild(pic);
        //trace("vis pic!");

        fate(1);

        ready=true;
    }
}
}
