/**
 * Created by alexo on 15-May-15.
 */
package story
{
import D3.*;

import collections.common.Message;

import subjects.*;
import collections.Stats;

public class Movie
{
    private var i:uint; //порядковая переменная для счёта
    private var j:uint;
    private var k:uint;
    private var find_id:uint=0;

    private var bit:Bitte;
    private var dan:Danke;
    private var subs:Subjects;

    public function Movie(stage)
    {
        bit = Bitte.getInstance();
        dan = Danke.getInstance();
        subs = Subjects.getInstance(stage);
    }

    public function work (quest, timmer):void
    {
        //проверяем все квесты
        for (i=0; i<quest.length; i++)
        {
            if (quest[i].screen_work==bit.curRoom || quest[i].screen_work==0)
            {
                if (quest[i].activ)
                {
                   // trace("qid="+quest[i].qid);
                    if (!quest[i].rready)
                    {
                       action (quest[i], timmer); //процедура проверки выполнения квестов
                    }
                    if (quest[i].rready)
                    {
                        effect (quest);  //процедура "раздачи слонов" по выполнению квестов
                    }
                }
            }
        }
    }

    private function action (quest, timmer):void //процедура проверки выполнения квестов
    {
        k=0;
        j=0;
       // trace("qid="+quest.qid);
        while (j<quest.action.length && quest.rready==0)
        {
            if (quest.action[j].typpe=="no") //действие не требуется
            {
                //trace("hi! "+quest.qid);
                k+=1;
            }
            if (quest.action[j].typpe=="tap") //нажата кнопка
            {
                if (bit.mouseParClick==quest.action[j].iii)
                {
                    trace("qid="+quest.qid+";bit.mouseParClick="+bit.mouseParClick+"; "+quest.action[j].iii);
                    k += 1;
                }
            }
            if (quest.action[j].typpe=="weAre") //мы ва нужной комнате
            {
                if (bit.curRoom==int(quest.action[j].room) || int(quest.action[j].room)==0)
                {
                    k+=1;
                }
            }
            if (quest.action[j].typpe=="nextTurn") //следующий ход
            {
                if (quest.action[j].num =="inCase" && bit.sChangeTurn) //нашли, что ход сменился
                {
                    k+=1;
                }
                if (quest.action[j].num !="inCase" && dan.nextTurn==quest.action[j].num)
                {
                    k+=1;
                }
            }
            if (quest.action[j].typpe=="timeMoreThan") //в игре прошло ходов больше, чем...
            {
                if (timmer.numOfMoves>=quest.action[j].iii)
                {
                    k+=1;
                }
            }
            if (quest.action[j].typpe=="noBuilding") //ни на одной из земель нет строения
            {
                //trace("noBuilding="+quest.action[j].tip);
                for (var f:int=0; f<dan.lands.length; f++)
                {
                    //trace("--dan.lands[f].building.landResType="+dan.lands[f].building.landResType);
                    if (dan.lands[f].building.landResType==quest.action[j].tip)
                    {
                        //trace("here");
                        k-=1;
                        break;
                    }
                }
                k+=1;
            }
            if (quest.action[j].typpe=="randi") //процент от числа, который будет считаться успешным
            {
                var ri:int=Math.random()*100;
                //trace("ri="+ri);
                if (ri<quest.action[j].num)
                {
                    k+=1;
                }
            }

            if (quest.action[j].typpe=="resEnd") //закончился ресурс
            {
                for (var y:int=0; y<dan.globalRes.length; y++)
                {
                    if (dan.globalRes[y].typpe==quest.action[j].num)
                    {
                        if (dan.globalRes[y].amount==dan.globalRes[y].min)
                        {
                            k += 1;
                        }
                        break;
                    }
                }
            }

            if (quest.action[j].typpe=="curDate") //точная дата, в которую должно произойти событие
            {
                //trace("timmer.curElder()="+timmer.curElder());
                //trace("timmer.curYounger()="+timmer.curYounger());
                if (
                        timmer.curElder()==int(quest.action[j].first)
                        &&
                        (String(quest.action[j].second)=="no" || String(quest.action[j].second)==timmer.curYounger())
                    )
                {
                    k += 1;
                }
            }

            if (quest.action[j].typpe=="positionIt") //спозиционировать предметы
            {
                //trace("bit.positionIt.length="+bit.positionIt.length);
                if (bit.positionIt.length>0)
                {
                    trace("posit it!");
                    k+=1;
                }
            }
            if (quest.action[j].typpe=="visIt") //визуализировать предметы
            {
                if (bit.visIt.length>0)
                {
                    trace("vis it!");
                    k+=1;
                }
            }
            if (quest.action[j].typpe=="darken") //визуализировать предметы
            {
                if (dan.darkScreen!=-1)
                {
                    trace("!!!dan.darkScreen="+dan.darkScreen);
                    k += 1;
                }
            }

            if (quest.action[j].typpe=="workActivity") //передвинут человек
            {
                if (bit.underOne!=-1 && bit.whatUnderOne!=-1)
                {
                    dan.reIncome=true;
                    trace("workActivity");
                    k += 1;
                }
            }
            if (quest.action[j].typpe=="madeBuild") //проведено строительство, надо создать препятствие build на земле
            {
                if (dan.madeBuilding!=-1)
                {
                    k += 1;
                }
            }

            if (quest.action[j].typpe == "updWaitReady")
            { //1 - показываем доступные апдейты, 0 - купленные
                if (quest.action[j].res==1 && dan.updWaitReady)
                {
                    k += 1;
                }
                if (quest.action[j].res==0 && !dan.updWaitReady)
                {
                    k += 1;
                }
            }

            if (quest.action[j].typpe=="changeTurn") //новый ход
            {
                if (bit.sMovieChangeTurn)
                {
                    k += 1;
                }
            }

            if (quest.action[j].typpe=="resLevelLowerThan") //уровень ресурса меньше, чем
            {
                for (var y:int=0; y<dan.globalRes.length; y++)
                {
                    if (dan.globalRes[y].typpe==String(quest.action[j].tip))
                    {
                        if (dan.globalRes[y].amount<quest.action[j].level)
                        {
                            var r:Number=Math.random()*1;
                            if (r<Number(quest.action[j].chance))
                            {
                                k += 1;
                            }
                        }
                        break;
                    }
                }
            }
            if (quest.action[j].typpe=="resLevelMoreThan") //уровень ресурса больше, чем
            {

                for (var y:int=0; y<dan.globalRes.length; y++)
                {
                    if (dan.globalRes[y].typpe==String(quest.action[j].tip))
                    {
                        if (dan.globalRes[y].amount>quest.action[j].level)
                        {
                            var r:Number=Math.random()*1;
                            if (r<Number(quest.action[j].chance))
                            {
                                k += 1;
                            }
                        }
                        break;
                    }
                }
            }

            if (quest.action[j].typpe == "numOfMany") //номер элемента в списке элементов
            {
                if (dan.numOfMany==quest.action[j].iii)
                {
                    //trace("dan.numOfMany="+dan.numOfMany);
                    k += 1;
                }
            }

            if (quest.action[j].typpe == "tapDown")  //зажат предмет
            {
                if (bit.mouseParDown==quest.action[j].iii)
                {
                    k += 1;
                }
            }

            if (quest.action[j].typpe == "heroMenuActivity")  //данная переменная активна
            {
                if (dan.heroMenuActivity!=-1 && dan.heroMenuNum!=-1)
                {
                    trace("dan.heroMenuActivity should act");
                    trace(dan.heroMenuNum+"P:P:"+quest.action[j].iii);
                    if (dan.heroMenuNum==quest.action[j].iii)
                    {
                        trace("true="+quest.qid);
                        //dan.heroMenuNum=-1;
                        k += 1;
                    }
                }
            }

            if (quest.action[j].typpe == "outOfPosition")  //элементы предмета сдвинуты с места
            {
                if (k == quest.action[j].num)
                {
                    trace("outOfPosition="+quest.action[j].iii);
                    for (var g:int=0; g<subs.sub.length; g++)
                    {
                        if (subs.sub[g].iii==int(quest.action[j].iii))
                        {
                            trace("2");
                            if (subs.sub[g].equalIt(quest.action[j].tip))
                            {
                                trace("3");
                                k += 1;
                            }
                            break;
                        }
                    }
                }
            }

            if (quest.action[j].typpe == "behChoice")  //переменная dan.behChoice!=0
            {
                if (dan.behChoice!=0)
                {
                    k += 1;
                }
            }

            if (quest.action[j].typpe == "heroPanelClose")  //директивное закрытие панели героя
            {
                if (dan.heroPanelClose)
                {
                    trace("dan.heroPanelClose = close");
                    dan.heroPanelClose=false;
                    k += 1;
                }
            }

            j+=1;
        }
        if (k==quest.action.length) //если все условия выполнены
        {
            quest.rready=1;
        } else
        {
            k=0;
        }
    }

    private function findSub(iii):int
    {
        for (var w:int=0; w<subs.sub.length; w++)
        {
            if (subs.sub[w].iii==iii)
            {
                return w;
            }
        }
        return -1;
    }

    private function effect (quest):void //процедура "раздачи слонов" по выполнению квестов
    {
        find_id=0;
        if (!quest[i].afterActiv)
        {
            quest[i].activ=false;
        }
        quest[i].rready=0;
       // trace("quest[i].qid="+quest[i].qid);

        for (j=0; j<quest[i].effect.length; j++)
        {
            if (quest[i].effect[j].typpe=="flyTo") ////переходим в комнату
            {
                bit.prevRoom=bit.curRoom;
                bit.curRoom=int(quest[i].effect[j].room);
            }
            if (quest[i].effect[j].typpe=="activate") //активируем ивент
            {
                for (var kk:int=0; kk<quest.length; kk++)
                {
                    if (quest[kk].qid==quest[i].effect[j].qid)
                    {
                        quest[kk].activ=true;
                    }
                }
            }
            if (quest[i].effect[j].typpe=="flyToPlane") ////переходим на слой
            {
                bit.prevPlane=bit.curPlane;
                bit.curPlane=quest[i].effect[j].plane;
            }
            if (quest[i].effect[j].typpe=="load") //тип эффекта "запуск другого квеста"
            {
                trace("begin load");
                bit.scenPath=quest[i].effect[j].scen;// prelScenaries.xml";
                bit.subPath=String(quest[i].effect[j].sub);//prelSubjects.xml";
                bit.textoPath=String(quest[i].effect[j].texto);//textoSubjects.xml";
                bit.nextLevel=Stats.THREE;
                bit.wait_scenario=true;
                bit.wait_subjects=true;
                bit.wait_texto=true;

            }
            if (quest[i].effect[j].typpe=="makeSkip") //пропускаем один из кусочков ролика
            {
                dan.smallSkip=1;
            }
            if (quest[i].effect[j].typpe=="reposition") //даём существующему предмету другую комнату
            {
                var t:int;
                t = findSub(quest[i].effect[j].iii);
                if (t!=-1)
                {
                    subs.sub[t].weAre = int(quest[i].effect[j].room);
                }
            }
            if (quest[i].effect[j].typpe=="buttonRepos")
            { //даём существующей кнопки другую комнату как цель
                var t:int;
                t = findSub(quest[i].effect[j].iii);
                if (t!=-1)
                {
                    subs.sub[t].getParam(quest[i].effect[j].tip, quest[i].effect[j].pos);
                }
            }

            if (quest[i].effect[j].typpe=="resChoose") //выбран рес
            {
                trace("resChoose effect");
                bit.underRes=String(quest[i].effect[j].tip);
                trace("pre bit.underRes="+bit.underRes);
            }

            if (quest[i].effect[j].typpe=="workerChange") //передвинут человек
            {
                trace("workerChange");
                var k1:int=0;
                var land:int=0;
                var magicNumber:int=2;
                for (k1=0; k1<dan.lands.length; k1++) //нашли землю, над которой ндао произвести работу
                {
                    if (dan.lands[k1].subID==bit.underOne)
                    {
                        trace("find danLand");
                        //magicNumber=2; //3 - магическое число, показывающее, сколкьо кажров надо добавить для отображения
                        land=k1;
                        break;
                    }
                    if(dan.lands[k1].landID==-bit.underOne)
                    {
                        trace("find danLand2");
                        bit.underOne=-dan.lands[k1].subID;
                        land=k1;
                        break;
                    }
                }
                trace("bit.underRes="+bit.underRes);
                if (dan.lands[land].building.canWork)
                {
                    dan.lands[land].building.workerChangePosition();
                    dan.lands[land].changePics(magicNumber);
                }
                trace("now close");

                bit.whatUnderOne=-1;
                bit.underRes="";
            }

            if (quest[i].effect[j].typpe=="positionIt") //спозиционировать предметы
            {
                var k:uint;
                while (bit.positionIt.length>0)
                {
                    var res:int=bit.positionIt[0];
                    for (k=0; k<subs.sub.length; k++ )
                    {
                        if (subs.sub[k].iii==res)
                        {
                            subs.sub[k].subX=bit.positionIt[1];
                            subs.sub[k].subY=bit.positionIt[2];
                            bit.positionIt.splice(0,3);
                        }
                    }
                }
            }
            if (quest[i].effect[j].typpe=="visIt") //визуализировать предметы
            {
                var k:uint;
                while (bit.visIt.length>0)
                {
                    var res:int=bit.visIt[0];
                    for (k=0; k<subs.sub.length; k++ )
                    {
                        if (subs.sub[k].iii==res)
                        {
                            if (bit.visIt[1]==1 || bit.visIt[1]==0)
                            {
                                subs.sub[k].vis=bit.visIt[1];
                                subs.sub[k].alph=1;
                            } else
                            {
                                subs.sub[k].vis = 1;
                                subs.sub[k].alph=bit.visIt[1];
                            }
                            bit.visIt.splice(0, 2);
                        }
                    }
                }
            }

            if (quest[i].effect[j].typpe == "darken")
            {
                if (String(quest[i].effect[j].mode)=="off")
                {
                    dan.darkScreen=4;
                }
            }

            if (quest[i].effect[j].typpe == "visOn" && dan.darkScreen!=0)
            {
                //сделать видимым определённый предмет
                for (find_id=0; find_id<subs.sub.length; find_id++)
                {
                    if (subs.sub[find_id].iii==quest[i].effect[j].iii)
                    {
                        trace("vis on="+quest[i].effect[j].iii);
                        //trace("dan.darkScreen="+dan.darkScreen);
                        subs.sub[find_id].vis = 1;
                        break;
                    }
                }
            }
            if (quest[i].effect[j].typpe == "visOff")
            {
                //trace("Vis Off!");
                //trace("quest[i].effect[j].iii="+quest[i].effect[j].iii);
                //сделать видимым определённый предмет
                for (find_id=0; find_id<subs.sub.length; find_id++)
                {
                    if (subs.sub[find_id].iii==quest[i].effect[j].iii)
                    {
                        //trace("find");
                        subs.sub[find_id].vis = 0;
                        break;
                    }
                }
            }

            if (quest[i].effect[j].typpe == "vis")
            {
                //trace("quest[i].effect[j].iii="+quest[i].effect[j].iii);
                var res:int=quest[i].effect[j].iii;
                for (k=0; k<subs.sub.length; k++ )
                {
                    if (subs.sub[k].iii==res)
                    {
                        if (dan.darkScreen==1)
                        {
                            subs.sub[k].alph=1;
                            subs.sub[k].vis=1;
                        }
                        if (dan.darkScreen==0)
                        {
                            subs.sub[k].alph=1;
                            subs.sub[k].vis=0;
                        }
                        //dan.darkScreen=-1;
                        break;
                    }
                }
                dan.darkScreen=-1;
            }

            if (quest[i].effect[j].typpe == "simpleVis")
            {

                for (k=0; k<subs.sub.length; k++ )
                {
                    if (subs.sub[k].iii == quest[i].effect[j].iii)
                    {
                        trace("subs.sub[k].vis="+subs.sub[k].vis);
                        if (subs.sub[k].vis == 1)
                        {
                            subs.sub[k].vis = 0;
                        } else
                        {
                            subs.sub[k].vis = 1;
                        }
                        break;
                    }
                }
            }

            if (quest[i].effect[j].typpe == "buildTap") //выбрано здание
            {
                dan.buildTap=1;
            }

            if (quest[i].effect[j].typpe == "turnOut")
            {//заканчиваем действие перехода
                dan.nextTurn=0;
            }

            if (quest[i].effect[j].typpe == "problemSituation")
            { //проведено строительство, надо создать препятствие build на земле
                trace("here problemSituation");
                var nn:int=-1;
                if (dan.madeBuilding>-1)
                {
                    nn=dan.madeBuilding;
                } else
                {
                    if (quest[i].effect[j].where=="any")
                    {
                        var t=50;
                        while(nn<0 && t>0)
                        {
                            nn = Math.random() * dan.lands.length;
                            if (dan.lands[nn].building.workStopProblem=="")
                            {
                                dan.lands[nn].building.workStopProblem=String(quest[i].effect[j].tip);
                            } else
                            {
                                nn=-1;
                            }
                            t--;
                        }
                    }
                }
                trace("nn="+nn);
                if (nn!=-1)
                {
                    if (dan.madeBuilding==-1)
                    {
                        dan.lands[nn].building.timeToBuild=int(quest[i].effect[j].timme);
                    }
                    dan.lands[nn].building.canWork = false;
                    dan.lands[nn].building.workStopProblem = String(quest[i].effect[j].tip);
                    dan.madeBuilding = -1;
                }
            }

            if (quest[i].effect[j].typpe == "update")
            { //нажата или нет кнопка апдейт
                dan.update=true;
                trace("update begin");
            }

            if (quest[i].effect[j].typpe == "clearUpdates")
            { //зачищаем все окна с инфой о апдейтах
                dan.updChange=true;
                dan.updInfo="";
                dan.updIII=-1;
                dan.updCost="";
                dan.update=true;
            }
            if (quest[i].effect[j].typpe == "buyUpdate")
            { //отплата приобретения апдейта на землю/здание в виде ресурса по его номеру в массиве
                dan.typeOfUpdatePay=int(quest[i].effect[j].res);
                dan.reIncome=true;
                dan.lag=10;
            }

            if (quest[i].effect[j].typpe == "updWaitReady")
            { //1 - показываем доступные апдейты, 0 - купленные
                if (quest[i].effect[j].res==1)
                {
                    dan.updWaitReady = true;
                    dan.updReShow=true;
                } else
                {
                    dan.updWaitReady = false;
                    dan.updReShow=true;
                }
            }

            if (quest[i].effect[j].typpe=="resChange")  //меняем значение ресурса на величину
            {
                for (var zz:int = 0; zz < dan.globalRes.length; zz++)
                {
                    if (
                            dan.globalRes[zz].typpe == String(quest[i].effect[j].tip) &&
                            dan.globalRes[zz].amount > dan.globalRes[zz].min + int(quest[i].effect[j].num))
                    {
                        dan.globalRes[zz].amount += int(quest[i].effect[j].num);
                    }
                }
            }

            if (quest[i].effect[j].typpe=="dxKnown") //сдвиг, на который нужно перемещать панель, когда открыт новый город
            {
                dan.dxKnown=int(quest[i].effect[j].num);
            }

            if (quest[i].effect[j].typpe=="fromAdditionalCityPanel")
            { //меняет состояние отображаемой панели города при выборе в доп.панели
                //bit.mouseParClick == dan.cityStart
                //dan.numOfMany
                var putNum:int=dan.numOfMany;
                trace("fromAdditionalCityPanel");
                trace("dan.numOfMany="+dan.numOfMany);
                while (putNum>=dan.numOfElemsCityPanel)
                {
                    putNum-=dan.numOfElemsCityPanel;
                }
                trace("putNum="+putNum);
                bit.mouseParClick = dan.cityStart;
                trace("dan.knownCities[putNum-1]="+dan.knownCities[putNum-1]);
                dan.numOfMany = dan.cities[dan.knownCities[putNum-1]].elem;
            }

            if (quest[i].effect[j].typpe=="relationChange") //город: влиять на отношения, улучшить
            {
                if (int(quest[i].effect[j].res)==1)//результат положительный
                {
                    //ничего не делаем
                }

            }

            if (quest[i].effect[j].typpe=="getCoords")   //взять координаты предмета
            {
                for (var zz:int=0; zz<subs.sub.length; zz++)
                {
                    if (subs.sub[zz].iii==quest[i].effect[j].iii)
                    {
                        dan.getsetX=subs.sub[zz].subX;
                        dan.getsetY=subs.sub[zz].subY;
                    }
                }
            }
            if (quest[i].effect[j].typpe=="setCoords")   //выставить координаты предмету
            {
                for (var zz:int=0; zz<subs.sub.length; zz++)
                {
                    if (subs.sub[zz].iii==quest[i].effect[j].iii)
                    {
                        if (quest[i].effect[j].xx==0 && quest[i].effect[j].yy==0)
                        {
                            subs.sub[zz].subX = dan.getsetX;
                            subs.sub[zz].subY = dan.getsetY;
                        } else
                        {
                            subs.sub[zz].subX = quest[i].effect[j].xx;
                            subs.sub[zz].subY = quest[i].effect[j].yy;
                        }
                    }
                }
            }
            if (quest[i].effect[j].typpe=="setNowCoords")   //выставить координаты предмету
            {
                for (var zz:int=0; zz<subs.sub.length; zz++)
                {
                    if (subs.sub[zz].iii==quest[i].effect[j].iii)
                    {
                        subs.sub[zz].subX=dan.getsetNowX;
                        subs.sub[zz].subY=dan.getsetNowY;
                    }
                }
            }
            if (quest[i].effect[j].typpe=="cityClose") //выставляем значение для закрытия города в менеджере
            {
                dan.cityClose=true;
            }

            if (quest[i].effect[j].typpe=="heroControl") //выделяем выбранного героя для контроля
            {
                dan.heroChoose=dan.downOfMany;
                trace("dan.heroChoose="+dan.heroChoose);
                trace("dan.numOfSub="+dan.numOfSub);
            }

            if (quest[i].effect[j].typpe=="heroOut") //убираем у героя активность определённого типа (которая сейчас в фокусе)
            {
                trace("delete your hero!");
                if (String(quest[i].effect[j].tip)=="city") //тип активности - город
                {
                    var tt:int=0;
                    var zz:int=0
                    while (zz<dan.currentHeroes.length)
                    {
                        for (var gg:int=0; gg<dan.currentHeroes[zz].needTyppe.length; gg++)
                        {
                            if (dan.currentHeroes[zz].needTyppe[gg]=="city" && dan.currentHeroes[zz].needNum[gg]==dan.currentCity)
                            {
                                dan.currentHeroes[zz].needTyppe.splice(gg,1);
                                dan.currentHeroes[zz].needNum.splice(gg,1);
                                tt=1;
                                break;
                            }
                        }
                        zz++;
                    }
                    if (tt==1)
                    {
                        break;
                    }
                }
                if (String(quest[i].effect[j].tip)=="close") //убрать выделение героя
                {
                    trace("hero close");
                    dan.heroChooseMemory=dan.heroChoose;
                    dan.heroChoose=-1;

                }
            }

            if (quest[i].effect[j].typpe=="gotoFram")  //устанавливаем другой кадр элементу предмета
            {
                for (var jj=0; jj<subs.sub.length; jj++)
                {
                    if (subs.sub[jj].iii==quest[i].effect[j].iii)
                    {
                        subs.sub[jj].changeFrame(quest[i].effect[j].eee, quest[i].effect[j].num);
                        break;
                    }
                }
            }

            if (quest[i].effect[j].typpe=="needFram")  //требуется перепроверить картинки в соответствии с кадрами
            {
                trace("needFram");
                for (var jj=0; jj<subs.sub.length; jj++)
                {
                    if (subs.sub[jj].iii==quest[i].effect[j].iii)
                    {
                        trace("jing!");
                        subs.sub[jj].neddFram=true;
                        break;
                    }
                }
            }

            if (quest[i].effect[j].typpe=="heroStartFinish")  //стартуем или выключаем экран героя
            {
                if (String(quest[i].effect[j].res)=="start")
                {
                    dan.heroStart=true;
                } else
                {
                    dan.heroStart=false;
                }
            }

            if (quest[i].effect[j].typpe=="tradeOffer") //изменения торговли для клиента
            {
                dan.buyOffer=quest[i].effect[j].buy;
                dan.sellOffer=quest[i].effect[j].sell;
            }

            if (quest[i].effect[j].typpe=="clickLike") //меняем индекс нажатого родителя-элемента
            {
                bit.mouseParClick=quest[i].effect[j].iii;
            }

            if (quest[i].effect[j].typpe=="changeLanguage") //смена языка: английский
            {
                bit.textMode=quest[i].effect[j].txt;
            }

            if (quest[i].effect[j].typpe=="deleteModule") //удаляем модуль
            {
                bit.delCommand=true;
                bit.delSubjects=true;
                bit.delScenario=true;
                bit.delModuleName=quest[i].effect[j].moduleName;
                if (quest[i].effect[j].moduleParams=="game")
                {
                    bit.delParameters=true;
                }
            }

            if (quest[i].effect[j].typpe=="behPosFromMess") //заминусовываем переменную, отвечающую за очистку мессенджера
            {
                dan.behPosFromMess=quest[i].effect[j].iii;
            }

            if (quest[i].effect[j].typpe=="messWasTap") //номер элемента в предмете МенюСообщений, который был выбран игроком
            {
                dan.messWasTap=bit.mouseClick;
            }

            if (quest[i].effect[j].typpe=="makeMessage") //точная дата, в которую должно произойти событие
            {
                trace("makeMessage");
                dan.mess.push(new Message());
                dan.mess[dan.mess.length-1].behMenu=quest[i].effect[j].behMenu;
                dan.mess[dan.mess.length-1].iii=quest[i].effect[j].iii;
                dan.mess[dan.mess.length-1].stil=quest[i].effect[j].stil;
                if (int(quest[i].effect[j].activeShow)==1)
                {
                    dan.mess[dan.mess.length - 1].activeShow=true;
                } else
                {
                    dan.mess[dan.mess.length - 1].activeShow=false;
                }
                if (int(quest[i].effect[j].out)==1)
                {
                    dan.mess[dan.mess.length - 1].out=true;
                } else
                {
                    dan.mess[dan.mess.length - 1].out=false;
                }
            }

            if (quest[i].effect[j].typpe=="cityAllianceArmy") //смена логической переменной, отвечающей за то, показывается город или целиком альянс
            {
                trace("quest[i].effect[j].res="+quest[i].effect[j].res);
                if (int(quest[i].effect[j].res)==1)
                {
                    dan.cityAllianceArmy=true;
                } else
                {
                    dan.cityAllianceArmy=false;
                }
                trace("dan.cityAllianceArmy="+dan.cityAllianceArmy);
            }

            if (quest[i].effect[j].typpe == "nextTurn")
            {
                //нажата кнопка нового хода
                bit.sChangeTurn=true;
            }

            if (quest[i].effect[j].typpe == "categoryWillSave") //сменяем категорию показа истории
            {
                dan.categoryWillSave=quest[i].effect[j].num;
            }

            if (quest[i].effect[j].typpe == "heroHistoryChange")//меняем героя при показе истории
            {
                if (quest[i].effect[j].iii==1 && dan.willSave[dan.heroHistoryCategory].heroStory.length-1>dan.historyHeroChoose)
                {
                    dan.historyHeroChoose++;
                }
                if (quest[i].effect[j].iii==0 && dan.historyHeroChoose>0)
                {
                    dan.historyHeroChoose--;
                }
            }
        }
    }
}
}
