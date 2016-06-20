/**
 * Created by alexo on 03.06.2016.
 */
package story.managers
{
import collections.common.Hero;
import collections.inWorld.TradeTransaction;

import D3.Bitte;
import story.Danke;

public class TextManager
{
    private var bit:Bitte;
    private var dan:Danke;

    private var i:int;

    public function TextManager()
    {
        bit = Bitte.getInstance();
        dan = Danke.getInstance();
        i=0;
    }

    public function work(el)
    {
        for (i=0; i<el.length; i++)
        {
            if (el[i].typeOfElement=="txt")
            {
                texter(el[i], i);
            }
        }
    }

    private function simpleChoiser(el, j):int
    {
        for (var k:int=0; k<bit.texto[j].mode.length; k++)
        {
            if (bit.textMode==bit.texto[j].mode[k] && el.txt!=bit.texto[j].txt[k])
            {
                el.txt=bit.texto[j].txt[k];
                el.pic.text=bit.texto[j].txt[k];
                //kd++;
                return 1;
            }
        }
        return 0;
    }

    private function harderChoiser(el, j):String
    {
        for (var k:int=0; k<bit.texto[j].mode.length; k++)
        {
            if (bit.textMode==bit.texto[j].mode[k])
            {
                return bit.texto[j].txt[k];
            }
        }
        return "";
    }

    private function texter(el, num):void
    {
        var kd:int=0;

        if (el.tid.substr(0,4)=="#mov" && el.tid.substr(5,4)=="hero" && dan.heroChoose>0)
        {
            var hr:int=int(el.tid.substr(9,1))-1;
            el.txt="";
            var hero:Hero = dan.currentHeroes[dan.heroChoose-1];
            if (hero.needTyppe.length>hr)
            {
                for (var j:int = 0; j < dan.heroActivities.length; j++)
                {
                    if (dan.heroActivities[j].act == hero.needTyppe[hr])
                    {
                        for (var k:int = 0; k < dan.heroActivities[j].txt.length; k++)
                        {
                            //trace("dan.heroActivities[j].txt[k]="+dan.heroActivities[j].txt[k]);
                            if (dan.heroActivities[j].txt[k] == "$curCityName") //имя города
                            {
                                //trace("!");
                                for (var m:int = 0; m < bit.texto.length; m++)
                                {
                                    if (int(hero.needNum[hr])>=0 && int(dan.cities[hero.needNum[hr]].name) == bit.texto[m].tid)
                                    {
                                        el.txt += harderChoiser(el, m)+" ";
                                        //trace("111="+el.txt);
                                        break;
                                    }
                                }
                            }

                            if (dan.heroActivities[j].txt[k].substr(0, 1)!="$")
                            {
                                //trace("?");
                                for (var m:int = 0; m < bit.texto.length; m++)
                                {
                                    if (int(dan.heroActivities[j].txt[k]) == bit.texto[m].tid)
                                    {
                                        el.txt += harderChoiser(el, m)+" ";
                                        //trace("111="+el.txt);
                                        kd++;
                                        break;
                                    }
                                }
                            }
                        }
                        /*if (el.pic.text != el.txt)
                        {
                            el.pic.text = el.txt;
                        }*/
                        break;
                    }
                }
            }
            if (el.pic.text != el.txt)
            {
                el.pic.text = el.txt;
                return;
            }
        }

        if (el.tid=="$timer" && el.txt!=String(bit.sTimmer))
        {
            el.txt=bit.sTimmer;
            el.pic.text=bit.sTimmer;
            kd++;
        }

        if (el.tid.length>4 && el.tid.substr(0, 4) == "$res") //основной ресурс
        {
            var v:int = 0;
            var d:int=4;
            while(d<el.tid.length)
            {
                v = v*10 + int(el.tid.charAt(d));
                d++;
            }
            if (el.txt != String(dan.globalRes[v].amount))
            {
                el.txt = dan.globalRes[v].amount;
                el.pic.text=el.txt;
                kd++;
            }
        }

        if (dan.heroChoose>0 && el.tid.length>6 && el.tid.substr(0, 6) == "$hAbil") //скилы игрока
        {
            var v:int=int(el.tid.substr(6, 1));
            el.txt = dan.currentHeroes[dan.heroChoose-1].heroResMax[v-1];
            //trace("v="+v+"; $hAbil="+el.txt);
            if (el.pic.text!=el.txt)
            {
                el.pic.text=el.txt;
                kd++;
            }
        }

        //$hSum1
        if (dan.heroChoose>0 && el.tid.length>5 && el.tid.substr(0, 5) == "$hSum") //скилы игрока
        {
            var rNum:int=int(el.tid.substr(5, 1))-1;
            var hero:Hero = dan.currentHeroes[dan.heroChoose-1];
            var sum:int=0;
            for (var j:int=0; j<hero.needTyppe.length; j++)
            {
                for (var k:int=0; k<dan.heroActivities.length; k++)
                {
                    if (hero.needTyppe[j]==dan.heroActivities[k].act)
                    {
                        for (var n:int=0; n<dan.heroActivities[k].costTyppe.length; n++)
                        {
                            if (dan.heroActivities[k].costTyppe[n]==hero.heroResTyppe[rNum])
                            {
                                sum+=dan.heroActivities[k].costNum[n];
                                break;
                            }
                        }
                        break;
                    }
                }
            }
            if (sum!=0 && String(sum)!=el.txt)
            {
                el.txt=sum;
                el.pic.text=el.txt;
                kd++;
            }
            if (sum==0 && el.txt!="")
            {
                el.txt="";
                el.pic.text="";
                kd++;
            }
        }
        //$hCost1_1 //номер действия, номер требуемого ресурса
        if (dan.heroChoose>0 && el.tid.length>6 && el.tid.substr(0, 6) == "$hCost") //скилы игрока
        {
            var hNum:int=int(el.tid.substr(6, 1));
            var rNum:int=int(el.tid.substr(8, 1));
            var hero:Hero = dan.currentHeroes[dan.heroChoose-1];

            var currAct:int=-1;
            if (hNum-1<hero.needTyppe.length)
            {
                for (var j:int = 0; j < dan.heroActivities.length; j++)
                {
                    if (dan.heroActivities[j].act == hero.needTyppe[hNum - 1]) //нашли тип занятости текущего персонажа в общем списке типов занятостей
                    {
                        currAct=j;
                        break;
                    }
                }
                var c:int=0;
                for (var j:int = 0; j <dan.heroActivities[currAct].costTyppe.length; j++)
                {
                    if (dan.heroActivities[currAct].costTyppe[j]==dan.heroRes[rNum-1].typpe)
                    {
                        c++;
                        el.txt=dan.heroActivities[currAct].costNum[j];
                        el.pic.text=el.txt;
                        kd++;
                        break;
                    }
                }
                if (c==0 && el.txt!="")
                {
                    el.txt="";
                    el.pic.text=el.txt;
                    kd++;
                }
            } else
            {
                if (el.txt!="")
                {
                    el.txt="";
                    el.pic.text=el.txt;
                    kd++;
                }
            }
        }

        if (el.tid.substr(0, 5) == "$city") //имя города
        {
            if (dan.currentCity!=-1)
            {
                for (var j:int=0; j<bit.texto.length; j++)
                {
                    if (int(dan.cities[dan.currentCity].name)==bit.texto[j].tid)
                    {
                        for (var k:int=0; k<bit.texto[j].mode.length; k++)
                        {
                            kd+=simpleChoiser(el, j);
                        }
                        break;
                    }
                }
            }
        }

        if (el.tid.substr(0, 11) == "$cityStatus") //статус города по отношению к городу клиента
        {
            if ( dan.currentCity==-1)
            {
                return;
            }
            //ищем город текущего игрока
            for (var i:int=0; i<dan.cities.length; i++)
            {
                if (dan.cities[i].iii==dan.playerIII) //нашли
                {
                    for (var j:int=0; j<dan.cities[i].peacewarIII.length; j++) //проходим по отношениям этого города
                    {
                        if (dan.cities[i].peacewarIII[j]== dan.cities[dan.currentCity].iii) //пока не нашли
                        {
                            var st:int=dan.cities[i].status[j] * (-1); //взяли номер статуса, берём обратный, так как смотрим по городу клиента
                            //теперь находим его в статусах
                            var numOfStatus:int=-1;
                            for (var k:int=0; k<dan.status.length; k++)
                            {
                                if (dan.status[k].num==st)
                                {
                                    numOfStatus=dan.status[k].txt;
                                    break;
                                }
                            }
                            if (numOfStatus!=-1) //а теперь ищем нужную текстовку
                            {
                                for (var j:int = 0; j < bit.texto.length; j++)
                                {
                                    if (numOfStatus == bit.texto[j].tid)
                                    {
                                        for (var k:int = 0; k < bit.texto[j].mode.length; k++)
                                        {
                                            kd+=simpleChoiser(el, j);
                                        }
                                        break;
                                    }
                                }
                            }
                        }
                    }
                    break;
                }
            }
        }

        if (el.tid.substr(0, 4) == "$tra") //текущий показатель торговли ресурса относительно ресурса
        {
            if (dan.playerIII==-1 || dan.currentCity==-1)
            {
                return;
            }
            var numBuy:int = int(el.tid.substr(4, 1));
            var numSell:int = int(el.tid.substr(6, 1));
            var nameBuy:String="";
            var nameSell:String="";
            for (var i:int=0; i<dan.globalRes.length; i++)
            {
                if (dan.globalRes[i].iii==numBuy)
                {
                    nameBuy=dan.globalRes[i].typpe;
                }
                if (dan.globalRes[i].iii==numSell)
                {
                    nameSell=dan.globalRes[i].typpe;
                }
            }
            var transitionNum:int=-1;
            for (var i:int=0; i<dan.tradeTransactions.length; i++) //находим нужную торговую компанию
            {
                if ((dan.tradeTransactions[i].city1==dan.playerIII && dan.tradeTransactions[i].city2==dan.cities[dan.currentCity].iii) ||
                        (dan.tradeTransactions[i].city2==dan.playerIII && dan.tradeTransactions[i].city1==dan.cities[dan.currentCity].iii))
                {
                    transitionNum=i;
                    break;
                }
            }
            var transition:TradeTransaction = dan.tradeTransactions[transitionNum];
            for (var i:int=0; i<transition.res.length; i++) //находим соответствующую сделку
            {
                if (transition.res[i]==nameBuy && transition.cost[i]==nameSell)
                {
                    if (int(transition.rNum[i])!=0)
                    {
                        el.txt = "+" + int(transition.cNum[i]) + "/-" + int(transition.rNum[i]);
                        kd++;
                    }
                }
                if (transition.res[i]==nameSell && transition.cost[i]==nameBuy)
                {
                    if (int(transition.rNum[i])!=0)
                    {
                        el.txt = "-" + int(transition.rNum[i]) + "/+" + int(transition.cNum[i]);
                        kd++;
                    }
                }
            }
            if (kd==0)
            {
                el.txt="0/0";
                kd++;
            }
            el.pic.text = el.txt;
        }

        if (el.tid.length>4 && el.tid.substr(0,4) == "$inc") //доход/расход по ресурсу
        {
            var v:int=int(el.tid.charAt(4));
            if (el.txt!=String(dan.globalRes[v].income))
            {
                el.txt=dan.globalRes[v].income;
                if (int(el.txt)>=0)
                {
                    el.pic.text = "+" + el.txt;
                } else
                {
                    el.pic.text = el.txt;
                }
                kd++;
            }
        }

        if (el.tid.length>6 && el.tid.substr(0,6) == "$pream") //наличие ресурса для учёта
        {
            var v:int=int(el.tid.charAt(6));
            if (el.tid.length>6)
            {
                v=v*10+int(el.tid.charAt(7));
            }
            v--;
            if (el.txt!=String(dan.globalRes[v].presenceAmount))
            {
                el.txt=dan.globalRes[v].presenceAmount;
                el.pic.text=el.txt;
                kd++;
            }
        }

        if (el.tid.length>4 && el.tid.substr(0,4) == "$fre") //наличие ресурса для использования
        {
            var v:int=int(el.tid.charAt(4));
            if (el.txt!=String(dan.globalRes[v].freeAmount))
            {
                el.txt=dan.globalRes[v].freeAmount;
                el.pic.text=el.txt;
                kd++;
            }
        }

        if (el.tid.length>4 && el.tid.substr(0,4) == "$bui")  //рес для строительства !! не учитывает числа>10!!!
        {
            var buildingNum:int=0;
            var resNum:int=0;
            var d:int=4;
            while (el.tid.charAt(d)!="_")
            {
                buildingNum = buildingNum*10+int(el.tid.charAt(d));
                d++;
            }
            d++;
            while(d<el.tid.length)
            {
                resNum = resNum*10 + int(el.tid.charAt(d));
                d++;
            }
            if (dan.buildings[buildingNum].costToBuild.length>resNum-1 && dan.buildings[buildingNum].costToBuild[resNum-1]!=0)
            {
                el.txt=dan.buildings[buildingNum].costToBuild[resNum-1];
            } else
            {
                el.txt="";
            }
            el.pic.text=el.txt;
            kd++;
        }

        if (el.tid.substr(0,6) == "$hName")  //имя текущего героя
        {
            if (dan.heroChoose<0)// && dan.currentCity<0)
            {
                return;
            }
            var nm:int = -1;
            if (dan.heroChoose>0)// && dan.currentCity<0)
            {
                var d:int = 0;
                nm = dan.currentHeroes[dan.heroChoose-1].nameID;
            }
            if (nm==-1)
            {
                if (el.txt!="")
                {
                    el.txt="";
                    el.pic.text="";
                }
                return;
            }
            for (var j:int=0; j<bit.texto.length; j++)
            {
                if (nm==bit.texto[j].tid)
                {
                    kd+=simpleChoiser(el, j);
                    break;
                }
            }
        }
        if (el.tid.substr(0,7) == "$hCityN")  //имя текущего героя
        {
            if (dan.currentCity<0)
            {
                return;
            }
            var nm:int = -1;
            if (dan.currentCity>=0)
            {
                var d:int = 0;
                for (i = 0; i < dan.currentHeroes.length; i++)
                {
                    for (j = 0; j < dan.currentHeroes[i].needTyppe.length; j++)
                    {
                        if (dan.currentHeroes[i].needTyppe[j] == "city" && dan.currentHeroes[i].needNum[j] == dan.currentCity)
                        {
                            nm = dan.currentHeroes[i].nameID;
                            d = 1;
                            break;
                        }
                    }
                    if (d == 1)
                    {
                        break;
                    }
                }
            }
            if (nm==-1)
            {
                if (el.txt!="")
                {
                    el.txt="";
                    el.pic.text="";
                }
                return;
            }
            for (var j:int=0; j<bit.texto.length; j++)
            {
                if (nm==bit.texto[j].tid)
                {
                    kd+=simpleChoiser(el, j);
                    break;
                }
            }
        }

        if (el.tid.length>4 && el.tid.substr(0,4) == "$btm") //время строительства
        {
            var d:int=4;
            var buildingNum:int=0;
            while(d<el.tid.length)
            {
                buildingNum = buildingNum*10 + int(el.tid.charAt(d));
                d++;
            }
            el.txt = dan.buildings[buildingNum].timeToBuild;
            el.pic.text = el.txt;
            kd++;
        }

        if (el.tid == "$info" && el.txt!=dan.updInfo) //окошко с информацией
        {
            el.txt = dan.updInfo;
            if (el.txt=="")
            {
                el.pic.text=el.txt;
                kd++;
            } else
            {
                if (el.txt.length>3 && el.txt.substr(0,4) == "$mod") //время строительства
                {
                    var upNum:int=0;
                    var k:int=4;
                    while (k<el.txt.length)
                    {
                        upNum = upNum*10+int(el.txt.charAt(k));
                        k++;
                    }
                    for (var j:int = 0; j < dan.updates.length; j++)
                    {
                        if (dan.updates[j].iii==upNum)
                        {
                            var material:String=dan.updates[j].description;
                            for (var j:int = 0; j < bit.texto.length; j++)
                            {
                                if (int(material) == bit.texto[j].tid)
                                {
                                    kd+=simpleChoiser(el, j);
                                    break;
                                }
                            }
                            break;
                        }
                    }
                }
            }
        }

        if (el.tid.length>3 && el.tid.substr(0,3) == "$up") //время строительства
        {
                var nnn:int = buildingNum*10 + int(el.tid.charAt(3));
                if (dan.updateTap>-1 && el.txt!=dan.updates[dan.updateTap].upResNum[nnn])
                {
                    el.txt=dan.updates[dan.updateTap].upResNum[nnn];
                    el.pic.text = el.txt;
                    kd++;
                }
                if (dan.updateTap==-1 && el.txt!="")
                {
                    el.txt="";
                    el.pic.text = el.txt;
                    kd++;
                }

        }

        if (el.tid == "$currModif" && el.txt!=dan.updCost) //окошко со стоимостью апдейта
        {
            if (dan.updIII!=-1)
            {
                el.txt = dan.updCost;
            }
            if (dan.updIII==-1)
            {
                el.txt = "";
            }
            el.pic.text = el.txt;
            kd++;
        }

        if (kd==0)
        {
            for (var j:int=0; j<bit.texto.length; j++)
            {
                if (el.tid==bit.texto[j].tid)
                {
                    kd+=simpleChoiser(el, j);
                    break;
                }
            }
        }
        if (kd>0)
        {
            el.makeFormat();
            kd=0;
        }
    }
}
}