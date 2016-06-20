/**
 * Created by alexo on 26-May-15.
 */
package story
{
import D3.Bitte;

import flash.events.Event;
import flash.events.MouseEvent;

import flash.net.FileFilter;

import flash.net.FileReference;
import flash.ui.Mouse;

import flash.utils.ByteArray;

public class Saver
{
    private var way:String;
    private var bit:Bitte;

    private var i:uint;
    private var s:String;

    public function Saver()
    {
        bit = Bitte.getInstance();
    }

    public function work(sub)
    {
        if (bit.curRoom==11)
        {
            bit.needToBeSave=true;
            bit.curRoom=16;
            bit.prevRoom=16;
        }
        if (bit.needToBeSave==true)
        {
            s="";
            s=sub.getSave();
            bit.needToBeSave=false;
            bit.curRoom=16;
            save();
        }
        //trace("3Saverbit.curRoom="+bit.curRoom);
    }
   // [Fault] exception, information=Error: Error #2176: Certain actions, such as those that display a pop-up window,
    //    may only be invoked upon user interaction, for example by a mouse click or button press.
   //     at flash.net::FileReference/_save()
    private function save()
    {
        //var MyTextField:TextField = new TextField();
        //var MyButtonField:TextField = new TextField();
        var MyFile:FileReference = new FileReference();

       // MyTextField.border = true;
        //MyTextField.type = TextFieldType.INPUT;

       /* MyButtonField.background = true;
        MyButtonField.backgroundColor = 0x339933;
        MyButtonField.x = 150;
        MyButtonField.height = 20;
        MyButtonField.text = "Click here to save";

        addChild(MyTextField);
        addChild(MyButtonField);*/
       // MyButtonField.addEventListener(MouseEvent.CLICK, clickhandler);

        //function clickhandler(e:MouseEvent): void {
        //MyFile.browse([new FileFilter("Images", "*.jpg;*.gif;*.png")]);
        /*var path:String=bit.addr+"mytxt.txt";
        function onFileLoaded(e:Event):void
        {
            MyFile.save(s);
        }
        var t:Event;
        onFileLoaded(t);*/

        //}


       /* var byteArray:ByteArray = new ByteArray();
        byteArray.writeUTFBytes(s);

         сохраняем файл на компьютере пользователя

        var path:String=bit.addr+"mytxt.txt";
        trace("path="+path);
        var fileReferenceSave:FileReference = new FileReference();
        fileReferenceSave.save(s);*/
    }
}
}
