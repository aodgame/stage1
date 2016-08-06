/**
 * Created by alexo on 27.04.2016.
 */
package collections
{
public class Texto
{
    public var tid:int;
    public var txt:Vector.<String> = new Vector.<String>();
    public var mode:Vector.<String> = new Vector.<String>();
    public var moduleName:String="";

    public function Texto()
    {
    }

    public function show(currMode):String
    {
        var s:String = "";
        for (var i:int=0; i<mode.length; i++)
        {
            if (mode[i]==currMode)
            {
                s=txt[i];
                break;
            }
        }
        return s;
    }
}
}
