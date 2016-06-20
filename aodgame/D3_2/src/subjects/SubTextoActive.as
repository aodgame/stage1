/**
 * Created by alexo on 15.06.2016.
 */
package subjects
{
import story.Danke;

public class SubTextoActive extends Parent2Subject
{
    public var fram:Vector.<int> = new Vector.<int>();

    public var cameraUse:int=0;

    public var move:Vector.<Boolean> = new Vector.<Boolean>(); //элемент предмета может передвигаться под мышкой
    public var baseX:Vector.<int> = new Vector.<int>();
    public var baseY:Vector.<int> = new Vector.<int>();
    private var cli:Vector.<int> = new Vector.<int>();
    private var tx:Vector.<int> = new Vector.<int>();
    private var ty:Vector.<int> = new Vector.<int>();

    private var tap:Vector.<int> = new Vector.<int>(); //определяем, был ли нажат элемент

    private var stx:int=-1; //координаты области, уход предмета из которой засчитывается за удаление
    private var sty:int=-1;
    private var sthe:int=-1;
    private var stwi:int=-1;

    private var dan:Danke;

    public function SubTextoActive(myXML, pics, el, ii)
    {
        end_load(myXML, ii, pics, el);
    }

    override public function work(ii):void
    {
        super.work(ii);
        if (cameraUse==1)
        {
            show();
        }

        if (bit.mouseParUp==iii)
        {
            bit.whatUnderOne=iii;
        }
    }

    override public function getParam(str, num)
    {
        trace(str+":::"+num);
    }

    override public function model(el):void
    {
        super.model(el);
        standartBehavior(el);
    }

    private function standartBehavior(el):void
    {
        if (vis==1)
        {
            for (i = 0; i < numOfEl.length; i++)
            {
                if (el[numOfEl[i]].typeOfElement!="txt")
                {
                    el[numOfEl[i]].pic.gotoAndStop(fram[i]);
                }
                if (numOfEl[i] == bit.mouseClick)
                {
                    dan.numOfMany = i+1; //ид никогда не начинаются с нуля
                    dan.numOfSub=iii;
                }
                if (numOfEl[i] == bit.mouseDown)
                {
                    dan.downOfMany = i+1; //ид никогда не начинаются с нуля
                }
            }

            //для движимых предметов
            var t:int=0;
            for (var j:int=0;j<move.length; j++)
            {
                if (move[j] && (specID[j].substr(0,3)=="mov" || specID[j].substr(0,4)=="#mov"))
                {
                    t++;
                    mouseMoveElement(j, el, t);
                }
                if (move[j] && specID[j].substr(0,2)=="go")
                {
                    t++;
                    mouseMoveSubject(j, el, t);
                    if (vis==1)
                    {
                        dan.getsetNowX=subX;
                        dan.getsetNowY=subY;
                    }
                }
            }
        }
    }

    private function mouseMoveSubject(num, el, t):void
    {
        if (cli[num]==1)
        {
            if (bit.dm==0)
            {
                cli[num]=0;
                //sx[num]=baseX[num];
                //sy[num]=baseY[num];
                bit.cliX=bit.sx;
                bit.cliY=bit.sy;

            } else
            {
                subX=bit.sx+tx[num];
                subY=bit.sy+ty[num];
            }
        }
        if (bit.mouseParDown==iii)
        {
            if (bit.mouseDown==el[numOfEl[num]].iii)
            {
                cli[num] = 1;
                tx[num] = subX - bit.sx;
                ty[num] = subY - bit.sy;
            }
        }
    }

    private function outI(el, num)//определяем, покинул ли элемент большей своей частью область определения предмета
    {
        //trace("SubTextoActive: sx; sy = "+sx[num]+"; "+sy[num]);
        if (bit.sx<stx || bit.sx>stx+stwi || bit.sy<sty || bit.sy>sty+sthe)
        {
            dan.outI=num-1;
            //trace("out="+num);
        }
    }

    private function mouseMoveElement(num, el, t):void
    {
        if (cli[num]==1)
        {
            if (bit.dm==0)
            {
                if (sx[num] - baseX[num] < 10 && sx[num] - baseX[num] > -10 && sy[num] - baseY[num] < 10 && sy[num] - baseY[num] > -10)
                {
                    tap[num]=1;
                } else
                {
                    tap[num]=-1;
                }
                cli[num]=0;
                outI(el, num);
                sx[num]=baseX[num];
                sy[num]=baseY[num];

            } else
            {
                sx[num]=bit.sx+tx[num];
                sy[num]=bit.sy+ty[num];
            }
        }
        if (bit.mouseParDown==iii)
        {
            if (bit.mouseDown==el[numOfEl[num]].iii)
            {
                cli[num] = 1;
                tx[num] = sx[num] - bit.sx;
                ty[num] = sy[num] - bit.sy;
            }
        }
    }

    override protected function end_load(myXML, ii, pics, el):void
    {
        super.end_load(myXML, ii, pics, el);
        dan = Danke.getInstance();

        if (myXML.camera=="1")
        {
            cameraUse = 1;
        }

        stx=myXML.stx;
        sty=myXML.sty;
        stwi=myXML.wi;
        sthe=myXML.he;
        trace("stx="+stx+"; sty="+sty+"; stwi="+stwi+"; sthe="+sthe);

        for (i=0; i<myXML.pos.length(); i++)
        {
            subs.push("mclow");
            visOne.push(1);
            sx.push(myXML.pos[i].@xx);
            sy.push(myXML.pos[i].@yy);

            if (myXML.pos[i].@ww!="0")
            {
                sw.push(myXML.pos[i].@ww);
            } else
            {
                sw.push(0);
            }
            if (myXML.pos[i].@hh!="0")
            {
                sh.push(myXML.pos[i].@hh);
            } else
            {
                sh.push(0);
            }
            specID.push(myXML.pos[i].@spec);
            fram.push(myXML.pos[i].@fram);
            neddFram=true;

            if (specID[specID.length-1].substr(0,3)=="mov" || specID[specID.length-1].substr(0,2)=="go")
            {
                move.push(true);
            }else
            {
                move.push(false);
            }
            baseX.push(sx[sx.length-1]);
            baseY.push(sy[sy.length-1]);
            cli.push(0);
            tx.push(0);
            ty.push(0);
            tap.push(0);
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

            if (str.substr(0,4)=="#mov")
            {
                move.push(true);
            } else
            {
                move.push(false);
            }
            baseX.push(sx[sx.length-1]);
            baseY.push(sy[sy.length-1]);
            cli.push(0);
            tx.push(0);
            ty.push(0);
            tap.push(0);
        }
        ready=true;
    }
}
}