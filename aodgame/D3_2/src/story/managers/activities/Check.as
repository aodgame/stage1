/**
 * Created by alexo on 22.08.2016.
 */
package story.managers.activities
{
import collections.behavior.BehResult;
import collections.common.Hero;

public class Check
{
    private var i:int;
    private var j:int;
    public var behRes:int=-1;
    public var behCost:int=-1;
    public var heroChoice:int=-1;

    public function Check()
    {
        i=0;
        j=0;
    }

    public function clear():void
    {
        heroChoice=-1;
    }

    public function choice(dan, behActChoice, bH):Boolean //находим какой пункт выбрал пользователь
    {
        behCost=bH;
        trace("choice");
        trace("dan.behChoice="+dan.behChoice);
        trace("behActChoice="+behActChoice);
        if (dan.behChoice==-1 || behActChoice==-1)
        {
            return false;
        }
        behCost=dan.behMenu[behActChoice].choicerBehActivity[dan.behChoice-1];
        trace("behCost="+behCost);
        for (i=0; i<dan.behAct.length; i++)
        {
            if (dan.behAct[i].iii==behCost)
            {
                trace("i="+i+":"+dan.behAct[i].iii);
                behCost=i;
                trace("new behCost="+behCost);
                return true;
            }
        }
        return false;
    }

    public function choose(dan, bR):Boolean //находим, по какому варианту развития пойдёт событие после выбора пользователя
    {
        behRes=bR;
        trace("choose");
        var min=0;
        var r:int=Math.random()*100;
        trace("behCost="+behCost);
        trace("r="+r);
        for (i=0; i<dan.behAct[behCost].resBehRes.length; i++)
        {
            trace("behCost="+behCost+"; "+dan.behAct[behCost].resChance[i]);
            if (r<dan.behAct[behCost].resChance[i]+min)
            {
                trace("dan.behAct[behCost].resBehRes="+dan.behAct[behCost].resBehRes[i]);
                behRes=dan.behAct[behCost].resBehRes[i];//i;
                trace("behRes="+behRes);
                return true;
            } else
            {
                min+=dan.behAct[behCost].resChance[i];
            }
        }
        return false;
    }



    public function enoughRes(dan, hC):Boolean
    {
        heroChoice=hC;
        trace("resEnough");

        trace("dan.heroChoose="+dan.heroChoose);
        var isPossible:Boolean=false;

        var behGo:int=-1;
        for (i=0; i<dan.behRes.length; i++)
        {
            if (behRes==dan.behRes[i].iii) //behRes получен в choose
            {
                behGo = i;
                break;
            }
        }
        var bRes:BehResult=dan.behRes[behGo];//behCost
        trace("bRes.heroResNum.length="+bRes.heroResNum.length);


        if (dan.behRes[behGo].heroResNum.length==0) //behCost
        {
            isPossible=true;
        }
        if (heroChoice==-1 && dan.heroChooseMemory!=-1)
        {
            heroChoice = dan.heroChooseMemory;
            dan.heroChooseMemory=-1;
        }
        if (heroChoice==-1 && dan.currentCity!=-1)
        {
            //ищем нашего героя, ответственного за город
            for (var i:int=0; i<dan.currentHeroes.length; i++)
            {
                for (var j:int=0; j<dan.currentHeroes[i].needTyppe.length; j++)
                {
                    if (dan.currentHeroes[i].needTyppe[j]=="city" && dan.currentHeroes[i].needNum[j]==dan.currentCity)
                    {
                        heroChoice=i+1;
                        break;
                    }
                }
            }
        }
        trace("heroChoice="+heroChoice);
        if (heroChoice!=-1)
        {
            trace("dan.behChoice="+dan.behChoice);
            isPossible=true;
            trace("behCost="+behCost);
            var hero:Hero=dan.currentHeroes[heroChoice-1];


            trace("behRes="+behRes);
            trace("bRes.heroResTyppe.length="+bRes.heroResTyppe.length);
            for (i=0; i<bRes.heroResNum.length; i++)
            {
                for (var j:int=0; j<hero.heroResTyppe.length; j++)
                {
                    if (bRes.heroResTyppe[i]==hero.heroResTyppe[j])
                    {
                        if (bRes.heroResNumTyppe[i]=="abs")
                        {
                            if (hero.heroResMax[j]>=bRes.heroResNum[i])
                            {
                                hero.heroResMax[j]-=bRes.heroResNum[i];
                                isPossible=true;
                                trace("true");
                                continue;
                            } else
                            {
                                trace("ffalse");
                                isPossible=false;
                                break;
                            }
                        }
                        if (bRes.heroResNumTyppe[i]=="perc")
                        {
                            hero.heroResMax[j]-= hero.heroResMax[j]*bRes.heroResNum[i]/100;
                            isPossible=true;
                        }
                    }
                }
                if (!isPossible)
                {
                    break;
                }
            }
        }
        trace("isPossible="+isPossible)
        return isPossible;
    }

    public function enoughRelations(dan):Boolean //проверяем соответствие отношений городов
    {
        var behGo:int=-1;
        for (i=0; i<dan.behRes.length; i++)
        {
            trace(i+"; dan.behRes[i].iii="+dan.behRes[i].iii);
            if (behRes==dan.behRes[i].iii)
            {
                behGo=i;
                trace("true");
                break;
            }
        }
        var bRes:BehResult=dan.behRes[behGo];
        if (bRes.needRelTyppe.length==0) //проверяем, есть ли запросы на проверку взаимоотношений городов
        {
            return true;
        }

        var res:Boolean = false;
        for (i=0; i<bRes.needRelTyppe.length; i++) //и если они есть - разбираемся
        {
            if (bRes.needRelTyppe[i] == "firstAlliance") //игрока принимает лидер альянса, и у игрока нет своего альянса
            {
                if (dan.cities[0].alliance==-1 && dan.cities[dan.currentCity].leader)
                {
                    res = true;
                } else
                {
                    res = false;
                    break;
                }
            }
            if (bRes.needRelTyppe[i] == "noAlliance") //проверяем, что у города нет другого альянса
            {
                trace("noAlliance")
                if (dan.cities[dan.currentCity].alliance == -1)
                {
                    res = true;
                } else
                {
                    res = false;
                    break;
                }
            }
            if (bRes.needRelTyppe[i] == "power") //проверяем, что ваши силы как минимум сопоставимы
            {
                trace("power");
                var nm:int = 0;
                for (j = 0; j < dan.globalRes.length; j++) //находим нужный ресурс
                {
                    if (dan.globalRes[j].typpe == bRes.needRelRes[i])
                    {
                        nm = j;
                        break;
                    }
                }
                if (bRes.needRelNumTyppe[i] == "both")
                {
                    if (dan.globalRes[nm].amount >= dan.cities[dan.currentCity].army * 0.7)
                    {
                        res = true;
                    } else
                    {
                        res = false;
                        break;
                    }
                }
                if (bRes.needRelNumTyppe[i] == "you")
                {
                    if (dan.globalRes[nm].amount >= dan.cities[dan.currentCity].army * 1.2)
                    {
                        res = true;
                    } else
                    {
                        res = false;
                        break;
                    }
                }
            }
            if (bRes.needRelNumTyppe[i]=="relations") //уровень отношений высокий
            {
                if (bRes.needRelNumTyppe[i]=="high")
                {
                    if (dan.cities[dan.currentCity].peacewarRelations[0] >= 85)
                    {
                        res = true;
                    } else
                    {
                        res = false;
                        break;
                    }
                }
                if (bRes.needRelNumTyppe[i]=="good")
                {
                    if (dan.cities[dan.currentCity].peacewarRelations[0] >= 50)
                    {
                        res = true;
                    } else
                    {
                        res = false;
                        break;
                    }
                }
            }
            if (bRes.needRelNumTyppe[i]=="noWar")
            {
                if (dan.cities[dan.currentCity].peacewar[0]==0)
                {
                    res=true;
                } else
                {
                    res=false;
                    break;
                }
            }
        }
        trace("enough relations="+res);
        return res;
    }

    public function dipStatus(dan, behPos, landNum):Boolean
    { //проверка взаимоотношений с городом
        trace("dipStatus");
        var b:Boolean=false;
        trace("behPos="+behPos);
        trace("landNum="+landNum);
        if (behPos!=-1 && landNum!=-1 && dan.behPos[behPos].dip!="") //если необходимость проверить дип отношения есть
        {
            trace("need to check");
            trace(behPos);
            trace(landNum);
            trace("dan.behPos[behPos].war="+dan.behPos[behPos].war);
            trace("dan.cities[landNum].peacewar[0]="+dan.cities[landNum].peacewar[0]);
            if (dan.behPos[behPos].war==dan.cities[landNum].peacewar[0])
            {
                trace("true;")
                b=true;
            }
        } else
        {
            b=true;
        }
        return b;
    }
}
}
