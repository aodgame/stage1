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

    private var cont:int=-1;//переменная проверяет, были ли установлены соотношения правительств/характеров граждан к городам

    private var additionalCityPanel:int=-1; //номер вспомогательной панели города

    public function CityManager()
    {
        bit = Bitte.getInstance();
        dan = Danke.getInstance();
    }

    public function work(sub):void
    {
        if (dan.specCityPanel==-1 && additionalCityPanel!=-1) //чистим переменную, чтобы на дополнительной панели не отображались все города
        {
            additionalCityPanel=-1;
        }
        contentIt();

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
            cityAdditionalPanel(sub);
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

    private function cityAdditionalPanel(sub) //проверяем вспомогательную панель для быстрого перехода между городами
    {
        if (dan.knownCities.length>dan.known) //был добавлен новый город в список
        {
            if (additionalCityPanel==-1) //мы не знаем, где находится предмет со вспомогательной панелью
            {
                for (i = 0; i < sub.length; i++)
                {
                    if (sub[i].iii==dan.specCityPanel)
                    {
                        additionalCityPanel=i;

                        dan.numOfElemsCityPanel=sub[i].numOfEl.length/4; //количество логических блоков - 4
                        break;
                    }
                }
                for (i=0; i<sub[additionalCityPanel].visOne.length; i++)
                {
                    sub[additionalCityPanel].visOne[i]=0;
                    sub[additionalCityPanel].neddFram=true;
                }
            }
            //trace("dan.dxKnown="+dan.dxKnown)
            while (dan.known<dan.knownCities.length)
            {
                sub[additionalCityPanel].subX += dan.dxKnown;
                sub[additionalCityPanel].neddFram=true;
                dan.known++;
            }
            /*trace(" sub[additionalCityPanel].subX="+ sub[additionalCityPanel].subX);
            trace("additionalCityPanel="+additionalCityPanel);
            trace("dan.numOfElemsCityPanel="+dan.numOfElemsCityPanel);
            trace("dan.known="+dan.known);*/
            for (i=0; i<sub[additionalCityPanel].visOne.length; i++)
            {
                if (i>=0 && i<dan.numOfElemsCityPanel && i<dan.known)
                {
                    sub[additionalCityPanel].visOne[i]=1;
                }
                if (i-dan.numOfElemsCityPanel>=0 && i<dan.numOfElemsCityPanel*2 && i-dan.numOfElemsCityPanel<dan.known)
                {
                    sub[additionalCityPanel].visOne[i]=1;
                }
                if (i-dan.numOfElemsCityPanel*2>=0 && i<dan.numOfElemsCityPanel*3 && i-dan.numOfElemsCityPanel*2<dan.known)
                {
                    sub[additionalCityPanel].visOne[i]=1;
                }
                if (i-dan.numOfElemsCityPanel*3>=0 && i<dan.numOfElemsCityPanel*4 && i-dan.numOfElemsCityPanel*3<dan.known)
                {
                    sub[additionalCityPanel].visOne[i]=1;
                }
            }
        }

        if (bit.mouseParClick == dan.cityStart && dan.known>0)
        {
            trace("here in additional panel");
            for (i=0; i<dan.knownCities.length; i++)
            {
                var ii:int=dan.cities[dan.knownCities[i]].iii;
                var rel:int=0;
                for (var j:int=0;j<dan.cities.length; j++)
                {
                    if (dan.cities[j].iii==ii)
                    {
                        sub[additionalCityPanel].fram[dan.numOfElemsCityPanel + i] = dan.cities[j].peacewarRelations[0];
                        break;
                    }
                }
            }
            sub[additionalCityPanel].neddFram=true;
        }
    }

    private function contentIt():void
    {
        if (cont==-1 && dan.characters.length>0 && dan.governments.length>0)
        {
            cont=0;
            for (i=0; i<dan.cities.length; i++)
            {
                for (var j:int=0; j<dan.characters.length; j++)
                {
                    if (dan.cities[i].character==dan.characters[j].fint)
                    {
                        dan.cities[i].characterTxt=dan.characters[j].sint;
                    }
                }
                for (var j:int=0; j<dan.governments.length; j++)
                {
                    if (dan.cities[i].government==dan.governments[j].fint)
                    {
                        dan.cities[i].governmentTxt=dan.governments[j].sint;
                    }
                }
                for (var j:int=0; j<dan.patrons.length; j++)
                {
                    if (dan.cities[i].patron==dan.patrons[j].fint)
                    {
                        dan.cities[i].patronTxt=dan.patrons[j].sint;
                    }
                }
            }
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
                            if (dan.cities[i].peacewarIII[j] == dan.cities[dan.currentCity].iii) //пока не нашли
                            {
                                trace("dan.cities[i].name="+dan.cities[i].name);
                                trace("dan.cities[i].peacewarIII[j]="+dan.cities[i].peacewarIII[j]);
                                trace("dan.cities[i].peacewarRelations[j]="+dan.cities[i].peacewarRelations[j]);
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