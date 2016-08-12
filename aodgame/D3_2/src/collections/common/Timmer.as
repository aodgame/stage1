/**
 * Created by alexo on 27.04.2016.
 */
package collections.common
{
public class Timmer
{
    public var id:int;
    private var elderStart:int;
    private var elderLag:int;
    private var offText:String;

    private var younger:Vector.<String> = new Vector.<String>();
    private var curYoung;

    public var numOfMoves:int; //количество ходов

    public function Timmer()
    {
        id=-1;
        elderStart=0;
        elderLag=0;
        offText="";
        curYoung=0;
    }

    public function creation(iii, start, lag, txt, vect):void
    {
        id=iii;
        elderStart=start;
        elderLag=lag;
        offText=txt;
        younger=vect;
        curYoung=0;
        numOfMoves=0;
    }

    public function show():String
    {
        var s:String = "";
        if (younger!= null && younger.length>0)
        {
            s = younger[curYoung] + " ";
        }
        s += elderStart + " " + offText;
        return s;
    }

    public function changeDate():String
    {
        if (younger!=null && younger.length>0)
        {
            if (curYoung<younger.length-1)
            {
                curYoung++;
            }else
            {
                curYoung=0;
                elderStart+=elderLag;
            }

        } else
        {
            elderStart+=elderLag;
        }
        return show();
    }

    public function curElder():int
    {
        return elderStart;
    }

    public function curYounger():String
    {
        if (younger==null || younger.length==0)
        {
            return "";
        }
        return younger[curYoung];
    }
}
}
