package {

import flash.display.Sprite;
import D3.*;

[SWF(frameRate=24,width=1024,height=768)]

public class Main extends Sprite
{
    public var d3:D3;

    public function Main()
    {
        d3 = new D3(stage);
        addChild(d3);
        d3.go();
    }
}
}
