unit uBayerTest;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  BGRAbitmap, BGRABitmapTypes;

type

  TWBPreset = (
             wbpNONE,
             wbpAUTO,                // Auto white balance
             wbpCLOUDY,              // cloudy day 7500k
             wbpDAYLIGHT,            // daylight 6500k
             wbpINCANDESCENCE,       // White hot light 5000k
             wbpFLUORESCENT,         // fluorescent lamp 4400k
             wbpTUNGSTEN             // Tungsten lamp 2800k
             );

  { TFormAF }

  TFormAF = class(TForm)
    Button1: TButton;
    CBBlue: TCheckBox;
    CBGreen: TCheckBox;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Image1: TImage;
    ScrollBox1: TScrollBox;
    procedure Button1Click(Sender: TObject);
  private
    BMP: TBitmap;
    aMS: TMemoryStream;
  public

  end;

var
  FormAF: TFormAF;

implementation

uses
  ctypes;

type
  cvsize = packed record
    width : cint;
    height: cint;
  end;
  cvstatus=cint;
  pbbyte= pbyte;


{$R *.lfm}

//see https://www.programmersought.com/article/98291796437/
procedure GrayWorld(var img: TBGRABitmap; preset:TWBPreset);
var
  avgR: integer = 0;
  avgG: integer = 0;
  avgB: integer = 0;
  sumR: integer = 0;
  sumG: integer = 0;
  sumB: integer = 0;
  p: PBGRAPixel;
  size:integer;
  k:double;
  newB, newG, newR: double;
  x: integer;
  kb,kg,kr: double;
begin
  if preset = wbpNONE then
    exit;
  size:= img.Height*img.Width;
  p:= img.Data;
  for x:= 0 to size-1 do begin
    sumB := sumB + p^.blue;
    sumG := sumG + p^.green;
    sumR := sumR + p^.red;
    inc(p);
  end;
  avgR:= trunc(sumR / size);
  avgG:= trunc(sumG / size);
  avgB:= trunc(sumB / size);
  k := 0.299 * avgR + 0.587 * avgG + 0.114 * avgB;
  case preset of
    wbpAUTO: begin               // Auto white balance
      avgR:= trunc(sumR / size);
      avgG:= trunc(sumG / size);
      avgB:= trunc(sumB / size);
      end;
    wbpCLOUDY: begin             // cloudy day 7500k
      avgR:= trunc(sumR * 1.953125 / size);
      avgG:= trunc(sumG * 1.0390625 / size);
      avgB:= trunc(sumB / size);
      end;
    wbpDAYLIGHT: begin           // daylight 6500k
      avgR:= trunc(sumR * 1.2734375 / size);
      avgG:= trunc(sumG / size);
      avgB:= trunc(sumB * 1.0625 / size);
      end;
    wbpINCANDESCENCE: begin      // White hot light 5000k
      avgR:= trunc(sumR * 1.2890625 / size);
      avgG:= trunc(sumG / size);
      avgB:= trunc(sumB * 1.0625 / size);
      end;
    wbpFLUORESCENT:begin         // fluorescent lamp 4400k
      avgR:= trunc(sumR * 1.1875 / size);
      avgG:= trunc(sumG / size);
      avgB:= trunc(sumB * 1.3125 / size);
      end;
    wbpTUNGSTEN:begin             // Tungsten lamp 2800k
      avgR:= trunc(sumR / size);
      avgG:= trunc(sumG * 1.0078125 / size);
      avgB:= trunc(sumB * 1.28125 / size);
      end;
  else
    ;
  end;
  kr:= k / avgR;
  kg:= k / avgG;
  kb:= k / avgB;

  p:= img.Data;
  for x:= 0 to size-1 do begin
    newB:= p^.blue * kb;
    newG:= p^.green * kg;
    newR:= p^.red * kr;
    if trunc(newB) > 255 then
      p^.blue:= 255
    else
      p^.blue:= trunc(newB);
    if trunc(newG) > 255 then
      p^.green:= 255
    else
      p^.green:= trunc(newG);
    if trunc(newR) > 255 then
      p^.red:= 255
    else
      p^.red:= trunc(newR);
    inc(p);
  end;
end;

function deBayer(
     bayer0:pbbyte;
     bayer_step:cint;
     dst0:pbbyte;
     dst_step:cint;
     size:cvsize;
     blue,
     start_with_green:cint):cvstatus;
var
    t0,t1 :cint;
    bayer_end,
    bayer,dst : pbbyte;
    start, cnt: LongInt;
label 123;
begin
  Result:= 0;
  // Destination clear
  // wide of picture * RGB * size of byte
  cnt:= size.width*3*sizeof(dst0[0]);
  // heighth of picture minus one * size of one line
  start:= (size.height - 1)*dst_step;
  //
  fillchar( dst0^, cnt, #0);
  fillchar( (dst0 + start)^, cnt ,#0 );
//    memset( dst0, 0, size.width*3*sizeof(dst0[0]) );
//    memset( dst0 + (size.height - 1)*dst_step, 0, size.width*3*sizeof(dst0[0]) );
  inc(dst0 ,dst_step + 3 + 1);
  dec(size.height , 2);
  dec(size.width , 2);
  repeat
//    for( ; size.height-- > 0; bayer0 += bayer_step, dst0 += dst_step )
    bayer:=bayer0;
    dst:=dst0;
    bayer_end:=bayer+size.width;
{       const uchar* bayer = bayer0;
      uchar* dst = dst0;
      const uchar* bayer_end = bayer + size.width;}
    dst[-4] :=0;
    dst[-3] :=0;
    dst[-2] :=0;
    dst[size.width*3-1] :=0;
    dst[size.width*3]   :=0;
    dst[size.width*3+1] :=0;
    if( size.width <= 0 ) then
        goto 123; // continue; // can't use contineu because of decrement operator abuse + for
    if( start_with_green )<>0 then
     begin
        t0 := (ord(bayer[1]) + ord(bayer[bayer_step*2+1]) + 1) shr {>>} 1;
        t1 := (ord(bayer[bayer_step]) + ord(bayer[bayer_step+2]) + 1) shr {>>} 1;
        dst[-blue] := t0;
        dst[0] := bayer[bayer_step+1];
        dst[blue] := (t1);
        inc(bayer);
        inc(dst, 3);
     end;

    if( blue > 0 ) then
     begin
        repeat
//           for( ; bayer <= bayer_end - 2; bayer += 2, dst += 6 )

            t0 := (ord(bayer[0]) + ord(bayer[2]) + ord(bayer[bayer_step*2]) +
                  ord(bayer[bayer_step*2+2]) + 2) shr {>>} 2;
            t1 := (ord(bayer[1]) + ord(bayer[bayer_step]) +
                  ord(bayer[bayer_step+2]) + ord(bayer[bayer_step*2+1])+2) shr {>>} 2;
            dst[-1] := (t0);
            dst[0] := (t1);
            dst[1] := bayer[bayer_step+1];

            t0 := (ord(bayer[2]) + ord(bayer[bayer_step*2+2]) + 1) shr {>>} 1;
            t1 := (ord(bayer[bayer_step+1]) + ord(bayer[bayer_step+3]) + 1) shr {>>} 1;
            dst[2] := (t0);
            dst[3] := bayer[bayer_step+2];
            dst[4] := (t1);

          inc(bayer,2);
          inc(dst,6);
        until bayer>(bayer_end-2);
     end
    else
     begin
//            for( ; bayer <= bayer_end - 2; bayer += 2, dst += 6 )            {\
       repeat
            t0 := (ord(bayer[0]) + ord(bayer[2]) + ord(bayer[bayer_step*2]) +
                  ord(bayer[bayer_step*2+2]) + 2) {>>} shr 2;
            t1 := (ord(bayer[1]) + ord(bayer[bayer_step]) +
                  ord(bayer[bayer_step+2]) + ord(bayer[bayer_step*2+1])+2) {>>} shr 2;
            dst[1] := (t0);
            dst[0] := (t1);
            dst[-1] := bayer[bayer_step+1];

            t0 := (ord(bayer[2]) + ord(bayer[bayer_step*2+2]) + 1) {>>} shr 1;
            t1 := (ord(bayer[bayer_step+1]) + ord(bayer[bayer_step+3]) + 1) {>>} shr 1;
            dst[4] := (t0);
            dst[3] := bayer[bayer_step+2];
            dst[2] := (t1);
            inc(bayer,2);
          inc(dst,6);
        until bayer>(bayer_end-2);
     end;

    if( bayer < bayer_end ) then
    begin
        t0 := (ord(bayer[0]) + ord(bayer[2]) + ord(bayer[bayer_step*2]) +
              ord(bayer[bayer_step*2+2]) + 2) {>>} shr 2;
        t1 := (ord(bayer[1]) + ord(bayer[bayer_step]) +
              ord(bayer[bayer_step+2]) + ord(bayer[bayer_step*2+1])+2) shr { >>} 2;
        dst[-blue] := (t0);
        dst[0] := (t1);
        dst[blue] := bayer[bayer_step+1];
        inc(bayer);
        inc(dst,3);
    end;
    blue := -blue;
    start_with_green := not start_with_green;
//( ; size.height-- > 0; bayer0 += bayer_step, dst0 += dst_step )
123:
    inc(bayer0,bayer_step);
    inc(dst0,dst_step);
    dec(size.height);
  until (size.height<=0);
  result:=1;
end;





{ TFormAF }

procedure TFormAF.Button1Click(Sender: TObject);
var
  aRect:TRect;
  pos,cnt: LongInt;
  w,h,s: integer;
  x: cvsize;

  i: Integer;
  p: PBGRAPixel;
  img,tmp : TBGRABitmap;
  mem: array of byte;
  blue, green: integer;
begin
  w:= 3872;
  h:= 2764;
  Image1.Width:= w;
  Image1.Height:= h;
  s:= w*h;
  img := TBGRAbitmap.create (w,h, BGRA(0,0,0,255)); //schwarz, alpha = 255
  i := 0;
  p := img.Data;
  try
    // Stream read
    aMS:= TMemoryStream.Create;
    try
      aMS.LoadFromFile('SGRBG8.raw');
      pos:=aMS.Size;
      if pos > 0 then begin
        aMS.Position:= 0;
        X.width:= w;
        x.height:= h;
        SetLength(mem,w*h*3);
        if CBBlue.Checked then
          blue:= 1
        else
          blue:= 0;
        if CBGreen.Checked then
          green:= 1
        else
          green:= -1;
        deBayer(aMS.Memory, w, @mem[0], w*3, x, blue,green);
        for i:= 0 to w*h-1 do begin
          p^.red  := mem[i*3+0];
          p^.green:= mem[i*3+1];
          p^.blue := mem[i*3+2];
          p^.alpha:= 255;
          inc(p);
        end;
        img.InvalidateBitmap;
        SetLength(mem,0);
        // Zeichnen
        img.InvalidateBitmap;
        case ComboBox2.ItemIndex of
          1: img.InplaceNormalize(false);
          2: img.InplaceNormalize(true);
        end;
        if (ComboBox1.ItemIndex >= 0) then
          GrayWorld(img,TWBPreset(ComboBox1.ItemIndex));
        tmp := TBGRABitmap.create;
        BGRAreplace (tmp, img.Resample(Image1.width,image1.height));
        tmp.draw (Image1.Canvas,0,0);
      end
      else
        ShowMessage('Kein Bild gefunden');
    finally
      aMS.Free;
      aMS:= nil;
    end;
  finally
    img.Free;
    img:= nil;
    tmp.Free;
    tmp:= nil;
  end;
end;

end.
