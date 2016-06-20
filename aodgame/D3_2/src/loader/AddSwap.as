/**
 * Created by alexo on 22-May-15.
 */
package loader
{
import flash.display.MovieClip;

public class AddSwap extends MovieClip
{
    private var i:int=0;
    private var j:int=0;

    public function AddSwap(add)
    {
        add.push(-1);
    }

    public function addManager(add, el):void
    {
        i=0;
        while (add.length>0)
        {
            if (add[0]==-1)
            {
                bigAdd(el);
                add.splice(0,1);
                i--;
            }
            i++
        }
    }

    public function swapManager(add, el):void
    {

    }

    private function bigAdd(el):void
    {
        for (j=0; j< 20; j++)
        {
            for (i = 0; i < el.length; i++)
            {
                if (el[i].atChild==j)
                {
                    addChild(el[i]);
                }
            }
        }
    }
}
}
