/**
 * Created by alexo on 26.04.2016.
 */
package collections.inCity
{
import collections.*;
import collections.inCity.Building;

import D3.Bitte;

import story.Danke;

public class Land
{
    public var xx:int;
    public var yy:int;
    public var id:int;
    public var subID:int;
    public var landID:int;
    public var res:String;
    public var elemTyppe:Vector.<String> = new Vector.<String>();

    public var elemID:Vector.<int> = new Vector.<int>();
    public var elemPic:Vector.<int> = new Vector.<int>();
    public var elemIncome:Vector.<int> = new Vector.<int>();
    private var previousNumOfWorkers:int;
    public var currentNumOfWorkers:int;

    private var bit:Bitte;
    private var dan:Danke;

    public var building:Building;

    public var depends:Vector.<int> = new Vector.<int>();

    public function Land()
    {
        bit = Bitte.getInstance();
        dan=Danke.getInstance();
        xx=0;
        yy=0;
        id=-1;
        subID=-1;
        building = new Building();
        previousNumOfWorkers=-1;
        currentNumOfWorkers=0;
        elemTyppe = new Vector.<String>();
    }

    private function workersSumm():int
    {
        var n:int=0;
        for (var i:int=0; i<building.currWorkersOnPlace.length; i++)
        {
            if (building.currWorkersOnPlace[i]>0)
            {
                n++;
            }
        }
        return n;
    }

    public function situationRePic():void
    {
        //делаем пересчёт с учётом границ
        var num:int=0;
        for (var i:int=0; i<depends.length; i++)
        {
            for (var j:int=0; j<dan.lands.length; j++)
            {
                if (dan.lands[j].id==depends[i] &&
                        (dan.lands[j].building.workStopProblem!="" && dan.lands[j].building.workStopProblem!="build" && dan.lands[j].building.workStopProblem!="no"))
                { //нашли соответствие с землёй и нашли, что там какая-то проблема
                    num++;
                }
            }
        }
        if (depends.length>0 && num==depends.length && (building.workStopProblem=="" || building.workStopProblem=="build" || building.workStopProblem=="no" || building.workStopProblem=="wait"))
        {
            building.canWork=false;
            building.timeToBuild=-1;
            building.workStopProblem="wait";
        } else
        {
            if (building.workStopProblem=="wait")
            {
                trace("building.workStopProblem==wait");
                building.canWork=true;
                building.timeToBuild=0;
                building.workStopProblem="no";
            }
        }


        building.situationControl();

        //проверяем соответствие типов глобальных ресурсов к тем, что на данной земле в текущий момент
        if (res!=building.landResType || elemTyppe.length==0)
        {
            elemTyppe = new Vector.<String>();
            res=building.landResType;
            for (var j:int=0; j<dan.landRes.length; j++)
            {
                if (res==dan.landRes[j].typpe)
                {
                    for (var k:int=0; k<dan.landRes[j].globalResTyppe.length; k++)
                    {
                        elemTyppe.push(dan.landRes[j].globalResTyppe[k]);
                    }
                }
            }
            trace("id="+id);
            for (var j:int=0; j<elemTyppe.length; j++)
            {
                trace(elemTyppe[j]);
            }
        }

        //проверяем необходимость перерисовки объектов
        if (building.canWork && elemPic[elemPic.length-1]>1)
        {
            elemPic[elemPic.length-1]=1;
        }
        if (!building.canWork && elemPic[elemPic.length-1]==1)
        {
            for (var j:int=0; j<dan.problemSituation.length; j++)
            {
                if (building.workStopProblem==dan.problemSituation[j].typpe)
                {
                    elemPic[elemPic.length - 1] = j+1;
                    break;
                }
            }
        }
    }

    public function changePics(magicConst1):void
    {
        if (previousNumOfWorkers==-1)
        {
            previousNumOfWorkers=0;
            previousNumOfWorkers=workersSumm();
            currentNumOfWorkers=previousNumOfWorkers;
        }
        //trace("Hello Land!");

        currentNumOfWorkers=workersSumm();
        for (var i:int=0; i<elemIncome.length; i++)
        {
            if (previousNumOfWorkers>1)
            {
                elemIncome[i] /= previousNumOfWorkers;
            }
            if (currentNumOfWorkers>1)
            {
                elemIncome[i] *= currentNumOfWorkers;
            }
        }
        previousNumOfWorkers=currentNumOfWorkers;

        for (var i:int=0; i<building.currWorkersOnPlace.length; i++)
        {
            if (building.currWorkersOnPlace[i]==-1)
            {
                elemPic[Stats.FIRST_BUILDING_FRAME + i]=1;
                continue;
            }
            if (building.currWorkersOnPlace[i]==0)
            {
                elemPic[Stats.FIRST_BUILDING_FRAME + i]=2;
                continue;
            }
            elemPic[Stats.FIRST_BUILDING_FRAME + i] = building.currWorkersOnPlace[i] + magicConst1;
        }
    }
}
}