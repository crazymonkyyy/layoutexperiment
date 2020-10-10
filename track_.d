public import frsize;
alias screenint=ushort;

struct track{
  size[] defs;
  size gaps;
  screenint width;
  screenint unittopix=1;
  screenint[] spilts;//I kinda wish I could have the order of the default constuctor, the defination order and memory layout seperately 
  screenint calcgap;
  void calcspilts(){
    assert(width!=0);
    import std.algorithm;
    auto total=defs.sum+( gaps*(defs.length-2) );
    auto frtopix=
      (width-(total.pix_.pix_+total.i_*unittopix))//todo grab a safe divide
      /(total.fr_.fr_);
    auto strangeprefixsum(T)(T[] in_,T gap){//std functional is broke
      T[] out_;
      T total;
      foreach(e;in_){
        total=total+e;
        out_~=total;
        total=total+gap;
      }
      return out_;
    }
    screenint sizetopix(size a){
      return cast(screenint)(
      a.i_*unittopix+
      a.fr_.fr_*frtopix+
      a.pix_.pix_);
    }
    import std.array;
    calcgap=sizetopix(gaps);
    spilts=strangeprefixsum(defs,pix(calcgap)).map!(sizetopix).array;
  }
  auto ref calcspilts(screenint a){
    width=a;
    calcspilts;
    return spilts;
  }
  auto opSlice(size_t a,size_t b){
    assert(spilts.length>=b);
    struct pair{screenint a; screenint b;}
    if(b==0){return pair(0,0);}
    if(a==0){return pair(0,spilts[b-1]);}
    return pair(cast(screenint)(spilts[a-1]+calcgap),spilts[b-1]);
  }
}

unittest{
  import std.stdio;
  track foo=track([fr(1),fr(1),fr(1)],pix(2));
  foo.calcspilts(100).writeln;
  foo[0..1].writeln;
  foo.calcspilts(1000).writeln;
  size[] bar_=[size(200),fr(10),fr(10),fr(10)];
  track bar=track(bar_,fr(1));
  bar.calcspilts(1800).write;bar.calcgap.writeln;
  bar.calcspilts(1799).write;bar.calcgap.writeln;//todo I think fr math is doing int division in the wrong order
  bar.calcspilts(1798).write;bar.calcgap.writeln;
  bar.calcspilts(1600).write;bar.calcgap.writeln;
  bar.calcspilts(1200).write;bar.calcgap.writeln;
  bar.calcspilts(1000).write;bar.calcgap.writeln;
  bar[0..4].writeln;
  bar[1..3].writeln;
  bar[2..3].writeln;
}