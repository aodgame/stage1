/**
 * Created by ��������� on 09.05.2016.
 */
package subjects
{
import collections.inCity.Building;

import story.Danke;

public class SubElementsMenu extends Parent2Subject
{
    public var fram:Vector.<int> = new Vector.<int>(); //������� ��� ������� �������
    //public var neddFram:Boolean=false;

    public var cameraUse:int=0;

    public var modificator:String;
    public var sft:Vector.<String> = new Vector.<String>();

    private var currentInt:int=-1;
    private var currentBool:Boolean=false;

    public var move:Vector.<Boolean> = new Vector.<Boolean>(); //элемент предмета может передвигаться под мышкой
    public var baseX:Vector.<int> = new Vector.<int>();
    public var baseY:Vector.<int> = new Vector.<int>();
    public var wayCount:Vector.<int> = new Vector.<int>(); //на сколько пикселей сдвинут объект
    private var cli:Vector.<int> = new Vector.<int>();
    private var tx:Vector.<int> = new Vector.<int>();
    private var ty:Vector.<int> = new Vector.<int>();

    private var tap:Vector.<int> = new Vector.<int>(); //определяем, был ли нажат элемент
    private var checkWho:Vector.<int> = new Vector.<int>();
    private var checkWith:Vector.<int> = new Vector.<int>();
    private var checkControl:Vector.<int> = new Vector.<int>();

    private var dan:Danke;

    public function SubElementsMenu(myXML, pics, el, ii, moduleName)
    {
        end_load(myXML, ii, pics, el, moduleName);
    }

    override public function work(ii):void
    {
        super.work(ii);
        if (cameraUse==1)
        {
            show();
        }

        if (bit.mouseParUp==iii)
        {
            bit.whatUnderOne=iii;
        }
    }

    override public function getParam(str, num)
    {
        trace(str+":::"+num);
    }

    override public function equalIt(tip):Boolean
    {
        var bool:Boolean = false;
        for (var y:int=0; y<sx.length; y++)
        {
            if (tip=="intro" && tap[y]==1)
            {
                tap[y]=0;
                bool = true;
                break;
            }
            if (tip=="extro" && tap[y]==-1)
            {
                trace("extro out");
                tap[y]=0;
                bool = true;
                break;
            }
        }
        return bool;
    }

    override public function changeFrame(eee, num):void
    {
        fram[eee-1]=num;
        trace("here=")+iii;
        neddFram=true;
    }

    override public function model(el):void
    {
        super.model(el);

        if (modificator=="modification" && dan.updChange) //требуется переформатировать апдейты
        {
            nonMod(el);
        }

        if (modificator=="upds")
        {
            parentUpd(el);
        }

        if (modificator=="")
        {
            makeFram(el);
            if (dan.updChange) //сохраняем для следующего круга, чтобы сделать новый refram
            {
                neddFram = true;
            }
        }

        if (modificator=="standy")
        {
            standardBehavior(el);
        }
    }

    private function controlling(el):void
    {
        var curEl:int=-1;
        var tip:int=0;
        //trace("checkWho.length="+checkWho.length);
        if (checkWho.length==0)
        {
            return;
        }
        //trace("bit.mouseOver="+bit.mouseOver+"; bit.mouseOut="+bit.mouseOut+"; bit.mouseClick="+bit.mouseClick);
       // trace("numOfEl.length="+numOfEl.length);
        for (i = 0; i < numOfEl.length; i++)
        {
            if (bit.mouseClick==numOfEl[i])
            {
                //trace("mouseClick 1="+bit.mouseOver+":i="+i+"; numOfEl="+numOfEl[i]);
                tip=3;
                curEl=i;
                break;
            }
            if (bit.mouseOver==numOfEl[i])
            {
                //trace("mouseOver 1="+bit.mouseOver+":i="+i+"; numOfEl="+numOfEl[i]);
                tip=1;
                curEl=i;
                break;
            }
            if (bit.mouseOut==numOfEl[i] && el[numOfEl[i]].typeOfElement=="txt")
            {
                //trace("mouseOut 1="+bit.mouseOver+":i="+i+"; numOfEl="+numOfEl[i]);
                tip=2;
                curEl=i;
                break;
            }

        }
        if (curEl!=-1)
        {
            //trace("curEl="+curEl);
            for (i=0; i<checkWho.length; i++)
            {
                if (checkWho[i]==curEl && tip==1 && checkControl[i]==0)
                {
                    //trace("checkWho[i]="+checkWho[i]);
                    trace(el[numOfEl[curEl]].typeOfElement+"::"+el[numOfEl[curEl]].iii);
                    checkControl[i]=1;
                    for (var j:int=0; j<checkWho.length; j++)
                    {
                        if (j!=i && checkControl[j]!=0)
                        {
                            checkControl[j]=0;
                            el[numOfEl[checkWith[j]]].pic.width /= 1.15;
                            el[numOfEl[checkWith[j]]].pic.height /= 1.15;
                        }
                    }
                    if (el[numOfEl[curEl]].typeOfElement=="txt")
                    {
                        //trace("txt");
                        el[numOfEl[checkWith[i]]].pic.width *= 1.15;
                        el[numOfEl[checkWith[i]]].pic.height *= 1.15;
                    } else
                    {
                        //trace("pic");
                    }
                    break;
                }
                if (checkWho[i]==curEl && tip==2 && checkControl[i]==1)
                {
                    if (el[numOfEl[curEl]].typeOfElement=="txt")
                    {
                        checkControl[i]=0;
                        el[numOfEl[checkWith[i]]].pic.width /= 1.15;
                        el[numOfEl[checkWith[i]]].pic.height /= 1.15;
                    } else
                    {
                        //el[numOfEl[checkWith[i]]].pic.width /= 1.15;
                    }
                    break;
                }
                if (checkWho[i]==curEl && tip==3)
                {
                    bit.mouseClick=numOfEl[checkWith[i]];
                    for (j=0; j<numOfEl.length; j++)
                    {
                        if (bit.mouseClick==numOfEl[j])
                        {
                            trace("j= dan.behChoice = "+j);
                            dan.behChoice = j;
                            break;
                        }
                    }
                    //trace("bit.mouseClick="+bit.mouseClick);
                    break;
                }
            }
        }
    }

    private function standardBehavior(el):void
    {
        if (vis==1)
        {
            if (iii==483)
            {
                //trace("controlling iii=" + iii);
            }
            controlling(el);

            for (i = 0; i < numOfEl.length; i++)
            {
                if (el[numOfEl[i]].typeOfElement!="txt")
                {
                    el[numOfEl[i]].pic.gotoAndStop(fram[i]);
                }
                if (numOfEl[i] == bit.mouseClick)
                {
                    dan.numOfMany = i+1; //ид никогда не начинаются с нуля
                    dan.numOfSub=iii;
                }
                if (numOfEl[i] == bit.mouseDown)
                {
                    dan.downOfMany = i+1; //ид никогда не начинаются с нуля
                   // dan.numOfSub=iii;
                }

                /*if (sx[i]!=baseX[i] || sy[i]!=baseY[i])
                {
                    wayCount[i]++;
                    if (wayCount[i]>500)
                    {
                        wayCount[i]=100;
                    }
                } else
                {
                    if (wayCount[i]>10)
                    {
                        wayCount[i]=10;
                    } else
                    {
                        wayCount[i]=0;
                    }
                }*/
            }

            //для движимых предметов
            var t:int=0;
            for (var j:int=0;j<move.length; j++)
            {
                if (move[j] && specID[j].substr(0,3)=="mov")// && fram[j]>=2)
                {
                    t++;
                    mouseMoveElement(j, el, t);
                }
                if (move[j] && specID[j].substr(0,2)=="go")// && fram[j]>=2)
                {
                    t++;
                    mouseMoveSubject(j, el, t);
                    if (vis==1)
                    {
                        dan.getsetNowX=subX;
                        dan.getsetNowY=subY;
                    }
                }

                if (specID[j].substr(0,4)=="show")// && fram[j]>=2)
                { //блок элементов, которые приходится вписывать в игру из-за недостаточной гибкости используемого метапрограммирования на базе xml
                    //show:cRel кадр с отношениями этого города к городу клиента
                    //trace("her the city");
                    if (specID[j].substr(5,4)=="cRel")
                    {
                        fram[j]=dan.currRelations;
                        //el[numOfEl[i]].pic.gotoAndStop(fram[i]);
                    }
                    //show:cRel кадр со значением мир/война между городами
                    if (specID[j].substr(5,4)=="cPvW")
                    {
                        fram[j]=dan.currPeaceWar+1;
                        //el[numOfEl[i]].pic.gotoAndStop(fram[i]);
                    }
                }
                if (specID[j]=="currHero")
                {
                    if (dan.heroChoose>0)
                    {
                        if (fram[j] != dan.currentHeroes[dan.heroChoose - 1].iii)
                        {
                            trace("dan.currentHeroes[dan.heroChoose-1].iii=" + dan.currentHeroes[dan.heroChoose - 1].iii);
                            fram[j] = dan.currentHeroes[dan.heroChoose - 1].iii;
                            neddFram=true;
                        }
                    } else
                    {
                        if (fram[j]!=1)
                        {
                            fram[j]=1;
                        }
                    }
                }
            }
        }
    }

    private function mouseMoveSubject(num, el, t):void
    {
        if (cli[num]==1)
        {
            if (bit.dm==0)
            {
                cli[num]=0;
                //sx[num]=baseX[num];
                //sy[num]=baseY[num];
                bit.cliX=bit.sx;
                bit.cliY=bit.sy;

            } else
            {
                subX=bit.sx+tx[num];
                subY=bit.sy+ty[num];
            }
        }
        if (bit.mouseParDown==iii)
        {
            if (bit.mouseDown==el[numOfEl[num]].iii)
            {
                cli[num] = 1;
                tx[num] = subX - bit.sx;
                ty[num] = subY - bit.sy;
            }
        }
    }

    private function mouseMoveElement(num, el, t):void
    {
        if (cli[num]==1)
        {
            if (bit.dm==0)
            {
                if (sx[num] - baseX[num] < 10 && sx[num] - baseX[num] > -10 && sy[num] - baseY[num] < 10 && sy[num] - baseY[num] > -10)
                {
                    tap[num]=1;
                } else
                {
                    tap[num]=-1;
                }
                cli[num]=0;
                sx[num]=baseX[num];
                sy[num]=baseY[num];

            } else
            {
                sx[num]=bit.sx+tx[num];
                sy[num]=bit.sy+ty[num];

                wayCount[num]++;
            }
        }
        if (bit.mouseParDown==iii)
        {
            if (bit.mouseDown==el[numOfEl[num]].iii)
            {
                cli[num] = 1;
                tx[num] = sx[num] - bit.sx;
                ty[num] = sy[num] - bit.sy;
                wayCount[num]=0;
            }
        }



        /*if (sx[i]!=baseX[i] || sy[i]!=baseY[i])
        {
            wayCount[i]++;
            if (wayCount[i]>500)
            {
                wayCount[i]=100;
            }
        } else
        {
            if (wayCount[i]>10)
            {
                wayCount[i]=10;
            } else
            {
                wayCount[i]=0;
            }
        }*/
    }

    private function parentUpd(el):void
    {
        if (dan.landInWork != -1) //отображаем апдейты над землёй
        {
            if (currentInt != dan.landInWork || currentBool != dan.lands[dan.landInWork].building.canWork || dan.updReShow)
            {
                dan.updReShow=false;
                currentBool = dan.lands[dan.landInWork].building.canWork;
                currentInt = dan.landInWork;
                //trace("upds Land=" + dan.landInWork);
                updMod(el);
            }
        }

        if ((dan.landInWork == -1 && currentInt != -1) || dan.localResChange) //удаляется картинка апдейта при разрушении здания
        {
            dan.updChange = true;
            dan.updInfo = "";
            dan.updIII = -1;
            dan.updCost = "";
            dan.update = true;

            dan.updateTap = -1;

            currentInt = -1;
            for (i = 0; i < numOfEl.length; i++)
            {
                el[numOfEl[i]].pic.gotoAndStop(1);
            }
            while (sft.length > 0)
            {
                sft.pop();
            }
            dan.localResChange = false;
        }

        if (bit.mouseClick != -1 && dan.landInWork!=-1) //получаем информацию о том, какой из апдейтов выделен
        {
            if (dan.updWaitReady) //для доступных апгрейдов
            {
                for (i = 0; i < numOfEl.length; i++)
                {
                    if (bit.mouseClick == el[numOfEl[i]].iii && sft.length>0)
                    {
                        dan.updInfo = "$mod" + sft[i];
                        for (var k:int = 0; k < dan.updates.length; k++)
                        {
                            if (dan.updates[k].iii == int(sft[i]))
                            {
                                dan.updateTap = k; //сохраняем, какой апдейт выделен игроком
                            }
                        }
                        //trace(" dan.updInfo=" + dan.updInfo);
                        dan.updIII = i;
                        break;
                    }
                }
            } else //для купленных апгрейдов
            {
                var b:Building=dan.lands[dan.landInWork].building;
                for (i = 0; i < numOfEl.length; i++)
                {
                    if (bit.mouseClick == el[numOfEl[i]].iii && i<b.madeUpdates.length)
                    {
                        for (var k:int=0; k<dan.updates.length; k++)
                        {
                            if (b.madeUpdates[i]==dan.updates[k].iii)
                            {
                                dan.updInfo = "$mod" + dan.updates[k].iii;
                                dan.updateTap = k; //сохраняем, какой апдейт выделен игроком
                                dan.updIII = i;
                                break;
                            }
                        }
                    }
                }
            }
        }
    }

    private function updMod(el):void
    {
        //trace("dan.updWaitReady="+dan.updWaitReady+"; dan.updReShow="+dan.updReShow);
        var b:Building=dan.lands[dan.landInWork].building;
        var alreadyRemembed:Vector.<int> = new Vector.<int>();
        var currentEl:int=0;
        if (dan.updWaitReady) //возможные апдейты (что отображать)
        {
            for (i=0; i<numOfEl.length; i++) //очищаем картинку
            {
                el[numOfEl[i]].pic.gotoAndStop(0);
            }

            if (!b.canWork || b.timeToBuild!=0)
            {
                return;
            }
            //trace("dan.updWaitReady="+dan.updWaitReady);
            var position:int=0;
            for (i=0; i<dan.updates.length; i++) //проходим по всем апдейтам
            {
                if (dan.updates[i].isOpened!=1) //апдейт недоступен - уходим отсюда
                {
                    continue;
                }
                //trace("available");
                var unknown:Boolean=true;
                for (var j:int=0; j<b.madeUpdates.length; j++) //проверяем, а вдруг этот апдейт уже исследован
                {
                    if (b.madeUpdates[j]==dan.updates[i].iii)
                    {
                        unknown=false;
                        break;
                    }
                }
                if (unknown)
                {
                    unknown=false;
                } else
                {
                    continue;
                }
                //trace("don't use");
                for (var j:int=0; j<dan.updates[i].tip.length; j++) //проверяем апдейты в соответствии с текущим зданием
                {
                    if (dan.updates[i].tip[j]=="increaseResource" && dan.updates[i].iid[j]==b.iii) //увеличиваем один из ресурсов земли
                    {
                        unknown=true;
                        break;
                    }
                }
                if (unknown)
                {
                    //trace("It's our update");
                    for (var j:int=0; j<alreadyRemembed.length; j++) //проверяем, не упоминали ли этот апдейт раньше
                    {
                        if (alreadyRemembed[j]==dan.updates[i].iii)
                        {
                            unknown=false;
                            break;
                        }
                    }
                }
                if (unknown) //отображаем его в списке апдейтов
                {
                    //trace("don't search already");
                    alreadyRemembed.push(dan.updates[i].iii);
                    sft.push(dan.updates[i].iii);
                    //dan.updateTap=i; //сохраняем, какой апдейт выделен игроком
                    el[numOfEl[currentEl]].pic.gotoAndStop(dan.updates[i].iii+3);
                    position=1;

                    currentEl++;
                } else
                {
                   // el[numOfEl[currentEl]].pic.gotoAndStop(2);
                }
            }

            for (i=currentEl; i<numOfEl.length; i++) //проходим по всем апдейтам
            {
                sft.push(0);
                el[numOfEl[i]].pic.gotoAndStop(2);
            }

        } else //купленные апдейты
        {
            for (var j:int=0; j<numOfEl.length; j++)
            {
                if (j<b.madeUpdates.length)
                {
                    el[numOfEl[j]].pic.gotoAndStop(b.madeUpdates[j]+3);//dan.updates[j].iii+3);

                } else
                {
                    el[numOfEl[j]].pic.gotoAndStop(2);
                }
            }
        }
    }

    private function nonMod(el):void
    {
            var startNum:int=0;
            for (i=0; i<numOfEl.length; i++)
            {
                if (el[numOfEl[i]].typeOfElement!="txt")
                {
                    el[numOfEl[i]].pic.gotoAndStop(dan.updates[i].iii+1);
                    if (dan.updates[i].isOpened==-1)
                    {
                        el[numOfEl[i]].pic.status.gotoAndStop(1);
                    }
                    if (dan.updates[i].isOpened==0)
                    {
                        el[numOfEl[i]].pic.status.gotoAndStop(2);
                    }
                    if (dan.updates[i].isOpened==1)
                    {
                        el[numOfEl[i]].pic.status.gotoAndStop(3);
                    }
                }
            }
        for (i=0; i<numOfEl.length; i++)
        {
            if (bit.mouseClick == el[numOfEl[i]].iii)
            {
                dan.updInfo = sft[i];
                dan.updIII = i;
                break;
            }
        }
    }

    private function makeFram(el):void
    {
        if (neddFram)
        {
            neddFram = false;
            var startNum:int = 0;
            for (i = 0; i < numOfEl.length; i++)
            {
                if (el[numOfEl[i]].typeOfElement != "txt")
                {
                    el[numOfEl[i]].pic.gotoAndStop(fram[i]);

                    if (modificator == "" && specID[i].length > 3 && specID[i].substr(0, 3) == "btn")
                    {
                        startNum++;
                        var res:Boolean=true;
                        //trace("current land="+dan.landInWork);
                        for (var s:int=0; s<dan.buildings[startNum].notBuildLand.length; s++) //не запрещена ли местность для постройки
                        {
                            //trace("dan.buildings[startNum].notBuildLand[s]="+dan.buildings[startNum].notBuildLand[s]);
                            if (dan.buildings[startNum].notBuildLand[s]-1==dan.landInWork)
                            {
                                res=false;
                                break;
                            }
                        }
                        if (!res || !dan.buildings[startNum].canBuild)
                        {
                            el[numOfEl[i]].pic.gotoAndStop(2);
                        } else
                        {
                            el[numOfEl[i]].pic.gotoAndStop(1);
                        }
                    }
                }
            }
        }

    }

    override protected function end_load(myXML, ii, pics, el, moduleName):void
    {
        super.end_load(myXML, ii, pics, el, moduleName);
        dan = Danke.getInstance();

        if (myXML.camera=="1")
        {
            cameraUse = 1;
        }

        modificator=myXML.type.@modificator;

        for (i=0; i<myXML.pos.length(); i++)
        {
            subs.push("mc");
            visOne.push(1);
            sx.push(myXML.pos[i].@xx);
            sy.push(myXML.pos[i].@yy);

            if (myXML.pos[i].@ww!="0")
            {
                sw.push(myXML.pos[i].@ww);
            } else
            {
                sw.push(0);
            }
            if (myXML.pos[i].@hh!="0")
            {
                sh.push(myXML.pos[i].@hh);
            } else
            {
                sh.push(0);
            }
            specID.push(myXML.pos[i].@spec);
            sft.push(myXML.pos[i].@inf);
            fram.push(myXML.pos[i].@fram);
            neddFram=true;

            if (specID[specID.length-1].substr(0,3)=="mov" || specID[specID.length-1].substr(0,2)=="go")
            {
                move.push(true);
            }else
            {
                move.push(false);
            }
            baseX.push(sx[sx.length-1]);
            baseY.push(sy[sy.length-1]);
            wayCount.push(0);
            cli.push(0);
            tx.push(0);
            ty.push(0);

            tap.push(0);
        }

        for (i=0; i<myXML.txt.length(); i++)
        {
            subs.push("txt");
            visOne.push(1);
            sx.push(myXML.txt[i].@xx);
            sy.push(myXML.txt[i].@yy);
            sw.push(0);
            sh.push(0);
            wayCount.push(0);
            var str:String=myXML.txt[i].@id;
            specID.push(str);
            picAddr.push(new String(""));

            move.push(false);
            baseX.push(0);
            baseY.push(0);
            cli.push(0);
            tx.push(0);
            ty.push(0);
            tap.push(0);
        }

        for (i=0; i<myXML.check.length(); i++)
        {
            checkWho.push(new int(myXML.check[i].@_who));
            checkWith.push(new int(myXML.check[i].@_with));
            checkControl.push(0);
        }
        for (i=0; i<checkWho.length; i++)
        {
            trace(i+"; checkWho="+checkWho[i]+"; checkWith="+checkWith[i]);
        }

        ready=true;
    }
}
}