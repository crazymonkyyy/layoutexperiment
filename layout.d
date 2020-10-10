public import frsize;
alias rectint=ulong;
enum unitw=1;//mathwrong   8;
enum unith=1;//mathwrong   12;//textsize or something
struct rect{
  rectint x;
  rectint y;
  rectint x2;
  rectint y2;
}

auto layoutgenerate(Key)(size[] row,size rowgap,size[] col,size colgap,Key[][] coloring){
  rect[Key] outputdel(ushort width,ushort heigth){
    import track_;
    auto row_=track(row,rowgap,width ,ushort(unitw));row_.calcspilts;
    auto col_=track(col,colgap,heigth,ushort(unith));col_.calcspilts;
    
    import griddeconstuct;
    auto coloring_=coloring.deconstructgridcoloring;
    rect[Key] out_;
    foreach(c;coloring_){
      auto r=row_[c.x..c.x2];
      auto h=col_[c.y..c.y2];
      out_[c.id]=rect(r.a,h.a,r.b,h.b);
    }
    return out_;
  }
  return &outputdel;
}
import std.stdio;
unittest{
  enum  c {red__,green,blue_,black,white}
  auto layout= layoutgenerate(
    [size(20),fr(1),fr(1),size(80),fr(1)],pix(2),
    [size(20),fr(1),fr(1),size(40),fr(1)],pix(2),
    [
    [c.red__,c.blue_,c.blue_,c.black,c.black],
    [c.red__,c.blue_,c.blue_,c.black,c.black],
    [c.red__,c.blue_,c.blue_,c.black,c.black],
    [c.red__,c.blue_,c.blue_,c.white,c.white],
    [c.green,c.green,c.green,c.white,c.white]
    ]);
  layout.writeln;
  layout(800,480).writeln;
  layout(320,480).writeln;
}