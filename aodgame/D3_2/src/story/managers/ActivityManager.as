/**
 * Created by alexo on 27.06.2016.
 */
package story.managers
{
import D3.Bitte;

import collections.behavior.BehPositioning;
import collections.behavior.BehResult;
import collections.common.Hero;

import story.Danke;

public class ActivityManager
{
    private var bit:Bitte;
    private var dan:Danke;

    private var down:int=-1;

    private var i:int=0;
    private var j:int=0;

    private var numOfRes:int=-1;
    private var lag:int=0;

    private var heroChoice:int=-1; //номер героя
    private var behActChoice:int=-1; //номер выбора в массиве менюшек

    private var behCost:int=0; //хранит номер выбора игроком активности, а заьтем и его номер в массиве после первой проверки
    private var behRes:int=-1;
    private var curLand:int=-1;

    private var cityPic:int=-1;
    private var cityName:int=-1;

    private var cityIDII:int=-1; //номера в векторе панели города и спец.панели города
    private var specPanel:int=-1;


    public function ActivityManager()
    {
        bit = Bitte.getInstance();
        dan = Danke.getInstance();
    }

    public function work(sub):void
    {
        if (bit.dm==1 && down==-1 && bit.mouseParDown==dan.heroIII)
        {
            //trace("downOfMany="+dan.downOfMany);
            down=dan.downOfMany-1;
        }
        if ((bit.dm==0 && down!=-1) || dan.needToMakeMenu)
        {
            trace("positioning start");
            if (positioning(sub) || (dan.needToMakeMenu && posMess())) //перемещение героя либо просьба от системы сообщений
            {
                lag=2;
                dan.needToMakeMenu=false;
               // trace("but nowwww dan.needToMakeMenu="+dan.needToMakeMenu);
                makeMenu();
                //trace("and after dan.needToMakeMenu="+dan.needToMakeMenu);
            }
            down=-1;
        }
        if (dan.behChoice!=0) //определяем, куда наведён герой и что
        {
            trace("hero go");
            if (choice() && choose() && enoughRes())
            {
                trace("current behRes="+behRes);
                trace("behCost="+behCost);
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
                if (bRes.resChangeTyppe.length>0)
                {
                    resChanger(bRes);
                }
                if (bRes.warningLand.length>0)
                {
                    warningLandChanger(bRes);
                }
                if (bRes.changeTyppe.length>0)
                {
                    changer(sub, bRes);
                }
                if (bRes.cityRelTyppe.length>0)
                {
                    cityRel(sub, bRes);
                }

            }
            trace("dan.behChoice="+dan.behChoice);
            dan.behChoice=0;
            heroChoice=-1;
            behActChoice=-1;
            curLand=-1;
            numOfRes=-1;
        }
        if (lag>0)
        {
            lag--;
        } else
        {
            if (dan.heroMenuActivity!=-1)
            {
                dan.heroMenuActivity = -1;
                dan.heroMenuNum=-1;
            }
        }

        if (bit.sChangeTurn)
        {
            activities(sub);
        }
        cloudOut(sub);
    }

    private function cityRel(sub, bRes):void //меняем отношение города к вам
    {
        trace("cityRel");
        for (i=0; i<bRes.cityRelTyppe.length; i++)
        {
            if (bRes.cityRelTyppe[i]=="current") //город текущий открытый
            {
                if (bRes.cityRelNumTyppe[i]=="abs") //меняем на абсолютное значение
                {
                    trace("bRes.cityRelNum[i]="+bRes.cityRelNum[i]);
                    trace("dan.cities[dan.currentCity].name="+dan.cities[dan.currentCity].name);
                    trace("rel before="+dan.cities[dan.currentCity].peacewarRelations[0]);
                    dan.cities[dan.currentCity].peacewarRelations[0]+=bRes.cityRelNum[i];
                    dan.cities[0].peacewarRelations[dan.currentCity-1]+=bRes.cityRelNum[i]; //город игрока
                    trace("rel after="+dan.cities[dan.currentCity].peacewarRelations[0]);
                    dan.currRelations=dan.cities[dan.currentCity].peacewarRelations[0];
                    trace("dan.cities[dan.currentCity].name="+dan.cities[dan.currentCity].name);

                    //var cityIDII:int=-1;
                    //var specPanel:int=-1;

                    if (cityIDII==-1 || specPanel==-1)
                    {
                        trace("dan.specCityPanel="+dan.specCityPanel);
                        for (j = 0; j < sub.length; j++)
                        {
                            if (cityIDII == -1 && sub[j].iii == dan.cityDipPanel)
                            {
                                cityIDII = j;
                            }
                            if (specPanel == -1 && sub[j].iii == dan.specCityPanel)
                            {
                                specPanel = j;
                                trace("specPanel=" + specPanel + "::" + dan.specCityPanel);
                            }
                        }
                    }
                    for (j=0; j<sub[cityIDII].specID.length; j++) //находим элемент, который надо изменить
                    {
                        if (sub[cityIDII].specID[j]=="cRel")
                        {
                            sub[cityIDII].fram[j]=dan.currRelations;
                            sub[cityIDII].neddFram=true;
                            break;
                        }
                    }

                    for (var d:int=0; d<dan.knownCities.length; d++)
                    {
                        var ii:int=dan.cities[dan.knownCities[d]].iii;
                        trace("ii="+ii);
                        var rel:int=0;
                        for (var j:int=1;j<dan.cities.length; j++)
                        {
                            if (dan.cities[j].iii==ii)
                            {
                                sub[specPanel].fram[dan.numOfElemsCityPanel + d] = dan.cities[j].peacewarRelations[0];
                                break;
                            }
                        }
                    }
                    sub[specPanel].neddFram=true;

                    //for (j=0; j<)
                    //sub[specPanel].fram[dan.numOfElemsCityPanel + i] = dan.cities[j].peacewarRelations[0];
                }
            }
            if (bRes.cityRelTyppe[i]=="war") //объявляем войну союзу
            {
                trace("war");
                trace("dan.currentCit="+dan.currentCity);
                trace("name="+dan.cities[dan.currentCity].name);
                dan.currPeaceWar=1;
                dan.cities[dan.currentCity].peacewar[0]=dan.currPeaceWar;
                dan.cities[0].peacewar[dan.currentCity-1]=dan.currPeaceWar; //город игрока
                var alYou:int=dan.cities[0].alliance;
                var alEnemy:int=dan.cities[dan.currentCity].alliance;

                for (i=0; i<dan.alliances.length; i++)
                {
                    if (dan.alliances[i].iii==dan.cities[dan.currentCity].alliance)
                    {
                        dan.alliances[i].warWith.push(dan.cities[0].iii);
                    }
                    if (dan.alliances[i].iii==dan.cities[0].alliance)
                    {
                        dan.alliances[i].warWith.push(dan.cities[dan.currentCity].iii);
                    }
                }

                //находим альянсы
                trace("dan.cities[dan.currentCity].alliance="+dan.cities[dan.currentCity].alliance);
                trace("dan.cities[dan.currentCity].peacewar[0]="+dan.cities[dan.currentCity].peacewar[0]);
               /* for (i=0; i<dan.cities.length; i++)
                {
                    trace("dan.cities[i].name="+dan.cities[i].name);
                    if(dan.cities[i].alliance==dan.cities[dan.currentCity].alliance && dan.cities[i].alliance!=-1)
                    {
                        trace("war "+dan.cities[i].iii);
                        dan.cities[i].peacewar[0]=dan.currPeaceWar;
                    }
                    if(dan.cities[i].alliance==dan.cities[0].alliance && dan.cities[i].alliance!=-1)
                    {
                        trace("union "+dan.cities[i].iii)
                        dan.cities[i].peacewar[dan.currentCity-1]=dan.currPeaceWar;
                    }
                }*/
                for (i=0; i<dan.cities.length; i++) //каждый город альянса начинает выяснять отношения с каждым при совпадении альянсов
                {
                    for (j=0; j<dan.cities[i].peacewarIII.length; j++)
                    {
                        for (var k:int=0; k<dan.cities.length; k++)
                        {
                            if (dan.cities[k].iii==dan.cities[i].peacewarIII[j])
                            {
                                if (dan.cities[i].alliance==alYou && dan.cities[k].alliance==alEnemy)
                                {
                                    dan.cities[i].peacewar[j]=1;
                                }
                                if (dan.cities[i].alliance==alEnemy && dan.cities[k].alliance==alYou)
                                {
                                    dan.cities[i].peacewar[j]=1;
                                }
                                break;
                            }
                        }
                    }
                }

                for (i=0; i<dan.cities[0].peacewar.length; i++)
                {
                    trace(i+"="+dan.cities[0].peacewar[i]);
                }

                for (j=0; j<sub[cityIDII].specID.length; j++) //находим элемент, который надо изменить
                {
                    if (sub[cityIDII].specID[j]=="cPvW")
                    {
                        sub[cityIDII].fram[j]= dan.currPeaceWar+1;
                        sub[cityIDII].neddFram=true;
                        break;
                    }
                }
            }
        }
    }

    private function cloudOut(sub):void
    {
        if (dan.cloudsOut==-1 && dan.cityStart!=-1 && dan.cityName!=-1)
        {
            trace("dan.cloudsOut="+dan.cloudsOut+"; dan.cityStart="+dan.cityStart);
            for (i=0; i<sub.length; i++)
            {
                if (sub[i].iii==dan.cityStart)
                {
                    trace("clouds out here");
                    for (j=0; j<sub[i].visOne.length; j++)
                    {
                        sub[i].visOne[j]=0;
                    }
                    sub[i].neddFram = true;
                    cityPic=i;
                    //break;
                }
                if (sub[i].iii==dan.cityName)
                {
                    for (j=0; j<sub[i].visOne.length; j++)
                    {
                        sub[i].visOne[j]=0;
                    }
                    cityName=i;
                    sub[i].neddFram = true;
                }
            }
            dan.cloudsOut=0;
        }
        if (dan.cloudsOut==1 && dan.cityStart!=-1) //блок срабатывает, если убрано очередное облако
        {
            trace("out dan.cloudsOut="+dan.cloudsOut+"; dan.cityStart="+dan.cityStart);
            for (j = 0; j < sub[cityPic].visOne.length; j++)
            {
                var t:int=0;
                for (var k:int = 0; k < dan.clouds.length; k++)
                {
                    if (
                                (sub[cityPic].sx[j] + sub[cityPic].subX > dan.clouds[k].xx - dan.clouds[k].ww/2) &&
                                (sub[cityPic].sx[j] + sub[cityPic].subX < dan.clouds[k].xx + dan.clouds[k].ww/2) &&
                                (sub[cityPic].sy[j] + sub[cityPic].subY > dan.clouds[k].yy - dan.clouds[k].hh/2) &&
                                (sub[cityPic].sy[j] + sub[cityPic].subY < dan.clouds[k].yy + dan.clouds[k].hh/2)
                    )
                    {
                        if (!dan.clouds[k].vis)
                        {
                            t++;
                        } else
                        {
                            t=-100;
                        }
                    }
                }
                if (t>0)
                {
                    if (sub[cityPic].visOne[j]==0)
                    {
                        dan.knownCities.push(j); //начало j всегда с единицы, т.к. нулевой город - город игрока
                    }
                    sub[cityPic].visOne[j] = 1;
                    sub[cityPic].neddFram = true;
                    sub[cityName].visOne[j] = 1;
                    sub[cityName].neddFram = true;
                }
            }
            dan.cloudsOut=0;
        }
    }

    private function changer(sub, bRes):void
    {
        trace("69");
        for (var i=0; i<bRes.changeTyppe.length; i++)
        {
            switch (bRes.changeTyppe[i])
            {
                case "cloud":
                    for (var k:int=0; k<dan.clouds.length; k++)
                    {
                        if
                        (
                            (dan.clouds[k].vis) &&
                            (dan.heroMoveX>dan.clouds[k].xx - dan.clouds[k].ww/2) && (dan.heroMoveX<dan.clouds[k].xx + dan.clouds[k].ww+2)
                            &&
                            (dan.heroMoveY>dan.clouds[k].yy - dan.clouds[k].hh/2) && (dan.heroMoveY<dan.clouds[k].yy + dan.clouds[k].hh/2)
                        )
                        {
                            trace("changer dan.heroMoveX="+dan.heroMoveX+"; dan.heroMoveY="+dan.heroMoveY);
                            trace(" dan.heroChoose="+ dan.heroChoose);
                            dan.heroOnTyppe="shadow";
                            dan.heroStart=false;
                            //dan.heroChoose=heroChoice;
                            break;
                        }
                    }
                    break;
                default:
                    break;
            }
        }
    }

    private function activities(sub):void
    {
        for (var c:int=0; c<dan.currentHeroes.length; c++)
        {
            var activity:int=-1;
            var hero:Hero = dan.currentHeroes[c];
            for (var j:int = 0; j < hero.needTyppe.length; j++) //проходим по каждой из активностей
            {
                if (hero.needTyppe[j]!="shadow")
                {
                    continue;
                }
                var k:int = 0;

                trace("hero.needTyppe[j]="+hero.needTyppe[j]);
                //сравниваем, может ли герой позволить себе активность
                while (k < dan.heroActivities.length)
                {
                    if (hero.needTyppe[j] == dan.heroActivities[k].act)
                    {
                        var typp:int = 0;
                        while (typp < hero.heroResTyppe.length)
                        {
                            for (var n:int = 0; n < dan.heroActivities[k].costTyppe.length; n++)
                            {
                                if (dan.heroActivities[k].costTyppe[n] == hero.heroResTyppe[typp])
                                {
                                    if (hero.heroResMax[typp] - dan.heroActivities[k].costNum[n] >= 0)
                                    {
                                        trace("l-1");
                                        activity=j;
                                        break;
                                    } else
                                    {
                                        trace("l-2");
                                        activity=-2;
                                        break;
                                    }
                                }
                            }
                            typp++;
                            if (activity==-2)
                            {
                                trace("l-3");
                                break;
                            }
                        }
                    }
                    k++;
                    if (activity==-2)
                    {
                        trace("l-4");
                        break;
                    }
                }
                break;
            }
            if (activity>=0)
            {
                trace("|act");
                trace("hero.needTyppe[activity]="+hero.needTyppe[activity]);
                if (hero.needTyppe[activity]=="shadow")
                {
                    trace("cloud");
                    trace("x:y="+hero.needX[activity]+"::"+hero.needY[activity]);
                    for (var k:int = 0; k < dan.clouds.length; k++)
                    {
                        trace("i="+i+"; dan.clouds[k].vis="+dan.clouds[k].vis+"; x:y="+dan.clouds[k].xx+"::"+dan.clouds[k].yy);
                        var herox:int=hero.needX[activity];
                        var heroy:int=hero.needY[activity];
                        var xx:int=dan.clouds[k].xx;
                        var yy:int=dan.clouds[k].yy;
                        var ww:int=dan.clouds[k].ww;
                        var hh:int=dan.clouds[k].hh;
                        if
                        (
                                (dan.clouds[k].vis) &&
                                (herox > xx - ww/2) && (herox < xx + ww/2) && (heroy > yy - hh/2) && (heroy < yy + hh/2)
                        )
                        {
                            trace("have unvis one");
                            dan.clouds[k].vis = false;
                            dan.cloudsOut=1;
                        }
                    }
                    for (var k:int = 0; k < sub.length; k++)
                    {
                        if (sub[k].iii == dan.shadowPlane)
                        {
                            trace("unvis");
                            for (var m:int = 0; m < sub[k].numOfEl.length; m++)
                            {
                                if (!dan.clouds[m].vis)
                                {
                                    sub[k].visOne[m] = 0;
                                }
                            }
                            sub[k].neddFram = true;
                            break;
                        }
                    }
                }
            }
        }
    }

    private function choose():Boolean //находим, по какому варианту развития пойдёт событие после выбора пользователя
    {
        trace("choose");
        var min=0;
        var r:int=Math.random()*100;
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

    private function choice():Boolean //находим какой пункт выбрал пользователь
    {
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
                return true;
            }
        }
        return false;

    }

    private function enoughRes():Boolean
    {
        trace("resEnough");

        trace("dan.heroChoose="+dan.heroChoose);
        var isPossible:Boolean=false;

        var behGo:int=-1;
        for (i=0; i<dan.behRes.length; i++)
        {
            if (behRes==dan.behRes[i].iii)
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

    private function resChanger(bRes):void
    {
        trace("res Changer");
        //var bRes:BehResult=dan.behRes[behRes];
        trace("bRes.resChangeTyppe.length="+bRes.resChangeTyppe.length);
        for (i=0; i<bRes.resChangeTyppe.length; i++)
        {
            trace("i="+i);
            //trace("bRes.resChangeTyppe="+bRes.resChangeTyppe[i]);
            for (var j:int=0; j<dan.globalRes.length; j++)
            {
                //trace(">>dan.globalRes[j].typpe="+dan.globalRes[j].typpe);
                if (dan.globalRes[j].typpe==bRes.resChangeTyppe[i])
                {
                    if (bRes.resChangeNumTyppe[i]=="perc")
                    {
                        dan.globalRes[j].amount+=dan.globalRes[j].amount*bRes.resChangeNum[i]/100;
                        if (dan.globalRes[j].need=="need")
                        {
                            dan.globalRes[j].freeAmount+=dan.globalRes[j].amount*bRes.resChangeNum[i]/100;
                        }
                        if(dan.globalRes[j].need=="filler")
                        {
                            dan.globalRes[j].presenceAmount+=dan.globalRes[j].amount*bRes.resChangeNum[i]/100;
                        }
                    }
                    if (bRes.resChangeNumTyppe[i]=="abs")
                    {
                        dan.globalRes[j].amount+=bRes.resChangeNum[i];
                        if (dan.globalRes[j].need=="need")
                        {
                            dan.globalRes[j].freeAmount+=bRes.resChangeNum[i];
                        }
                        if(dan.globalRes[j].need=="filler")
                        {
                            trace("before presenceAmount="+dan.globalRes[j].presenceAmount);
                            dan.globalRes[j].presenceAmount+=bRes.resChangeNum[i];
                            trace("after presenceAmount="+dan.globalRes[j].presenceAmount);
                        }
                    }
                    if (dan.globalRes[j].amount<dan.globalRes[j].min)
                    {
                        dan.globalRes[j].amount=dan.globalRes[j].min;
                    }
                    if (dan.globalRes[j].freeAmount<dan.globalRes[j].min)
                    {
                        dan.globalRes[j].freeAmount=dan.globalRes[j].min;
                    }
                    if (dan.globalRes[j].presenceAmount<dan.globalRes[j].min)
                    {
                        dan.globalRes[j].presenceAmount=dan.globalRes[j].min;
                    }

                    if (dan.globalRes[j].amount>dan.globalRes[j].max)
                    {
                        dan.globalRes[j].amount=dan.globalRes[j].max;
                    }
                    if (dan.globalRes[j].freeAmount>dan.globalRes[j].max)
                    {
                        dan.globalRes[j].freeAmount=dan.globalRes[j].max;
                    }
                    if (dan.globalRes[j].presenceAmount>dan.globalRes[j].max)
                    {
                        dan.globalRes[j].presenceAmount=dan.globalRes[j].max;
                    }
                    trace(dan.globalRes[j].typpe+"::"+dan.globalRes[j].amount);
                    break;
                }
            }
        }
    }

    private function warningLandChanger(bRes):void
    {
        trace("!!!curLand="+curLand);
        var numOfLand:int=-1;
        for (i=0; i<bRes.warningTyppe.length; i++)
        {
            if (bRes.warningLand[i]=="currland")
            {
                trace("up1");
                for (var j:int=0; j<dan.lands.length; j++)
                {
                    if (dan.lands[j].subID==curLand)
                    {
                        trace("up2");
                        numOfLand=j;
                        break;
                    }
                }
                if (numOfLand!=-1)
                {
                    trace("inside");
                    dan.lands[numOfLand].building.workStopProblem=bRes.warningTyppe[i];
                    trace("workStopProblem="+dan.lands[numOfLand].building.workStopProblem);

                    dan.lands[numOfLand].building.timeToBuild=bRes.timeToBuild[i];
                    if (bRes.canWork[i]==1)
                    {
                        dan.lands[numOfLand].building.canWork = true;
                    } else
                    {
                        dan.lands[numOfLand].building.canWork = false;
                    }
                    //dan.lands[numOfLand].situationRePic();
                    dan.madeBuilding = -1;
                    break;
                }
            }
        }
    }

    private function posMess():Boolean
    {
        //trace("posMess0");
        if (dan.behPosFromMess!=-1)
        {
            //trace("posMess");
            //dan.behPosFromMess=-1;
            numOfRes = -2;//dan.behPosFromMess;
            return true;
        }
        return false;
    }
    private function positioning(sub):Boolean
    {
        trace(bit.mouseParClick);
        trace(bit.mouseClick);
        trace(dan.heroChoose);
        trace(dan.heroIII);
        trace("posit prefirst");
        if (bit.mouseParClick==dan.heroIII && bit.mouseParClick!=-1)
        {
            trace("equalisation");
            var h:int=-1;
            for (i=0; i<sub.length; i++)
            {
                if (sub[i].iii==dan.heroIII)
                {
                    h=i;
                    break;
                }
            }
            trace("h="+h);
            if (h!=-1)
            {
                trace(sub[h].sx[dan.heroChoose-1]+"::"+sub[h].baseX[dan.heroChoose-1]);
                trace(sub[h].sy[dan.heroChoose-1]+"::"+sub[h].baseY[dan.heroChoose-1]);
                if (sub[h].wayCount[dan.heroChoose-1]<10)
                {
                    trace("false;");
                    return false;
                }
            }

        }
        trace("posit first");
        var res:Boolean = false;
        var bool:Boolean=false;
        var landNum:int=-1;
        //trace(dan.heroChoose);
        heroChoice=dan.heroChoose; //[0]=1, [1]=2...
        for (i=0; i<dan.behPos.length; i++)
        {
            trace("i="+i);
            var bp:BehPositioning = dan.behPos[i];
            if (bit.curRoom!=bp.weAre)
            {
                continue;
            }
            trace("bp.where="+bp.where);
            switch (bp.where)
            {
                case "land":
                    trace("beh bit.underOne "+bit.underOne);
                    curLand=bit.underOne;
                    for (j=0; j<dan.lands.length; j++)
                    {
                        if (dan.lands[j].subID==bit.underOne)
                        {
                            landNum=j;
                            bool=true;
                            break;
                        }
                    }
                    break;
                case "cloud":
                        if (dan.currentCity==-1)
                        {
                            for (j = 0; j < dan.clouds.length; j++) //проверяем, над туманом ли войны отпустили героя
                            {
                                //trace("bit.sx+bit.sy=" + bit.sx + "+" + bit.sy);
                                //trace("xx+ww=" + dan.clouds[j].xx + "+" + dan.clouds[j].ww);
                                //trace("yy+hh=" + dan.clouds[j].yy + "+" + dan.clouds[j].hh);
                                if (
                                        (dan.clouds[j].vis) &&
                                        (bit.sx > dan.clouds[j].xx - dan.clouds[j].ww/2) && (bit.sx < dan.clouds[j].xx + dan.clouds[j].ww/2) &&
                                        (bit.sy > dan.clouds[j].yy - dan.clouds[j].hh/2) && (bit.sy < dan.clouds[j].yy + dan.clouds[j].hh/2))
                                {
                                    //trace("cityStart=" + dan.cityStart);
                                    //trace("currentCity=" + dan.currentCity);
                                    trace("cloud good");
                                    landNum = 0;
                                    bool = true;
                                    break;
                                }
                            }
                        }
                    break;
                default:
                    continue;
            }
            if (bool)
            {
                if (bp.warning != "" && bp.warning != "no" && bp.where!="cloud")
                {
                    if (landNum != -1 && bp.warning != dan.lands[landNum].building.workStopProblem)
                    {
                        trace("continue");
                        continue;
                    }
                }
                /*if (bp.warning != "" && landNum != -1 && bp.warning != dan.lands[landNum].building.workStopProblem)
                {
                    trace("continue");
                    continue;
                }*/
                dan.heroMoveX=bit.sx;
                dan.heroMoveY=bit.sy;
                trace("bit.sx="+bit.sx+"; bit.sy = "+bit.sy);
                trace("next one");
                res = true;
                numOfRes = i;

                break;
            }
        }

        return res;
    }

    private function makeMenu():void
    {
        if (numOfRes==-1)
        {
            return;
        }
        if (numOfRes>-1)
        {
            dan.heroMenuActivity = dan.behPos[numOfRes].resIII;
        } else
        {
        }
        trace("dan.heroMenuActivity="+dan.heroMenuActivity);
        numOfRes=-1;

        var z:int=-1;
        for (var j:int = 0; j < dan.behMenu.length; j++)
        {
            if (dan.behMenu[j].iii==dan.heroMenuActivity)
            {
                z=j;
                break;
            }
        }
        if (z!=-1)
        {
            trace("dan.behMenu[z].iii=" + dan.behMenu[z].iii);
            dan.heroMenuNum = dan.behMenu[z].choicerBehActivity.length;
            trace("dan.heroMenuNum=" + dan.heroMenuNum);
            behActChoice = z;
            trace("behActChoice" + behActChoice);
        }
    }
}
}
