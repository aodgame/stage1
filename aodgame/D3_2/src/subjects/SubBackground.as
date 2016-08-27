/**
 * Created by alexo on 25-May-15.
 */
package subjects
{
public class SubBackground extends Parent2Subject
{
    private var camera:Boolean=false;

    public function SubBackground(myXML, pics, el, ii, moduleName)
    {
        end_load(myXML, ii, pics, el, moduleName);
    }

    override public function work(ii):void
    {
        super.work(ii);
        if (camera)
        {
            show();
        }
    }

    override public function model(el):void
    {
        super.model(el);
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

    override protected function end_load(myXML, ii, pics, el, moduleName):void //заканчиваем загрузку
    {
        super.end_load(myXML, ii, pics, el, moduleName);

        subs.push("pic");
        visOne.push(1);
        sx.push(0);
        sy.push(0);
        sw.push(subW);
        sh.push(subH);
        specID.push(0);

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
           // trace("str="+str+"::"+specID.length);
            picAddr.push(new String(""));

            bit.textoCodes.push(new String());
            bit.textoTexts.push(new String());
        }

        if (myXML.camera=="1")
        {
            camera=true;
            angle=myXML.camera.@angle;
            if (angle!=0)
            {
                ang=true;
            }
        }

        ready=true;
    }
}
}