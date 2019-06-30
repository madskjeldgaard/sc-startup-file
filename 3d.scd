(
var controlWindow, w;
var r, a, b, c, d, matrix = [1, 0, 0, 1, 10, 10];
var sliders, spex, name;

w = Window.new.front;
w.view.background_(Color.white);

// create a controller-window
controlWindow = Window("matrix controls", Rect(400,200,350,120));
controlWindow.front;

// determine the rectangle to be drawn
r = Rect.fromPoints(a = 0 @ 0, c = 180 @ 180);
b = r.leftBottom;
d = r.rightTop;

// the drawFunc
w.drawFunc = {
    Pen.strokeColor = Color.red;
    Pen.matrix = matrix;
    Pen.width = 5;
    Pen.strokeRect(r);
    Pen.strokeOval(r);
    Pen.color = Color.blue;
    Pen.width = 0.1;
    Pen.line(a, c);
    Pen.line(b, d);
    Pen.stroke;

    Pen.font = Font( "Helvetica-Bold", 12 );
    Pen.stringAtPoint( "A", a - 6 );
    Pen.stringAtPoint( "B", b - 6 );
    Pen.stringAtPoint( "C", c - (0@6) );
    Pen.stringAtPoint( "D", d - (0@6) );

    Pen.font = Font( "Helvetica", 10 );
    Pen.stringInRect( "a matrix test", r.moveBy( 50, 50 ));
};

controlWindow.view.decorator = sliders = FlowLayout(controlWindow.view.bounds);
spex = [
    [0, 2.0].asSpec,
    [0, 2.0].asSpec,
    [0, 2.0].asSpec,
    [0, 2.0].asSpec,
    [0, 200.0].asSpec,
    [0, 200.0].asSpec
];
name = #[zoomX, shearingY, shearingX, zoomY, translateX, translateY];
6.do { |i|
    EZSlider(controlWindow, 300 @ 14, name[i], spex[i], { |ez| var val;
            val = ez.value;
            [i, val.round(10e-4)].postln;
            matrix.put(i, val);
            w.refresh; // reevaluate drawFunc function
    }, matrix[i]);
    sliders.nextLine;
};
w.refresh;
)
