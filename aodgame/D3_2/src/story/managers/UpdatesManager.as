/**
 * Created by alexo on 19.05.2016.
 */
package story.managers
{
import collections.common.Modification;

import story.Danke;

public class UpdatesManager
{
    private var dan:Danke;

    public function UpdatesManager()
    {
        dan = Danke.getInstance();
    }

    public function work():void
    {
        //покупка апдейта
        if (dan.typeOfUpdatePay!=-1)
        {
            var s:int=-1;
            for (var j:int=0; j<dan.updates[dan.updateTap].upResName.length; j++)
            {
                //trace("==dan.updates[dan.updateTap].upResName[j]="+dan.updates[dan.updateTap].upResName[j]);
                //trace("dan.globalRes[dan.typeOfUpdatePay].typpe="+dan.globalRes[dan.typeOfUpdatePay].typpe);
                if (dan.updates[dan.updateTap].upResName[j]==dan.globalRes[dan.typeOfUpdatePay].typpe)
                {
                    s=j;
                    break;
                }
            }
            if (dan.globalRes[dan.typeOfUpdatePay].amount-dan.updates[dan.updateTap].upResNum[j]>=0) //если денег хватает
            {
                dan.globalRes[dan.typeOfUpdatePay].amount-=dan.updates[dan.updateTap].upResNum[j];//покупаем
                landMade(); //обрабатываем землю с учётом апдейта
            }
            dan.typeOfUpdatePay=-1;
            dan.localResChange=true;
        }


        if (dan.updIII!=-1)
        {
            dan.updCost=String(dan.updates[dan.updIII].cost);
            //dan.updIII=-1;
        }

        if (dan.update)
        {
            dan.update=false;

            if (dan.updIII!=-1 && dan.updates[dan.updIII].isOpened==0)
            {
                for (var j:int=0; j<dan.globalRes.length; j++)
                {
                    if (dan.globalRes[j].typpe==dan.updates[dan.updIII].costRes
                            && dan.updates[dan.updIII].cost<=dan.globalRes[j].amount)
                    {
                        dan.globalRes[j].amount-=dan.updates[dan.updIII].cost;
                        dan.updates[dan.updIII].isOpened=1;
                        dan.updChange=true;

                        updateMaker();

                        break;
                    }
                }
                for (var j:int=0; j<dan.updates.length; j++)
                {
                    dan.updates[j].analyzeOfOpen(dan.updates);
                }
            }
        }
    }

    private function landMade():void
    {
        var upd:Modification=dan.updates[dan.updateTap];
        /*for (var t:int=0; t<upd.res.length; t++)
        {
            trace(t+"; upd.res[t]="+upd.res[t]);
        }*/
        for (var t:int=0; t<upd.tip.length; t++)
        {
            if (upd.tip[t]=="increaseResource" && dan.lands[dan.landInWork].building.landResType==dan.buildings[upd.iid[t]].landResType) //изменение добычи/потребления одного из ресурсов
            {
                var tmp:Boolean=false;
                for (var fast:int=0; fast<dan.lands[dan.landInWork].building.madeUpdates.length; fast++) //проверяем, что апдейт ранее не изучался
                {
                    if (dan.lands[dan.landInWork].building.madeUpdates[fast]==dan.updateTap)
                    {
                        tmp=true;
                        break;
                    }
                }
                if (!tmp) //и если не изучыался ранее, сохраняем его в списке исследованных апдейтов
                {
                    dan.lands[dan.landInWork].building.madeUpdates.push(dan.updateTap);
                }
                var numOfElem:int=-1; //находим, какой из ресурсов улучшается
                for (var fast:int=0; fast<dan.lands[dan.landInWork].elemTyppe.length; fast++)
                {
                    if (dan.lands[dan.landInWork].elemTyppe[fast]==upd.res[t])
                    {
                        numOfElem=fast;
                        break;
                    }
                }
                //и изменяем его
                if (dan.lands[dan.landInWork].currentNumOfWorkers>0)
                {
                    dan.lands[dan.landInWork].elemIncome[numOfElem]/=dan.lands[dan.landInWork].currentNumOfWorkers;
                }
                dan.lands[dan.landInWork].elemIncome[numOfElem]+=upd.num[t];
                if (dan.lands[dan.landInWork].currentNumOfWorkers>0)
                {
                    dan.lands[dan.landInWork].elemIncome[numOfElem]*=dan.lands[dan.landInWork].currentNumOfWorkers;
                }
                dan.globalResChange=true;
            }

            if (upd.tip[t]=="addWorkerPlace" && dan.lands[dan.landInWork].building.landResType==dan.buildings[upd.iid[t]].landResType) //добавляется рабочее место
            {
                if (dan.lands[dan.landInWork].building.maxWorkplace<3)
                {
                    dan.lands[dan.landInWork].building.maxWorkplace++;
                    dan.lands[dan.landInWork].building.currWorkersOnPlace[dan.lands[dan.landInWork].building.maxWorkplace-1]=0;
                    /*trace("here maxWorkplace");
                    trace("currWorkplace="+dan.lands[dan.landInWork].building.currWorkplace);
                    trace("currWorkplace.length="+dan.lands[dan.landInWork].building.currWorkplace.length);
                    trace("currWorkersOnPlace="+dan.lands[dan.landInWork].building.currWorkersOnPlace);
                    trace("currWorkersOnPlace.length="+dan.lands[dan.landInWork].building.currWorkersOnPlace.length);*/
                }
            }
        }
    }

    private function updateMaker():void
    {
        for (var v:int=0; v<dan.updates[dan.updIII].tip.length; v++)
        {
            if (dan.updates[dan.updIII].tip[v]=="openBuilding")
            {
                for (var kk:int=0; kk<dan.buildings.length; kk++)
                {
                    if (dan.buildings[kk].iii==dan.updates[dan.updIII].iid[v])
                    {
                        trace(dan.buildings[kk].baseTyppeOfBuilding);
                        dan.buildings[kk].canBuild=true;
                        break;
                    }
                }
            }
        }
    }
}
}
