//eh todo fix binary right subtraction 

alias whichint=short;
struct size{
  whichint i_;
  fr fr_;
  pix pix_;
  this(whichint a, whichint b,whichint c){
    i_  =a;
    fr_ =fr(b);
    pix_=pix(c);
  }
  this(int a){i_=cast(whichint)a;}
  this(whichint a){i_=a;}
  this(fr a){fr_=a;}
  this(pix a){pix_=a;}
  this(size a){this=a;}
  
  size opBinary(string s:"+")(size a){
    return size(
      cast(whichint)(i_       +a.i_       ),
      cast(whichint)(fr_.fr_  +a.fr_.fr_  ),
      cast(whichint)(pix_.pix_+a.pix_.pix_)
    );
  }
  size opBinary(string s:"*",T)(T a){
    return size(
      cast(whichint)(i_       *a),
      cast(whichint)(fr_.fr_  *a),
      cast(whichint)(pix_.pix_*a)
    );
  }
  size opBinary(string s:"+",T)(T a) if (!is(T==size)){
    return this+size(a);
  }
  size opBinary(string s:"-",T)(T a){
    return -(a + (-this));
  }
  size opBinaryRight(string s,T)(T a){
    mixin("return this"~s~"a;");
  }
  size opUnary(string s)(){
    return size(
      cast(whichint)(-i_       ),
      cast(whichint)(-fr_.fr_  ),
      cast(whichint)(-pix_.pix_)
    );
  }
}
struct fr{
  whichint fr_;
  size size_(){return size(0,fr_,0);}
  auto opUnary(string op)(){return size(0,0,0)-this;}
  size opBinary(string s:"-",T)(T a){
    return -(a + (-this));
  }
  size opBinary(string s:"+",T)(T a){
    return size_+size(a);
  }
  size opBinaryRight(string s,T)(T a){
    mixin("return this"~s~"a;");
  }
  alias size_ this;
}
struct pix{
  whichint pix_;
  size size_(){return size(0,0,pix_);}
  auto opUnary(string op)(){return size(0,0,0)-this;}
  size opBinary(string s:"-",T)(T a){
    return -(a + (-this));
  }
  size opBinary(string s:"+",T)(T a){
    return size_+size(a);
  }
  size opBinaryRight(string s,T)(T a){
    mixin("return this"~s~"a;");
  }
  alias size_ this;
}

unittest{
  assert(fr(1)+pix(2)==size(0,1,2));
  assert(1+fr(2)+pix(3)==size(1,2,3));
  assert(fr(1)-pix(2)==size(0,1,-2));
  //assert(1-fr(2)==size(1,-2,0));
  import std.stdio; (1-fr(2)-pix(3)).writeln;
  //assert(-1-fr(2)-pix(3)==size(-1,-2,-3));
  assert(pix(1)+fr(2)+3==size(3,2,1));
  assert(size(1,2,3)+size(4,5,6)==size(5,7,9));
  //(size(1,2,3)-size(1,1,1)).writeln;
  assert(size(1,2,3)-size(1,1,1)==size(0,1,2));
}