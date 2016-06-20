/**
 * Created by alexo on 28.04.2016.
 */
package collections.inCity
{
public class LandRes
{
   /* <landRes typpe="wood" pic="" name="220" description="221"> <!-- древесина -->
        <res typpe="mine" income="1"/>
    </landRes>*/
    public var typpe:String;
    public var pic:int;
    public var sName:String;
    public var sDescription:String;

    public var globalResTyppe:Vector.<String>;
    public var globalResIncome:Vector.<int>;

    public function LandRes()
    {
        typpe="";
        pic=1;
        sName="";
        sDescription="";
        globalResTyppe = new Vector.<String>();
        globalResIncome = new Vector.<int>();
    }
}
}
