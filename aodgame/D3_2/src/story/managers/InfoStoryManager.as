/**
 * Created by alexo on 26.07.2016.
 */
package story.managers
{
import D3.Bitte;

import collections.common.Hero;

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
        if (dan.historyTheHeroIsCome)
        {
            createHeroStory();
            dan.historyTheHeroIsCome=false;
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
                    if (dan.willSave[i].res!="hero")
                    {
                        dan.currMatrix.tip.push(0); //задаём его цвет
                        col++;
                        trace("dan.category[numOfCat].col.length=" + dan.category[numOfCat].col.length);
                        dan.currMatrix.first.push(dan.category[numOfCat].col[col]);
                        dan.currMatrix.second.push(0);

                        dan.currMatrix.tip.push(1); //задаём, в какие координаты матрицы он должен встать в начале
                        dan.currMatrix.first.push(0);
                        var yy:int = -dan.willSave[i].num[0];
                        dan.currMatrix.second.push(-dan.willSave[i].num[0]);

                        for (j = 1; j < dan.willSave[i].num.length; j++) //двигаем координаты
                        {
                            dan.currMatrix.tip.push(2);
                            dan.currMatrix.first.push(j);
                            dan.currMatrix.second.push(-dan.willSave[i].num[j]);
                        }
                    }
                }
            }
        }
        if (typeOfMatrix=="bandGraphic")
        {
            for (i = 0; i < dan.willSave.length; i++)
            {
                if (dan.willSave[i].category == category) //находим ресурс нужной категории
                {
                    if (dan.willSave[i].res == "hero") //если график связан с героями
                    {
                        dan.historyHeroChoose=0; //задаём номер героя, с которого начнём показ
                        dan.heroHistoryCategory=i;

                        var res:int=1;
                        var t:Vector.<int>= new Vector.<int>();
                        var max:int=0;
                        trace("dan.availableHeroes.length="+dan.availableHeroes.length);
                        while (res<dan.availableHeroes.length) //тогда проходим по всем возможным героям
                        {
                            var d:int=0;
                            for (var k:int = 0; k < dan.willSave[i].heroStory.length; k++)
                            {
                                if (dan.willSave[i].heroStory[k].typpe==dan.availableHeroes[res].typpe)
                                {
                                    d++; //пока не найдём их количество по каждому типу
                                }
                            }
                            t.push(d);
                            if (d>max)
                            {
                                max=d;
                            }
                            res++;
                        }
                        trace("t="+t);
                        for (var k:int = 0; k <t.length; k++) //теперь нужно подготовить матрицу графика
                        {
                            dan.currMatrix.tip.push(0); //задаём его цвет
                            col++;
                            trace("col="+col);
                            trace("dan.category[numOfCat].iii="+dan.category[numOfCat].iii);
                            dan.currMatrix.first.push(dan.category[numOfCat].col[col]);
                            dan.currMatrix.second.push(0);

                            dan.currMatrix.tip.push(3); //готовим заливку
                            dan.currMatrix.first.push(dan.category[numOfCat].col[col]); //цвет
                            dan.currMatrix.second.push(1); //прозрачность


                            dan.currMatrix.tip.push(1); //задаём, в какие координаты матрицы он должен встать в начале
                            dan.currMatrix.first.push(k);
                            dan.currMatrix.second.push(-t[k]);


                            dan.currMatrix.tip.push(4); //прямоугольник, xy берутся из предыдущего значения
                            dan.currMatrix.first.push(1); //ширина
                            dan.currMatrix.second.push(t[k]); //высота

                            dan.currMatrix.tip.push(5); //прекратить заливку
                            dan.currMatrix.first.push(0);
                            dan.currMatrix.second.push(0);
                        }


                        dan.currMatrix.maxy=max; //сохраняем максимальное значимое число для графика по оси y
                        dan.currMatrix.maxx=dan.availableHeroes.length;
                        break;
                    }
                }
            }
        }
    }

    private function createHeroStory():void
    {
        //ищем хронику, в которой хранятся герои
        var ave:int=-1;
        for (i=0; i<dan.willSave.length; i++)
        {
            if (dan.willSave[i].res=="hero")
            {
                ave=i;
                break;
            }
        }
        if (ave==-1)
        {
            return;
        }
        //теперь создаём память о герое
        var hero=dan.currentHeroes[dan.currentHeroes.length-1];
        dan.willSave[ave].heroStory.push(new Hero());
        j=dan.willSave[ave].heroStory.length-1;
        trace("bit.sTimmer="+bit.sTimmer);
        dan.willSave[ave].heroStory[j].s1=bit.sTimmer; //период известности
        dan.willSave[ave].heroStory[j].s2=bit.sTimmer;
        dan.willSave[ave].heroStory[j].typpe=hero.typpe;
        dan.willSave[ave].heroStory[j].iii=hero.iii;
        dan.willSave[ave].heroStory[j].txt=hero.txt;
        dan.willSave[ave].heroStory[j].nameID=hero.nameID;
        for (var i:int=0; i<hero.heroResTyppe.length; i++)
        {
            dan.willSave[ave].heroStory[j].heroResTyppe.push(hero.heroResTyppe[i]);
            dan.willSave[ave].heroStory[j].heroResMax.push(hero.heroResMax[i]);
            dan.willSave[ave].heroStory[j].heroResMin.push(0);
            dan.willSave[ave].heroStory[j].needNum.push(hero.heroResMax[i]); //переменная для слежения за текущим значением ресурсов

        }
    }

    private function collect():void //сохраняем новое значение параметров
    {
        for (i=0; i<dan.willSave.length; i++)
        {
            if (dan.willSave[i].res=="hero")
            { //герои
                for (j=0; j<dan.willSave[i].heroStory.length; j++)
                {
                    if (dan.willSave[i].heroStory[j].currentAge==-1)
                    {
                        continue; //история этого героя уже закончена
                    }
                    var myHero:Hero=dan.willSave[i].heroStory[j]; //в противном случае

                    //найдём героя в списке
                    var ave:int=-1;
                    for (var k:int=0; k<dan.currentHeroes.length; k++)
                    {
                        if (dan.currentHeroes[k].iii==myHero.iii)
                        {
                            ave=k;
                            break;
                        }
                    }
                    if (ave==-1) //если такого нет, то пропускаем
                    {
                        continue;
                    }

                    for (var k:int=0; k<myHero.heroResTyppe.length; k++)
                    {
                        trace("myHero.heroResMax[k]="+myHero.heroResMax[k]+"; dan.currentHeroes[ave].heroResMax[k]="+dan.currentHeroes[ave].heroResMax[k]);
                        myHero.heroResMin[k]+=myHero.needNum[k]-(dan.currentHeroes[ave].heroResMax[k]-1);//количество потраченных очков
                        myHero.needNum[k]=dan.currentHeroes[ave].heroResMax[k];
                        trace("myHero.heroResTyppe[k]="+myHero.heroResTyppe[k]+"; min="+ myHero.heroResMin[k]);
                        myHero.heroResMax[k]++;
                        if (myHero.heroResMin[k]<0)
                        {
                            myHero.heroResMin[k]=0;
                        }
                    }
                    myHero.s2=bit.sTimmer;
                }
            } else
            { //ресурсы
                for (j = 0; j < dan.globalRes.length; j++)
                {
                    if (dan.willSave[i].res == dan.globalRes[j].typpe)
                    {
                        dan.willSave[i].num.push(new int(dan.globalRes[j].amount));
                        if (int(dan.globalRes[j].amount) > dan.willSave[i].max) //сохраняем максимальное значение кривой
                        {
                            dan.willSave[i].max = int(dan.globalRes[j].amount);
                        }
                        break;
                    }
                }
            }
        }
    }
}
}
