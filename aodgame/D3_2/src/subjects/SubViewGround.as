/**
 * Created by alexo on 18-Jun-15.
 */
package subjects
{
import story.Danke;

public class SubViewGround extends ParentSubject
{
    private var currFrame:uint=1;
    //для спеков
    private var specFich:uint=0; //специальная фича для проигрыша с начала мувика (после проигрыша мувик исчезает до выхода в другую bit.current_room

    private var dan:Danke;

    public function SubViewGround(myXML, pics, el, ii)
    {
        end_load(myXML, ii, pics, el);
    }

    override public function work(ii):void
    {
        super.work(ii);
        resultVis=vision();
    }

    override public function model(el):void
    {
        for (i=0; i<numOfEl.length; i++)
        {
            if (resultVis==1 && el[numOfEl[i]].pic.visible!=visOne[i])
            {
                el[numOfEl[i]].pic.visible=visOne[i];
            }
            if (resultVis==0 && el[numOfEl[i]].pic.visible)
            {
                el[numOfEl[i]].pic.visible=false;
            }

            if (resultVis==1) //смена мувика на следующий или на конечный
            {
                if (el[numOfEl[i]].pic.mov1.currentFrame==el[numOfEl[i]].pic.mov1.totalFrames)
                {
                    if (el[numOfEl[i]].pic.currentFrame < el[numOfEl[i]].pic.totalFrames)
                    {
                        currFrame++;
                        el[numOfEl[i]].pic.gotoAndStop(currFrame);
                    } else
                    {
                        el[numOfEl[i]].pic.mov1.gotoAndStop(el[numOfEl[i]].pic.mov1.totalFrames-1);
                        dan.nextTurn=2;
                    }
                }
                if (dan.smallSkip==1) // если задано условие пропустить кусочек сценки
                {
                    dan.smallSkip=0;
                    el[numOfEl[i]].pic.mov1.gotoAndPlay(el[numOfEl[i]].pic.mov1.totalFrames-1);
                }
            }
        }
    }

    override protected function end_load(myXML, ii, pics, el):void //заканчиваем загрузку
    {
        super.end_load(myXML, ii, pics, el);

        dan = Danke.getInstance();

        subs.push("pic");
        vis=1;
        visOne.push(1);
        sx.push(0);
        sy.push(0);
        sw.push(0);
        sh.push(0);

        ready=true;
    }
}
}
