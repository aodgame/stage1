/**
 * Created by alexo on 26.07.2016.
 */
package subjects
{
import elements.ElemShape;

import story.Danke;

public class SubGraph extends Parent2Subject
{
    private var cat:int=-1;
    private var wid:int=0;
    private var heig:int=0;
    private var dan:Danke;

    public function SubGraph(myXML, pics, el, ii, moduleName)
    {
        end_load(myXML, ii, pics, el, moduleName);
    }

    override public function work(ii):void
    {
        super.work(ii);
    }

    override public function model(el):void
    {
        super.model(el);

        //trace("cat="+cat+"::"+dan.currMatrix.category+"; dan.currMatrix.needToRefram="+dan.currMatrix.needToRefram);
        if (dan.currMatrix.category==cat && dan.currMatrix.needToRefram)
        {
            trace("makeGraph");
            trace("dan.currMatrix.tip.length="+dan.currMatrix.tip.length);
            makeGraph(el[numOfEl[0]]);
           // el.parseIt(dan.currMatrix);
            dan.currMatrix.needToRefram=false;
        }
    }

    private function  makeGraph(el:ElemShape):void
    {
        trace("typeOfElement="+el.typeOfElement)
        el.pic.graphics.clear();

        var xstep:Number=wid/dan.currMatrix.maxx;
        var ystep:Number=heig/dan.currMatrix.maxy;
        if (dan.currMatrix.maxy==0)
        {
            ystep=0;
        }
        trace("xstep="+xstep+"; ystep="+ystep);

        trace("dan.currMatrix.tip.length="+dan.currMatrix.tip.length);
        trace("dan.currMatrix.first.length="+dan.currMatrix.first.length);
        trace("dan.currMatrix.second.length="+dan.currMatrix.second.length);

        trace("=====");
        trace("wid="+wid+"; dan.currMatrix.maxx="+dan.currMatrix.maxx+"; xstep="+xstep);
        trace("heig="+heig+"; dan.currMatrix.maxy="+dan.currMatrix.maxy+"; ystep="+ystep);
        for (var i:int=0; i<dan.currMatrix.tip.length; i++)
        {
            trace(dan.currMatrix.tip[i]+"::"+dan.currMatrix.first[i]+"::"+dan.currMatrix.second[i]);
            if (dan.currMatrix.tip[i]==0) //задаём стиль линии
            {
                var tColor:uint=uint(dan.currMatrix.first[i]);
                el.pic.graphics.lineStyle(5, tColor, 1);
            }
            if (dan.currMatrix.tip[i]==1) //переводим позицию в точку
            {
                el.pic.graphics.moveTo(int(dan.currMatrix.first[i])*xstep, dan.currMatrix.second[i]*ystep);
            }
            if (dan.currMatrix.tip[i]==2) //рисуем линию из позиции в новую позицию
            {
                el.pic.graphics.lineTo(int(dan.currMatrix.first[i])*xstep, dan.currMatrix.second[i]*ystep);
            }
            if (dan.currMatrix.tip[i]==3) //объявляем начало заливки
            {
                el.pic.graphics.beginFill(uint(dan.currMatrix.first[i]), dan.currMatrix.second[i]);
            }
            if (dan.currMatrix.tip[i]==4) //рисуем прямоугольник
            {
                el.pic.graphics.drawRect(int(dan.currMatrix.first[i-1])*xstep+(i-1), dan.currMatrix.second[i-1]*ystep,
                                        int(dan.currMatrix.first[i])*xstep, dan.currMatrix.second[i]*ystep);
            }
            if (dan.currMatrix.tip[i]==5) //объявляем завершение заливки
            {
                el.pic.graphics.endFill();
            }
        }
    }

    override public function IWontToBeSave():String
    {
        s="";
        return s;
    }

    override protected function end_load(myXML, ii, pics, el, moduleName):void //заканчиваем загрузку
    {
        super.end_load(myXML, ii, pics, el, moduleName);
        dan = Danke.getInstance();

        subs.push("sha");
        visOne.push(1);
        sx.push(0);
        sy.push(0);
        sw.push(subW);
        sh.push(subH);
        specID.push(0);

        cat=myXML.category.@cat;
        wid=myXML.category.@wid;
        heig=myXML.category.@heig;

        ready=true;
    }
}
}