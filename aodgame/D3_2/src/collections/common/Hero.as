/**
 * Created by alexo on 27.05.2016.
 */
package collections.common
{
public class Hero
{
    public var typpe:String;
    public var iii:int;
    public var txt:int;

    public var currentAge:int;
    private var maxAge:int;

    public var nameID:int;
    public var nameTextoID:int;

    public var needTyppe:Vector.<String> = new Vector.<String>();
    public var needNum:Vector.<int> = new Vector.<int>();
    public var needX:Vector.<int> = new Vector.<int>(); //сохраняем координаты места, над которыми было произведено событие
    public var needY:Vector.<int> = new Vector.<int>();

    public var heroResTyppe:Vector.<String> = new Vector.<String>();
    public var heroResMin:Vector.<int> = new Vector.<int>();
    public var heroResMax:Vector.<int> = new Vector.<int>();

    public var n1:int;
    public var n2:int;

    public function Hero()
    {
        typpe="";
        iii=-1;
        currentAge=0;
        maxAge=0;
        nameID=-1;
        n1=0;
        n2=0;
        txt=-1;
    }

    public function makeAge(n1:int, n2:int):void
    {
        if (maxAge == 0)
        {
            maxAge = Math.random() * (n2 - n1) + n1;
            trace("n1=" + n1 + "; n2=" + n2 + "; maxAge=" + maxAge);
        }
    }

    public function makeSkill(typpe:String, n1:int, n2:int):void
    {
        heroResTyppe.push(new String(typpe));
        var t:int=Math.random()*(n2-n1)+n1;
        heroResMax.push(new int(t));
    }

    public function makeName(names):void
    {
        nameID=names[int(Math.random()*names.length)];
        trace("nameID="+nameID);
    }

    public function endOfLife():Boolean
    {
        if (currentAge>=maxAge)
        {
            return true;
        }
        return false;
    }
    public function ma():int
    {
        return maxAge;
    }
}
}
