/**
 * Created by alexo on 15-May-15.
 */
package phys {
public class Find {
    public function Find()
    {
    }


    public static function  findNum(arr, ii, curr):int //вектор, индекс элемента, порядковый номер в векторе
    {
        var i:int;
        var j:int;
        var k:int;

        i=curr-1;
        j=curr+1;
        k=-1;

        while (i>=0 || j<=arr.length)
        {
            if (i>=0 && arr[i].iii==ii)
            {
                k=i;
                break;
            }
            if (j<arr.length && arr[j].iii==ii)
            {
                k=j;
                break;
            }
            i--;
            j++;
        }
        return k;
    }

}
}
