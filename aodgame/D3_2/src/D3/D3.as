package D3
{
import flash.display.MovieClip;
import flash.events.TimerEvent;
import flash.utils.Timer;

public class D3 extends MovieClip
{
    internal var bit:Bitte;
    internal var control:Control;
    internal var subjects:Subjects;
    internal var scenario:Scenario;
    internal var client:Client;
    internal var what:Timer = new Timer(1);

    public function D3(stage)
    {
        bit = Bitte.getInstance();
        subjects = Subjects.getInstance(stage);
        addChild(subjects);
        scenario = Scenario.getInstance(stage);
        control = new Control(stage);
        client = new Client();
    }

    public function go()
    {
        what.addEventListener(TimerEvent.TIMER, moving);
        what.start();
    }

    private function moving(event:TimerEvent):void
    {
        subjects.workControl();
        scenario.workControl();
        bit.workControl();
        client.workControl();
    }
}
}