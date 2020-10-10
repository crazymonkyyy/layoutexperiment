alias rectint=ulong;//int compadiblity rules NEVER get old
import std.stdio;
auto deconstructgridcoloring(T)(T[][] array){
  struct rect__{
    T id;
    rectint x;
    rectint y;
    rectint x2;
    rectint y2;
  }
  struct minmax{
    import lazynullable__;
    nullable!rectint xmin;
    nullable!rectint xmax;
    nullable!rectint ymax;
    nullable!rectint ymin;
  }
  minmax[T] data;
  foreach(y,innerarray;array){
  foreach(x,e;innerarray){
    if(e !in data){data[e]=minmax();}
    if(x<data[e].xmin){data[e].xmin=x;}
    if(x>data[e].xmax){data[e].xmax=x;}
    if(y<data[e].ymin){data[e].ymin=y;}
    if(y>data[e].ymax){data[e].ymax=y;}
  }}
  rect__[] out_;
  foreach(key,value;data){
    out_~=rect__(key,value.xmin,value.ymin,value.xmax+1,value.ymax+1);
  }
  return out_;
}
unittest{
  auto foo=[
    [1,1,2],
    [1,1,2],
    [3,3,3]];
  foo.deconstructgridcoloring.writeln;
}
unittest{
  enum c{red__,green,blue_,black,white};
  auto foo=[
  [c.red__,c.blue_,c.blue_,c.black,c.black],
  [c.red__,c.blue_,c.blue_,c.black,c.black],
  [c.red__,c.blue_,c.blue_,c.black,c.black],
  [c.red__,c.blue_,c.blue_,c.white,c.white],
  [c.green,c.green,c.green,c.white,c.white]
  ];
  foo.deconstructgridcoloring.writeln;
}