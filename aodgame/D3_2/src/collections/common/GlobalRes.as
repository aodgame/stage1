/**
 * Created by alexo on 28.04.2016.
 */
package collections.common
{
public class GlobalRes
{
   // <globalRes typpe="gold" pic="" name="200" description="201">1</globalRes>
    public var typpe:String;
    public var pic:String;
    public var sName:String;
    public var sDescription:String;

    public var iii:int=-1;

    public var amount:int; //количество всего ресурса на руках
    public var isFree:Boolean; //есть ли отличие максимального от текущего количества ресов
    public var freeAmount:int; //доступное количество ресурса для какого-либо использования
    public var income:int; //может быть получено в начале следующего хода

    public var min:int;
    public var max:int;

    public var need:String; //нужда одного ресурса в другом ресурсе
    public var paramsOfNeed:Vector.<String> = new Vector.<String>(); //параметры нужды
    public var needAmount:int; //для расчёта как часть ресурса, вычитаемого в конце хода
    public var presenceAmount:int; //для расчёта как часть ресурса, учитываемого в конце хода

    public function GlobalRes()
    {
        typpe="";
        pic="";
        sName="";
        sDescription="";
        amount=0;
        income=0;
        isFree=false;
        freeAmount=amount;
        min=0;
        max=0;
        needAmount=0;
        presenceAmount=0;
    }
}
}
