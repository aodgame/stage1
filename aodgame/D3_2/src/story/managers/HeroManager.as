/**
 * Created by alexo on 30.05.2016.
 */
package story.managers
{
import collections.common.Hero;
import D3.Bitte;
import story.Danke;

public class HeroManager
{
    private var dan:Danke;
    private var bit:Bitte;

    private var i:int=0;
    private var j:int=0;

    public function HeroManager()
    {
        dan = Danke.getInstance();
        bit = Bitte.getInstance();
    }

    public function work(subs):void
    {
        //trace("dan.heroIIIbuyPanel="+dan.heroIIIbuyPanel+"; dan.numOfSub="+dan.numOfSub);
        if (dan.heroIIIbuyPanel==dan.numOfSub && dan.currentHeroes.length<dan.maxHeroNum)
        {
            if (buyHero())
            {
                createHero(subs);
            }
            dan.numOfSub=-1;
        }
        if (dan.heroIIIbuyPanel==dan.numOfSub && dan.currentHeroes.length==dan.maxHeroNum) //зачищаем, чтобы не было  покупки постфактум
        {
            dan.numOfSub=-1;
        }

        if (dan.heroChoose>0 && dan.heroOnTyppe!="" && !dan.heroStart)//если герой выбран и его на что-то перекинули
        {
            heroCityRelation(subs);
        }

        if (dan.heroChoose>0 && dan.outI>-1) //выкидываем очередную занятость у героя. Радуйся, о герой
        {
            clearWorkplace(dan.heroChoose-1); //нюанс в том, что dan.outI (т.е. текстовый элемент -1) по номеру должен соответствовать виду деятельности героя
        }

        if (dan.heroActChange)
        {
            trace("before hero num="+(dan.heroChoose-1));
            for (var z:int=0; z<dan.currentHeroes[dan.heroChoose-1].needTyppe.length; z++)
            {
                trace(z+": needTyppe="+dan.currentHeroes[dan.heroChoose-1].needTyppe[z]+"; needNum="+dan.currentHeroes[dan.heroChoose-1].needNum[z]);
            }
            trace("dan.newPosActChange="+dan.newPosActChange);
            trace("dan.numActChange="+dan.numActChange);
            dan.heroActChange=false;

            var s:String= dan.currentHeroes[dan.heroChoose-1].needTyppe[dan.numActChange];
            var n:int=dan.currentHeroes[dan.heroChoose-1].needNum[dan.numActChange];

            dan.currentHeroes[dan.heroChoose-1].needTyppe.splice(dan.newPosActChange, 0, s);
            dan.currentHeroes[dan.heroChoose-1].needNum.splice(dan.newPosActChange, 0, n);

            trace("medium hero num="+(dan.heroChoose-1));
            for (var z:int=0; z<dan.currentHeroes[dan.heroChoose-1].needTyppe.length; z++)
            {
                trace(z+": needTyppe="+dan.currentHeroes[dan.heroChoose-1].needTyppe[z]+"; needNum="+dan.currentHeroes[dan.heroChoose-1].needNum[z]);
            }

            dan.currentHeroes[dan.heroChoose-1].needTyppe.splice(dan.numActChange+1, 1);
            dan.currentHeroes[dan.heroChoose-1].needNum.splice(dan.numActChange+1, 1);

            trace("hero num="+(dan.heroChoose-1));
            for (var z:int=0; z<dan.currentHeroes[dan.heroChoose-1].needTyppe.length; z++)
            {
                trace(z+": needTyppe="+dan.currentHeroes[dan.heroChoose-1].needTyppe[z]+"; needNum="+dan.currentHeroes[dan.heroChoose-1].needNum[z]);
            }
        }

        if (bit.sChangeTurn)
        {
            changeTurn(subs);
        }
    }

    private function clearWorkplace(num):void
    {
        trace("dan.outI="+dan.outI);
        dan.currentHeroes[num].needTyppe.splice(dan.outI,1);
        dan.currentHeroes[num].needNum.splice(dan.outI,1);
        //dan.outI=-1;
    }

    private function heroCityRelation(subs):void
    {
        //кто-то хочет заставить героя что-то сделать. Но что именно?
        if (dan.heroOnTyppe=="city") //ответственность за город
        {
            trace("before");
            for (i=0; i<dan.currentHeroes.length; i++)
            {
                trace("i="+i+"; "+dan.currentHeroes[i].nameID);
                for (j=0; j<dan.currentHeroes[i].needTyppe.length; j++)
                {
                    trace("j="+j+"; "+dan.currentHeroes[i].needTyppe[j]+":"+dan.currentHeroes[i].needNum[j]);
                }
            }

            trace("dan.heroOnNum="+dan.heroOnNum);
            for (i=0; i<dan.currentHeroes.length; i++)
            {
                trace("i="+i);
                j=0;
                while (j<dan.currentHeroes[i].needTyppe.length)
                {
                    trace("dan.currentHeroes[i].needNum[j]="+dan.currentHeroes[i].needNum[j]);
                    if (dan.currentHeroes[i].needTyppe[j]=="city" && dan.currentHeroes[i].needNum[j]==dan.heroOnNum)
                    {//радуйся, герой, эта ноша больше не твоя
                        dan.currentHeroes[i].needTyppe.splice(j,1);
                        dan.currentHeroes[i].needNum.splice(j,1);
                        j=-1;
                        break;
                    }
                    j++;
                }
                if (j==-1) //в теории одновременно может существовать только один герой, отвечающий за конкретный город
                {
                    break;
                }
            }
            trace("dan.heroChoose="+dan.heroChoose);
            dan.currentHeroes[dan.heroChoose-1].needTyppe.push("city"); //теперь это твоя ноша
            dan.currentHeroes[dan.heroChoose-1].needNum.push(dan.heroOnNum);


            trace("after");
            for (i=0; i<dan.currentHeroes.length; i++)
            {
                trace("i="+i+"; "+dan.currentHeroes[i].nameID);
                for (j=0; j<dan.currentHeroes[i].needTyppe.length; j++)
                {
                    trace("j="+j+"; "+dan.currentHeroes[i].needTyppe[j]+":"+dan.currentHeroes[i].needNum[j]);
                }
            }
            dan.heroOnTyppe="";
            dan.heroChoose=-1;
        }
    }

    private function changeTurn(subs):void
    {
        var i:int=0;
        while (i<dan.currentHeroes.length)
        {
            dan.currentHeroes[i].currentAge++;
            //trace(dan.currentHeroes[i].endOfLife());
            if (dan.currentHeroes[i].endOfLife())
            {
                for (var k:int=0; k<subs.length; k++)
                {
                    if (subs[k].iii == dan.heroIII)
                    {
                        for (var j:int=i; j<subs[k].fram.length-1; j++)
                        {
                            subs[k].fram[j]=subs[k].fram[j+1];
                        }
                        subs[k].fram[subs[k].fram.length-1]=1;
                        break;
                    }
                }
                dan.currentHeroes.splice(i,1);
                dan.heroChoose=-1;
                dan.heroPanelClose = true;
                i--;
            } else
            {
                makeActivity(dan.currentHeroes[i]);
                for (var k:int=0; k<dan.currentHeroes[i].heroResMax.length; k++)
                {

                    dan.currentHeroes[i].heroResMax[k]+=1;
                }
            }
            i++;
        }
    }

    private function makeActivity(hero):void //снимаем очки во время смены даты за выполнение активности персонажа
    {
        for (var j:int=0; j<hero.needTyppe.length; j++)
        {
            for (var k:int = 0; k < dan.heroActivities.length; k++)
            {
                if (hero.needTyppe[j] == dan.heroActivities[k].act)
                {
                    var typp:int=0;
                    while (typp<hero.heroResTyppe.length)
                    {
                        for (var n:int = 0; n < dan.heroActivities[k].costTyppe.length; n++)
                        {
                            if (dan.heroActivities[k].costTyppe[n] == hero.heroResTyppe[typp] && hero.heroResMax[typp]-dan.heroActivities[k].costNum[n]>=0)
                            {
                                hero.heroResMax[typp]-=dan.heroActivities[k].costNum[n];
                                break;
                            }
                        }
                        typp++;
                    }
                }
            }
        }
    }

    private function createHero(subs):void
    {
        trace("make hero");
        for (var i:int=0; i<subs.length; i++)
        {
            if (subs[i].iii==dan.heroIII)
            {
                for (var j:int=0; j<subs[i].fram.length; j++)
                {
                    if (subs[i].fram[j]==1)
                    {
                        trace(dan.currentHeroes[dan.currentHeroes.length-1].iii);
                        subs[i].fram[j]=dan.currentHeroes[dan.currentHeroes.length-1].iii+1;
                        trace("horey! ");
                        break;
                    }
                }

                break;
            }
        }
    }

    private function buyHero():Boolean
    {
        //trace("dan.numOfMany="+dan.numOfMany);
        if (dan.numOfMany<0)
        {
           return false;
        }
        var hero:Hero = dan.availableHeroes[dan.numOfMany];
        trace(hero.typpe+"; hero.iii="+hero.iii);
        var t:Boolean=true;
        var num:Vector.<int> = new Vector.<int>();
        //сначала проверка на возможность
        for (var i:int=0; i<hero.needTyppe.length; i++)
        {
            if (!t)
            {
                break;
            }
            for (var j:int=0; j<dan.globalRes.length; j++)
            {
                if (hero.needTyppe[i]==dan.globalRes[j].typpe)
                {
                    if (dan.globalRes[j].need=="need" && dan.globalRes[j].amount<hero.needNum[i])
                    {
                        t=false;
                    }
                    num.push(j);
                    break;
                }
            }
        }
        trace("t="+t);
        //затем покупка
        if (t)
        {
            for (var i:int=0; i<num.length; i++)
            {
                trace("res decrease "+dan.globalRes[num[i]].typpe);
                if (dan.globalRes[num[i]].need=="need")
                {

                    dan.globalRes[num[i]].amount -= hero.needNum[i];
                    dan.globalRes[num[i]].freeAmount -= hero.needNum[i];
                    dan.reIncome=true;
                    dan.lag=4;
                }
            }

            //и создание персонажа
            dan.currentHeroes.push(new Hero());
            dan.currentHeroes[dan.currentHeroes.length-1].makeAge(hero.n1, hero.n2);
            dan.currentHeroes[dan.currentHeroes.length-1].typpe=hero.typpe;
            dan.currentHeroes[dan.currentHeroes.length-1].iii=hero.iii;
            dan.currentHeroes[dan.currentHeroes.length-1].txt=hero.txt;
            dan.currentHeroes[dan.currentHeroes.length-1].makeName(dan.names);
            for (var i:int=0; i<hero.heroResTyppe.length; i++)
            {
                dan.currentHeroes[dan.currentHeroes.length-1].makeSkill
                (
                        hero.heroResTyppe[i],
                        hero.heroResMin[i],
                        hero.heroResMax[i]
                );
            }


            return true;
        }
        return false;
    }
}
}
