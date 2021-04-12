// This file is from Winni see https://www.lazarusforum.de/viewtopic.php?p=120964#p120964
unit BayerTest1;

{$mode objfpc}{$H+}

interface

uses
   Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
   BGRAbitmap, BGRABitmapTypes;

type

	 { TFormWinni }

   TFormWinni = class(TForm)
			Button1: TButton;
			Button2: TButton;
			Button3: TButton;
			Image1: TImage;
			Label1: TLabel;
			procedure Button1Click(Sender: TObject);
			procedure Button2Click(Sender: TObject);
			procedure Button3Click(Sender: TObject);
   private

   public

   end;

var
   FormWinni: TFormWinni;

   (*
   w:= 3872;
  h:= 2764;*)


implementation

{$R *.lfm}


Const
  w= 3872;
  h= 2764;
  fname =  'SGRBG8.raw';
  LE = LineEnding;

var mem: array of byte;



// Load
procedure TFormWinni.Button1Click(Sender: TObject);
var f : File;
    fsize,read : Int64;
begin
assignFile (f,  fname);
reset (f,1);
fsize := FileSize(f);
setLength(mem,fsize);
blockRead (f,mem[0],fsize,read);
//showMessage (IntToStr(fsize)+LE + IntToStr(Read)+LE +IntToStr(w*h));
closeFile (f);
ShowMessage('Geladen');
end;

//paint
procedure TFormWinni.Button2Click(Sender: TObject);
var i: int64;
    p: PBGRAPixel;
    img,tmp : TBGRABitmap;
begin
Label1.Caption := '0';
Application.ProcessMessages;
img := TBGRAbitmap.create (w div 2,h div 2, BGRA(0,0,0,255)); //schwarz, alpha = 255
i := 0;
p := img.Data;
while i <= high(mem) do
  begin
  p^.green := (mem[i]+mem[i+w+1]) div 2;
  p^.red := mem[i+1];
  p^.blue := mem[i+w];
  // alpha ist schon beim create gesetzt
  inc(i,2);
  inc(p);
  if i mod (w) = 0 then
     begin
     inc(i,w);
     label1.caption :=  FloatToStr(i/high(mem)*100)+'%';
     Application.ProcessMessages;
     end;
end; // while;
  img.InvalidateBitmap;
  img.saveToFile('./fullBayer.png');
  tmp := TBGRABitmap.create;
  BGRAreplace (tmp, img.Resample(Image1.width,image1.height));
  tmp.draw (Image1.Canvas,0,0);
  // Kleines Bild für Forum
  BGRAreplace (tmp, img.Resample (w div 8, h div 8));
  tmp.saveToFile('./Bayer.png');
  img.free;
  tmp.free;
end;

procedure TFormWinni.Button3Click(Sender: TObject);
begin
   close;
end;

end.

