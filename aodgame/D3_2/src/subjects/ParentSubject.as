package subjects
{
import D3.Bitte;

public class ParentSubject
{
    public var iii:uint; //индекс
    public var iid:uint; //номер по счёту

    public var picAddr:Vector.<String> = new Vector.<String>(); //линкаж мувика
    public var typpe:String; //тип предмета
    public var picLoad:int; //индекс граф.файла, откуда должны грузиться картинки
    public var picIndex:int; //индекс в массиве PicUno

    public var i:uint; //счётная переменная

    public var atChild:uint; //слой видимости

    public var subX:int; //значения всего блока графики
    public var subY:int;
    public var subW:uint;
    public var subH:uint;
    public var sx:Vector.<int> = new Vector.<int>(); //значения для каждого элемента относительно общих координат
    public var sy:Vector.<int> = new Vector.<int>();
    public var sw:Vector.<int> = new Vector.<int>();
    public var sh:Vector.<int> = new Vector.<int>();
    public var specID:Vector.<String> = new Vector.<String>();

    public var alph:int; //видимость предмета 1 - полная. Всё, что выше == alph/100
    public var oldAlph:int;

    public var weAre:uint; //где мы находимся 0 - везде
    public var ourPosition:uint; //наша локация в комнате (1-передний план, 2 - вспомогательный, 3- везде)
    public var vis:uint; //мы видимы и над нами можно производить действия, иначе только директивная видимость
    public var visDirective:int=-1; //-1 не влияет, 0 - директивно не видим, 1 - директивно видим
    public var resultVis:Boolean;
    public var visOne:Vector.<int> = new Vector.<int>(); //видимость каждого из элементов

    public var subs:Vector.<String> = new Vector.<String>(); //список-подсказка типов переменных
    public var numOfEl:Vector.<int> = new Vector.<int>();//номер элемента из вектора списка отображения
    public var idOfEl:Vector.<int> = new Vector.<int>();//индекс элемента из списка

    public var realW:Vector.<int> = new Vector.<int>();
    public var realH:Vector.<int> = new Vector.<int>();

    public var willSave:Boolean;

    public var ready:Boolean; //предмет готов к использованию

    protected var bit:Bitte;

    protected var s:String="";

    public var neddFram:Boolean=false;

   /* public function ParentSubject(myXML, pics, i)
    {

    }*/

    public function vision():Boolean
    {
        if (visDirective==1)
        {
            vis=1;
            return true;
        }
        if (visDirective==0)
        {
            vis=0;
            return false;
        }
        i=0;
        if (weAre==0 || weAre==bit.curRoom)
        {
            i++;
        }
        if (ourPosition==bit.curPlane || ourPosition==0)
        {
            i++;
        }
        if (vis==1)
        {
            i++;
        }
        if (i==3)
        {
            return true;
        }
        return false;
    }

    public function work(ii):void
    {
        if (ii!=iid)
        {
            iid=ii;
        }
    }

    public function getParam(str, num)
    {

    }
    public function takeParam(str):int
    {
        if (str=="subX")
        {
            return subX;
        }
        if (str=="subY")
        {
            return subY;
        }
        return 0;
    }

    public function equalIt(tip):Boolean
    {
        return false;
    }
    public function changeFrame(eee, num):void
    {

    }

    public function model(el):void
    {

    }

    public function extremalWork(ii, el):void
    {

    }

    public function IWontToBeSave():String
    {
        return s;
    }

    protected function end_load(myXML, ii, pics, el):void //заканчиваем загрузку
    {
        bit = Bitte.getInstance();
        atChild=myXML.atChild;
        typpe=myXML.type;
        weAre=myXML.type.@weAre;
        ourPosition=myXML.type.@ourPosition;
        vis=myXML.type.@vis;
        for (i=0; i<myXML.pic.length(); i++)
        {
            var t:int=0;
            var num:int=int(myXML.pic[i].@num);
            if (num==0)
            {
                num=1;
            }
            while(t<num)
            {
                picAddr.push(new String(myXML.pic[i]));
                t++;
            }
            picLoad=myXML.pic[i].@picload;
        }

        if (myXML.height!=0)
        {
            subH = myXML.height;
        }
        if (myXML.width!=0)
        {
            subW = myXML.width;
        }
        subX=myXML.x;
        subY=myXML.y;

        alph=1;
        oldAlph=1;

        iii=myXML.id;
        iid=ii;

        if  (myXML.type.@willSave=="1")
        {
            willSave=true;
        }
        else
        {
            willSave=false;
        }

        ready=false;

        for (i=0; i<pics.length; i++)
        {
            if (picLoad==pics[i].id)
            {
                picIndex=i;
                break;
            }
        }
    }
}
}