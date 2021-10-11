(*=============================================================================
     _________________________________
    /\                               /\
   /  mail: Prog.81@mail.ru         /  \
  /  icq : 487-975-512             /    \
 /  site: www.progu81.narod.ru    /______\
/________________________________/       /
\      /                         \      /
 \    /                           \    /
  \  /                             \  /
   \/_______________________________\/

=============================================================================*)






unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls;

type
  PRGB = ^TRGB;
  TRGB = record b, g, r : byte; end;

  TForm1 = class(TForm)
    bvlPalitraRight: TBevel;
    bvlPalitraTop: TBevel;
    bvlPalitraBottom: TBevel;
    bvlPalitraLeft: TBevel;
    bvl: TBevel;
    Timer: TTimer;
    procedure FormPaint(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
    Color1:TRGB;
    PalClr:Double;
  end;

var
  Form1: TForm1;

implementation
    uses Matrix_Vector, math;
{$R *.dfm}


const KeyColors :array [0..6] of TRGB = (
      (b:000; g:000; r:255), // red
      (b:000; g:255; r:255), // yellow
      (b:000; g:255; r:000), // green
      (b:255; g:255; r:000), // cyan
      (b:255; g:000; r:000), // blue
      (b:255; g:000; r:255), // magenta
      (b:000; g:000; r:255)  // red
      );

// средний цвет
function RGBMiddle(c1,c2:TRGB):TRGB;
begin
  Result.r := (c1.r + c2.r) shr 1;
  Result.g := (c1.g + c2.g) shr 1;
  Result.b := (c1.b + c2.b) shr 1;
end;

// смешивание 2-х цветов
// k - коэффициент от нуля до единици
function RGBMix(c1,c2:TRGB; k:Double):TRGB;
var kk:Double;
begin
  kk := 1 - k;
  Result.r := Byte(Trunc(c1.r * kk + k * c2.r));
  Result.g := Byte(Trunc(c1.g * kk + k * c2.g));
  Result.b := Byte(Trunc(c1.b * kk + k * c2.b));
end;

function PalitraColor(Value:Single):TRGB;
var c1,c2:TRGB;
    i:Integer;
    k:Single;
begin
  if Value < 0 then Value := 0 else
  if Value > 1 then Value := 1;

  i := Trunc(6 * Value);
  c1 := KeyColors[i];
  if i > 5 then i := 0;
  c2 := KeyColors[i+1];
  k := (Value*6)-Trunc(Value*6) ;
  if k > 1 then k := 1;
  Result := RGBMix(c1,c2, k);
end;

procedure PalitraCircle(Canvas:TCanvas; X,Y, Radius:Integer; Clr:TRGB);
const CLR_WHITE:TRGB = (b:255; g:255; r:255);
const CLR_BLACK:TRGB = (b:000; g:000; r:000);
const RANGE:VFloat = 25;
const WIDTH:VFloat = 1;
var
    X0      : integer;
    Y0      : integer;
var
    v : TVector;
    k, k2, len : Double;
    p : PRGB;
    xx, yy : integer;
    img:TBitmap;
begin
  img := TBitmap.Create;
  try
    img.Width := Radius shl 1;
    img.Height := img.Width;
    img.PixelFormat := pf24bit;

    X0 := Radius;
    Y0 := Radius;

    for yy := 0 to img.Height-1 do begin
        p := img.ScanLine[yy];
    for xx := 0 to img.Width -1 do begin
      v  := VVector(xx - X0, yy - Y0 , 0);
      len := (Radius div 2) + VLength(v);
      v := VNormalize(v);

      if xx <= X0 then begin
        if yy <= Y0 then begin
          k := VDotProduct(v, VVector(0,-1,0));
        end else begin
          k := 3.0 + VDotProduct(v, VVector(-1,0,0));
        end;
      end else begin
        if yy <= Y0 then begin
          k := 1.0 + VDotProduct(v, VVector(1,0,0));
        end else begin
          k := 2.0 + VDotProduct(v, VVector(0,1,0));
        end;
      end;

      if len < Radius - WIDTH then begin
        k2 := 1-(len - (Radius - WIDTH - RANGE)) / (RANGE);
        if k2 < 0 then k2 := 0 else if k2 > 1 then k2 := 1;
        p^ := RGBMix(PalitraColor(k / 4), Clr, k2);
      end else
      if len > Radius + WIDTH then begin
        k2 := (len - (Radius + WIDTH + RANGE)) / RANGE;
        if k2 < 0 then k2 := 0 else if k2 > 1 then k2 := 1;
        p^ := RGBMix(PalitraColor(k / 4), CLR_WHITE, k2);
      end else begin
        p^ := PalitraColor(k / 4);
      end;
      inc(p);
    end;
    end;

    Canvas.Draw(X,Y, img);
  finally
    img.Free;
  end;
end;

procedure PalitraRect(Canvas:TCanvas; Rc:TRect; clr:TRGB; UseClr,OrientHoriz:Boolean);
var x,y:Integer;
  img:TBitmap;
    p:PRGB;
    kx,ky:Double;
begin
  img := TBitmap.Create;
  try
    img.Width := Rc.Right - Rc.Left;
    img.Height := Rc.Bottom - Rc.Top;
    img.PixelFormat := pf24bit;

    for y := 0 to img.Height-1 do begin
      p := img.ScanLine[y];
      ky := y / img.Height;
    for x := 0 to img.Width-1 do begin
      kx := x / img.Width;
      if UseClr then begin
        if OrientHoriz then
          p^ := RGBMix(PalitraColor(kx), clr, ky) else
          p^ := RGBMix(PalitraColor(ky), clr, kx);
      end else
        if OrientHoriz then
          p^ := PalitraColor(kx) else
          p^ := PalitraColor(ky);
      Inc(p);
    end;
    end;

    Canvas.Draw(Rc.Left,Rc.Top, img);
  finally
    img.Free;
  end;
end;

procedure TForm1.FormPaint(Sender: TObject);
var r:Integer;
begin
  Color1 := PalitraColor(PalClr);
  PalitraRect(Canvas, bvlPalitraLeft.BoundsRect, Color1, False, False);
  PalitraRect(Canvas, bvlPalitraTop.BoundsRect, Color1, False, True);
  PalitraRect(Canvas, bvlPalitraRight.BoundsRect, Color1, True, False);
  PalitraRect(Canvas, bvlPalitraBottom.BoundsRect, Color1, True, True);
  r := bvl.Width;
  if r > bvl.Height then r := bvl.Height;
  PalitraCircle(Canvas, bvl.Left+((bvl.Width-r)div 2), bvl.Top+((bvl.Height-r)div 2), r div 2, PalitraColor(PalClr));
end;

procedure TForm1.TimerTimer(Sender: TObject);
begin
  PalClr := (GetTickCount mod 5000) / 5000;
  FormPaint(Sender);
end;

end.
