/**
 * Created by alexo on 26.04.2016.
 */
package story.managers
{
import story.*;

import collections.Stats;
import D3.Bitte;

public class LandsManager
{
    private var bit:Bitte;
    private var dan:Danke;
    private var i:int;

    private var currentSub:int;
    private var currentSubID:int;

    public function LandsManager()
    {
        bit = Bitte.getInstance();
        dan = Danke.getInstance();
        currentSub=-10;
        currentSubID=-10;
    }

    public function work():void
    {
        switch(dan.landSituation)
        {
            case 0:
                notActive();
                break;
            case 1:
                active();
                break;
            case -1:
                creation();
                break;
        }

        for (i=0; i<dan.lands.length; i++)
        {
            //dan.lands[i].building.situationControl();
            dan.lands[i].situationRePic();
        }
    }

    private function landInterview():void
    {
        for (i=0; i<dan.lands.length; i++)
        {
            //trace(i+"; dan.lands[i].building.maxWorkplace="+dan.lands[i].building.maxWorkplace);
            //trace("dan.lands[i].elemPic.length="+dan.lands[i].elemPic.length);
            for (var j:int=Stats.FIRST_BUILDING_FRAME; j<dan.lands[i].building.maxWorkplace+Stats.FIRST_BUILDING_FRAME; j++)
            {
                if (j<dan.lands[i].elemPic.length && dan.lands[i].elemPic[j]<=2)
                {
                    dan.lands[i].elemPic[j] = 2; //магическое число, обозначает, что локация разрешена для появления рабочих
                }
            }
        }
    }

    private function creation():void
    {
        if (dan.lands.length==0)
        {
            return;
        }
        dan.landSituation=0;
        for (i=0; i<dan.lands.length; i++)
        {
            bit.positionIt.push(dan.lands[i].subID);
            bit.positionIt.push(dan.lands[i].xx);
            bit.positionIt.push(dan.lands[i].yy);

            bit.visIt.push(dan.lands[i].subID);
            bit.visIt.push(10);

            bit.positionIt.push(dan.lands[i].landID);
            bit.positionIt.push(dan.lands[i].xx);
            bit.positionIt.push(dan.lands[i].yy);
        }

        dan.globalResChange=true;
        dan.reIncome=true;
    }

    private function notActive():void
    {
        landInterview();
        if (bit.mouseParClick!=0)
        {
            for (i=0; i<dan.lands.length; i++)
            {
                if (dan.lands[i].subID==bit.mouseParClick || dan.lands[i].landID==bit.mouseParClick)
                {
                    dan.landInWork=i; //задаём тон исследованиям
                    //trace("here bit.mouseParClick="+bit.mouseParClick);
                    bit.positionIt.push(dan.lands[i].subID);
                    bit.positionIt.push(512);
                    bit.positionIt.push(386);

                    bit.visIt.push(dan.lands[i].subID);
                    bit.visIt.push(1);

                    bit.positionIt.push(dan.lands[i].landID);
                    bit.positionIt.push(512);
                    bit.positionIt.push(386);

                    currentSub=bit.mouseParClick;
                    currentSubID=i;
                    dan.landSituation=1;
                    dan.darkScreen=1;
                    vision(0, 0);

                    dan.landTap=i;

                    //текстовка с подсказкой
                    dan.landInfoText="$lan"+dan.lands[dan.landInWork].description+"+"+dan.lands[dan.landInWork].building.description;
                }
            }
        }



    }

    private function vision(vis, landVis):void
    {
        var j:int;
        for (j=0; j<dan.lands.length; j++)
        {
            if (j!=currentSubID)
            {
                bit.visIt.push(dan.lands[j].subID);
                bit.visIt.push(vis);

                bit.visIt.push(dan.lands[j].landID);
                bit.visIt.push(landVis);
            }
        }
    }

    private function active():void
    {
        landInterview();
        if (dan.darkScreen==4)// || bit.mouseParClick==dan.lands[currentSubID].subID)
        {
            dan.landInWork=-1;

            bit.positionIt.push(dan.lands[currentSubID].subID);
            bit.positionIt.push(dan.lands[currentSubID].xx);
            bit.positionIt.push(dan.lands[currentSubID].yy);

            bit.visIt.push(dan.lands[currentSubID].subID);
            bit.visIt.push(10);

            bit.positionIt.push(dan.lands[currentSubID].landID);
            bit.positionIt.push(dan.lands[currentSubID].xx);
            bit.positionIt.push(dan.lands[currentSubID].yy);

            dan.landSituation = 0;
            dan.darkScreen=0;
            currentSub=-10;
            currentSubID=-10;
            vision(50, 1);

            dan.landTap=-1;


        }
    }
}
}