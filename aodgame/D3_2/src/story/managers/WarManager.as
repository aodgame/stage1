/**
 * Created by alexo on 11.08.2016.
 */
package story.managers
{
import D3.Bitte;

public class WarManager
{
    private var bit:Bitte;

    public function WarManager()
    {
        bit = Bitte.getInstance();
    }

    public function work():void
    {
        if (bit.sChangeTurn)
        {
            playerDesitionsAnalyze();
        }
    }

    private function playerDesitionsAnalyze():void
    {

    }
}
}
