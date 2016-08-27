/**
 * Created by alexo on 27.06.2016.
 */
package story.managers
{
import D3.Bitte;

import collections.behavior.BehResult;
import collections.common.Hero;
import collections.inWorld.Alliance;

import story.Danke;
import story.managers.activities.Check;
import story.managers.activities.Positioning;

public class ActivityManager
{
    private var bit:Bitte;
    private var dan:Danke;

    private var down:int=-1;

    private var i:int=0;
    private var j:int=0;

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

    private var landNum:int=-1;
    private var behPos:int=-1;

    private var posit:Positioning; //класс с функциями для позиционирования героев
    private var check:Check; //класс с функциями, котнролирующими условия исполнения активностей

    public function ActivityManager()
    {
        bit = Bitte.getInstance();
        dan = Danke.getInstance();
        posit = new Positioning();
        check = new Check();
    }

    public function work(sub):void
    {
        if (bit.dm==1 && down==-1 && bit.mouseParDown==dan.heroIII)
        {
            down=dan.downOfMany-1;
        }
        if ((bit.dm==0 && down!=-1) || dan.needToMakeMenu) //создаём менюшку сообщения (по крайней мере проверяем возможность создания)
        {
            trace("positioning start");
            if (posit.positioning(bit, dan, sub) || (dan.needToMakeMenu && posit.posMess(dan))) //перемещение героя либо просьба от системы сообщений
            {
                behPos=posit.return_BehPos();
                landNum=posit.return_LandNum();
                curLand=posit.return_CurLand();
                heroChoice=posit.return_HeroChoice();

                lag=10;
                dan.needToMakeMenu=false;

                posit.makeMenu(dan);
                behActChoice=posit.return_behActChoice();
            }
            down=-1;
        }
        if (dan.behChoice!=0) //определяем, куда наведён герой и что
        {
            if (check.choice(dan, behActChoice, behCost) &&
                    check.choose(dan, behRes) &&
                    check.enoughRes(dan, heroChoice) &&
                    check.enoughRelations(dan))// &&
                    //check.dipStatus(dan, behPos, landNum))
            {
                behCost=check.behCost;
                behRes=check.behRes;
                heroChoice=check.heroChoice;

                actions(sub);
            }

            heroChoice=-1;
            check.clear();
            curLand=-1;
            posit.clear();
            dan.behChoice=0;
            behActChoice=-1;

        }
        if (lag>0)
        {
            lag--;
        } else
        {
            if (dan.heroMenuActivity!=-1)
            {
                trace("make mess null");
                dan.heroMenuActivity = -1;
                dan.heroMenuNum=-1;
            }
        }

        if (bit.sChangeTurn)
        {
            activities(sub);
        }
        cloudOut(sub); //необходимо для обработки видимости городов за облаками
    }

    private function behItGo(analyzVar):int
    {
        var bG:int=-1;
        for (i=0; i<dan.behRes.length; i++)
        {
            if (analyzVar==dan.behRes[i].iii)
            {
                bG=i;
                break;
            }
        }
        return bG;
    }

    private function actions(sub):void
    {
        trace("current behRes="+behRes);
        trace("behCost="+behCost);
        var behGo:int=behItGo(behRes);
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

    private function cityRel(sub, bRes):void //меняем отношение города к вам
    {
        trace("cityRel");
        i=0;
        for (i=0; i<bRes.cityRelTyppe.length; i++)
        {
            if (bRes.cityRelTyppe[i]=="current") //город текущий открытый
            {
                if (bRes.cityRelNumTyppe[i]=="abs") //меняем на абсолютное значение
                {
                    dan.cities[dan.currentCity].peacewarRelations[0]+=bRes.cityRelNum[i];
                    dan.cities[0].peacewarRelations[dan.currentCity-1]+=bRes.cityRelNum[i]; //город игрока
                    dan.currRelations=dan.cities[dan.currentCity].peacewarRelations[0];

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

            if (i<bRes.cityRelTyppe.length && bRes.cityRelTyppe[i]=="alliance") //заключаем союз с городом
            {
                trace("Begin alliance working");
                if (bRes.cityRelNumTyppe=="out" || bRes.cityRelNumTyppe=="meOut")
                {
                    var cityIidi:int = -1;
                    if (bRes.cityRelNumTyppe == "out" && dan.cities[dan.currentCity].alliance != -1) //покинуть альянс
                    {
                        trace("out");
                        cityIidi = dan.currentCity;
                    }
                    if (bRes.cityRelNumTyppe == "meOut" && dan.cities[0].alliance != -1) //покинуть альянс
                    {
                        trace("meOut");
                        cityIidi = 0;
                    }
                    if (cityIidi==-1)
                    {
                        continue;
                    }
                    var alli:int = -1;
                    i = 0;
                    while (i < dan.alliances.length) //ищем нужный союз
                    {
                        if (dan.cities[cityIidi].alliance != -1 && dan.alliances[i].iii == dan.cities[cityIidi].alliance)
                        { //если нашли
                            trace("alli="+dan.alliances[i].iii+"::"+dan.alliances[i].members.length+"::"+dan.alliances[i].leader);
                            j=0;
                            while (j < dan.alliances[i].members.length) //проходим по его участникам
                            {
                                trace("member: "+dan.alliances[i].members[j]+";  dan.cities[cityIidi].name="+ dan.cities[cityIidi].name);
                                if (dan.alliances[i].members[j] == dan.cities[cityIidi].iii) //чтобы найти текущий город и удалить его из участников
                                {
                                    trace("splice");
                                    dan.alliances[i].members.splice(j, 1);
                                    break;
                                }
                                j++;
                            }
                            if (dan.alliances[i].members.length <= 1) //если в союзе остался всего один город, расформировываем союз
                            {
                                trace("alliance end");
                                trace("length="+dan.alliances[i].members.length);
                                trace("dan.alliances[i].members[0]="+dan.alliances[i].members[0]);
                                for (j = 0; j < dan.cities.length; j++)
                                {
                                    trace("just city: "+dan.cities[j].iii+" ("+dan.cities[j].name+")")
                                    if (dan.cities[j].iii == dan.alliances[i].members[0])
                                    {
                                        trace("member dan.cities[j].iii="+dan.cities[j].iii+" ("+dan.cities[j].name+")");
                                        dan.cities[j].alliance = -1;
                                        dan.cities[j].leader = false;
                                        dan.alliances[i].members.splice(0, 1);
                                        break;
                                    }
                                }
                                dan.alliances.splice(i, 1);
                            } else //иначе проверяем, не сменился ли лидер союза
                            {
                                if (dan.alliances[i].leader == dan.cities[cityIidi].iii)
                                {
                                    dan.alliances[i].leader = dan.alliances[i].members[0];
                                }
                            }

                            dan.cities[cityIidi].alliance = -1; //а у текущего города прописываем дефолтные настройки "без союза"
                            dan.cities[cityIidi].leader = false;
                            alli = i;
                            break;
                        }
                        i++;
                    }

                    continue;
                }
                trace("alliance");
                if (dan.cities[0].alliance==-1 && dan.cities[dan.currentCity].alliance==-1)
                {
                    trace("no alliance before");
                    dan.alliances.push(new Alliance());
                    dan.alliances[dan.alliances.length-1].iii=dan.alliances[dan.alliances.length-2].iii+1;
                    if (bRes.cityRelNumTyppe=="you") //определяем лидера союза
                    {
                        dan.alliances[dan.alliances.length - 1].leader = 1;
                        dan.cities[0].leader=1;
                    }
                    if (bRes.cityRelNumTyppe=="they")
                    {
                        dan.alliances[dan.alliances.length - 1].leader = 1;
                        dan.cities[0].leader=dan.currentCity;
                    }
                    dan.alliances[dan.alliances.length-1].members.push(1);
                    dan.alliances[dan.alliances.length-1].members.push(dan.currentCity+1);
                    dan.cities[dan.currentCity].alliance = dan.alliances[dan.alliances.length - 1].iii;
                    dan.cities[0].alliance = dan.alliances[dan.alliances.length - 1].iii;
                } else
                {
                    var alli:int=0;
                    trace("dan.cities[0].alliance="+dan.cities[0].alliance);
                    trace("dan.cities[dan.currentCity].alliance="+dan.cities[dan.currentCity+1].alliance);
                    for (i=0; i<dan.alliances.length; i++)
                    {
                        if (dan.cities[0].alliance!=-1 && dan.alliances[i].iii==dan.cities[0].alliance)
                        {
                            alli=i;
                            break;
                        }
                        if (dan.cities[dan.currentCity+1].alliance!=-1 && dan.alliances[i].iii==dan.cities[dan.currentCity+1].alliance)
                        {
                            alli=i;
                            break;
                        }
                    }
                    trace("alli="+alli);
                    trace("alliance is already done");
                    if (bRes.cityRelNumTyppe=="you")
                    {
                        dan.alliances[alli].members.push(dan.currentCity);
                        dan.cities[dan.currentCity].alliance = dan.alliances[alli].iii;
                    }
                    if (bRes.cityRelNumTyppe=="they")
                    {
                        dan.alliances[alli].members.push(1);
                        dan.cities[0].alliance = dan.alliances[alli].iii;
                    }
                }
            }
            if (i<bRes.cityRelTyppe.length && bRes.cityRelTyppe[i]=="thisCity") //город, над которым был герой
            {
                trace("thisCity");
                if (dan.overCity!=-1)
                {
                    if (bRes.cityRelNumTyppe[i]=="abs") //меняем на абсолютное значение
                    {
                        dan.cities[dan.overCity].peacewarRelations[0] += bRes.cityRelNum[i];
                        dan.cities[0].peacewarRelations[dan.overCity - 1] += bRes.cityRelNum[i]; //город игрока
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
        trace("changer");
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
                            dan.heroOnTyppe="shadow";
                            dan.heroStart=false;
                            break;
                        }
                    }
                    break;
                case "cityRaid":
                        trace("cityRaid");
                    dan.heroOnTyppe="cityRaid";
                    dan.heroStart=false;
                    break;
                case "citySiege":
                        trace("citySiege");
                    dan.heroOnTyppe="citySiege";
                    dan.heroStart=false;
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

    private function resChanger(bRes):void
    {
        trace("res Changer");
        for (i=0; i<bRes.resChangeTyppe.length; i++)
        {
            for (var j:int=0; j<dan.globalRes.length; j++)
            {
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
                    //trace(dan.globalRes[j].typpe+"::"+dan.globalRes[j].amount);
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
                    trace("dan.lands[numOfLand].building.timeToBuild="+dan.lands[numOfLand].building.timeToBuild);
                    if (bRes.canWork[i]==1)
                    {
                        dan.lands[numOfLand].building.canWork = true;
                    } else
                    {
                        dan.lands[numOfLand].building.canWork = false;
                    }
                    trace("change land Pic of problem="+dan.lands[numOfLand].subID);
                    trace(dan.lands[numOfLand].subID + "; building.workStopProblem="+dan.lands[numOfLand].building.workStopProblem);
                    dan.lands[numOfLand].situationRePic();
                    dan.madeBuilding = -1;//numOfLand;//-1;
                    break;
                }
            }
        }
    }
}
}