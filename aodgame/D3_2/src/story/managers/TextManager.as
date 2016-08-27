/**
 * Created by alexo on 03.06.2016.
 */
package story.managers
{
import collections.common.Hero;
import collections.inWorld.TradeTransaction;
import D3.Bitte;

import org.osmf.utils.OSMFStrings;

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

    public function work(el, sub)
    {
        for (i=0; i<el.length; i++)
        {
            if (el[i].typeOfElement=="txt" && el[i].pic.visible)
            {
                texter(el[i], i, sub);
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
                return 1;
            }
        }
        return 0;
    }

    private function mediumChoicer(el, num):String
    {
        var s:String="";
        for (var k:int=0; k<bit.texto.length; k++)
        {
            if (bit.texto[k].tid==num)
            {
                for (var m:int=0; m<bit.texto[k].mode.length; m++)
                {
                    if (bit.textMode==bit.texto[k].mode[m])
                    {
                        s=bit.texto[k].txt[m];
                        break;
                    }
                }
                break;
            }
        }
        return s;
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

    private function findBehMenu():int
    {
        var z:int=0;
        for (var j:int = 0; j < dan.behMenu.length; j++)
        {
            if (dan.behMenu[j].iii==dan.heroMenuActivity)
            {
                trace(dan.behMenu[j].iii);
                z=j;
                trace("beh menu z=="+z);
                break;
            }
        }
        return z;
    }

    private function letCheck(el, t):int
    {
        if (t!=el.txt)
        {
            el.txt=t;
            el.pic.text=t;
            return 1;
        }
        return 0;
    }

    private function texter(el, num, sub):void
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
                            trace("(dan.heroActivities[j].txt[k]="+dan.heroActivities[j].txt[k]);
                            if (dan.heroActivities[j].txt[k] == "$curCityName") //имя города
                            {
                                //trace("!");
                                for (var m:int = 0; m < bit.texto.length; m++)
                                {
                                    if (int(hero.needNum[hr])>=0 && int(dan.cities[hero.needNum[hr]].name) == bit.texto[m].tid)
                                    {
                                        el.txt += harderChoiser(el, m)+" ";
                                        break;
                                    }
                                }
                            }
                            if (dan.heroActivities[j].txt[k] == "$saveCityName") //имя города
                            {
                                trace("$saveCityName");
                                trace("hero.needNum[hr]="+hero.needNum[hr]);
                                trace (dan.cities[hero.needNum[hr]].name);
                                for (var m:int = 0; m < bit.texto.length; m++)
                                {
                                    if (int(hero.needNum[hr])>=0 && int(dan.cities[hero.needNum[hr]].name) == bit.texto[m].tid)
                                    {
                                        el.txt += harderChoiser(el, m)+" ";
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

        if (el.tid.substr(0, 9) == "$username") //ник пользователя
        {
            //trace("$username");
            if (bit.userName!="")
            {
                if (bit.userName!=el.txt)
                {
                    el.txt=bit.userName;
                    el.pic.text=el.txt;
                    kd++;
                }
            } else
            {
                //trace("noname");
                var bb:String=el.tid.substr(10, 2);
                el.txt=mediumChoicer(el, bb);
                if (el.txt!=el.pic.text)
                {
                    el.pic.text=el.txt;
                    kd++;
                }
            }
        }
            if (el.tid=="$actInfo" && dan.heroMenuActivity!=-1)
        {
            trace("$actInfo");
            var num:int=0;
            var t:String="";
            num=findBehMenu();

            if (dan.behMenu[num].txt.substr(0,1)=="$")
            {
                if (dan.behMenu[num].txt=="$goals") //цели на игру
                {
                    trace("$goals");
                    el.pic.text="";
                    for (var gl:int=0; gl<dan.wins.length; gl++)
                    {
                        if (dan.wins[gl].status=="disclass" || dan.wins[gl].status=="active")
                        {
                            trace("here="+dan.wins[gl].txt);
                            el.pic.text+=mediumChoicer(el, dan.wins[gl].txt)+"\n";
                        }
                    }
                    kd++;
                }
            } else
            {
                for (var j:int = 0; j < bit.texto.length; j++)
                {
                    if (dan.behMenu[num].txt == String(bit.texto[j].tid))
                    {
                        t += harderChoiser(el, j);
                        break;
                    }
                }
                kd += letCheck(el, t);
            }




        }

        if (el.tid.substr(0,5)=="$abtn" && dan.heroMenuActivity!=-1)
        {
            var num:int=0;
            var t:String="";
            var n:int=int(el.tid.substr(5,1))-1;
            trace("n="+n+"; dan.heroMenuNum="+dan.heroMenuNum);
            if (n>=dan.heroMenuNum)
            {
                return;
            }
            trace("$abtn next");
            num=findBehMenu();
            //trace("dan.behMenu.length="+dan.behMenu.length);
            for (var j:int = 0; j < bit.texto.length; j++)
            {
                if (dan.behMenu[num].choicerTxt.length>0 && dan.behMenu[num].choicerTxt[n] == String(bit.texto[j].tid))
                {
                    t += harderChoiser(el, j);
                    break;
                }
            }
            kd+=letCheck(el, t);
        }

        if (el.tid.substr(0,9)=="$hresneed" && dan.heroMenuActivity!=-1) //количество параметра героя, требуемого для выбора пунтка в сообщении
        {
            var num:int=el.tid.substr(9,1);
            if (dan.messFramsOfNumCost.length<=num || dan.messFramsOfNumCost[num-1]==0)
            {
                el.txt="";
            } else
            {
                el.txt=dan.messFramsOfNumCost[num-1];
            }
            if (el.pic.text!=el.txt)
            {
                el.pic.text=el.txt;
                kd++;
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
            kd+=letCheck(el, String(dan.globalRes[v].amount));
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
            if (sum!=0)
            {
                kd+=letCheck(el, String(sum));
            }
            if (sum==0)
            {
                kd+=letCheck(el, "");
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
                if (c==0)
                {
                    kd+=letCheck(el, "");
                }
            } else
            {
                kd+=letCheck(el, "");
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

        if (el.tid == "$cityGovern") //тип правления в городе и характер его граждан
        {
            if (dan.currentCity!=-1)
            {
                /*trace("name="+dan.cities[dan.currentCity].name);
                trace("dan.cities[dan.currentCity].characterTxt="+dan.cities[dan.currentCity].characterTxt);
                trace("dan.cities[dan.currentCity].governmentTxt="+dan.cities[dan.currentCity].governmentTxt);*/
                var car:int=-1;
                var gov:int=-1;
                for (var m:int = 0; m < bit.texto.length; m++)
                {
                    if (bit.texto[m].tid==dan.cities[dan.currentCity].characterTxt)
                    {
                        car=m;
                    }
                    if (bit.texto[m].tid==dan.cities[dan.currentCity].governmentTxt)
                    {
                        gov=m;
                    }
                    if (car!=-1 && gov!=-1)
                    {
                        break;
                    }
                }
                if (car!=-1 && gov!=-1)
                {
                    el.txt = harderChoiser(el, gov);
                    el.txt += " (" + harderChoiser(el, car) + ")";
                    if (el.pic.text != el.txt)
                    {
                        el.pic.text = el.txt;
                        kd++;
                    }
                }
            }
        }
        if (el.tid == "$patron") //тип покровителя города
        {
            if ( dan.currentCity==-1)
            {
                return;
            }
            el.txt=mediumChoicer(el, dan.cities[dan.currentCity].patronTxt);
            if (el.pic.text!=el.txt)
            {
                el.pic.text=el.txt;
                kd++;
            }
        }

        if (el.tid.substr(0, 8) == "$citizen") //количество жителей отпределённого типа в одном из городов
        {
            if (dan.currentCity==-1)
            {
                return;
            }
            var h:int=int(el.tid.substr(8, 1))-1;
            el.txt=dan.cities[dan.currentCity].citizenNum[h];
            if (el.pic.text!=el.txt)
            {
                el.pic.text=el.txt;
                kd++;
            }
        }

        if (el.tid == "$technology") //количество технологий этого города относительно вас
        {
            if (dan.currentCity==-1)
            {
                return;
            }
            var yourNum:int=0;
            for (var jj:int=0; jj<dan.updates.length; jj++)
            {
                if (dan.updates[jj].isOpened==1)
                {
                    yourNum++;
                }
            }
            //trace("yourNum="+yourNum);
            //trace("dan.cities[dan.currentCity].techLevel="+dan.cities[dan.currentCity].techLevel);
            if (yourNum<dan.cities[dan.currentCity].techLevel-2)
            {
                el.txt=dan.techLevelTxt[2];
            } else
            {
                if(yourNum > dan.cities[dan.currentCity].techLevel + 2)
                {
                    el.txt = dan.techLevelTxt[0];
                } else
                {
                    el.txt = dan.techLevelTxt[1];
                }
            }
            //trace("el.txt="+el.txt);
            el.txt=mediumChoicer(el, el.txt);
            //trace("el.txt="+el.txt);
            if (el.pic.text!=el.txt)
            {
                el.pic.text=el.txt;
                kd++;
            }
        }

        if (el.tid.substr(0, 13) == "$cityAlliance") //альянс, в который входит текущий город
        {
            /*trace("==city==");
            trace("dan.cityName="+dan.cityName);
            trace("dan.currentCity="+dan.currentCity);*/
            if (dan.currentCity>=0)
            {
                var s:Vector.<String> = new Vector.<String>();
                var n:int=-1;
                for (var m:int=13; m<el.tid.length; m++)
                {
                    if (el.tid.substr(m, 1)==":")
                    {
                        break;
                    }
                    if (el.tid.substr(m, 1)==",")
                    {
                        s.push(new String());
                        n++;
                    } else
                    {
                        s[n]+=el.tid.substr(m, 1);
                    }
                }

                var lid:Boolean=false;
                var cityNum:int=dan.cities[dan.currentCity].iii;
                var city:String=dan.cities[dan.currentCity].name;
                if (dan.cities[dan.currentCity].alliance==-1)
                {
                    lid = true;
                    city=dan.cities[dan.currentCity].name;
                    cityNum=1;//int(dan.cities[dan.currentCity].name);
                } else
                {
                    for (var jj:int = 0; jj < dan.alliances.length; jj++)
                    {
                        if (dan.alliances[jj].iii == dan.cities[dan.currentCity].alliance)
                        {
                            if (dan.alliances[jj].leader == cityNum) //если герой лидер альянса, то дальнейший поиск не нужен
                            {
                                lid = true;
                            }
                             else
                            {
                                for (var g:int=0; g<dan.cities.length; g++)
                                {
                                    if (dan.cities[g].iii==dan.alliances[jj].leader)
                                    {
                                        city=String(dan.cities[g].name);
                                        break;
                                    }
                                }
                            }
                            cityNum = dan.alliances[jj].members.length;
                            break;
                        }
                    }
                }
                el.txt = mediumChoicer(el, s[0]) +" "; //союз города
                el.txt+= mediumChoicer(el, city) +" "; //имя города
                el.txt+= " (" + mediumChoicer(el, s[1]); //участник
                el.txt+= " " + String(cityNum); //число участников
                if (s.length>2 && lid)
                {
                    el.txt+=", "+mediumChoicer(el, s[2]); //лидер
                }
                el.txt+=")";
                if (el.txt!=el.pic.text)
                {
                    el.pic.text = el.txt;
                    kd++;
                }
            }
        }
        if (el.tid == "$cityArmy") //сухопутная армия города
        {
            if (dan.currentCity==-1)
            {
                return;
            }
            if (!dan.cityAllianceArmy || dan.cities[dan.currentCity].alliance==-1)
            {
                el.txt=dan.cities[dan.currentCity].army;
            } else
            {
                trace("alliance="+dan.cities[dan.currentCity].alliance);
                var n:int=0;
                var allNum:int=-1;
                for (var m:int=0; m<dan.alliances.length; m++)
                {
                    if (dan.alliances[m].iii==dan.cities[dan.currentCity].alliance)
                    {
                        allNum=m;
                        trace("allNum="+allNum);
                        break;
                    }
                }
                for (var k:int=0; k<dan.cities.length; k++)
                {
                    if (dan.cities[k].alliance==dan.alliances[allNum].iii)
                    {
                        n+=dan.cities[k].army;
                    }
                }
                el.txt=n;
            }
            if (el.pic.text!=el.txt)
            {
                el.pic.text=el.txt;
                kd++;
            }
        }
        if (el.tid == "$cityFleet") //флот города
        {
            if (dan.currentCity==-1)
            {
                return;
            }
            if (!dan.cityAllianceArmy || dan.cities[dan.currentCity].alliance==-1)
            {
                el.txt=dan.cities[dan.currentCity].fleet;
            } else
            {
                var n:int=0;
                var allNum:int=-1;
                for (var m:int=0; m<dan.alliances.length; m++)
                {
                    if (dan.alliances[m].iii==dan.cities[dan.currentCity].alliance)
                    {
                        allNum=m;
                        break;
                    }
                }
                for (var k:int=0; k<dan.cities.length; k++)
                {
                    if (dan.cities[k].alliance==dan.alliances[allNum].iii)
                    {
                        n+=dan.cities[k].fleet;
                    }
                }
                el.txt=n;
            }
            if (el.pic.text!=el.txt)
            {
                el.pic.text=el.txt;
                kd++;
            }
        }

        if (el.tid.substr(0, 9) == "$cityName") //альянс, в который входит текущий город
        {
            var n:int=int(el.tid.substr(9, 1));
            if (el.tid.length==11)
            {
                n = n*10 + int(el.tid.substr(10, 1));
            }
            n-=1
            if (n<dan.knownCities.length)
            {
                var cnum:int = int(dan.cities[dan.knownCities[n]].name);
                el.txt = mediumChoicer(el, cnum);
                if (el.pic.text != el.txt)
                {
                   /* for (var z:int=0; z<dan.cities[dan.knownCities[n]].peacewarRelations.length; z++)
                    {
                        trace("peacewarRelations=" + dan.cities[dan.knownCities[n]].peacewarRelations[z]);
                    }*/
                    el.pic.text = el.txt;
                    kd++;
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
            kd+=letCheck(el, String(dan.globalRes[v].presenceAmount));
        }

        if (el.tid.length>4 && el.tid.substr(0,4) == "$fre") //наличие ресурса для использования
        {
            var v:int=int(el.tid.charAt(4));
            kd+=letCheck(el, String(dan.globalRes[v].freeAmount));
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
                kd+=letCheck(el, "");
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
        if (el.tid.substr(0,6) == "$hRole")  //профессия текущего героя
        {
            if (dan.heroChoose>0)
            {
                var t:String="(";
                for (var j:int = 0; j < bit.texto.length; j++)
                {
                    if (dan.currentHeroes[dan.heroChoose - 1].txt == bit.texto[j].tid)
                    {
                        t += harderChoiser(el, j);
                        break;
                    }
                }
                t+=")";
                kd+=letCheck(el, t);
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
                kd+=letCheck(el, "");
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

        if (el.tid == "$infr" && el.txt!=dan.updInfo) //окошко с информацией
        {
            el.txt = dan.updInfo;
            if (el.txt == "")
            {
                el.pic.text = el.txt;
                kd++;
            } else
            {
                if (el.txt.length > 3 && el.txt.substr(0, 4) == "$mod") //время строительства
                {
                    var upNum:int = 0;
                    var k:int = 4;
                    while (k < el.txt.length)
                    {
                        upNum = upNum * 10 + int(el.txt.charAt(k));
                        k++;
                    }
                    for (var j:int = 0; j < dan.updates.length; j++)
                    {
                        if (dan.updates[j].iii == upNum)
                        {
                            var material:String = dan.updates[j].description;
                            for (var j:int = 0; j < bit.texto.length; j++)
                            {
                                if (int(material) == bit.texto[j].tid)
                                {
                                    kd += simpleChoiser(el, j);
                                    break;
                                }
                            }
                            break;
                        }
                    }
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
            //kd+=letCheck(el, dan.buildings[buildingNum].timeToBuild);
            el.txt = dan.buildings[buildingNum].timeToBuild;
            el.pic.text = el.txt;
            kd++;
        }

        if (el.tid == "$info" && el.txt!=dan.landInfoText) //окошко с информацией
        {
            el.txt = dan.landInfoText;
            if (el.txt=="")
            {
                el.pic.text=el.txt;
                kd++;
            } else
            {
                if (el.txt.length>3 && el.txt.substr(0,4) == "$mod") //время строительства //SubElementsMenu.parentUpd(el)
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
                if (el.txt.length>3 && el.txt.substr(0,4) == "$lan") //текстовка земли //LandsManager.notActive()
                {
                    trace(el.txt);
                    var tIt:int=0;
                    var landInfo:String="";
                    var buildingInfo:String="";
                    for (var rr:int=4; rr< el.txt.length; rr++)
                    {
                        if (tIt==1)
                        {
                            buildingInfo+=el.txt.substr(rr,1);
                        }
                        if (tIt==0 && el.txt.substr(rr,1)!="+")
                        {
                            landInfo+=el.txt.substr(rr,1);
                        }
                        if (tIt==0 && el.txt.substr(rr,1)=="+")
                        {
                            tIt=1;
                        }

                    }
                    el.pic.text=mediumChoicer(el, int(buildingInfo));
                    if (el.pic.text.length>0)
                    {
                        el.pic.text += "\n";
                    }
                    el.pic.text+=mediumChoicer(el, int(landInfo));
                    kd++;
                }
                if (el.txt.length>3 && el.txt.substr(0,4) == "$bui") //тип апдейта //SubElementsMenu.specTextAnalyze()
                {
                    trace(el.txt);
                    var buiy:String=el.txt.substr(4,el.txt.length-4);
                    trace("buiy="+buiy);
                    el.pic.text=mediumChoicer(el, int(buiy));
                    trace("el.pic.text="+el.pic.text);
                    kd++;
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

        if (el.tid.substr(0, 9) == "$timeTurn") //количество ходов, прошедших с начала игры
        {
            var nn:int=el.tid.substr(9, 1);
            if (nn==0)
            {
                el.txt="0";
                if (el.txt!=el.pic.text)
                {
                    el.pic.text=el.txt;
                    kd++;
                }
            } else
            {
                var tt:int=(dan.willSave[0].num.length-1)/9*(nn);
                el.txt=tt;
                if (el.txt!=el.pic.text)
                {
                    el.pic.text=el.txt;
                    kd++;
                }
            }
        }

        if (el.tid.substr(0, 7) == "$reuNum") //количество ресурса относительно максимального значения
        {
            var nn:int=el.tid.substr(7, 1);
            var category:int=el.tid.substr(9, 1);
            var mx:int=0;
            for (var jj:int=0; jj<dan.willSave.length; jj++)
            {
                if (dan.willSave[jj].category==category && dan.willSave[jj].max>mx)
                {
                    mx=dan.willSave[jj].max;
                }
            }
            var tt:int=mx/4*(5-nn);
            el.txt=tt;
            if (el.txt!=el.pic.text)
            {
                el.pic.text=el.txt;
                kd++;
            }

        }
        if (el.tid.substr(0, 7) == "$heuNum") //количество ресурса относительно максимального значения
        {
            var nn:int=el.tid.substr(7, 1);
            var ave:int=0;
            for (var jj:int=0; jj<dan.willSave.length; jj++)
            {
                if (dan.willSave[jj].heroStory.length>0)
                {
                    ave=jj;
                    break;
                }
            }
            var nm:int=0;
            for (var jj:int=0; jj<dan.willSave[ave].heroStory.length; jj++)
            {
                if (dan.willSave[ave].heroStory[jj].typpe==dan.availableHeroes[nn].typpe)
                {
                    nm++;
                }
            }
            if (el.txt!=String(nm))
            {
                el.txt=String(nm);
                el.pic.text=el.txt;
                kd++;
            }
        }

        if (el.tid.substr(0, 8) == "$hisName") //экран истории: имя героя
        {
            if (dan.historyHeroChoose!=-1 && dan.willSave[dan.heroHistoryCategory].heroStory.length>0)
            {
                var tp:String = String(dan.willSave[dan.heroHistoryCategory].heroStory[dan.historyHeroChoose].nameID);
                //trace("tp="+tp);
                el.txt=mediumChoicer(el,tp);
                if (el.pic.text!=el.txt)
                {
                    el.pic.text=el.txt;
                    kd++;
                }
            }
        }

        if (el.tid.substr(0, 8) == "$hisRole") //экран истории: роль героя
        {
            if (dan.historyHeroChoose!=-1 && dan.willSave[dan.heroHistoryCategory].heroStory.length>0)
            {
                var tp:String = String(dan.willSave[dan.heroHistoryCategory].heroStory[dan.historyHeroChoose].txt);
                //trace("tp="+tp);
                el.txt="("+mediumChoicer(el,tp)+")";
                if (el.pic.text!=el.txt)
                {
                    el.pic.text=el.txt;
                    kd++;
                }
            }
        }
        if (el.tid.substr(0, 8) == "$hisDate") //экран истории: роль героя
        {
            if (dan.historyHeroChoose!=-1 && dan.willSave[dan.heroHistoryCategory].heroStory.length>0)
            {
                var s1:String = dan.willSave[dan.heroHistoryCategory].heroStory[dan.historyHeroChoose].s1;
                var s2:String = dan.willSave[dan.heroHistoryCategory].heroStory[dan.historyHeroChoose].s2;
                //trace("tp="+tp);
                el.txt = s1+ " - "+s2;
                if (el.pic.text!=el.txt)
                {
                    el.pic.text=el.txt;
                    kd++;
                }
            }
        }

        if (el.tid == "$advice" && dan.advice!=0) //подсказка
        {
            //trace("advice");
            //trace("dan.advice="+dan.advice);
            el.txt=mediumChoicer(el, dan.advice);
            if (el.pic.text!=el.txt)
            {
                el.pic.text=el.txt;
                kd++;
            }
        }

        if (el.tid.substr(0, 8) == "$hisResu") //экран истории: роль героя
        {
            if (dan.historyHeroChoose!=-1 && dan.willSave[dan.heroHistoryCategory].heroStory.length>0)
            {
                //_0_0
                var minmax:int = int(el.tid.substr(9, 1));
                var res:int = int(el.tid.substr(11, 1));
                if (minmax == 0)
                {
                    el.txt = dan.willSave[dan.heroHistoryCategory].heroStory[dan.historyHeroChoose].heroResMin[res];
                } else
                {
                    el.txt = dan.willSave[dan.heroHistoryCategory].heroStory[dan.historyHeroChoose].heroResMax[res];
                }
                if (el.pic.text != el.txt)
                {
                    el.pic.text = el.txt;
                    kd++;
                }
            }
        }

        if (el.tid=="$uLogin")
        {
            if (!bit.logged)
            {
                bit.userLogin=el.pic.text;
                if (bit.userLogin=="")
                {
                    el.pic.text=bit.userLogin;
                }
            } else
            {
                el.pic.text=bit.userLogin;
                el.txt=el.pic.text;
            }
            kd++;
        }
        if (el.tid=="$uPass")
        {
            if (!bit.logged)
            {
                if (bit.userPass=="//")
                {
                    el.pic.text="";
                }
                bit.userPass=el.pic.text;
                el.txt=el.pic.text;

                if (bit.userPass=="")
                {
                    el.pic.text=bit.userPass;
                }
            } else
            {
                el.pic.text="";//bit.userPass;
            }
            kd++;
        }
        if (el.tid=="$uNick")
        {
            if (bit.logged && !bit.waiting)
            {
                bit.userName=el.pic.text;
                el.txt=el.pic.text;

                if (bit.userName=="")
                {
                    el.pic.text=bit.userName;
                }
            } else
            {
                el.pic.text=bit.userName;
            }
            kd++;
        }
        if (el.tid=="$uMail")
        {
            if (bit.logged && !bit.waiting)
            {
                bit.userEmail=el.pic.text;
                el.txt=el.pic.text;

                if (bit.userEmail=="")
                {
                    el.pic.text=bit.userEmail;
                }
            } else
            {
                el.pic.text=bit.userEmail;
            }
            kd++;
        }

        if (el.tid.substr(0, 6)=="$winRe") //выполненные достижения
        {
            var rout:Boolean=false;
            el.pic.text="";
            for (var gl:int=0; gl<dan.wins.length; gl++)
            {
                if (dan.wins[gl].status=="done")
                {
                    rout=true;
                    el.pic.text+=mediumChoicer(el, dan.wins[gl].restxt)+"\n";
                }
            }
            if  (!rout)
            {
                el.pic.text+=mediumChoicer(el, el.tid.substr(8, el.tid.length-8));
            }
            var m:int=el.tid.substr(6, 1);
            while (el.pic.numLines<m)
            {
                el.pic.text+="\n";
            }
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