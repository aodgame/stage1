/**
 * Created by alexo on 25-May-15.
 */
package elements
{
import flash.display.MovieClip;
import flash.events.MouseEvent;
import flash.ui.Mouse;
import flash.ui.MouseCursor;

public class ElemPic extends ParentElement
{
    public var pic:MovieClip;

    public function ElemPic(pics, picAddr, ii, typpe, moduleName, i)
    {
        creation(pics, picAddr, ii, typpe, moduleName, i);
    }

    override public function fate(i):int
    {
        if (i==1)
        {
            //pic.buttonMode = pic.mouseEnabled = pic.useHandCursor = true;
            pic.mouseChildren = false;
            pic.addEventListener(MouseEvent.MOUSE_OVER, overClick);
        }
        if (i==0)
        {
            pic.removeEventListener(MouseEvent.MOUSE_OVER, overClick);
            removeChild(pic);
        }

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

    private function overClick(event:MouseEvent):void
    {
        if (pic.visible)
        {
            Mouse.cursor = MouseCursor.BUTTON;
            bit.mouseOver = iii;
            bit.mouseParOver = parnt;
        }
    }

    override public function creation(pics, picAddr, ii, typpe, moduleName, i):void
    {
        super.creation(pics, picAddr, ii, typpe, moduleName, i);
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
