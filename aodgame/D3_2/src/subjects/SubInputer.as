/**
 * Created by alexo on 16.08.2016.
 */
package subjects
{
import story.Danke;

public class SubInputer extends Parent2Subject
{
    public var fram:Vector.<int> = new Vector.<int>();

    public var cameraUse:int=0;

    private var modificator:String="";
    private var maxChars:int=0; //максимальное количество символов, вводимое в строку, 0 - сколько угодно
    private var makeMaxChars:Boolean=false;

    private var posInArray:int=-1;

    public function SubInputer(myXML, pics, el, ii, moduleName)
    {
        end_load(myXML, ii, pics, el, moduleName);
    }

    override public function work(ii):void
    {
        super.work(ii);
        if (cameraUse==1)
        {
            show();
        }

        if (bit.mouseParUp==iii)
        {
            bit.whatUnderOne=iii;
        }
    }

    override public function getParam(str, num)
    {
        trace(str+":::"+num);
    }

    override public function model(el):void
    {
        super.model(el);
        standartBehavior(el);
    }

    private function standartBehavior(el):void
    {
        if (vis==1)
        {
            if (el[numOfEl[0]].iii!=idOfEl)
            {
                return;
            }
            if (!makeMaxChars)
            {
                makeMaxChars=true;
                el[numOfEl[0]].pic.maxChars=maxChars;
            }
            /*if (el.pic.text.length>10)
            {
                el.pic.text=el.pic.text.substr(0,10);
            }*/
        }
    }


    override protected function end_load(myXML, ii, pics, el, moduleName):void
    {
        super.end_load(myXML, ii, pics, el, moduleName);

        if (myXML.camera=="1")
        {
            cameraUse = 1;
        }

        modificator=myXML.type.@modificator;

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
            picAddr.push(new String(""));

            maxChars=int(myXML.maxChars.@mc);
        }
        ready=true;
    }
}
}
