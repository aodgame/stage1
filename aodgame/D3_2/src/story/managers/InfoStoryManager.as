/**
 * Created by alexo on 26.07.2016.
 */
package story.managers
{
import D3.Bitte;

import story.Danke;

public class InfoStoryManager
{
    private var dan:Danke;
    private var bit:Bitte;

    private var i:int;
    private var j:int;

    private var category:int;

    public function InfoStoryManager()
    {
        dan = Danke.getInstance();
        bit = Bitte.getInstance();
        i=0;
        j=0;
        category=0;
    }

    public function work(sub):void
    {
        if (bit.sChangeTurn)
        {
            trace("save InfoStoryManager");
            collect();
        }
        if (category!=dan.categoryWillSave)
        {
            if (dan.categoryWillSave==0)
            {
                category=0;
            } else
            {
                trace("make matrix in InfoStoryManager");
                trace("dan.categoryWillSave=" + dan.categoryWillSave);
                category = dan.categoryWillSave;
                matrixMake();
            }
        }
    }

    private function matrixMake():void //формируем матрицу отображения
    {
        dan.currMatrix.needToRefram=true;
        dan.currMatrix.category=category;
        dan.currMatrix.tip = new Vector.<int>();
        dan.currMatrix.first = new Vector.<String>();
        dan.currMatrix.second = new Vector.<int>();

        var xmin:int=0; //график идёт вправо
        var ymin:int=0; //график идёт вверх
        var xmax:int=dan.willSave.length;
        var ymax:int=0;
        var xstep:int=1;
        var ystep:int=1;
        for (i=0; i<dan.willSave.length; i++) //сначала находим максимальное значение по вертикали
        {
            if (dan.willSave[i].category==category && dan.willSave[i].max>ymax)
            {
                ymax=dan.willSave[i].max;
            }
        }
        dan.currMatrix.maxy=ymax; //сохраняем максимальное значимое число для графика по оси y
        dan.currMatrix.maxx=dan.willSave[0].num.length-1;
        ymax=-ymax;


        var numOfCat:int=-1;
        var typeOfMatrix:String="";
        var col:int=-1;
        trace("dan.category.length="+dan.category.length);
        for (i=0; i<dan.category.length; i++)
        {
            if (dan.category[i].iii==category)
            {
                numOfCat=i;
                typeOfMatrix=dan.category[i].out;
                break;
            }
        }

        if (typeOfMatrix=="lineGraphic")
        {
            for (i = 0; i < dan.willSave.length; i++)
            {
                if (dan.willSave[i].category == category) //находим ресурс нужной категории
                {

                    dan.currMatrix.tip.push(0); //задаём его цвет
                    col++;
                    trace("dan.category[numOfCat].col.length="+dan.category[numOfCat].col.length);
                    dan.currMatrix.first.push(dan.category[numOfCat].col[col]);
                    dan.currMatrix.second.push(0);

                    dan.currMatrix.tip.push(1); //задаём, в какие координаты матрицы он должен встать в начале
                    dan.currMatrix.first.push(0);
                    var yy:int=-dan.willSave[i].num[0];
                    dan.currMatrix.second.push(-dan.willSave[i].num[0]);

                    for (j=1; j<dan.willSave[i].num.length; j++) //двигаем координаты
                    {
                        dan.currMatrix.tip.push(2);
                        dan.currMatrix.first.push(j);
                        dan.currMatrix.second.push(-dan.willSave[i].num[j]);
                    }
                }
            }
        }
    }

    private function collect():void //сохраняем новое значение параметров
    {
        for (i=0; i<dan.willSave.length; i++)
        {
            for (j=0; j<dan.globalRes.length; j++)
            {
                if (dan.willSave[i].res==dan.globalRes[j].typpe)
                {
                    dan.willSave[i].num.push(new int(dan.globalRes[j].amount));
                    if (int(dan.globalRes[j].amount)>dan.willSave[i].max) //сохраняем максимальное значение кривой
                    {
                        dan.willSave[i].max=int(dan.globalRes[j].amount);
                    }
                    break;
                }
            }
        }
    }
}
}
