import std.stdio;
import core.time;
import std.process;
import std.conv;
import std.random;
import core.thread;
import std.array;
import reactivelayout;
import arsd.simpledisplay_;

alias mt = MonoTime;
alias td = Duration;
alias now= mt.currTime;

void main(string[] s){
  mt timerstart;
  bool started;
  int current;
  int[] timers;
  
  foreach(i;0..(s[1].to!int)){
    timers~=s[2+i].to!int;
  }
  auto getcommand(){
    return s[s[1].to!int+2..$].join(" ");
  }
  bool istime(){
    if(!started){return false;}
    auto foo=now-timerstart;
    return minutes(timers[current])<foo;
  }
  auto timeleft(){
    auto foo=now-timerstart;
    return minutes(timers[current])-foo;
  }
  void starttimer(){
    timerstart=now;
    started=true;
  }
  void update(){
    if(started){
      if(istime){
        getcommand.writeln;
        started=false;
      } else {
        timeleft.writeln;
  }}}
  timers.writeln;
  current=0;
  starttimer;
  while(true){
    update;
    Thread.sleep(seconds(dice(2,1,1,1,1)));
  }
}