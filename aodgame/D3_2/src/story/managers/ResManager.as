/**
 * Created by alexo on 29.04.2016.
 */
package story.managers
{
import collections.common.Hero;
import collections.inCity.Building;

import story.*;
import collections.inCity.Land;
import D3.Bitte;

public class ResManager
{
    private var bit:Bitte;
    private var dan:Danke;
    private var i:int;

    //public var lag:int=10;

    public function ResManager()
    {
        bit = Bitte.getInstance();
        dan = Danke.getInstance();
        i=0;
    }

    public function work():void
    {
        if (dan.lag>0)
        {
            dan.lag--;
            dan.globalResChange=true;
            dan.reIncome=true;
        }
        if (dan.reIncome) //пересчитываем доходы игрока
        {
            dan.reIncome=false;
            reIncome();
            reFreeAmount();
        }

        if (dan.globalResChange)// || dan.localResChange)
        {
            globalResChange();
            dan.globalResChange=false;
        }

        if (bit.sChangeTurn)
        {
            reResource();
            reTrade();
        }

        decreaseWorkerDel(); //проверяем, всё ли в порядке на рабочих местах
    }

    private function decreaseWorkerDel(): void //если рабочих становится меньше, чем возможно
    {
        for (i=0; i<dan.globalRes.length; i++)
        {
            while (dan.globalRes[i].freeAmount > dan.globalRes[i].amount) //заодно правим, если кажется, что свободных рабочих больше, чем их в реальности есть
            {
                dan.globalRes[i].freeAmount--;
            }

            if (dan.globalRes[i].freeAmount < dan.globalRes[i].min) //надо убрать одного из работников с земли
            {
                for (var k:int = 0; k < dan.lands.length; k++)
                {
                    var build:Building = dan.lands[k].building;
                    for (var zz:int = 0; zz < build.currWorkersOnPlace.length; zz++)
                    {
                        if (build.currWorkersOnPlace[zz] < 1)
                        {
                            continue;
                        }
                        var tmp:int=-1;
                        for (var ch:int=0; ch<build.globalResNeedToWork.length; ch++)
                        {
                            if (build.globalResNeedToWorkCons[ch]==build.currWorkersOnPlace[zz] - 1)
                            {
                                tmp=ch;
                                break;
                            }
                        }
                        if (build.globalResNeedToWork[tmp] == dan.globalRes[i].typpe && dan.globalRes[i].freeAmount<dan.globalRes[i].min)
                        {
                            build.currWorkersOnPlace[zz] = 0;

                            for (var chi=0;chi<build.currWorkplace.length; chi++)
                            {
                                if (build.globalResNeedToWork[chi] == dan.globalRes[i].typpe) //проверяем, нужен ли нам именно текущий ресурс
                                {
                                    build.currWorkplace[chi]--;
                                }
                            }
                            dan.lands[k].currentNumOfWorkers--;
                            dan.lands[k].changePics(2);
                            dan.globalRes[i].freeAmount++;
                        }
                    }
                }
            }
        }
    }

    private function globalResChange():void
    {
        var k:int=0;
        //trace("res_need");
        for (k=0; k<dan.globalRes.length; k++)
        {
            dan.globalRes[k].needAmount=0;
            dan.globalRes[rr].presenceAmount=0;
        }

        for (k=0; k<dan.globalRes.length; k++)
        {
            if (dan.globalRes[k].need=="need") //нашли нужду в расчёте ресурса
            {
                for (var ll:int=0; ll<dan.globalRes[k].paramsOfNeed.length; ll+=4)
                {
                    for (var rr:int=0; rr<dan.globalRes.length; rr++)
                    {
                        if (dan.globalRes[rr].typpe==dan.globalRes[k].paramsOfNeed[ll+2]) //нашли тип ресурса, который нужен
                        {
                            /*if (dan.globalRes[k].paramsOfNeed[ll+3]=="presence") //если требуется учесть ресурс
                            {
                                dan.globalRes[rr].presenceAmount += dan.globalRes[k].amount /
                                int(dan.globalRes[k].paramsOfNeed[ll]) *
                                int(dan.globalRes[k].paramsOfNeed[ll + 1]);
                                trace("dan.globalRes[rr].typpe="+dan.globalRes[rr].typpe+"; dan.globalRes[rr].presenceAmount="+dan.globalRes[rr].presenceAmount);
                            }*/
                            if (dan.globalRes[k].paramsOfNeed[ll+3]=="decrease") //если требуется вычесть ресурс
                            {
                                dan.globalRes[rr].needAmount += dan.globalRes[k].amount /
                                int(dan.globalRes[k].paramsOfNeed[ll]) *
                                int(dan.globalRes[k].paramsOfNeed[ll + 1]);
                            }
                            break;
                        }
                    }
                }
            }
            if (dan.globalRes[k].need=="owner") //нашли нужду в расчёте ресурса
            {
                dan.globalRes[k].presenceAmount=0;
                for (i=0; i<dan.lands.length; i++)
                {
                    for (var j:int=0; j<dan.lands[i].elemTyppe.length; j++)
                    {
                        if (dan.lands[i].elemTyppe[j] == dan.globalRes[k].typpe)
                        {
                            dan.globalRes[k].presenceAmount+=dan.lands[i].elemIncome[j];
                            //trace("dan.globalRes[k].typpe="+dan.globalRes[k].typpe+"; dan.globalRes[k].presenceAmount="+dan.globalRes[k].presenceAmount);
                        }
                    }
                }
            }
        }
    }

    private function resourseVSresource(globalRes)
    {
        for (i=0; i<dan.globalRes.length; i++)
        {
            if (dan.globalRes[i].amount+globalRes[i]>0) //здесь проверяем, можно ли рассчитать данный ресурс
            {
                dan.globalRes[i].amount += globalRes[i];
                globalRes[i]=0;
            } else //и если нет, пробуем рассчитать хотя бы часть
            {
                while (dan.globalRes[i].amount>0)
                {
                    dan.globalRes[i].amount-=1;
                    globalRes[i]+=1;
                }
            }
        }
    }

    private function reTrade():void //обозначаем торговлю
    {
        trace("reTrade=1");
        var resUse:Vector.<int> = new Vector.<int>();

        var cityActNum:int=-1;
        //уточняем номер активности типа город
        for (var k:int=0; k<dan.heroActivities.length; k++)
        {
            if (dan.heroActivities[k].act=="city")
            {
                cityActNum=k;
                break;
            }
        }

        for (i=0; i<dan.currentHeroes.length; i++) //проходим по каждому герою
        {
            var hero:Hero = dan.currentHeroes[i];
            //trace("hero i="+i);

            resUse = new Vector.<int>();
            for(var k:int=0; k<dan.heroRes.length; k++)
            {
                resUse.push(hero.heroResMax[k]);
            }

            for (var j:int=0; j<hero.needTyppe.length; j++)//проходим по каждой активности каждого героя
            {
                var curActivity:int=0;
                //и вначале делаем подсчёт очков, необходимых на эти активности
                for (var k:int=0; k<dan.heroActivities.length; k++) //для этого находим связь каждой из активностей героя со списком активностей
                {
                    if (hero.needTyppe[j]==dan.heroActivities[k].act)
                    {
                        curActivity=k;
                        break;
                    }
                }
                for (var k:int=0; k<dan.heroActivities[curActivity].costTyppe.length; k++) //и подсчитываем, сколько очков игрок уже потратил бы, дойдя до этой активности
                {
                    for (var n:int=0; n<dan.heroRes.length; n++)
                    {
                        if (dan.heroActivities[curActivity].costTyppe[k]==dan.heroRes[n].typpe)
                        {
                            resUse[n]-=dan.heroActivities[curActivity].costNum[k];
                            break;
                        }
                    }
                }
                if (hero.needTyppe[j]=="city") //теперь просчитываем торговлю
                {
                    //trace("hero city");
                    var enought:Boolean=true;
                    for (var k:int=0; k<dan.heroActivities[curActivity].costTyppe.length; k++) //уточняем, хватает ли нам запаса ресурсов на эту активность
                    {
                        for (var n:int=0; n<dan.heroRes.length; n++)
                        {
                            if (dan.heroActivities[curActivity].costTyppe[k]==dan.heroRes[n].typpe && resUse[n]<0)
                            {
                                enought=false;
                                break;
                            }
                        }
                    }
                    if (!enought) //ресурсов героя не хватает, уходим к следующему герою
                    {
                        break;
                    }

                    var youhero:int=-1;
                    var unhero:int=-1;
                    var transNum:int=-1;
                    //trace("curNum of hero="+dan.heroActivities[curActivity].act);
                    //trace(">>"+hero.needTyppe[j]+":"+hero.needNum[j]);
                    //ресурсов героя хватает, начинаем просчёт торговли
                    for (var k:int=0; k<dan.tradeTransactions.length; k++)
                    {
                        if (dan.tradeTransactions[k].city1==hero.needNum[j] && dan.tradeTransactions[k].city2==dan.playerIII)
                        {
                            youhero=1;
                            unhero=0;
                            transNum=k+1;
                            break;
                        }
                        if (dan.tradeTransactions[k].city2==hero.needNum[j] && dan.tradeTransactions[k].city1==dan.playerIII)
                        {
                            youhero=0;
                            unhero=1;
                            transNum=k+1;
                            break;
                        }
                    }

                    //trace("transNum="+transNum);
                    //trace("dan.tradeTransactions[transNum].res.length="+dan.tradeTransactions[transNum].res.length);
                    //trace("dan.tradeTransactions[transNum].cost.length="+dan.tradeTransactions[transNum].cost.length);
                    for (var t:int=0; t<dan.tradeTransactions.length; t++)
                    {
                        //trace("t="+t+"; res.length="+dan.tradeTransactions[t].res.length+"::"+dan.tradeTransactions[t].cost.length);
                    }
                    for (var t:int=0; t<dan.globalRes.length; t++)
                    {
                        dan.globalRes[t].littleInt=dan.globalRes[t].amount;
                        if (dan.globalRes[t].amount<0)
                        {
                            dan.globalRes[t].littleInt=0;
                        }
                    }

                    //проверяем, а хватит ли ресурсов для сделки
                    enought=true;

                    for (var k:int=0; k<dan.tradeTransactions[transNum].res.length; k++)
                    {
                        var resTyppe:String="";
                        var resNum:int=0;

                        var costTyppe:String="";
                        var costNum:int=0;
                        //trace("res="+dan.tradeTransactions[transNum].res[k]+"; cost:"+dan.tradeTransactions[transNum].cost[k]);
                        //trace("rNum="+dan.tradeTransactions[transNum].rNum[k]+"; cNum="+dan.tradeTransactions[transNum].cNum[k]);
                        resTyppe=dan.tradeTransactions[transNum].res[k];
                        resNum=dan.tradeTransactions[transNum].cNum[k];
                        costTyppe=dan.tradeTransactions[transNum].cost[k];
                        costNum=dan.tradeTransactions[transNum].rNum[k];

                        for (var t:int=0; t<dan.globalRes.length; t++)
                        {
                            if (dan.globalRes[t].typpe==resTyppe)
                            {
                                //trace("before minus: dan.globalRes[t].littleInt="+dan.globalRes[t].littleInt+"("+dan.globalRes[t].typpe);
                                dan.globalRes[t].littleInt+=resNum;
                                //trace("minus: dan.globalRes[t].littleInt="+dan.globalRes[t].littleInt+"("+dan.globalRes[t].typpe)
                            }
                            if (dan.globalRes[t].typpe==costTyppe)
                            {
                                //trace("before plus: dan.globalRes[t].littleInt="+dan.globalRes[t].littleInt+"("+dan.globalRes[t].typpe);
                                dan.globalRes[t].littleInt-=costNum;
                                //trace("plus: dan.globalRes[t].littleInt="+dan.globalRes[t].littleInt+"("+dan.globalRes[t].typpe);
                            }
                        }
                    }
                    for (var t:int=0; t<dan.globalRes.length; t++) //определяем, будет ли после всех подсчётов ресурсов достаточно для сделки
                    {
                        if (dan.globalRes[t].littleInt<0)
                        {
                            //trace("typpe="+dan.globalRes[t].typpe+"::"+dan.globalRes[t].littleInt);
                            enought=false;
                            break;
                        }
                    }
                    if (enought)
                    {
                        for (var t:int=0; t<dan.globalRes.length; t++)
                        {
                            //trace(dan.globalRes[t].typpe+"::"+dan.globalRes[t].amount+"<"+dan.globalRes[t].littleInt);
                            dan.globalRes[t].amount=dan.globalRes[t].littleInt;
                        }
                    }
                }
            }
        }
    }

    private function reResource():void
    {
        //До и после расчёта ресурсов земель рассчитываем ресурсы, потребляемые другими ресурсами
        var globalRes:Vector.<int> = new Vector.<int>();
        for (i=0; i<dan.globalRes.length; i++)
        {
            globalRes.push(dan.globalRes[i].needAmount);
        }
        resourseVSresource(globalRes);

        //рассчитываем ресурсы, получаемые/необходимые для земель
        var numsOfLands:Vector.<int> = new Vector.<int>();
        for (i=0; i<dan.lands.length; i++)
        {
            numsOfLands.push(i);
        }
        var j:int=0;
        var k:int=0;
        var reCycle:Boolean=true;
        while(reCycle && numsOfLands.length>0)
        {
            i=0;
            reCycle=false;
            while (i<numsOfLands.length) //проходим по оставшимся номерам земли
            {                //сначала проверим, возможно ли вообще использование этой земли
                var land:Land = dan.lands[numsOfLands[i]];
                var possible:Boolean=true;
                if (land.currentNumOfWorkers <= 0 || !land.building.canWork)
                {
                    possible = false;
                    i++;
                    continue;
                }

                for (j=0; j<land.elemTyppe.length; j++) //проходим по имеющимся ресурсам
                {
                    for (k=0; k<dan.globalRes.length; k++)
                    {
                        if (dan.globalRes[k].typpe==land.elemTyppe[j])
                        {
                            if (land.elemIncome[j] == 0 ||
                                     dan.globalRes[k].min > dan.globalRes[k].amount + land.elemIncome[j])
                            { //и если при сложении получим отрицательный результат
                                possible = false;
                                break;
                            }
                        }
                    }
                    if (!possible)
                    {
                        break;
                    }
                }
                if (possible) //складываем только при положительном результате
                {
                    reCycle=true;
                    for (j=0; j<land.elemTyppe.length; j++) //проходим по имеющимся ресурсам
                    {

                        for (k = 0; k < dan.globalRes.length; k++)
                        {
                            if (dan.globalRes[k].typpe == land.elemTyppe[j] && land.elemIncome[j]!=0)
                            {
                                dan.globalRes[k].amount += land.elemIncome[j];
                                break;
                            }
                        }
                    }
                    numsOfLands.splice(i,1);
                    i--;
                }
                i++;
                trace("numsOfLands.length="+numsOfLands.length);
            }
        }

        resourseVSresource(globalRes);

        for (i=0; i<globalRes.length; i++)
        {
            if (globalRes[i]<0)
            {
                dan.globalRes[i].presenceAmount=globalRes[i]*(-1); //сохраняем задолженность по ресурсам за предыдущий ход
            }
        }

        //здесь рассчитываем возможность роста ресурса по шкале income="grow"
        growingNeedRes();

        /*for (i=0; i<dan.globalRes.length; i++)
        {
            dan.globalRes[i].amount+=dan.globalRes[i].income;
        }*/
    }

    private function growingNeedRes():void
    {
        for (i=0; i<dan.globalRes.length; i++)
        {
            //trace("dan.globalRes[i].typpe="+dan.globalRes[i].typpe);
            if (dan.globalRes[i].need=="need")
            {
                //trace("here="+dan.globalRes[i].paramsOfNeed.length);
                var res:int=0;
                var sum:int=0;
                for (var j:int=3; j<dan.globalRes[i].paramsOfNeed.length; j+=4)
                {
                    //trace("===dan.globalRes[i].paramsOfNeed[j]="+dan.globalRes[i].paramsOfNeed[j]);
                    if (dan.globalRes[i].paramsOfNeed[j]=="grow") //нашли ресурс, который нужен для роста
                    {
                        sum++;
                        res +=  makeGrow(dan.globalRes[i].paramsOfNeed[j-1], int(dan.globalRes[i].paramsOfNeed[j-3]), int(dan.globalRes[i].paramsOfNeed[j-2]), dan.globalRes[i].amount);
                    }
                    if (dan.globalRes[i].paramsOfNeed[j]=="wane") //нашли ресурс, по которому у нас может быть задолженность
                    {
                        for (var z:int=0; z<dan.globalRes.length; z++)
                        {
                            if (dan.globalRes[z].typpe==dan.globalRes[i].paramsOfNeed[j-1]) //нашли тип должника
                            {
                                while (dan.globalRes[z].presenceAmount>0 && dan.globalRes[i].amount>dan.globalRes[i].min)  //и пока у него есть долг или пока есть с кого этот долг требовать
                                {
                                    dan.globalRes[z].presenceAmount-=int(dan.globalRes[i].paramsOfNeed[j-3]); //уменьшаем долг согласно установленной таксе
                                    if (dan.globalRes[i].amount > dan.globalRes[i].min) //снижаем число ресурса, с которым не рассчитался должник
                                    {
                                        dan.globalRes[i].amount--;
                                    }
                                }
                                break;
                            }
                        }
                        dan.reIncome=true;
                        dan.lag=10;
                    }
                    if (dan.globalRes[i].paramsOfNeed[j]=="control") //определяет макс значение за каждую единицу плюс рост за ход
                    {
                        trace("Res typpe="+dan.globalRes[i].paramsOfNeed[j-1]);
                        for (var z:int=0; z<dan.globalRes.length; z++)
                        {
                            if (dan.globalRes[i].paramsOfNeed[j-1] == dan.globalRes[z].typpe) //нашли тип должника
                            {
                                trace("equal type="+dan.globalRes[z].typpe);
                                //перерасчитываем максимальное возможное значение
                                dan.globalRes[i].max=dan.globalRes[z].amount*int(dan.globalRes[i].paramsOfNeed[j - 3]);
                                //и даём доход за ход
                                dan.globalRes[i].amount+=int(dan.globalRes[z].amount*Number(dan.globalRes[i].paramsOfNeed[j - 2]));
                                if (dan.globalRes[i].amount>dan.globalRes[i].max)
                                {
                                    dan.globalRes[i].amount=dan.globalRes[i].max;
                                }
                                break;
                            }
                        }
                    }
                }
                if (res==sum && sum!=0)
                {
                    //trace("true");
                    if (dan.globalRes[i].amount*0.2<1)
                    {
                        dan.globalRes[i].amount++;
                    } else
                    {
                        dan.globalRes[i].amount += dan.globalRes[i].amount * 0.2;
                    }
                    dan.globalRes[i].freeAmount++;
                    dan.reIncome=true;
                    dan.lag=10;
                }
            }

            if (dan.globalRes[i].need=="filler") //высчитываем изменение ресурса
            {    //<need every="1" need="-1" from="human" income="house"/>
                for (var t:int=0; t<dan.globalRes[i].paramsOfNeed.length; t+=4)
                {
                    var from:int = -1;
                    var income:int = -1;
                    for (var j:int = 0; j < dan.globalRes.length; j++)
                    {
                        //trace("j="+j+"; i="+i+"; dan.globalRes[i].paramsOfNeed.length="+dan.globalRes[i].paramsOfNeed.length+"; t="+t);
                        if (dan.globalRes[j].typpe == dan.globalRes[i].paramsOfNeed[t+2])
                        {
                            //trace("from :: dan.globalRes[j].typpe="+dan.globalRes[j].typpe);
                            from=j;
                        }
                        if (dan.globalRes[j].typpe == dan.globalRes[i].paramsOfNeed[t+3])
                        {
                            //trace("income :: dan.globalRes[j].typpe="+dan.globalRes[j].typpe);
                            income=j;
                        }
                    }
                    var amUp:int=-1;
                    var umDown:int=-1;
                    if (dan.globalRes[from].need=="owner")
                    {
                        amUp=dan.globalRes[from].presenceAmount;
                    } else
                    {
                        amUp=dan.globalRes[from].amount;
                    }
                    if (dan.globalRes[income].need=="owner")
                    {
                        umDown=dan.globalRes[income].presenceAmount;
                    } else
                    {
                        umDown=dan.globalRes[income].amount;
                    }

                    if (amUp==0) //общаться не с кем, так что и менять ничего не надо
                    {
                        return;
                    }
                    //trace("dan.globalRes[from].amount="+amUp);
                    //trace("dan.globalRes[income].amount="+umDown);
                    //trace(Number(amUp/umDown)+":::"+int(dan.globalRes[i].paramsOfNeed[t]));
                    if ((int(dan.globalRes[i].paramsOfNeed[t+1])<0 && Number(amUp/umDown)>int(dan.globalRes[i].paramsOfNeed[t])) ||
                            (int(dan.globalRes[i].paramsOfNeed[t+1])==0 && umDown<=0))
                    {
                        if (dan.globalRes[i].amount>dan.globalRes[i].min)
                        {
                            dan.globalRes[i].amount--;
                        }
                        if (dan.globalRes[i].presenceAmount>dan.globalRes[i].min)
                        {
                            dan.globalRes[i].presenceAmount--;
                        }
                       // trace("minus="+dan.globalRes[i].typpe);
                    }
                }
            }
        }
        for (i=0; i<dan.globalRes.length; i++) //зачищаем долги
        {
            if (dan.globalRes[i].need=="0" && dan.globalRes[i].freeAmount!=0)
            {
                dan.globalRes[i].freeAmount=0;
            }
        }
    }

    public function laggy(num):void
    {
        dan.lag=num;
    }

    private function makeGrow(needRes, who, howMatch, whoAmount):int
    {
        var res:int=0;

        for (var z:int=0; z<dan.globalRes.length; z++)
        {
            //trace("dan.globalRes[z].typpe="+dan.globalRes[z].typpe+"; needRes="+needRes);
            if (dan.globalRes[z].typpe==needRes)
            {
                if ((dan.globalRes[z].need=="need" || dan.globalRes[z].need=="0") && dan.globalRes[z].amount>=howMatch)
                {
                    res=1;
                    break;
                }
                if (dan.globalRes[z].need=="owner" && dan.globalRes[z].presenceAmount>howMatch*whoAmount)
                {
                    res=1;
                    break;
                }
            }
        }
        return res;
    }

    private function reFreeAmount():void
    {
        for (i=0; i<dan.globalRes.length; i++)
        {
            dan.globalRes[i].freeAmount=dan.globalRes[i].amount;
        }

        for (i = 0; i < dan.lands.length; i++)
        {
            for (var j:int=0; j<dan.lands[i].building.globalResNeedToWork.length; j++)
            {
                for (var k:int=0; k<dan.globalRes.length; k++)
                {
                    if (dan.globalRes[k].typpe==dan.lands[i].building.globalResNeedToWork[j])
                    {
                        dan.globalRes[k].freeAmount-=dan.lands[i].building.currWorkplace[j];
                        break;
                    }
                }
            }
        }
    }

    private function reIncome():void
    {
        for (i=0; i<dan.globalRes.length; i++)
        {
            dan.globalRes[i].income=0;
        }

        for(i=0; i<dan.lands.length; i++)
        {
            var j:int=0;
            var landRes:String=dan.lands[i].building.landResType;
            var numOfWorkers:int=0;

            var globalResTyppe:Vector.<String> = new Vector.<String>();
            var globalResIncome:Vector.<int> = new Vector.<int>();

            while (j<dan.lands[i].building.currWorkersOnPlace.length)
            {
                if (dan.lands[i].building.currWorkersOnPlace[j]>0)
                {
                    numOfWorkers++;
                }
                j++;
            }

            for (var k:int=0; k<dan.landRes.length; k++)
            {
                if (dan.landRes[k].typpe==landRes)
                {
                    for (j=0;j<dan.landRes[k].globalResTyppe.length; j++)
                    {
                        globalResTyppe.push(dan.landRes[k].globalResTyppe[j]);
                        //globalResIncome.push(dan.landRes[k].globalResIncome[j]);
                    }
                    break;
                }
            }

            for (var k:int=0; k<dan.globalRes.length; k++)
            {
                for (var l:int=0; l<globalResTyppe.length; l++)
                {
                    if (dan.globalRes[k].typpe == globalResTyppe[l] && numOfWorkers>0)
                    {
                        dan.globalRes[k].income+=dan.lands[i].elemIncome[l];//numOfWorkers*globalResIncome[l];
                        break;
                    }
                }
            }
        }

        for (var k:int=0; k<dan.globalRes.length; k++)
        {
            dan.globalRes[k].income+=dan.globalRes[k].needAmount;
        }
    }
}
}