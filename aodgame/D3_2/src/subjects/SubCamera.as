/**
 * Created by alexo on 22-May-15.
 */
package subjects
{
import collections.Stats;

public class SubCamera extends ParentSubject
{
    private var myRoom:int;
    private var weWorkNow:Boolean;
    private var xx:int;
    private var yy:int;

    private var dm:int=0;
    private var mx:int=0;
    private var my:int=0;

    public function SubCamera(myXML, pics, el, ii, moduleName)
    {
        end_load(myXML, ii, pics, el, moduleName);
    }

    override public function work(ii):void
    {
        super.work(ii);

        if (bit.curRoom!=myRoom)
        {
            myRoom=bit.curRoom;
            for (var i:int=0; i<bit.room.length; i++)
            {
                if (bit.room[i].iii==myRoom)
                {
                    weWorkNow = true;
                    break;
                } else
                {
                    weWorkNow=false;
                    bit.realX=0;
                    bit.realY=0;
                }
            }
        }

        if (weWorkNow)
        {
            tapping();
            moving();
        }
    }

    private function tapping()
    {
        if (dm==0 && bit.dm==1)
        {
            dm=1;
            mx=bit.sx;
            my=bit.sy;
        }
        if (dm==1 && bit.dm==1)
        {
            if (bit.sx<mx)
            {
                mx=bit.sx;
                bit.horiz=2;
            }
            if (bit.sx>mx)
            {
                mx=bit.sx;
                bit.horiz=1;
            }
            if (bit.sy<my)
            {
                my=bit.sy;
                bit.vertic=2;
            }
            if (bit.sy>my)
            {
                my=bit.sy;
                bit.vertic=1;
            }
        }
        if (dm==1 && bit.dm==0)
        {
            dm=0;
        }
    }

    private function moving()
    {
        if (bit.horiz==1) //движемся вправо
        {
            bit.realX-=4;
        }
        if (bit.horiz==2) //движемся влево
        {
            bit.realX+=4;
        }
        if (bit.vertic==1) //движемся вниз
        {
            bit.realY-=4;
        }
        if (bit.vertic==2) //движемся вверх
        {
            bit.realY+=4;
        }

        if (bit.realX<0)
        {
            bit.realX=0;
        }
        if (bit.realY<0)
        {
            bit.realY=0;
        }
        if (bit.realX>bit.room[i].xx-Stats.MAX_SCREEN_X)
        {
            bit.realX=bit.room[i].xx-Stats.MAX_SCREEN_X;
        }
        if (bit.realY>bit.room[i].yy-Stats.MAX_SCREEN_Y)
        {
            bit.realY=bit.room[i].yy-Stats.MAX_SCREEN_Y;
        }
        bit.horiz=0;
        bit.vertic=0;
    }

    override protected function end_load(myXML, ii, pics, el, moduleName):void //заканчиваем загрузку
    {
        weWorkNow=false;
        xx=0;
        yy=0;

        super.end_load(myXML, ii, pics, el, moduleName);

        ready=true;
    }
}
}