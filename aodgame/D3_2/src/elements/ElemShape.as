/**
 * Created by alexo on 26.07.2016.
 */
package elements
{
import collections.inHistory.MatrixView;

import flash.display.MovieClip;
import flash.events.MouseEvent;
import flash.ui.Mouse;
import flash.ui.MouseCursor;

public class ElemShape extends ParentElement
{
    public var pic:MovieClip;

    public function ElemShape(pics, picAddr, ii, typpe, moduleName, i)
    {
        creation(pics, picAddr, ii, typpe, moduleName, i);
    }

    override public function fate(i):int
    {
        return i;
    }

    override public function creation(pics, picAddr, ii, typpe, moduleName, i):void
    {
        super.creation(pics, picAddr, ii, typpe, moduleName, i);
        pic = new MovieClip();
        pic.graphics.clear();
        pic.x=0;
        pic.y=0;
        pic.gotoAndStop(1);

        addChild(pic);

        fate(1);

        ready=true;
    }
}
}
