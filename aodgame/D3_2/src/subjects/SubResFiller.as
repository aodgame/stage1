/**
 * Created by alexo on 17.05.2016.
 */
package subjects
{
import story.Danke;

public class SubResFiller  extends Parent2Subject
{
    //private var neddFram:Boolean=true;
    private var previousResAmount:int=-1000;
    private var min:int=0;
    private var max:int=0;
    private var numOfBaseRes:int=-1;

    private var dan:Danke;

    public function SubResFiller(myXML, pics, el, ii)
    {
        end_load(myXML, ii, pics, el);
    }

    override public function work(ii):void
    {
        super.work(ii);
    }

    override public function model(el):void
    {
        super.model(el);

            makeFram(el);
    }

    private function makeFram(el):void
    {
        if (numOfBaseRes==-1 || dan.globalRes[numOfBaseRes].typpe == specID[0])
        {
            for (i = 0; i < dan.globalRes.length; i++)
            {
                if (dan.globalRes[i].typpe == specID[0])
                {
                    numOfBaseRes = i;
                    break;
                }
            }
        }
        if (previousResAmount!=dan.globalRes[numOfBaseRes].presenceAmount)
        {
            previousResAmount = dan.globalRes[numOfBaseRes].presenceAmount;
            neddFram=true;
        }
        if (min==max)
        {
            min=dan.globalRes[numOfBaseRes].min;
            max=dan.globalRes[numOfBaseRes].max;
            //trace("min="+min+"; max="+max);
            neddFram=true;
        }

        if (neddFram)
        {
            var maxBase:int =  el[numOfEl[0]].pic.totalFrames;
            //trace("el[0].pic.totalFrames="+ el[numOfEl[0]].pic.totalFrames);
            var cur1:int = previousResAmount - min;
            var max1:int = max - min;
            //trace("cur1*maxBase/max1="+cur1+"*"+maxBase+"/"+max1+"="+cur1*maxBase/max1);
            el[numOfEl[0]].pic.gotoAndStop(int(cur1 * maxBase / max1));
            neddFram = false;
        }
    }

    override public function IWontToBeSave():String
    {
        s="";
        s+="<subject>\n";
        s+="<id>"+iii+"</id>\n";
        s+="<type weAre=\""+weAre+"\" ourPosition=\""+ourPosition+"\" vis=\""+vis+"\" willSave=\"";
        if (willSave)
        {
            s+=1;
        }
        else
        {
            s+=0;
        }
        s+="\">button</type>\n";
        return s;
    }

    override protected function end_load(myXML, ii, pics, el):void //заканчиваем загрузку
    {
        super.end_load(myXML, ii, pics, el);
        dan = Danke.getInstance();

        subs.push("pic");
        visOne.push(1);
        sx.push(0);
        sy.push(0);
        sw.push(subW);
        sh.push(subH);
        specID.push(myXML.type.@spec);

        for (i=0; i<myXML.txt.length(); i++)
        {
            subs.push("txt");
            visOne.push(1);
            sx.push(myXML.txt[i].@xx);
            sy.push(myXML.txt[i].@yy);
            sw.push(0);
            sh.push(0);
            var str:String=myXML.txt[i].@id;
            specID.push(str);
            //trace("str="+str+"::"+specID.length);
            picAddr.push(new String(""));
        }

        ready=true;
    }
}
}
