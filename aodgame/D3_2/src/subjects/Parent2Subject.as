/**
 * Created by ��������� on 25.06.2015.
 */
package subjects
{
public class Parent2Subject extends ParentSubject
{
    public var curX:int;
    public var curY:int;

    public var startX:Vector.<int> = new Vector.<int>();
    public var startY:Vector.<int> = new Vector.<int>();

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

    private function textPositioning():void
    {
        if(startX.length!=sx.length)
        {
            for (i=0; i<sx.length; i++)
            {
                startX.push(sx[i]);
                startY.push(sy[i]);
            }
        }
    }
    private function textPosIt(curEl):void
    {
        if (curEl.typeOfElement=="txt")
        {
            var lng:int=curEl.pic.numLines;
            var pos:int=startY[i]-(lng-1)*(curEl.size+2)/2;
            if (sy[i]!=pos)
            {
                sy[i]=pos;
            }
        }
    }

    private function visualisation(curEl):void
    {
        if (alph!=oldAlph)
        {
            if (alph>1)
            {
                curEl.pic.alpha=alph/1000;
            } else
            {
                curEl.pic.alpha=100;
            }
            oldAlph=alph;
        }
        if (resultVis==1 && curEl.pic.visible!=visOne[i])
        {
            curEl.pic.visible=visOne[i];
        }
        if (resultVis==0 && curEl.pic.visible)
        {
            curEl.pic.visible=false;
        }
    }

    override public function model(el):void
    {
        textPositioning();
        for (i=0; i<numOfEl.length; i++)
        {
            visualisation(el[numOfEl[i]]);
            textPosIt(el[numOfEl[i]]);
        }
    }

    override protected function end_load(myXML, ii, pics, el, moduleName):void
    {
        super.end_load(myXML, ii, pics, el, moduleName);
        curX=subX;
        curY=subY;
    }
}
}