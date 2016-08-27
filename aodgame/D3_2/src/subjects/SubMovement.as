/**
 * Created by alexo on 02.05.2016.
 */
package subjects
{
public class SubMovement extends Parent2Subject
{
    public var fram:Vector.<int> = new Vector.<int>(); //текущий тип ресурса локации
    /*
     ** [0] - знак ресурсов
     ** [1..3] - первый тип добываемого/теряемого реса
     ** [4] - место под первое здание/человека
     ** [5..7] - место под второе здание/человека
     */
    //private var neddFram:Boolean=false;

    public var cameraUse:int=0;

    private var baseX:int;
    private var baseY:int;
    private var cli:int=0;
    private var tx:int;
    private var ty:int;
    private var move:Boolean;

    public function SubMovement(myXML, pics, el, ii, moduleName)
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
        if (move)
        {
            mouseMove();
        }

        if (bit.mouseParUp==iii || cli==-1)
        {
            bit.whatUnderOne=iii;
            cli=0;
            trace("|in movement");
            trace("bit.whatUnderOne="+bit.whatUnderOne);
            trace("bit.underRes="+bit.underRes);
        }
    }

    private function mouseMove():void
    {
        if (cli==1)
        {
            if (bit.dm==0)
            {
                trace("outs");
                cli=-1;
                for (i=0; i<sx.length; i++)
                {
                    subX=baseX;
                    subY=baseY;
                }
            } else
            {
                for (i=0; i<sx.length; i++)
                {
                    subX = bit.sx+tx;
                    subY = bit.sy+ty;
                }
            }
            return;
        }
        if (bit.mouseParDown==iii)
        {
            cli=1;
            tx=subX-bit.sx;
            ty=subY-bit.sy;
        }

    }

    override public function getParam(str, num)
    {
        trace(str+":::"+num);
    }

    override public function model(el):void
    {
        super.model(el);
        if (neddFram)
        {
            neddFram=false;
            for (i=0; i<numOfEl.length; i++)
            {
                if (el[numOfEl[i]].typeOfElement!="txt")
                {
                    el[numOfEl[i]].pic.gotoAndStop(fram[i]);
                }
            }
        }
    }

    override protected function end_load(myXML, ii, pics, el, moduleName):void //заканчиваем загрузку
    {
        super.end_load(myXML, ii, pics, el, moduleName);

        if (myXML.camera=="1")
        {
            cameraUse = 1;
        }

        if (myXML.move=="true")
        {
            move=true;
        }else
        {
            move=false;
        }
        baseX = subX;
        baseY = subY;

        subs.push("mc");
        visOne.push(1);
        sx.push(0);
        sy.push(0);
        sw.push(0);
        sh.push(0);
        specID.push(0);
        fram.push(myXML.type.@fram);
        neddFram=true;

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
        }
        tx=0;
        ty=0;
        ready=true;
    }
}
}