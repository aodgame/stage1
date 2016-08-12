package D3
{
import collections.Room;

import collections.Stats;
import collections.Texto;

import avmplus.metadataXml;
import avmplus.variableXml;

import flash.system.System;

import mx.resources.ResourceManager;

public class Bitte
{
    private static var instance:Bitte;		//Это будет уникальный экземпляр, созданный классом
    private static var ok2Create:Boolean=false;

    //переменные загрузки
    public var addr:String = "http://aodgame.16mb.com/game1/";
            //"http://aodgame.16mb.com/game1/";
            //"J://work/gitrep/aodgame/D3_2/";
            //"E://1/D3_2/";//D://7_differ/1/D3/"; //путь к загружаемой папке
    public const scenPath0:String="prelScenaries.xml"; //путь к файлу сценария
    public const subPath0:String="prelSubjects.xml"; //путь к файлу граф.информации
    public const textoPath0:String=""; //путь к файлу текстовой информации
        public var scenPath:String="prelScenaries.xml"; //путь к файлу сценария
        public var subPath:String="prelSubjects.xml"; //путь к файлу граф.информации
    public var textoPath:String=""; //путь к файлу текстовой информации

    public var nextLevel:uint=Stats.THREE; //начало загрузки нового уровня
        public var wait_subjects:Boolean=false; //грузятся ли предметы в данный момент
        public var wait_texto:Boolean=false;
        public var wait_scenario:Boolean=false;
        public var subLoad:uint=Stats.ZERO; //размер загруженной графики в процентах
        public var needToClear:Boolean = false; //нужно ли предварительно зачищать существующие объекты

    //сохранения
    public var needToBeSave:Boolean=false;

    //переменные событий
    public var realX:int=0; //координаты нолевой точки камеры в приложении
    public var realY:int=0;
    public var centx:int=0;//512;
    public var centy:int=0;//334;

    public var sx:int=0; //х-координата курсора в приложении
    public var sy:int=0; //у-координата курсора в приложении
    public var cli:int=0;
    public var cliX:int=0; //координаты мыши в момент отпускания кнопки
    public var cliY:int=0;
    public var dm:int=0; // 0 - мышь в покоящемся состоянии, 1 - в нажатом
    public var scrollY:int=0; //скроллинг колеса -1 вниз, 1 вверх, 0 ничего
    public var horiz:int=0; //нажаты стрелки ввеврх/низ(1/2) и влево/вправо (1/2)
    public var vertic:int=0;

    //переменные игры
    public var curRoom:int=0; //текущие и предыдущие комната и слой
    public var curPlane:int=0;
    public var prevRoom:int=0;
    public var prevPlane:int=0;

    //размеры комнат (по дефолту 1024 на 768)
    public var room:Vector.<Room> = new Vector.<Room>();

    //переменные мыши
    public var mouseParClick:int=-1;
    public var mouseClick:int=-1;
    public var mouseParDown:int=-1;
    public var mouseDown:int=-1;
    public var mouseParOut:int=-1;
    public var mouseOut:int=-1;
    public var mouseParOver:int=-1;
    public var mouseOver:int=-1;
    public var mouseParUp:int=-1;
    public var mouseUp:int=-1;

    public var mouseElementTyppe:String="";

    //
    public var underOne:int=-1; //над каким из ландшафтов происходит событие
    public var whatUnderOne:int=-1; //с каким элементом происходит событие
    public var underRes:String=""; //какой рес связан с элементом whatUnderOne

    public var positionIt:Vector.<int> = new Vector.<int>(); //id, xx, yy
    public var visIt:Vector.<int> = new Vector.<int>(); //id, vis

    //внутриигровые переменные
    public var texto:Vector.<Texto> = new Vector.<Texto>();
    public var sTimmer:String="";
    public var sCurrentTurn:int=1; //текущий ход
    public var sChangeTurn:Boolean=false; //смена хода
        public var sMovieChangeTurn:Boolean = false; //спец переменная смены хода для Фильма
    public var textMode:String="ru";

    public var textoCodes:Vector.<String> = new Vector.<String>();
    public var textoTexts:Vector.<String> = new Vector.<String>();

    //приказ на удаление
    public var delModuleName:String="";
    public var delCommand:Boolean=false;
    public var delSubjects:Boolean=false;
    public var delScenario:Boolean=false;
    public var delParameters:Boolean=false;

    public var userName:String=""; //ник пользователя

    public function Bitte()
    {
        trace("addr="+addr);
        if(!ok2Create) throw new Error(this+" is a Singleton. access using getInstance()");
    }

    public function workControl()
    {
        if (mouseParClick!=-1)
        {
            mouseParClick=-1;
            mouseClick=-1;
        }
        if (mouseParDown!=-1)
        {
            mouseParDown=-1;
        }
        if (mouseParOver!=-1)
        {
            mouseParOver=-1;
        }
        if (mouseParOut!=-1)
        {
            mouseParOut = -1;
        }
        if (mouseParUp!=-1)
        {
            mouseParUp = -1;
        }
        cli=0;
    }

    public static function getInstance():Bitte
    {
        //Если нет экземпляра, создаем его
        if(!instance)
        {
            //Разрешить создание экземпляра, а после его создания запретить
            ok2Create = true;
            instance = new Bitte();
            ok2Create = false;
            trace('Экземпляр "Одиночки" создан!');
        }
        return instance;
    }
}
}
