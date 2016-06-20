/**
 * Created by alexo on 26-May-15.
 */
package subjects
{
public class SubButton extends Parent2Subject
{
    public var fram:uint;
    //private var neddFram:Boolean=false;

    public var goTo:int;
    public var goPosition:int;

    public var cameraUse:int=0;

    public var sel:Vector.<int> = new Vector.<int>();
    public var unsel:Boolean=false;

    public function SubButton(myXML, pics, el, ii)
    {
        end_load(myXML, ii, pics, el);
    }

    override public function work(ii):void
    {
        super.work(ii);

        if (bit.curRoom==weAre && unsel)
        {
            if (bit.cli==1)// && (bit.mouseParClick==-1 || bit.mouseParUp!=-1))
            {
                selectIt();
            }
            /*if (bit.cli==1 && bit.mouseParUp!=-1)
            {
                selectIt();
            }*/
        }
        if (cameraUse==1)
        {
            show();
        }
        framer();

    }

    private function framer():void
    {
        if (bit.mouseParClick==iii)
        {
            if (goTo>0)
            {
                bit.prevRoom=bit.curRoom;
                bit.curRoom=goTo;
            }
            if (goPosition>0)
            {
                bit.prevPlane=bit.curPlane;
                bit.curPlane=goPosition;
            }
            fram=2;
            neddFram=true;
        }
        if (bit.mouseParDown==iii)
        {
            fram=3;
            neddFram=true;
        }
        if (bit.mouseParOver==iii)
        {
            fram=2;
            neddFram=true;
        }
        if (bit.mouseParOut==iii)
        {
            fram=1;
            neddFram=true;
        }
        if (bit.mouseParUp==iii)
        {
            fram=2;
            neddFram=true;
        }
    }

    private function selectIt()
    {
        var xx:int=0;
        var yy:int=0;
        var ww:int=0;
        var hh:int=0;
        for (i=0; i<sel.length; i+=4)
        {
            ww=sel[i+2];
            hh=sel[i+3];
            xx=sel[i]+subX;
            yy=sel[i+1]+subY;
            if (bit.sx<xx+ww && bit.sx>xx && bit.sy<yy+hh && bit.sy>yy)
            {
                if (bit.cli==1 && bit.mouseParClick==-1)
                {
                    bit.mouseParClick = iii;
                    //trace("new bit.mouseParClick=" + bit.mouseParClick);
                } else
                {
                    //trace("old bit.mouseParUp="+bit.mouseParUp);
                }
                if (bit.cli==1 && bit.mouseParUp!=-1)
                {
                    //trace("new bit.mouseParUp="+bit.mouseParUp);
                    bit.underOne=iii;
                }
                break;
            }
        }
    }

    override public function getParam(str, num)
    {
        trace(str+":::"+num);
        if (str=="goTo")
        {
            var n:int;
            n=num;
            goTo=n;
        }
    }

    override public function model(el):void
    {
        super.model(el);
        if (neddFram)
        {
            neddFram=false;
            for (i=0; i<numOfEl.length; i++)
            {
                if (el[numOfEl[i]].typeOfElement!="txt")
                {
                    el[numOfEl[i]].pic.gotoAndStop(fram);
                }
            }
        }
    }

    override protected function end_load(myXML, ii, pics, el):void //заканчиваем загрузку
    {
        super.end_load(myXML, ii, pics, el);

        fram=1;

        goTo=myXML.portal.@goTo;
        goPosition=myXML.portal.@goPosition;
        if (myXML.camera=="1")
        {
            cameraUse = 1;
        }

        subs.push("mc");
        visOne.push(1);
        sx.push(0);
        sy.push(0);
        sw.push(0);
        sh.push(0);
        if (myXML.selectation=="0")
        {
            unsel=true;
            specID.push("unselect");
            var xe:int=myXML.selectation.@xe;
            var ye:int=myXML.selectation.@ye;

            for (i=0; i<myXML.sel.length(); i++)
            {
                sel.push((int(myXML.sel[i].@xx-xe)));
                sel.push((int(myXML.sel[i].@yy-ye)));
                sel.push(myXML.sel[i].@ww);
                sel.push(myXML.sel[i].@hh);
            }
        } else
        {
            specID.push("0");
        }
        if (specID[specID.length-1]=="0" && myXML.btn=="yes")
        {
            specID[specID.length-1]="btn";
        }

        for (i=0; i<myXML.txt.length(); i++)
        {
            subs.push("txt");
            visOne.push(1);
            sx.push(myXML.txt[i].@xx);
            sy.push(myXML.txt[i].@yy);
            sw.push(0);
            sh.push(0);
            var str:String=myXML.txt[i].@id;
            specID.push(str);
            picAddr.push(new String(""));
        }

        ready=true;
    }
}
}