/**
 * Created by alexo on 22.07.2016.
 */
package story.managers
{
import D3.Bitte;

import story.Danke;

public class Messanger
{
    private var curShow:int=-1;
    private var i:int=0;
    private var dan:Danke;
    private var bit:Bitte;
    private var lag:int=0;

    private var wasDel:int=-1; //номер в векторе, какое из сообщений было удалено
    private var wasShow:int=-1; //номер в векторе, какое из сообщений было показано, но не удалено
    private var visual:Vector.<int> = new Vector.<int>();

    private var iidi:int=-1;

    public function Messanger()
    {
        dan = Danke.getInstance();
        bit = Bitte.getInstance();
    }

    public function work(sub):void
    {
        analyze();

        show(sub);
        combinate(sub);
        tapper(sub);
    }

    private function combinate(sub):void //находим номер в векторе айтема с сообщениями
    {
        if (iidi==-1 && dan.messMenuPanel!=-1)
        {
            for (i=0; i<sub.length; i++)
            {
                if (sub[i].iii==dan.messMenuPanel)
                {
                    iidi=i;
                    break;
                }
            }
        }
        if (iidi!=-1 && dan.messMenuPanel==-1)
        {
            iidi=-1;
        }
        if (bit.delParameters==-1)
        {
            iidi=-1;
            curShow=-1;
            i=0;
            lag=0;
            wasDel=-1;
            wasShow=-1;
            visual = new Vector.<int>();
        }
    }

    private function show(sub):void
    {
        if (iidi==-1 || sub.length<=iidi)
        {
            return;
        }
        if (visual.length!=dan.mess.length || dan.messRefram)
        {
            trace("mess maker");
            dan.messRefram=false;
            while (visual.length>0)
            {
                visual.pop();
            }
            for (i=0; i<sub[iidi].fram.length; i++)
            {
                if (dan.mess.length>i)
                {
                    visual.push(1);
                    var t=(dan.mess[i].stil-1)*2; //показываем картинку, соответствующую типу сообщения
                    trace(dan.mess[i].stil+"; message stil="+t);
                    trace(dan.mess[i].iii);
                    if (dan.mess[i].wasShowed)
                    {
                        sub[iidi].fram[i] = t+4;
                    } else
                    {
                        sub[iidi].fram[i] = t+3;
                    }
                } else
                {
                    sub[iidi].fram[i] = 2;
                }
            }
            sub[iidi].neddFram=true;
        }
        if (wasShow!=-1)
        {
            sub[iidi].fram[wasShow] = (dan.mess[wasShow].stil-1)*2+4;
            wasShow=-1;
            sub[iidi].neddFram=true;
        }

        sub[iidi].neddFram=true;
    }

    private function tapper(sub):void
    {
        if (dan.messWasTap!=-1 && iidi!=-1)
        {
            trace("sub[iidi].iii="+sub[iidi].iii);
            trace("dan.messWasTap="+dan.messWasTap);
            for (i=0; i<sub[iidi].numOfEl.length; i++)
            {
                trace("sub[iidi].numOfEl="+sub[iidi].numOfEl[i]);
                if (sub[iidi].numOfEl[i]==dan.messWasTap)
                {
                    dan.needToMakeMenu=true;
                    curShow=i;
                    dan.mess[i].wasShowed=1;
                    dan.heroMenuActivity=dan.mess[i].behMenu;
                    dan.behPosFromMess=dan.mess[i].behMenu;
                    break;
                }
            }

            dan.messWasTap=-1;
        }
    }

    private function analyze():void
    {
        if (lag==0)
        {
            lag=10;
        } else
        {
            lag--;
        }
        //анализируем, нужно ли кого-то показывать
        if (curShow==-1 && lag==0)
        {
            for (i=0; i<dan.mess.length; i++)
            {
                if (dan.mess[i].activeShow && !dan.mess[i].wasShowed)
                {
                    dan.needToMakeMenu=true;
                    curShow=i;
                    dan.mess[i].wasShowed=1;
                    dan.heroMenuActivity=dan.mess[i].behMenu;
                    dan.behPosFromMess=dan.mess[i].behMenu;
                    trace("hey ho");
                    break;
                }
            }
        }
        //анализируем, а не надо ли данное сообщение удалить
        //trace("curShow="+curShow+"; dan.needToMakeMenu="+dan.needToMakeMenu);
        if (curShow!=-1 && dan.mess.length>0 && !dan.needToMakeMenu && dan.behPosFromMess==-1)
        {
            //trace("it out);");
            if (!dan.mess[curShow].out)
            {
                wasShow=curShow;
            }
            if (dan.mess[curShow].out)
            {
                //trace("was out");
                dan.mess.splice(curShow,1);
                wasDel=curShow;
            }
            curShow=-1;
        }
    }

}
}
