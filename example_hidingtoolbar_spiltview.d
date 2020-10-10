import reactivelayout;
import arsd.simpledisplay_;
import std.conv;

enum elements {
  toolbar,
  view___,
  view2__,
  view4k_
}

mixin preplayout!elements;

int textscale=1;

void main() {
  auto window = new SimpleWindow(Size(500, 500), "Event example - simpledisplay.d"
      ,OpenGlOptions.no,Resizability.allowResizing);
  
  void draw(Color c,rect r){
    auto painter = window.draw();
    painter.fillColor(c);
    painter.drawRectangle(Point(cast(int)r.x,cast(int)r.y),cast(int)(r.x2-r.x),cast(int)(r.y2-r.y));
  }
  
  enum small       =screenkey(pix(1)      +fr(1),pix(1)      +fr(1));
  enum singleview  =screenkey(pix(360-50) +fr(9),pix(480-50) +fr(16));
  enum doubleview  =screenkey(pix(720-50) +fr(4),pix(480-50) +fr(3));
  enum singleview4k=screenkey(pix(1024-50)+fr(9),pix(1538-50)+fr(16));
  enum doubleview4k=screenkey(pix(2048-50)+fr(4),pix(1538-50)+fr(3));  
  
  with(elements){
  master[small]=layoutgenerate(
    [fr(1)],pix(2),
    [fr(1)],pix(2),
    [
    [view___]
    ]);
  master[singleview]=layoutgenerate(
    [fr(1)],pix(2),
    [pix(128),fr(1)],pix(2),
    [
    [toolbar],
    [view___]
    ]);
  master[doubleview]=layoutgenerate(
    [fr(1),fr(1)],pix(10),
    [pix(128),fr(1)],pix(2),
    [
    [toolbar,toolbar],
    [view___,view2__]
  ]);
  master[singleview4k]=layoutgenerate(
    [fr(1)],pix(4),
    [pix(256),fr(1)],pix(4),
    [
    [toolbar],
    [view4k_]
    ]);
  master[doubleview4k]=layoutgenerate(
    [fr(1),fr(1)],pix(20),
    [pix(256),fr(1)],pix(4),
    [
    [toolbar,toolbar],
    [view4k_,view2__]
  ]);
  
  void drawtoolbar(rect r){
    draw(Color.red,r);
  }
  void drawview___(rect r){
    textscale=1;
    draw(Color.blue,r);
  }
  void drawview2__(rect r){
    draw(Color.blue,r);
  }
  void drawview4k_(rect r){
    textscale=2;
    draw(Color.blue,r);
  }
  
  with(elements){
    dele[toolbar]=&drawtoolbar;
    dele[view___]=&drawview___;
    dele[view2__]=&drawview2__;
    dele[view4k_]=&drawview4k_;
  }
  
  window.windowResized= (int w,int h){
    draw(Color.gray,rect(0,0,w,h));
    resizehook(w,h);
    drawall();
  };
  window.eventLoop(10000,
    delegate(){},
    delegate(KeyEvent event) {},
    delegate(MouseEvent event) {},
    delegate(dchar ch) {}
  );
}}