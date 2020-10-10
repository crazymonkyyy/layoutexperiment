import reactivelayout;
import arsd.simpledisplay_;
import std.conv;

mixin preplayout!Color;

void main() {
  auto window = new SimpleWindow(Size(500, 500), "Event example - simpledisplay.d"
      ,OpenGlOptions.no,Resizability.allowResizing);
  
  void draw(Color c,rect r){
    auto painter = window.draw();
    painter.fillColor(c);
    painter.drawRectangle(Point(cast(int)r.x,cast(int)r.y),cast(int)(r.x2-r.x),cast(int)(r.y2-r.y));
  }
  with(Color){
  master[screenkey(size(1),size(1))]=layoutgenerate(
    [],pix(2),
    [],pix(2),
    [
    [],
    [],
    [],
    [],
    []
    ]);
  static foreach(i,c;[red,blue,black,white,green]){
    import std.conv;
    mixin("auto f"~i.to!string~"(rect r){draw(c,r);}");
    mixin("dele[c]=&f"~i.to!string~";");
  }
  window.windowResized= (int w,int h){
    draw(gray,rect(0,0,w,h));
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