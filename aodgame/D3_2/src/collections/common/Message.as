/**
 * Created by alexo on 22.07.2016.
 */
package collections.common
{
public class Message
{
    public var behMenu:int; //количество кнопок, требуемых для сообщения
    public var activeShow:Boolean; //должен быть активно показан игроку
    public var out:Boolean; //удаляется после просмотра
    public var wasShowed:Boolean; //был показан игроку
    public var iii:int;

    public function Message()
    {
        behMenu = -1;
        activeShow = false;
        wasShowed = false;
        out=true;
        iii=-1;
    }
}
}
