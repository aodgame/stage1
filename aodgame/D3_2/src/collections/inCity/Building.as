/**
 * Created by alexo on 03.05.2016.
 */
package collections.inCity
{
import collections.*;

import D3.Bitte;
import story.Danke;

public class Building
{
    private var dan:Danke;
    private var bit:Bitte;

    public var iii:int; //индекс типа здания
    public var landResType:String; //какой ресурс производит (связан с LandRes, у которого связь с GlobalRes)
    public var baseLandResType:String;
    public var name:String;
    public var description:String;

    public var baseTyppeOfBuilding:String;

    public var notBuildLand:Vector.<int> = new Vector.<int>(); //список земель, где стройка конкретного строения невозможна

    public var baseBuilding:Boolean; //является ли базовым для локации (то есть появляется автоматически, если больше ничего нет)
    public var canBuild:Boolean; //здание разрешено/запрещено строить
    public var canWork:Boolean; //зданию разрешено/запрещено работать
    public var workStopProblem:String; //причина, по которой строение не работает
    public var globalResNeedToWork:Vector.<String> = new Vector.<String>(); // перечисление глобальных ресурсов, необходимых для работы (любой из)
    public var globalResNeedToWorkCons:Vector.<int> = new Vector.<int>(); // подсказка на номер изображения ресурса в массиве
    public var currWorkplace:Vector.<int> = new Vector.<int>(); //собственно, количество каждого из необходимых ресурсов
    public var currWorkersOnPlace:Vector.<int> = new Vector.<int>(); //по порядку, какой тип globalResNeedToWork стоит на позициях 1-...

    public var madeUpdates:Vector.<int> = new Vector.<int>(); //перечисление исследований, совершённых для конкретного строения
    public var maxWorkplace:int; //количество доступных рабочих мест

    public var costToBuild:Vector.<int> = new Vector.<int>(); //необходимое количество ресов для постройки
    public var typeOfBuildRes:Vector.<String> = new Vector.<String>(); //необходимые типы ресов для постройки
    public var timeToBuild:int;

    private var i:int;

    /*
    ** Если по результатам работы здания, ресы в Danke уходят в минус, здание не срабатывает в этом ходу
     */
    public function Building()
    {
        workStopProblem="";
        dan = Danke.getInstance();
        bit = Bitte.getInstance();
        i=0;
        iii=-1;
        landResType="";
        baseLandResType="";
        name="";
        description="";
        baseTyppeOfBuilding="";
        baseBuilding=false;
        canBuild=false;
        canWork=true;
        maxWorkplace=0;
        timeToBuild=0;
        currWorkersOnPlace.push(-1);
        currWorkersOnPlace.push(-1);
        currWorkersOnPlace.push(-1);
    }

    //public var underOne:int=-1; //над каким из ландшафтов происходит событие
    //public var whatUnderOne:int=-1; //с каким элементом происходит событие
    //public var underRes:int=-1; //какой рес связан с элементом whatUnderOne

    public function situationControl():void
    {
        if (timeToBuild>0 && bit.sChangeTurn)
        {
            timeToBuild--;
        }
        if (!canWork && timeToBuild==0)
        {
            canWork=true;
            //timeToBuild=-1;
        }
    }

    public function dependsControl():void
    {

    }

    public function workerChangePosition():void
    {
        trace("Hello Building! "+bit.underOne);
        if (bit.underOne>0) //ставим работника на рабочее место
        {
            for (i=0; i<dan.globalRes.length; i++)
            {
                if (dan.globalRes[i].typpe==bit.underRes)//проверяем, есть ли свободный рес
                {
                    if (dan.globalRes[i].freeAmount<=0)
                    {
                        return; //свободного ресурса нет
                    }
                }
            }
            var spec:int=0;
            for (i=0; i<currWorkersOnPlace.length; i++) //проверяем, есть ли свободные рабочие места
            {
                if (currWorkersOnPlace[i]>0)
                {
                    spec++;
                }
            }
            if (spec>=maxWorkplace)
            {
                return;
            }

            var _typpe:int=-1;
            for (i=0;i<currWorkplace.length; i++)
            {
                if (globalResNeedToWork[i]==bit.underRes) //проверяем, нужен ли нам именно текущий ресурс
                {
                    currWorkplace[i]++;
                    _typpe=i;
                    break;
                }
            }
            for (var jj:int=0; jj<currWorkersOnPlace.length; jj++)
            {
                if (currWorkersOnPlace[jj]==0 && _typpe>=0)
                {
                    currWorkersOnPlace[jj]=globalResNeedToWorkCons[_typpe]+1; //_typpe+1; //вынужденно прибавляем единицу, чтобы не пересечься с началом массива отображений в elemPic
                    dan.reIncome=true;
                    break;
                }
            }
        } else //убираем работника
        {
            //trace("currWorkersOnPlace[bit.whatUnderOne]="+currWorkersOnPlace[bit.whatUnderOne]);
            for (var s:int=0; s<globalResNeedToWorkCons.length; s++)
            {
                if (globalResNeedToWorkCons[s]==currWorkersOnPlace[bit.whatUnderOne]-1)
                {
                    currWorkplace[s]--;
                }
            }
            currWorkersOnPlace[bit.whatUnderOne]=0;
            dan.reIncome=true;
        }
    }

    public function create():void
    {
        var j:int=0;
        for (i=0; i<dan.buildings.length; i++)
        {
            if (dan.buildings[i].iii==iii)
            {
                j=i;
                break;
            }
        }
        if (dan.buildings[j].landResType=="custom")
        {
            landResType=baseLandResType;
        }
        name=dan.buildings[j].name;
        description=dan.buildings[j].description;
        baseBuilding=dan.buildings[j].baseBuilding;
        canBuild=dan.buildings[j].canBuild;
        for (i=0; i<dan.buildings[j].globalResNeedToWork.length; i++)
        {
            globalResNeedToWork.push(dan.buildings[j].globalResNeedToWork[i]);
            globalResNeedToWorkCons.push(dan.buildings[j].globalResNeedToWorkCons[i]);
            currWorkplace.push(0);
        }
        costToBuild=dan.buildings[j].costToBuild;
        typeOfBuildRes=dan.buildings[j].typeOfBuildRes;
        timeToBuild=dan.buildings[j].timeToBuild;
        maxWorkplace=dan.buildings[j].maxWorkplace;
        for (i=0; i<maxWorkplace; i++)
        {
            currWorkersOnPlace[i]=0;
        }
    }
}
}