import arsd.simpledisplay;
import std.stdio;

void main() {
  auto window = new SimpleWindow(Size(500, 500), "Event example - simpledisplay.d"
    ,OpenGlOptions.no,Resizability.allowResizing);

  window.eventLoop(10000,
      delegate(){
        "timer".writeln;
      },
      delegate(KeyEvent event) {
      },
      delegate(MouseEvent event) {
      },
      delegate(dchar ch) {
      }
  );
  window.windowResized= (int w,int h){
    "hi".writeln;
  };
}