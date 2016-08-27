/**
 * Created by alexo on 27.06.2016.
 */
package collections.behavior
{
public class BehResult
{
    public var iii:int;

    public var heroResTyppe:Vector.<String>;
    public var heroResNum:Vector.<int>;
    public var heroResNumTyppe:Vector.<String>;
    public var need:int;
    public var from:int;

    public var resChangeTyppe:Vector.<String>;
    public var resChangeNum:Vector.<int>;
    public var resChangeNumTyppe:Vector.<String>;

    public var warningTyppe:Vector.<String>;
    public var warningLand:Vector.<String>;
    public var timeToBuild:Vector.<int>;
    public var canWork:Vector.<int>;

    public var message:String;

    public var changeTyppe:Vector.<String>;

    public var cityRelTyppe:Vector.<String>; //отношения с городами
    public var cityRelNum:Vector.<int>;
    public var cityRelNumTyppe:Vector.<String>;

    public var needRelTyppe:Vector.<String>; //требования, чтобы завязать отношения с городами
    public var needRelNumTyppe:Vector.<String>;
    public var needRelRes:Vector.<String>;



    //<cityRel typpe="current" num="10" numTyppe="perc"/>

    /*<behResult iii="1">
        <!-- треб рес героя,
        изменяется глобальный ресурс,
        снимается варнинг (ставим no) с текущей земли,
        выдаётся текстовое сообщение-->
        <heroRes typpe="leadership" num="2" numTyppe="abs" need="1" from="1"/>
        <resChange typpe="army_hoplite" num="-10" numTyppe="perc"/>
        <warning typpe="no" land="currland"/>
        <message txt=""/>
    </behResult>*/

    public function BehResult()
    {
        iii=0;
        heroResTyppe = new Vector.<String>();
        heroResNum = new Vector.<int>();
        heroResNumTyppe = new Vector.<String>();
        need = 0;
        from = 0;
        resChangeTyppe = new Vector.<String>();
        resChangeNum = new Vector.<int>();
        resChangeNumTyppe = new Vector.<String>();
        warningTyppe = new Vector.<String>();
        warningLand = new Vector.<String>();
        timeToBuild = new Vector.<int>();
        canWork = new Vector.<int>();
        message="";
        changeTyppe= new Vector.<String>();
        cityRelTyppe = new Vector.<String>();
        cityRelNum = new Vector.<int>();
        cityRelNumTyppe = new Vector.<String>();
        needRelTyppe = new Vector.<String>();
        needRelNumTyppe = new Vector.<String>();
        needRelRes = new Vector.<String>();

    }
}
}
