public import layout;
public import rectmatching;

auto resizehook_(T)(T data,int w,int h){
  screenkey which;
  int min=int.max;
  foreach(e;data.byKey){
    auto t=e.distence(w,h);
    if(t<min){
      min=t;
      which=e;
    }
  }
  import track_;
  return data[which](cast(screenint)w,cast(screenint)h);
}

void drawbykey_(T,U,V)(T currentlayout,U userdelegates,V key){
  userdelegates[key](currentlayout[key]);
}

void drawall_(T,S)(T currentlayout,S userdelegates){
  foreach(k;currentlayout.keys){
    drawbykey_(currentlayout,userdelegates,k);
  }
}

mixin template preplayout(KEY,string mastername="master",
      string storename="store",string delegates="dele"){

  alias storedlayout=rect[KEY];
  alias sizelayout=storedlayout delegate(ushort,ushort);
  alias masterlayout=sizelayout[screenkey];
  alias drawdelegate=void delegate(rect);
  
  mixin("masterlayout "~mastername~";");
  mixin("storedlayout "~storename~";");
  mixin("drawdelegate[KEY] "~delegates~";");
  
  void drawall(){
    mixin("drawall_("~storename~","~delegates~");");
  }
  void resizehook(T)(T x,T y){
    mixin(storename~".clear;");
    mixin(storename~"=resizehook_("~mastername~",x,y);");
    drawall;
  }
  void drawbykey(KEY k){
    mixin("drawbykey_("~storename~","~delegates~",k);");
  }
}
unittest{
  mixin preplayout!int;
  masterlayout foo;
}