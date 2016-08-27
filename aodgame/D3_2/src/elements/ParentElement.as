package elements
{
import D3.Bitte;

import flash.display.MovieClip;

public class ParentElement extends MovieClip
{
    private static var scoreNum:uint=0; //раздаёт порядковые номера

    public var ready:Boolean=false;
    public var parnt:int; //индекс предмета-владельца
    public var parntID:int; //индекс предмета-владельца
    public var iii:int; //мой индекс

    public var tid:String="";

    public var atChild:uint; //слой видимости

    public var typeOfElement:String="";
    public var specInfo:String="";

    protected var bit:Bitte;

    public var moduleName:String="";

    public function ParentElement()
    {
    }

    public function parse():void
    {

    }

    public function fate(i):int
    {
        return 0;
    }

    public function correctScoreNum(nu:int):void
    {
        scoreNum=nu;
    }


    public function creation(pics, picAddr, ii, typpe, moduleName, i):void
    {
        this.moduleName=moduleName;
        parntID=i;

        iii=scoreNum;
        scoreNum++;
        parnt=ii;

        bit = Bitte.getInstance();

        typeOfElement=typpe;
        //return 0;
    }
}
}
