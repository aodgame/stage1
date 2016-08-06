package subjects
{
public class SubPreloader extends Parent2Subject
{
    private var lag:int=0;

    public function SubPreloader(myXML, pics, el, ii, moduleName)
    {
        end_load(myXML, ii, pics, el, moduleName);
    }

    override public function work(ii):void
    {
        if (ii!=iid)
        {
            iid=ii;
        }
        if (bit.wait_subjects || bit.wait_scenario || bit.wait_texto)
        {
            if (vis==0)
            {
                vis = 1;
                lag=5;
            }
        }
        if (!bit.wait_subjects && !bit.wait_scenario && !bit.wait_texto)
        {
            if (vis==1 && lag>0)
            {
                lag--;
            }
            if (vis==1 && lag==0)
            {
                vis = 0;
            }
        }
        resultVis=vis;
    }

    override public function model(el):void
    {
        super.model(el);
    }

    override public function extremalWork(ii, el):void
    {
        work(ii);
        model(el);
    }

    override protected function end_load(myXML, ii, pics, el, moduleName):void //заканчиваем загрузку
    {
        super.end_load(myXML, ii, pics, el, moduleName);

        subs.push("pic");
        visOne.push(1);
        sx.push(0);
        sy.push(0);
        sw.push(0);
        sh.push(0);

        ready=true;
    }
}
}
