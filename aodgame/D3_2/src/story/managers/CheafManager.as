/**
 * Created by alexo on 02.06.2016.
 */
package story.managers
{
import story.Danke;

public class CheafManager
{
    private var landsManager:LandsManager;
    private var resManager:ResManager;
    private var buildingManager:BuildingManager;
    private var updManager:UpdatesManager;
    private var heroManager:HeroManager;
    private var cityManager:CityManager;

    private var dan:Danke;

    public function CheafManager()
    {
        landsManager = new LandsManager();
        resManager = new ResManager();
        buildingManager = new BuildingManager();
        updManager = new UpdatesManager();
        heroManager = new HeroManager();
        cityManager = new CityManager();

        dan = Danke.getInstance();
    }

    public function work(sub):void
    {
        buildingManager.work(sub);
        landsManager.work();
        resManager.work();
        updManager.work();
        cityManager.work(sub);
        heroManager.work(sub);

        dan.outI=-1;
    }

    public function unwork(sub):void
    {
        resManager.laggy(2);
    }
}
}
