package elements
{
import D3.Bitte;

import flash.display.MovieClip;

public class ParentElement extends MovieClip
{
    private static var scoreNum:uint=0; //раздаёт порядковые номера

    public var ready:Boolean=false;
    public var parnt:int; //индекс предмета-владельца
    public var iii:int; //мой индекс

    public var tid:String;

    public var atChild:uint; //слой видимости

    public var typeOfElement:String="";
    public var specInfo:String="";

    protected var bit:Bitte;

    public function ParentElement()
    {
    }

    public function parse()
    {

    }

    public function fate(i):int
    {
        return 0;
    }

    public function creation(pics, picAddr, ii, typpe):void
    {
        iii=scoreNum;
        scoreNum++;
        parnt=ii;

        bit = Bitte.getInstance();

        typeOfElement=typpe;
        //return 0;
    }
}
}
