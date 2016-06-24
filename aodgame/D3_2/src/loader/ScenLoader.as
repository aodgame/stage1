/**
 * Created by alexo on 15-May-15.
 */
package loader
{
import collections.common.HeroActivity;
import collections.common.HeroRes;
import collections.inCity.Building;
import collections.inWorld.City;
import collections.common.GlobalRes;
import collections.common.Hero;
import collections.inCity.Land;
import collections.inCity.LandRes;
import collections.inWorld.Status;
import collections.common.Modification;
import collections.inCity.ProblemSituation;
import collections.inWorld.TradeCost;
import collections.inWorld.TradeTransaction;

import story.Danke;
import story.Quest;
import collections.Stats;
import flash.net.URLRequest;

public class ScenLoader extends ParentLoader
{
    private var dan:Danke;

    public function ScenLoader()
    {
        dan = Danke.getInstance();
    }

    public function levelGo(quests, timmer):void //функция загрузки графики
    {
        trace("!scen_level_go="+level_go);
        if (level_go==Stats.ZERO) //загрузка XML игры
        {
            if (bit.needToClear) //предварительно нужно убрать существующие предметы
            {
                clearAll(quests);
            }
            level_go+=Stats.ONE; //ждём завершения загрузки конфига
            bit.wait_scenario=true; //даём сигнал для прелодера

            t1=bit.addr+bit.scenPath; //?rnd="+Math.random();
            trace(t1);
            _request = new URLRequest(t1);

            GoLoad();
        }
        if (level_go==Stats.TWO) //рзабираем переменные
        {
            GoCreateParams(timmer);
            GoRead(quests);

        }
        if (level_go==Stats.THREE) //
        {
            bit.nextLevel-=Stats.ONE; //убираем пункт ожидания в загрузке
            level_go+=Stats.ONE;
            bit.wait_scenario=false; //убираем загрузочную ширму для графики

            if (!bit.wait_subjects) //если загрузка завершена, убираем триггер зачистки
            {
                bit.needToClear=false;
            }
        }
        if (level_go==Stats.FOUR && !bit.wait_scenario) //ничего не происходит
        {
        }
        if (level_go==Stats.FOUR && bit.wait_scenario) //ничего не происходит
        {
            level_go=Stats.ZERO;
        }
    }

    private function clearAll(quests):void
    {

    }

    private function GoCreateParams(timmer)
    {
        //открываем ресурсы
        for (i=0; i<myXML.globalRes.length(); i++)
        {
            dan.globalRes.push(new GlobalRes());
            dan.globalRes[dan.globalRes.length-1].iii=myXML.globalRes[i].@iii;
            dan.globalRes[dan.globalRes.length-1].typpe=myXML.globalRes[i].@typpe;
            dan.globalRes[dan.globalRes.length-1].pic=myXML.globalRes[i].@pic;
            dan.globalRes[dan.globalRes.length-1].sName=myXML.globalRes[i].@name;
            dan.globalRes[dan.globalRes.length-1].sDescription=myXML.globalRes[i].@description;
            dan.globalRes[dan.globalRes.length-1].amount=myXML.globalRes[i].@startAmount;
            dan.globalRes[dan.globalRes.length-1].min=myXML.globalRes[i].@min;
            dan.globalRes[dan.globalRes.length-1].max=myXML.globalRes[i].@max;
            if (myXML.globalRes[i].@isFree=="1")
            {
                dan.globalRes[dan.globalRes.length-1].isFree=true;
                dan.globalRes[dan.globalRes.length-1].freeAmount=dan.globalRes[dan.globalRes.length-1].amount;
            } else
            {
                dan.globalRes[dan.globalRes.length-1].isFree=false;
            }
            dan.globalRes[dan.globalRes.length-1].need=myXML.globalRes[i].@spec;
            for (var uu:int=0; uu<myXML.globalRes[i].need.length(); uu++)
            {
                dan.globalRes[dan.globalRes.length-1].paramsOfNeed.push(String(myXML.globalRes[i].need[uu].@every));
                dan.globalRes[dan.globalRes.length-1].paramsOfNeed.push(String(myXML.globalRes[i].need[uu].@need));
                dan.globalRes[dan.globalRes.length-1].paramsOfNeed.push(String(myXML.globalRes[i].need[uu].@from));
                dan.globalRes[dan.globalRes.length-1].paramsOfNeed.push(String(myXML.globalRes[i].need[uu].@income));
            }
            //trace("dan.globalRes[dan.globalRes.length-1]..typpe="+dan.globalRes[dan.globalRes.length-1].typpe+"; dan.globalRes[dan.globalRes.length-1].paramsOfNeed.length="+dan.globalRes[dan.globalRes.length-1].paramsOfNeed.length);
        }

        //меняем ресурсы на ресурсы
        for (i=0; i<myXML.landRes.length(); i++)
        {
            dan.landRes.push(new LandRes());
            dan.landRes[dan.landRes.length-1].typpe = myXML.landRes[i].@typpe;
            dan.landRes[dan.landRes.length-1].pic=myXML.landRes[i].@pic;
            dan.landRes[dan.landRes.length-1].sName=myXML.landRes[i].@name;
            dan.landRes[dan.landRes.length-1].sDescription=myXML.landRes[i].@description;

            for (var j:int=0; j<myXML.landRes[i].res.length(); j++)
            {
                dan.landRes[dan.landRes.length-1].globalResTyppe.push(new String(myXML.landRes[i].res[j].@typpe));
                dan.landRes[dan.landRes.length-1].globalResIncome.push(new int(myXML.landRes[i].res[j].@income));
            }
        }

        //готовимся к строениям
        for (i=0; i<myXML.building.length(); i++)
        {
            dan.buildings.push(new Building());
            dan.buildings[dan.buildings.length-1].iii=myXML.building[i].@iii;
            dan.buildings[dan.buildings.length-1].landResType=myXML.building[i].@landResType;
            dan.buildings[dan.buildings.length-1].baseLandResType=myXML.building[i].@landResType;
            dan.buildings[dan.buildings.length-1].name=myXML.building[i].@name;
            dan.buildings[dan.buildings.length-1].description=myXML.building[i].@description;
            dan.buildings[dan.buildings.length-1].baseTyppeOfBuilding=myXML.building[i].@landResType;

            if (myXML.building[i].param.@baseBuilding=="1")
            {
                dan.buildings[dan.buildings.length - 1].baseBuilding = true;
            }
            if (myXML.building[i].param.@canBuild=="1")
            {
                dan.buildings[dan.buildings.length - 1].canBuild = true;
            }
            dan.buildings[dan.buildings.length - 1].timeToBuild=myXML.building[i].param.@timeToBuild;
            dan.buildings[dan.buildings.length - 1].maxWorkplace=myXML.building[i].param.@maxWorkplace;

            var obj=myXML.building[i];
            for (var j:int=0; j<obj.globalResNeedToWork.length(); j++)
            {
                dan.buildings[dan.buildings.length-1].globalResNeedToWork.push(String(obj.globalResNeedToWork[j]));
                dan.buildings[dan.buildings.length-1].globalResNeedToWorkCons.push(int(obj.globalResNeedToWork[j].@cons));
                dan.buildings[dan.buildings.length-1].currWorkplace.push(0);
            }
            for (var j:int=0; j<obj.build.length(); j++)
            {
                dan.buildings[dan.buildings.length-1].costToBuild.push(int(obj.build[j].@cost));
                dan.buildings[dan.buildings.length-1].typeOfBuildRes.push(obj.build[j].@res);
            }

            for (var j:int=0; j<obj.notBuildLand.length(); j++)
            {
                dan.buildings[dan.buildings.length-1].notBuildLand.push(new int(obj.notBuildLand[j]));
            }
        }
        /*for (var hh:int=0; hh<dan.buildings.length; hh++)
        {
            trace(hh+"::dan.buildings[hh].baseTyppeOfBuilding="+dan.buildings[hh].baseTyppeOfBuilding);
        }*/

        //осознаём местность
        //("myXML.land.length()="+myXML.land.length());
        for (i=0; i<myXML.land.length(); i++)
        {
            dan.lands.push(new Land());
            dan.lands[dan.lands.length-1].xx=myXML.land[i].@xx;
            dan.lands[dan.lands.length-1].yy=myXML.land[i].@yy;
            dan.lands[dan.lands.length-1].id=myXML.land[i].@id;
            dan.lands[dan.lands.length-1].subID=myXML.land[i].@subID;

            dan.lands[dan.lands.length-1].landID=myXML.land[i].@landID;
            dan.lands[dan.lands.length-1].res=myXML.land[i].@res;
            for (var j:int=0; j<myXML.land[i].elem.length(); j++)
            {
                dan.lands[dan.lands.length-1].elemID.push(myXML.land[i].elem[j].@id);
                dan.lands[dan.lands.length-1].elemPic.push(myXML.land[i].elem[j].@pic);
                dan.lands[dan.lands.length-1].elemIncome.push(myXML.land[i].elem[j].@income);
            }
            //trace("dan.lands[dan.lands.length-1].elemPic.length="+dan.lands[dan.lands.length-1].elemPic.length);
            //trace("myXML.land[i].elem.length()="+myXML.land[i].elem.length());


            //trace("before dan.lands[dan.lands.length-1].elemPic.length="+dan.lands[dan.lands.length-1].elemPic.length);
            //обнаруживаем собственников
            if (myXML.land[i].building.des=="yes")
            {
                dan.lands[dan.lands.length - 1].building.iii = myXML.land[i].building.@iii;
                dan.lands[dan.lands.length - 1].building.baseLandResType = myXML.land[i].@res;
                dan.lands[dan.lands.length - 1].building.baseTyppeOfBuilding=myXML.land[i].building.@typpe;
                dan.lands[dan.lands.length - 1].building.create();
                //trace("after dan.lands[dan.lands.length-1].elemPic.length=" + dan.lands[dan.lands.length - 1].elemPic.length);
            }
            dan.reIncome=true;

            for (var j:int=0; j<myXML.land[i].depends.length(); j++)
            {
                dan.lands[dan.lands.length - 1].depends.push(myXML.land[i].depends[j].@from);
            }
        }
        //trace("dan.lands.length="+dan.lands.length);

        //придумываем проблемы
        for (i=0; i<myXML.problemSituation.length(); i++)
        {
            dan.problemSituation.push(new ProblemSituation());
            dan.problemSituation[dan.problemSituation.length-1].typpe=myXML.problemSituation[i].@typpe;
        }

        //пролоббироваем технологии
        for (i=0; i<myXML.modification.length(); i++)
        {
            dan.updates.push(new Modification());
            dan.updates[dan.updates.length-1].iii=myXML.modification[i].@iii;
            dan.updates[dan.updates.length-1].name=myXML.modification[i].@name;
            dan.updates[dan.updates.length-1].description=myXML.modification[i].@description;
            dan.updates[dan.updates.length-1].isOpened=int(myXML.modification[i].@isOpened);
            dan.updates[dan.updates.length-1].cost=int(myXML.modification[i].@cost);
            dan.updates[dan.updates.length-1].costRes=myXML.modification[i].@res;

            for (var j:int=0; j<myXML.modification[i].needToOpen.length(); j++)
            {
                dan.updates[dan.updates.length-1].needToOpen.push(new int(myXML.modification[i].needToOpen[j].@iii));
            }
            dan.updates[dan.updates.length-1].analyzeOfOpen(dan.updates);

            for (var j:int=0; j<myXML.modification[i].typpe.length(); j++)
            { //смотрим в суть светлого будущего технологий
                dan.updates[dan.updates.length-1].tip.push(new String(myXML.modification[i].typpe[j].@tip));
                dan.updates[dan.updates.length-1].iid.push(new int(myXML.modification[i].typpe[j].@id));
                dan.updates[dan.updates.length-1].res.push(new String(myXML.modification[i].typpe[j].@res));
                dan.updates[dan.updates.length-1].num.push(new int(myXML.modification[i].typpe[j].@num));

                for (var jj:int=0; jj<myXML.modification[i].typpe[j].upd.length(); jj++)
                { //ищем капиталистическую изнанку
                    dan.updates[dan.updates.length-1].upResName.push(new String(myXML.modification[i].typpe[j].upd[jj].@name));
                    dan.updates[dan.updates.length-1].upResNum.push(new int(myXML.modification[i].typpe[j].upd[jj].@num));
                }
            }
            dan.updChange=true;
        }

        //привносим летоисчисление
        var id:int=myXML.timmer.@id;
        var elderDate:int=myXML.timmer.elder.@date;
        var elderLag:int=myXML.timmer.elder.@lag;
        var elderOffText:String=myXML.timmer.elder.@offText;
        var vect:Vector.<String> = null;
        if (myXML.timmer.younger.date.length()>0)
        {
            vect = new Vector.<String>();
            for (i=0; i<myXML.timmer.younger.date.length(); i++)
            {
                vect.push(new String(myXML.timmer.younger.date[i]));
            }
        }
        timmer.creation(id, elderDate, elderLag, elderOffText, vect);

        //читаем имена
        for (i=0; i<myXML.name.length(); i++)
        {
            dan.names.push(new int());
            dan.names[dan.names.length-1]= myXML.name[i].@id;
        }

        //определяем способности героев
        for (i=0; i<myXML.heroRes.length(); i++)
        {
            dan.heroRes.push(new HeroRes());
            dan.heroRes[dan.heroRes.length-1].typpe=myXML.heroRes[i].@typpe;
            dan.heroRes[dan.heroRes.length-1].txt=myXML.heroRes[i].@txt;
        }

        //воспеваем античных героев
        for (i=0; i<myXML.hero.length(); i++)
        {
            dan.availableHeroes.push(new Hero());
            dan.availableHeroes[dan.availableHeroes.length-1].typpe = myXML.hero[i].@typpe;
            dan.availableHeroes[dan.availableHeroes.length-1].iii = myXML.hero[i].@iii;
            dan.availableHeroes[dan.availableHeroes.length-1].txt = myXML.hero[i].@txt;
            dan.availableHeroes[dan.availableHeroes.length-1].n1=myXML.hero[i].@ageMin;
            dan.availableHeroes[dan.availableHeroes.length-1].n2=myXML.hero[i].@ageMax;
            dan.availableHeroes[dan.availableHeroes.length-1].makeAge(myXML.hero[i].@ageMin, myXML.hero[i].@ageMax);
            //<hero typpe="adventurer" iii="1" ageMin="10" ageMax="15"/>
            //dan.availableHeroes[dan.avaWilableHeroes.length-1].makeName(dan.names);
            for (var jj:int=0; jj<myXML.hero[i].need.length(); jj++)
            {
                dan.availableHeroes[dan.availableHeroes.length-1].needTyppe.push(new String(myXML.hero[i].need[jj].@typpe));
                dan.availableHeroes[dan.availableHeroes.length-1].needNum.push(new int(myXML.hero[i].need[jj].@num));
            }
            for (var jj:int=0; jj<myXML.hero[i].heroRes.length(); jj++)
            {
                dan.availableHeroes[dan.availableHeroes.length-1].heroResTyppe.push(new String(myXML.hero[i].heroRes[jj].@typpe));
                dan.availableHeroes[dan.availableHeroes.length-1].heroResMin.push(new int(myXML.hero[i].heroRes[jj].@min));
                dan.availableHeroes[dan.availableHeroes.length-1].heroResMax.push(new int(myXML.hero[i].heroRes[jj].@max));
            }
        }

        //вводим бухгалтерию закреплённых переменных
        for (i=0; i<myXML.params.length(); i++)
        {
            if (String(myXML.params[i].@type)=="heroBuyPanel")
            {
                dan.heroIIIbuyPanel=int(myXML.params[i].@iii);
            }
            if (String(myXML.params[i].@type)=="hero")
            {
                dan.heroIII=int(myXML.params[i].@iii);
            }
            if (String(myXML.params[i].@type)=="cityStart")
            {
                dan.cityStart=int(myXML.params[i].@iii);
            }
            if (String(myXML.params[i].@type)=="playerIII")
            {
                dan.playerIII=int(myXML.params[i].@iii);
            }
            if (String(myXML.params[i].@type)=="cityPanel")
            {
                dan.cityPanel=int(myXML.params[i].@iii);
            }
            if (String(myXML.params[i].@type)=="heroFramNumInCity")
            {
                dan.heroFramNumInCity=int(myXML.params[i].@iii);
            }
            if (String(myXML.params[i].@type)=="maxHeroNum")
            {
                dan.maxHeroNum=int(myXML.params[i].@iii);
            }
            if (String(myXML.params[i].@type)=="maxHeroActionsNum")
            {
                dan.maxHeroActionsNum=int(myXML.params[i].@iii);
            }
            /*if (String(myXML.params[i].@type)=="heroScreenCloseShadow")
            {
                dan.heroScreenCloseShadow=int(myXML.params[i].@iii);
            }*/

        }

        //строим города
        for (i=0; i<myXML.city.length(); i++)
        {
            dan.cities.push(new City());
            dan.cities[dan.cities.length-1].iii=int(myXML.city[i].@iii);
            dan.cities[dan.cities.length-1].name=String(myXML.city[i].@name);
            dan.cities[dan.cities.length-1].sub=int(myXML.city[i].@sub);
            dan.cities[dan.cities.length-1].elem=int(myXML.city[i].@elem);
            for (var jj:int=0; jj<myXML.city[i].peacewar.length(); jj++)
            {
                dan.cities[dan.cities.length-1].peacewarIII.push(new int(myXML.city[i].peacewar[jj].@iii));
                dan.cities[dan.cities.length-1].peacewarRelations.push(new int(myXML.city[i].peacewar[jj].@relation));
                dan.cities[dan.cities.length-1].peacewar.push(new int(myXML.city[i].peacewar[jj].@war));
                dan.cities[dan.cities.length-1].status.push(new int(myXML.city[i].peacewar[jj].@status));
            }
        }

        //вводим статусы взаимоотношений городов
        for (i=0; i<myXML.statu.length(); i++)
        {
            dan.status.push((new Status()));
            dan.status[dan.status.length-1].num=myXML.statu[i].@num;
            dan.status[dan.status.length-1].txt=myXML.statu[i].@txt;
        }

        //воссоздаём торговые связи
        for (i=0; i<myXML.trading.length(); i++)
        {
            dan.tradeTransactions.push(new TradeTransaction());
            dan.tradeTransactions[dan.tradeTransactions.length-1].city1=myXML.trading[i].@city1;
            dan.tradeTransactions[dan.tradeTransactions.length-1].city2=myXML.trading[i].@city2;
            dan.tradeTransactions[dan.tradeTransactions.length-1].isWork=int(myXML.trading[i].@isWork);
            for (var jj:int=0; jj<myXML.trading[i].from1.length(); jj++)
            {
                dan.tradeTransactions[dan.tradeTransactions.length-1].res.push(new String(myXML.trading[i].from1[jj].@res));
                dan.tradeTransactions[dan.tradeTransactions.length-1].cost.push(new String(myXML.trading[i].from1[jj].@cost));
                dan.tradeTransactions[dan.tradeTransactions.length-1].rNum.push(new int(myXML.trading[i].from1[jj].@rNum));
                dan.tradeTransactions[dan.tradeTransactions.length-1].cNum.push(new int(myXML.trading[i].from1[jj].@cNum));
            }
        }

        //делаем остальную торговлю главного героя
        for (i=0; i<dan.cities.length; i++)
        {
            if (dan.cities[i].iii!=dan.heroIII)
            {
                var possible:Boolean=true;
                for (var jj:int=0; jj<dan.tradeTransactions.length; jj++) //ищем, нет ли таких же торговых связей
                {
                    if (dan.tradeTransactions[jj].city1==dan.heroIII && dan.tradeTransactions[jj].city2==dan.cities[i].iii)
                    {
                        possible=false;
                        break;
                    }
                    if (dan.tradeTransactions[jj].city2==dan.heroIII && dan.tradeTransactions[jj].city1==dan.cities[i].iii)
                    {
                        possible=false;
                        break;
                    }
                }
                if (possible) //и если связей не нашли, создаём их
                {
                    dan.tradeTransactions.push(new TradeTransaction());
                    dan.tradeTransactions[dan.tradeTransactions.length-1].city1=dan.playerIII;
                    dan.tradeTransactions[dan.tradeTransactions.length-1].city2=dan.cities[i].iii;
                    dan.tradeTransactions[dan.tradeTransactions.length-1].isWork=0;
                }
            }
        }

        //узнаём торговые курсы
        for (i=0; i<myXML.costFrom1.length(); i++)
        {
            dan.tradeCost.push(new TradeCost());
            dan.tradeCost[dan.tradeCost.length-1].res=myXML.costFrom1[i].@res;
            dan.tradeCost[dan.tradeCost.length-1].cost=myXML.costFrom1[i].@cost;
            dan.tradeCost[dan.tradeCost.length-1].rNum=int(myXML.costFrom1[i].@rNum);
            dan.tradeCost[dan.tradeCost.length-1].cNum=int(myXML.costFrom1[i].@cNum);
        }
       // <costFrom1 res="food" cost="gold" rNum="2" cNum="1"/> <!-- за две меры пищи получим один талант-->

        //оформляем трудоустройство героев
        /*<heroActivity>
            <activity act="city"/>
            <relate txt="614"/>
            <relate txt="$curCityName"/>
        </heroActivity>*/
        for (i=0; i<myXML.heroActivity.length(); i++)
        {
            dan.heroActivities.push(new HeroActivity());
            dan.heroActivities[dan.heroActivities.length-1].act=myXML.heroActivity[i].activity.@act;
            for (var jj:int=0; jj<myXML.heroActivity[i].relate.length(); jj++)
            {
                dan.heroActivities[dan.heroActivities.length-1].txt.push(new String(myXML.heroActivity[i].relate[jj].@txt));
            }
            for (var jj:int=0; jj<myXML.heroActivity[i].cost.length(); jj++)
            {
                dan.heroActivities[dan.heroActivities.length-1].costTyppe.push(new String(myXML.heroActivity[i].cost[jj].@typpe));
                dan.heroActivities[dan.heroActivities.length-1].costNum.push(new int(myXML.heroActivity[i].cost[jj].@num));
            }

        }
        for (i=0; i<dan.heroActivities.length; i++)
        {
            for (var jj:int=0; jj<dan.heroActivities[i].txt.length; jj++)
            {
                trace("act="+dan.heroActivities[i].act+"; txt="+dan.heroActivities[i].txt[j]);
            }
        }
    }

    private function GoRead(quest):void
    {
        //quest.push (new Object());
        for (i=0; i<myXML.mmotion.length(); i++)
        {
            quest.push (new Quest(myXML.mmotion[i]));
        }
        level_go+=Stats.ONE;
    }
}
}