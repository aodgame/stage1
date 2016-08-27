/**
 * Created by alexo on 11.05.2016.
 */
package story.managers
{
import story.*;

import collections.inCity.Building;
import D3.Bitte;

public class BuildingManager
{
    private var bit:Bitte;
    private var dan:Danke;
    private var i:int=0;
    private var bTyppe:int=-1; //номер предмета buildingMenu в массиве предметов

    public function BuildingManager()
    {
        bit=Bitte.getInstance();
        dan=Danke.getInstance();
    }

    public function work(subs):void
    {
        if (dan.buildTap==1)
        {
            analyzeTap(subs);
            dan.buildTap=-bit.mouseClick;
        }
    }

    private function analyzeTap(subs):void
    {
        trace("analyzeTap=");
        bTyppeControl(subs);

        for (i=0;i<subs[bTyppe].idOfEl.length; i++)
        {
            trace(i+"; "+subs[bTyppe].idOfEl[i]+"::bit.mouseClick="+bit.mouseClick+";; subs[bTyppe].specID[i].substr(0, 3)="+subs[bTyppe].specID[i].substr(0, 3));
            if (subs[bTyppe].idOfEl[i]==bit.mouseClick && subs[bTyppe].specID[i].substr(0, 3)=="btn")
            {
                trace("btnclick");
                //нашли, что нажата кнопка постройки здания
                var yy:int = 3;
                var z:int = 0;
                while(yy<subs[bTyppe].specID[i].length)
                {
                    z= z*10 + int(subs[bTyppe].specID[i].substr(yy, 1));
                    yy++;
                }
               // var z:int=int(subs[bTyppe].specID[i].substr(3, 1));
                if (controlOfPossible(z) && findMoney(z))
                {
                    deleteWorkers();
                    reBuilding(z);
                    dan.madeBuilding=dan.landTap;// запоминаем для movie, что здание было изменено
                    dan.globalResChange=true;
                    dan.localResChange=true;

                    //текстовка с подсказкой
                    dan.landInfoText="$lan"+dan.lands[dan.landTap].description+"+"+dan.lands[dan.landTap].building.description;
                    trace("Changed info about the land");
                }
            }
        }
    }

    private function bTyppeControl(subs):void //проверяем, что уже знаем номер элемента buildingMenu в векторе
    {
        if (bTyppe==-1 || subs[bTyppe].typpe!="buildingMenu")
        {
            for (i = 0; i < subs.length; i++)
            {
                if (subs[i].typpe=="buildingMenu" && subs[i].modificator=="")
                {
                    bTyppe=i;
                    trace("bTyppe="+bTyppe);
                    break;
                }
            }
        }
    }

    private function controlOfPossible(z):Boolean
    {
        if (z==1&&
                (dan.lands[dan.landTap].building.workStopProblem=="" || dan.lands[dan.landTap].building.workStopProblem=="no"))
        {
            return true;
        }
        if(z>1 && dan.lands[dan.landTap].building.baseTyppeOfBuilding=="custom" && dan.lands[dan.landTap].building.canBuild &&
                (dan.lands[dan.landTap].building.workStopProblem=="" || dan.lands[dan.landTap].building.workStopProblem=="no"))
        {
            return true;
        }
        return false;
    }

    private function findMoney(z):Boolean
    {
        //сначала проверим, хватает ли нам денег
        for (var j:int=0; j<dan.buildings[z].typeOfBuildRes.length; j++)
        {
            for (var k:int=0; k<dan.globalRes.length; k++)
            {
                if (dan.globalRes[k].typpe==dan.buildings[z].typeOfBuildRes[j] &&
                        dan.globalRes[k].amount<dan.buildings[z].costToBuild[j])
                {
                    return false;
                }
            }
        }
        //а затем выцсчитываем стоимость здания из наших ресурсов
        for (var j:int=0; j<dan.buildings[z].typeOfBuildRes.length; j++)
        {
            for (var k:int=0; k<dan.globalRes.length; k++)
            {
                if (dan.globalRes[k].typpe==dan.buildings[z].typeOfBuildRes[j])
                {
                    dan.globalRes[k].amount-=dan.buildings[z].costToBuild[j];
                    break;
                }
            }
        }
        return true;
    }

    private function deleteWorkers():void
    {
        var building:Building=dan.lands[dan.landTap].building;

        for (var j:int=0; j<building.currWorkersOnPlace.length; j++) //проходим по всем рабочим местам
        {
            if (building.currWorkersOnPlace[j]>0) //если рабочего нашли
            {
                var itNum:int=-1;
                for (var k:int=0; k<building.globalResNeedToWorkCons.length; k++)
                {
                    if (building.globalResNeedToWorkCons[k]==building.currWorkersOnPlace[j]-1)
                    {
                        itNum=k;
                        break;
                    }
                }
                for (var k:int=0; k<dan.globalRes.length; k++) //проходим по ресурсам
                {
                    //trace("building.currWorkersOnPlace[j]="+building.currWorkersOnPlace[j]);
                    if (building.globalResNeedToWork[itNum]==dan.globalRes[k].typpe)
                    {
                        dan.globalRes[k].freeAmount++; //и возвращаем ресы
                        break;
                    }
                }
                building.currWorkersOnPlace[j]=0; //рабочему задаём пустую клетку
                dan.lands[dan.landTap].changePics(3); //магическая константа
                dan.reIncome=true;
            }
        }
        for (var j:int=0; j<building.currWorkplace.length; j++)
        {
            building.currWorkplace[j]=0;
        }
    }

    private function reBuilding(z):void
    {
        var elemID:int=dan.lands[dan.landTap].elemID[3];
        var baseLandResType:String=dan.lands[dan.landTap].building.baseLandResType;
        dan.lands[dan.landTap].building = new Building();
        dan.lands[dan.landTap].building.iii = z;
        dan.lands[dan.landTap].building.baseLandResType = baseLandResType;
        dan.lands[dan.landTap].building.landResType=dan.buildings[z].baseLandResType;
        dan.lands[dan.landTap].building.baseBuilding=dan.buildings[z].baseBuilding;
        dan.lands[dan.landTap].building.create();

        //dan.lands[dan.landTap].building.canWork=false;
        //dan.lands[dan.landTap].building.workStopProblem="build";

        dan.lands[dan.landTap].building.baseTyppeOfBuilding=dan.buildings[z].baseLandResType;

        var currLandRes:int=-1;
        for (var s:int=0; s<dan.landRes.length; s++)
        {
            if (dan.landRes[s].typpe == dan.lands[dan.landTap].building.landResType)
            {
                currLandRes = s;
                break;
            }
        }
        for (var j:int=0; j<dan.lands[dan.landTap].elemPic.length; j++)
        {
            if (j<3) //сначала меняем иконки ресурсов
            {
                if (dan.landRes[currLandRes].globalResIncome.length>j)
                {
                    for (var hh:int=0; hh<dan.globalRes.length; hh++)
                    {
                        if (dan.globalRes[hh].typpe==dan.landRes[currLandRes].globalResTyppe[j])
                        {
                            dan.lands[dan.landTap].elemPic[j] =hh+2;
                            //trace("hh="+hh);
                        }
                    }
                } else
                {
                    dan.lands[dan.landTap].elemPic[j] = 1;
                }
                if (dan.landRes[currLandRes].globalResIncome.length>j) //здесь задаём уровень добычи ресурсов
                {
                    dan.lands[dan.landTap].elemIncome[j] = dan.landRes[currLandRes].globalResIncome[j];
                } else
                {
                    dan.lands[dan.landTap].elemIncome[j]=0;
                }
            }
            if(j==3) //теперь меняем иконку строения
            {
                dan.lands[dan.landTap].elemPic[j] = currLandRes + 1;
                dan.lands[dan.landTap].elemIncome[j]=0;
            }
            if (j>3) //теперь меняем иконки мест для рабочих
            {
                if (dan.lands[dan.landTap].building.maxWorkplace>j-3)
                {
                    dan.lands[dan.landTap].elemPic[j] = 2;
                } else
                {
                    dan.lands[dan.landTap].elemPic[j] = 1;
                }
                dan.lands[dan.landTap].elemIncome[j]=0;
            }
            dan.lands[dan.landTap].elemID[j]=elemID;
        }
    }
}
}