/**
 * Created by alexo on 27.04.2016.
 */
package subjects
{
import collections.inCity.Land;

import story.Danke;

public class SubLand extends Parent2Subject
{
    public var fram:Vector.<int> = new Vector.<int>(); //текущий тип ресурса локации
        /*
        ** [1..3] - тип добываемого/теряемого реса
        * ** [0] - знак ресурсов
        ** [4..6] - место под первое здание/человека
        ** [7] - место под четвёртое/первое здание/человека
         */
    public var move:Vector.<Boolean> = new Vector.<Boolean>(); //элемент предмета может передвигаться под мышкой
    public var baseX:Vector.<int> = new Vector.<int>();
    public var baseY:Vector.<int> = new Vector.<int>();
    private var cli:Vector.<int> = new Vector.<int>();
    private var tx:Vector.<int> = new Vector.<int>();
    private var ty:Vector.<int> = new Vector.<int>();

    public var land:int; //с какой из локаций в векторе Land установлена связь
    //private var neddFram:Boolean=false;

    public var cameraUse:int=0;

    private var j:int=0;

    private var dan:Danke;

    public function SubLand(myXML, pics, el, ii)
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
        resource();
    }

    private function resource():void
    {
        if (dan.lands.length==0)
        {
            return;
        }
        if (land==-1 || iii!=dan.lands[land].landID)
        {
            land=findLand();
        }
        var myLand:Land = dan.lands[land];
        for (i=0; i<myLand.elemPic.length; i++)
        {
            if (fram.length>i && fram[i]!=myLand.elemPic[i])
            {
                fram[i]=myLand.elemPic[i];
                neddFram=true;
            }
        }
    }

    private function findLand():int
    {
        var s:int=1;
        for (i=0; i<dan.lands.length; i++)
        {
            if (dan.lands[i].landID == iii)
            {
                s = i;
                break;
            }
        }
        return s;
    }

    private function find(str):int
    {
        var s:int=1;
        for (var j:int=0; j<dan.landRes.length; j++)
        {
            if (dan.landRes[j].typpe==str)
            {
                s=dan.landRes[j].pic;
                break;
            }
        }
        return s;
    }

    override public function getParam(str, num)
    {
        trace(str+":::"+num);
    }

    override public function model(el):void
    {
        super.model(el);

        var t:int=0;
        for (j=0;j<move.length; j++)
        {
            if (move[j] && fram[j]>2)
            {
                t++;
                mouseMove(j, el, t);
            }
        }
        makeFram(el);
        specialText(el);
    }

    private function makeFram(el):void
    {
        if (neddFram)
        {
            neddFram=false;
            for (i=0; i<numOfEl.length; i++)
            {
                if (el[numOfEl[i]].typeOfElement!="txt")
                {
                    el[numOfEl[i]].pic.gotoAndStop(fram[i]);
                }
            }
        }
    }

    private function specialText(el):void
    {
        var k:int=-1;
        for (i=0;i<numOfEl.length; i++)
        {
            if (el[numOfEl[i]].typeOfElement=="txt")
            {
                k++;
                if (el[numOfEl[i]].tid=="$res")
                {
                    if (el[numOfEl[i]].txt != dan.lands[land].elemIncome[k])
                    {
                        if (dan.lands[land].elemIncome[k]!=0)
                        {
                            el[numOfEl[i]].txt = dan.lands[land].elemIncome[k];
                        } else
                        {
                            el[numOfEl[i]].txt="";
                        }
                        el[numOfEl[i]].pic.text = el[numOfEl[i]].txt;
                        //trace("new income="+el[numOfEl[i]].txt);
                        el[numOfEl[i]].makeFormat();
                    }
                }
            }
        }
    }

    private function mouseMove(num, el, t):void
    {
        if (cli[num]==1)
        {
            if (bit.dm==0)
            {
                if (sx[num]-baseX[num]>10 || sx[num]-baseX[num]<-10 || sy[num]-baseY[num]>10 || sy[num]-baseY[num]<-10)
                {
                    bit.mouseParClick = -1;
                    bit.underRes="out";
                    bit.underOne=-iii;
                    bit.whatUnderOne=num-3-1;//-t; таким образом мы утвердили, что первые три -ресы, следующий - значок реса
                    //fram[num]=2;
                }
                cli[num]=0;
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

    override protected function end_load(myXML, ii, pics, el):void //заканчиваем загрузку
    {
        super.end_load(myXML, ii, pics, el);
        dan = Danke.getInstance();
        land=-1;

        if (myXML.camera=="1")
        {
            cameraUse = 1;
        }

        //trace("iii="+iii);
        for (i=0; i<myXML.pos.length(); i++)
        {
            subs.push("mc");
            visOne.push(1);
            sx.push(myXML.pos[i].@xx);
            sy.push(myXML.pos[i].@yy);

            baseX.push(sx[sx.length-1]);
            baseY.push(sy[sy.length-1]);
            cli.push(0);
            tx.push(0);
            ty.push(0);
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
            specID.push(0);
            fram.push(-1);

            if (myXML.pos[i].@move=="t")
            {
                move.push(true);
            } else
            {
                move.push(false);
            }
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

            move.push(false);
            baseX.push(0);
            baseY.push(0);
            cli.push(0);
            tx.push(0);
            ty.push(0);
        }
        ready=true;
    }
}
}