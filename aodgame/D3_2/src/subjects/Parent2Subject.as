/**
 * Created by ��������� on 25.06.2015.
 */
package subjects
{
import story.Danke;

public class Parent2Subject extends ParentSubject
{
    public var curX:int;
    public var curY:int;

    //protected var dan:Danke;

    override public function work(ii):void
    {
        super.work(ii);
        resultVis = vision();
    }

    protected function show()
    {
        if (bit.realX - curX < 1025 + subW && bit.realY - curY < 769 + subH &&
                bit.realX - curX > -1025 - subW && bit.realY - curY > -769 - subH)
        {
            subX = bit.centx - (bit.realX - curX);
            subY = bit.centy - (bit.realY - curY);
        }
        else
        {
            resultVis = 0;
        }
    }

    override public function takeParam(str):int
    {
        return super.takeParam(str);
    }

    override public function model(el):void
    {
        for (i=0; i<numOfEl.length; i++)
        {
            if (alph!=oldAlph)
            {
                if (alph>1)
                {
                    el[numOfEl[i]].pic.alpha=alph/1000;
                } else
                {
                    el[numOfEl[i]].pic.alpha=100;
                }
                oldAlph=alph;
            }
            if (resultVis==1 && el[numOfEl[i]].pic.visible!=visOne[i])
            {
                el[numOfEl[i]].pic.visible=visOne[i];
            }
            if (resultVis==0 && el[numOfEl[i]].pic.visible)
            {
                el[numOfEl[i]].pic.visible=false;
            }
        }
    }

    override protected function end_load(myXML, ii, pics, el):void //����������� ��������
    {
        super.end_load(myXML, ii, pics, el);

        curX=subX;
        curY=subY;

        //dan = Danke.getInstance();
    }
}
}

