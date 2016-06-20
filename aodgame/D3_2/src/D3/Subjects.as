package D3
{
import loader.AddSwap;
import loader.PicUno;
import loader.SubjLoader;
import loader.TextoLoader;

import phys.Find;

import story.managers.TextManager;

import flash.display.MovieClip;
import subjects.*;
import elements.*;

public class Subjects extends MovieClip
{
    private static var instance:Subjects;		//Это будет уникальный экземпляр, созданный классом
    private static var ok2Create:Boolean=false;

    public var sub:Vector.<ParentSubject> = new Vector.<ParentSubject>(); //������, �������� ��������
    private var el:Vector.<ParentElement> = new Vector.<ParentElement>(); //������, �������� ��������
    private var pics:Vector.<PicUno> = new Vector.<PicUno>();

    private var levering:SubjLoader; //класс загрузки изображений и создания предметов при переходе между уровнями.
    private var texting:TextoLoader;
    private var elemeiting:AddSwap; //класс создания предметов и их свапов
    private var bit:Bitte;

    private var swap:Vector.<int> = new Vector.<int>(); //элементы подлежащие свапу
    private var add:Vector.<int> = new Vector.<int>(); //элементы подлежащие помещению на сцену

    private var textManager:TextManager;

    private var i:int;
    private var j:int;

    function Subjects(stage)
    {
        trace("We are ok!");
        if(!ok2Create) throw new Error(this+" is a Singleton. access using getInstance()");

        bit = Bitte.getInstance();
        levering = new SubjLoader(); //класс загрузок уровня
        texting = new TextoLoader();
        elemeiting = new AddSwap(add); //класс добавления предметов и их свапов
        addChild(elemeiting);

        textManager= new TextManager();
    }

    public static function getInstance(stage):Subjects
    {
        if(!instance) //Если нет экземпляра, создаем его
        {
            //Разрешить создание экземпляра, а после его создания запретить
            ok2Create = true;
            instance = new Subjects(stage);
            ok2Create = false;
            trace('Subject created.');
        }
        return instance;
    }

    public function workControl ():void
    {
        var length:int = sub.length;
        if (bit.nextLevel>0) //если обнаружено завершение уровня
        {
            texting.levelGo(); //грузим тексты
            levering.levelGo(sub, el, pics, add);
            for (i=0; i<length; i++)
            {
                sub[i].extremalWork(i, el); //обрабатываем логику предметов
            }
        }
        if (bit.nextLevel==0) //общий игровой таймер
        {
            for (i=0; i<length; i++)
            {
                sub[i].work(i); //обрабатываем логику предметов
                sub[i].model(el); //производим изменения внешности элементов
                publicum(i); //ставим все элементы предметов в нужные координаты
            }
            textManager.work(el);
            if (add.length>0)
            {
                elemeiting.addManager(add, el);
            }
            if (swap.length>0)
            {
                elemeiting.swapManager(add, el);
            }
        }
    }

    public function getSave():String
    {
        var s:String = "";
        for (i = 0; i < sub.length; i++)
        {
            if (sub[i].willSave)
            {
                s += sub[i].IWontToBeSave();
            }
        }
        return s;
    }

    private function publicum(ii):void //ставим все элементы предметов в нужные координаты
    {
        var currSub:ParentSubject = sub[ii];
        var length:int=currSub.visOne.length;
        for (j=0; j<length; j++) //проходим по всем элементам данного предмета
        {
            if (currSub.vis==1) //предмет виден, задаётся также директивная видимость внутри предмета-родителя
            {
                if (currSub.visOne[j] == 1) //видим конкретный элxемент
                {
                    if (el[currSub.numOfEl[j]].iii != currSub.idOfEl[j])  //совпадают ли индексы элемента и его предмета-владельца
                    {
                        currSub.numOfEl[j] = Find.findNum(el, currSub.idOfEl[j], currSub.idOfEl[j]); //вектор, индекс элемента, порядковый номер в векторе
                    }
                    if (currSub.numOfEl[j] != -1) //предмет существует
                    {
                        el[currSub.numOfEl[j]].x = currSub.subX+currSub.sx[j];
                        el[currSub.numOfEl[j]].y = currSub.subY+currSub.sy[j];
                    }
                }
            } else
            {
                if (el[currSub.numOfEl[j]].x<5000)
                {
                   // el[currSub.numOfEl[j]].x=5000;
                }
            }
        }
    }
}
}