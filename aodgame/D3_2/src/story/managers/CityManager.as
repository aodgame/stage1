/**
 * Created by alexo on 07.06.2016.
 */
package story.managers
{
import collections.inWorld.TradeTransaction;
import D3.Bitte;
import story.Danke;

public class CityManager
{
    private var bit:Bitte;
    private var dan:Danke;

    private var cityIDII:int=-1;

    private var heroControl:Boolean=false;
    private var i:int=0;

    private var cityPanelIdii:int=-1;

    public function CityManager()
    {
        bit = Bitte.getInstance();
        dan = Danke.getInstance();
    }

    public function work(sub):void
    {
        if (bit.mouseParClick == dan.cityStart)// город запущен
        {
            if (cityIDII==-1)
            {
                for (i=0; i<sub.length; i++)
                {
                    if (sub[i].iii==dan.cityPanel)
                    {
                        cityIDII=i;
                        break;
                    }
                }
            }
            cityStart(sub);
        }

        if (dan.cityClose) //город закрыт
        {
            trace("city close");
            dan.currentCity=-1;
            dan.cityClose=false;
        }

        cityHeroRelation(sub);

        //trace(dan.currentCity+";"+dan.playerIII+";"+dan.buyOffer+";"+dan.sellOffer);
        if (dan.currentCity!=-1 && dan.playerIII!=-1 && dan.buyOffer!="" && dan.sellOffer!="") //меняем показатель торговли для клиента
        {
            trading(sub);
            dan.buyOffer="";
            dan.sellOffer="";
        }

        if (dan.outI>-1 && dan.heroChoose>0 && dan.cityStart!=-1) //убрать изображение героя с города, если мы убрали ему ответственность о городе
        {
            sub[cityPanelIdii].fram[dan.heroFramNumInCity-1]=1;
            sub[cityPanelIdii].neddFram=true;
        }
    }

    private function cityHeroRelation(sub):void
    {
        if (dan.cityStart!=-1 && bit.dm==1 && dan.heroChoose>=0 && !dan.heroStart) //пытаемся определить, переносят ли героя на город
        {

           // trace("dan.heroChoose="+dan.heroChoose);
            if (!heroControl)
            {
                heroControl = true;
            }
        }
        if (dan.cityStart!=-1 && dan.heroChoose>0 && heroControl && !dan.heroStart)
        {
            if (bit.dm==0 && heroControl) //мышь отпустили, смотрим, в каких координатах
            {
                if (cityPanelIdii==-1 || sub[cityPanelIdii].iii!=dan.cityPanel) //но сначала уточняем, что нам известно положение предмета в векторе
                {
                    for (i=0; i<sub.length; i++)
                    {
                        if (sub[i].iii==dan.cityPanel)
                        {
                            cityPanelIdii=i; //нашли сам предмет
                            break;
                        }
                    }
                }
                for (i=0; i<sub[cityPanelIdii].numOfEl.length; i++) //пробегаем по его элементам
                {
                    var px:int=sub[cityPanelIdii].subX+sub[cityPanelIdii].sx[i];
                    var py:int=sub[cityPanelIdii].subY+sub[cityPanelIdii].sy[i];
                    if (bit.sx>=px && bit.sx<=px+sub[cityPanelIdii].realW[i] && bit.sy>=py && bit.sy<=py+sub[cityPanelIdii].realH[i])
                    {
                        trace("ok dan.currentCity="+dan.currentCity);
                        dan.heroOnTyppe="city";
                        dan.heroOnNum=dan.currentCity;
                        //trace("sub[cityPanelIdii].iii="+sub[cityPanelIdii].iii);
                        //trace("dan.heroFramNumInCity="+dan.heroFramNumInCity);
                        //trace("dan.heroChoose="+dan.heroChoose);
                        sub[cityPanelIdii].fram[dan.heroFramNumInCity-1]=dan.currentHeroes[dan.heroChoose-1].iii+1;
                        //trace(dan.currentHeroes[dan.heroChoose-1].typpe);
                        sub[cityPanelIdii].neddFram=true;
                        //trace("dan.heroOnNum="+dan.heroOnNum);

                    }
                }

                if (dan.currentCity==-1)
                {
                    dan.heroOnTyppe="";
                }

                heroControl=false;
            }
        }
    }

    private function cityStart(sub):void
    {
        //trace("time to City");
        for (var z:int=0; z<dan.cities.length; z++)
        {
            //trace("dan.numOfMany="+dan.numOfMany);
            if (dan.cities[z].sub==bit.mouseParClick && dan.cities[z].elem==dan.numOfMany)
            {
                dan.currentCity=z;
                trace("dan.currentCity will be = "+ dan.currentCity);
                //trace("dan.currentCity="+dan.currentCity);

                //ищем город текущего игрока
                for (var i:int=0; i<dan.cities.length; i++)
                {
                    if (dan.cities[i].iii==dan.playerIII) //нашли
                    {
                        for (var j:int=0; j<dan.cities[i].peacewarIII.length; j++) //проходим по отношениям этого города
                        {
                            if (dan.cities[i].peacewarIII[j]== dan.cities[dan.currentCity].iii) //пока не нашли
                            {
                                dan.currPeaceWar = dan.cities[i].peacewar[j]; //устанавливаем, мир между ними или война
                                dan.currRelations=dan.cities[i].peacewarRelations[j]; //а также уровень отношений
                            }
                        }
                        break;
                    }
                }

                //ищем нашего героя, ответственного за город
                var f:int=0;
                for (var i:int=0; i<dan.currentHeroes.length; i++)
                {
                    for (var j:int=0; j<dan.currentHeroes[i].needTyppe.length; j++)
                    {
                        if (dan.currentHeroes[i].needTyppe[j]=="city" && dan.currentHeroes[i].needNum[j]==dan.currentCity)
                        {
                            sub[cityIDII].fram[dan.heroFramNumInCity-1]=dan.currentHeroes[i].iii+1;
                            sub[cityIDII].neddFram=true;
                            f=1;
                            break;
                        }
                    }
                }
                if (f==0)
                {
                    //trace("cityIDII="+cityIDII);
                    //trace(sub[cityIDII].iii);
                    //trace("sub[cityIDII].fram.length="+sub[cityIDII].fram.length);
                    //trace("dan.heroFramNumInCity="+dan.heroFramNumInCity);
                    sub[cityIDII].fram[dan.heroFramNumInCity-1]=1;
                    sub[cityIDII].neddFram=true;
                }

                break;
            }
        }
    }

    private function trading(sub):void
    {
        trace("innnn");
        //dan.cities[dan.currentCity].iii
        //dan.playerIII
        var transactionNum:int=-1;
        var hero:int=-1;
        var unhero:int=-1;

        for (i=0; i<dan.tradeTransactions.length; i++) //находим транзакцию игрока-клиента
        {
            if (dan.tradeTransactions[i].city1==dan.cities[dan.currentCity].iii && dan.tradeTransactions[i].city2==dan.playerIII)
            {
                transactionNum=i;
                hero=1;
                unhero=0;
                break;
            }
            if (dan.tradeTransactions[i].city2==dan.cities[dan.currentCity].iii && dan.tradeTransactions[i].city1==dan.playerIII)
            {
                transactionNum=i;
                hero=0;
                unhero=1;
                break;
            }
        }
        var transaction:TradeTransaction = dan.tradeTransactions[transactionNum];
        var itNum:int=-1;

        var mod:int=1;
        for (i=0; i<transaction.res.length; i++)//теперь ищем, а были ли установлены торговые отношения по нужным товарам
        {
            if (transaction.res[i]==dan.buyOffer && transaction.cost[i]==dan.sellOffer) //всё нормальнО, покупка продолжается
            {
                itNum=i;
            }
            if (transaction.res[i]==dan.sellOffer && transaction.cost[i]==dan.buyOffer) //требуется уменьшить объём покупки
            {
                itNum=i;
                if (transaction.cNum[itNum]==0 && transaction.rNum[itNum]==0)
                {
                    transaction.res[i]=dan.buyOffer;
                    transaction.cost[i]=dan.sellOffer;
                } else
                {
                    mod = -1;
                }
            }
        }
        if (itNum == -1) //если не были, то создаём торговые отношения
        {
            transaction.res.push(dan.buyOffer);
            transaction.cost.push(dan.sellOffer);
            transaction.rNum.push(0);
            transaction.cNum.push(0);
            itNum=transaction.res.length-1;
        }
        //теперь рассчитываем новое значение согласно имеющимся курсам
        var resI:int=-1;
        var costI:int=-1;
        //учитываем курсы и сначала проверяем на уменьшение

        if (mod<0)
        {
            for (i = 0; i < dan.tradeCost.length; i++)
            {
                if (dan.tradeCost[i].cost == transaction.cost[itNum] && dan.tradeCost[i].res == transaction.res[itNum])
                {
                    resI = i;
                }
            }
            if (resI != -1)
            {
                transaction.rNum[itNum] -= dan.tradeCost[resI].rNum;
                transaction.cNum[itNum] -= dan.tradeCost[resI].cNum;
            }
            if (transaction.cNum[itNum]<=0 || transaction.rNum[itNum]<=0)
            {
                transaction.cNum[itNum] = 0;
                transaction.rNum[itNum] = 0;
                var temp:String = transaction.cost[itNum];
                transaction.cost[itNum] = transaction.res[itNum];
                transaction.res[itNum] = temp;
            }
        } else
        {
            for (i = 0; i < dan.tradeCost.length; i++)
            {
                if (dan.tradeCost[i].res == transaction.res[itNum] && dan.tradeCost[i].cost == transaction.cost[itNum])
                {
                    resI = i;
                }
            }
            if (resI != -1)
            {
                transaction.rNum[itNum] += dan.tradeCost[resI].rNum;
                transaction.cNum[itNum] += dan.tradeCost[resI].cNum;
            }
        }

        trace("Trades:");
        for (i=0; i<dan.tradeTransactions.length; i++)
        {
            if ((dan.tradeTransactions[i].city1==dan.playerIII || dan.tradeTransactions[i].city2==dan.playerIII) && dan.tradeTransactions[i].cNum.length>0)
            {
                trace("i=" + i + "; city1=" + dan.tradeTransactions[i].city1 + "; city2=" + dan.tradeTransactions[i].city2);
                for (var j:int = 0; j < dan.tradeTransactions[i].res.length; j++)
                {
                    trace(dan.tradeTransactions[i].res[j] + ": " + dan.tradeTransactions[i].cost[j] + "; " + dan.tradeTransactions[i].rNum[j] + "; " + dan.tradeTransactions[i].cNum[j]);
                }
            }
        }
    }
}
}