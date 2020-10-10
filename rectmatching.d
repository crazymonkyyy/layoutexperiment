enum unitw=1;
enum unith=1;//broke in layout and should probaly imported somehow
public import frsize;
struct screenkey{
  size width;
  size heigth;
  auto distence(T)(T w,T h){
    import std.math;
    auto dis(T)(T a,T b,T c,T d){
      return abs(a-c)+abs(b-d);
    }
    
    auto sizetofixed(size a,int b){
      return a.i_*b+a.pix_.pix_;
    }
    auto w_=sizetofixed(width ,unitw);
    auto h_=sizetofixed(heigth,unith);
    
    if(width.fr_.fr_==0||heigth.fr_.fr_==0){return dis(w_,h_,w,h);}
    
    auto wfr=(w-w_)/(cast(float) width.fr_.fr_);
    auto hfr=(h-h_)/(cast(float)heigth.fr_.fr_);
    auto fr=fmin(wfr,hfr);
    if(fr<0){return 10000;}
    auto w__=cast(int)fr* width.fr_.fr_+w_;
    auto h__=cast(int)fr*heigth.fr_.fr_+h_;
    return dis(w__,h__,w,h)+cast(int)fr;
  }
}

unittest{
  import std.stdio;
  auto a=screenkey(fr(3),fr(4));
  auto b=screenkey(fr(16),fr(9));
  auto c=screenkey(size(100),size(200));
  auto d=screenkey(size(4000),size(3000));
  auto e=screenkey(fr(16)+720,fr(9)+480);
  
  void discheck(T)(T w,T h){
    writeln(w," ,",h,":");
    a.write;a.distence(w,h).writeln;
    b.write;b.distence(w,h).writeln;
    c.write;c.distence(w,h).writeln;
    d.write;d.distence(w,h).writeln;
    e.write;e.distence(w,h).writeln;
  } 
  discheck(720,480);
  discheck(100,200);
  discheck(1080,900);
  discheck(100,150);
}