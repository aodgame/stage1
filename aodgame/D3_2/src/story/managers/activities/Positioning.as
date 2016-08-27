/**
 * Created by alexo on 22.08.2016.
 */
package story.managers.activities
{
import collections.behavior.BehPositioning;

public class Positioning
{
    private var numOfRes:int;
    private var i:int;
    private var j:int;

    private var behPos:int=-1;
    private var landNum:int=-1;
    private var curLand:int=-1;
    private var heroChoice:int=-1; //номер героя
    private var behActChoice:int=-1; //номер выбора в массиве менюшек

    public function Positioning()
    {
        numOfRes=-1;
        i=0;
        j=0;
    }

    public function clear():void
    {
        numOfRes=-1;
        curLand=-1;
        heroChoice=-1;
        behActChoice=-1
    }
    public function return_BehPos():int
    {
        return behPos;
    }
    public function return_LandNum():int
    {
        return landNum;
    }
    public function return_CurLand():int
    {
        return curLand;
    }
    public function return_HeroChoice():int
    {
        return heroChoice;
    }

    public function return_behActChoice():int
    {
        return behActChoice;
    }

    public function posMess(dan):Boolean
    {
        if (dan.behPosFromMess!=-1)
        {
            numOfRes = -2;
            return true;
        }
        return false;
    }

    public function positioning(bit, dan, sub):Boolean
    {
        dan.overCity=-1;
        behPos=-1;
        trace(bit.mouseParClick);
        trace(bit.mouseClick);
        trace(dan.heroChoose);
        trace(dan.heroIII);
        //trace("posit prefirst");
        landNum=-1;
        if (bit.mouseParClick==dan.heroIII && bit.mouseParClick!=-1)
        {
            //trace("equalisation");
            var h:int=-1;
            for (i=0; i<sub.length; i++)
            {
                if (sub[i].iii==dan.heroIII)
                {
                    h=i;
                    break;
                }
            }
            //trace("h="+h);
            if (h!=-1)
            {
                trace(sub[h].sx[dan.heroChoose-1]+"::"+sub[h].baseX[dan.heroChoose-1]);
                trace(sub[h].sy[dan.heroChoose-1]+"::"+sub[h].baseY[dan.heroChoose-1]);
                if (sub[h].wayCount[dan.heroChoose-1]<10)
                {
                    //trace("false;");
                    return false;
                }
            }

        }
        //trace("posit first");
        var res:Boolean = false;
        var bool:Boolean=false;

        //trace(dan.heroChoose);
        heroChoice=dan.heroChoose; //[0]=1, [1]=2...
        for (i=0; i<dan.behPos.length; i++)
        {
            //trace("i="+i);
            var bp:BehPositioning = dan.behPos[i];
            behPos=i;
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
                            if (
                                    (dan.clouds[j].vis) &&
                                    (bit.sx > dan.clouds[j].xx - dan.clouds[j].ww/2) && (bit.sx < dan.clouds[j].xx + dan.clouds[j].ww/2) &&
                                    (bit.sy > dan.clouds[j].yy - dan.clouds[j].hh/2) && (bit.sy < dan.clouds[j].yy + dan.clouds[j].hh/2))
                            {
                                landNum = 0;
                                bool = true;
                                break;
                            }
                        }
                    }
                    break;
                case "city": //герой над городом на карте мира
                    if (dan.currentCity==-1)
                    {
                        for (j = 0; j < dan.cities.length; j++)
                        {
                            if (bit.sx > dan.cities[j].xx - dan.cities[j].ww / 2 && bit.sx < dan.cities[j].xx + dan.cities[j].ww / 2 &&
                                    bit.sy > dan.cities[j].yy - dan.cities[j].yy / 2 && bit.sy < dan.cities[j].yy + dan.cities[j].yy / 2)
                            {
                                if ((bp.whereParam=="war" && dan.cities[j].peacewar[0]==1) ||
                                        (bp.whereParam=="peace" && dan.cities[j].peacewar[0]==0))
                                {
                                    landNum = j;
                                    trace("city landNum=" + landNum);
                                    dan.overCity = j;
                                    bool = true;
                                    break;
                                }
                            }
                        }
                    }
                    break;
                default:
                    continue;
            }
            if (bool)
            {
                trace("dan.lands[landNum].building.workStopProblem="+dan.lands[landNum].building.workStopProblem);
                trace("bp.warning="+bp.warning);

                if (bp.warning != "" && bp.where!="cloud" && bp.where!="city") //bp.warning != "no" &&
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
                trace("next one");
                res = true;
                numOfRes = i;

                //trace("dan.behPos[numOfRes].iii="+dan.behPos[numOfRes].iii);
                //trace("numOfRes="+numOfRes);
                //trace("dan.behPos[numOfRes].resIII="+dan.behPos[numOfRes].resIII);
                break;
            }
        }
        trace("res="+res);
        return res;
    }

    public function makeMenu(dan):void
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
        //trace("dan.heroMenuActivity="+dan.heroMenuActivity);
        numOfRes=-1;

        var z:int=-1;
        for (var j:int = 0; j < dan.behMenu.length; j++)
        {
            //trace("dan.behMenu[j]="+dan.behMenu[j].iii);
            if (dan.behMenu[j].iii==dan.heroMenuActivity)
            {
                z=j;
                break;
            }
        }
        if (z!=-1)
        {
            //trace("dan.behMenu[z].iii=" + dan.behMenu[z].iii);
            dan.heroMenuNum = dan.behMenu[z].choicerBehActivity.length;
            //trace("dan.heroMenuNum=" + dan.heroMenuNum);
            behActChoice = z;
            //trace("behActChoice" + behActChoice);
            heroCostPanelMaker(dan);
        }
    }

    public function heroCostPanelMaker(dan):void
    {
        var z:int=0;
        for (var j:int = 0; j < dan.behMenu.length; j++)
        {
            if (dan.behMenu[j].iii==dan.heroMenuActivity)
            {
                trace(dan.behMenu[j].iii);
                z=j;
                //trace("beh menu z=="+z);
                break;
            }
        }

        //trace("dan.behMenu[z].fram.length="+dan.behMenu[z].fram.length);
        while (dan.messFramsOfFramCost.length>0)
        {
            dan.messFramsOfFramCost.pop();
            dan.messFramsOfNumCost.pop();
        }
        for (var j:int=0; j<dan.behMenu[z].fram.length; j++)
        {
            //trace(dan.behMenu[z].fram[j]+"::"+dan.behMenu[z].framNum[j]);
            dan.messFramsOfFramCost.push(dan.behMenu[z].fram[j]);
            dan.messFramsOfNumCost.push(dan.behMenu[z].framNum[j]);
        }
    }
}
}
