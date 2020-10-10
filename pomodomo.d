import std.stdio;
import core.time;
import std.process;
import std.conv;
import std.random;
import core.thread;
import std.array;
import arsd.simpledisplay_;
import reactivelayout;
import std.algorithm;

mixin preplayout!int;

alias mt = MonoTime;
alias td = Duration;
alias now= mt.currTime;

Color background = Color(0,0,0);
Color text       = Color(128,128,128);
Color highlight  = Color(0,64,64);

void main(string[] s){
  //-------------- timer functions
  mt timerstart;
  bool started;
  int current;
  int[] timers;
  if(s.length>1){
    foreach(i;0..(s[1].to!int)){
      timers~=s[2+i].to!int;
  }}
  if(timers.length==0){
    timers~=25;
    timers~=5;
    "syntax: the number of timers, the timers space seperated in minutes, the command that runs when done".writeln;
    "./pomodomo 3 1 2 3 ~/.config/wallpaperchanger.sh".writeln;
    "./pomodomo 2 25 5 beep".writeln;
    "./pomodomo 1 300 rm -*".writeln;
    "./pomodomo 16 5 10 20 25 40 45 60 120 180 7 49 420 1337 1 2 3".writeln;
  }
  assert(timers.length<17,"due to the delegate bug in dlang I support only 16 timers, this can be changed in code trivailly however");
  auto getcommand(){
    if(s.length<timers.length+1){return "";}
    return s[s[1].to!int+2..$].join(" ");
  }
  auto savedcommand=getcommand;
  bool istime(){
    if(!started){return false;}
    auto foo=now-timerstart;
    return minutes(timers[current])<foo;
  }
  auto timeleft(){
    if( ! started){return td();}
    auto foo=now-timerstart;
    return minutes(timers[current])-foo;
  }
  string timeleft_(){
    auto t=timeleft;
    auto f(long i){
      string s=i.to!string;
      if(s.length==1){s="0"~s;}
      return s;
    }
    return 
        f(t.total!"minutes")~
        ":"~
        f(t.total!"seconds"%60);
  }
  string timerstring(int id){
    return timers[id].to!string~":00";
  }
  void starttimer(){
    timerstart=now;
    started=true;
  }
  void update(){
    if(started){
      if(istime){
        //getcommand.writeln;
        executeShell(savedcommand);
        started=false;
        current++; if(current==timers.length){current=0;}
      } else {
        //timeleft.writeln;
  }}}
  //---------------------- fonts
  
  struct fontwrapper{
    OperatingSystemFont foo; alias foo this;
    int size_;
    void size(int a){
      if(a!=size_){
        size_=a;
        foo= new OperatingSystemFont("*",a);
  }}}
  fontwrapper countdown;
  fontwrapper button;
  
  int calcbuttonfont(rect[] a){
    rect r=a.front;
    return min(48,(r.y2-r.y)/2,max(14,(r.y2-r.y)));//todo
  }
  
  //---------------------- layouts
  
  //(size[] row,size rowgap,size[] col,size colgap,Key[][] coloring){
  
  //the keys: countdown is -1, 0..timers.length is the timer buttons
  master[screenkey(pix(1)+fr(1),pix(1)+fr(1))]=layoutgenerate(
    [fr(1)],pix(2),
    [fr(1)],pix(2),
    [
    [-1]
    ]);
  void generatelayout1(){
    size[] col;
    int[] top;
    int[] buttons;
    size x,y;
    foreach(i;0..timers.length){
      col~=fr(5)+pix(8*5);
      top~=-1;
      buttons~=cast(int)i;//OH MY GOD DLANG
      x=x+pix(8*5)+fr(4);
      //y=y+pix(8*5);//the width of a char * "00:00", ish maybe
    }
    y=fr(1)+pix(16);
    master[screenkey(x,y)]=layoutgenerate(
      col,fr(1),
      [fr(3)+pix(32),fr(1)+pix(14)],pix(1),
      [
      top,
      buttons,
      ]);
  }
  generatelayout1;
  void generatelayout2(){
    size[] col;
    int[][] keys;
    size x,y;
    foreach(i;0..timers.length){
      col~=fr(5);
      keys~=[cast(int)i,int(-1)];
      x=x+pix(8*5);
      y=y+pix(16);//the width of a char * "00:00", ish maybe
    }
    x=x+fr(3);
    y=y+fr(1);
    master[screenkey(x,y)]=layoutgenerate(
      [fr(1)+pix(8*5),fr(4)+pix(16*5)],pix(0),
      col,fr(1),
      keys);
  }
  generatelayout2;
  
  //--------------------- window creation
  auto window = new SimpleWindow(Size(500, 500), "Event example - simpledisplay.d"
    ,OpenGlOptions.no,Resizability.allowResizing);
  void draw(Color c,rect r){
    auto painter = window.draw();
    painter.fillColor(c);
    painter.drawRectangle(Point(cast(int)r.x,cast(int)r.y),cast(int)(r.x2-r.x),cast(int)(r.y2-r.y));
  }
  void drawcountdown(rect r){
    auto painter = window.draw();
    draw(background,r);
    painter.outlineColor(text);
    countdown.size=min(128,r.y2-r.y,(r.x2-r.x)/6*2);
    painter.setFont(countdown);
    painter.drawText(Point(cast(int)r.x,cast(int)r.y),timeleft_,Point(cast(int)r.x2,cast(int)r.y2)
        ,TextAlignment.Center|TextAlignment.VerticalCenter);
  }
  
  void drawbutton(int id, rect r){
    auto painter = window.draw();
    painter.outlineColor(text);
    if(id==current){painter.fillColor(highlight);}
    else{painter.fillColor(background);}
    painter.setFont(button);
    painter.drawRectangle(Point(cast(int)r.x,cast(int)r.y),cast(int)(r.x2-r.x),cast(int)(r.y2-r.y));
    painter.drawText(Point(cast(int)r.x,cast(int)r.y),timerstring(id),Point(cast(int)r.x2,cast(int)r.y2)
        ,TextAlignment.Center|TextAlignment.VerticalCenter);
  }
  //--------- draw hooks
  
  dele[-1]=&drawcountdown;
  static foreach(i;0..16){
    mixin("void f"~i.to!string~"(rect r){drawbutton("~i.to!string~",r);}");
    mixin("dele[cast(int)i]=&f"~i.to!string~";");
  }
  
  //--------- final setup
  
  void click(int a){
    if( ! started){
      if(a!=-1){current=a;}
      starttimer;
    }
  }
  
  window.windowResized= (int w,int h){
    draw(Color.black,rect(0,0,w,h));
    resizehook(w,h);
    drawall();
  };
  //current=cast(int)timers.length-1;
  //starttimer;
  window.eventLoop(1000,
    delegate(){drawbykey(-1);update;},
    delegate(KeyEvent event) {},
    delegate(MouseEvent event) {
      if(event.type==MouseEventType.buttonPressed){
        foreach(k,v;store){
          if(
            event.x>v.x  &&
            event.x<v.x2 &&
            event.y>v.y  &&
            event.y<v.y2
          ) {click(k); drawall();}
        }
      }
    },
    delegate(dchar ch) {}
  );
}