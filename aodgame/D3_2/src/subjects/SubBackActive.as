/**
 * Created by Lemming on 22.06.15.
 */
package subjects
{
public class SubBackActive extends Parent2Subject
{
    public function SubBackActive(myXML, pics, el, ii)
    {
        end_load(myXML, ii, pics, el);
    }

    override public function work(ii):void
    {
        super.work(ii);
        show();
    }

    override public function model(el):void
    {
        super.model(el);
    }

    override public function IWontToBeSave():String
    {
        s="";
        return s;
    }

    override protected function end_load(myXML, ii, pics, el):void //заканчиваем загрузку
    {
        super.end_load(myXML, ii, pics, el);

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