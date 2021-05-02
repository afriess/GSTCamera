unit uBayerTest;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    PaintBox: TPaintBox;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    BMP: TBitmap;
    aMS: TMemoryStream;
  public

  end;

var
  Form1: TForm1;

implementation

uses
  SRGGB82RGB;

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
var
  aRect:TRect;
  pos,cnt: LongInt;
  w,h,s: integer;
begin
  w:= 3872;
  h:= 2764;
  s:= w*h;
  BMP:=TBitmap.Create;
  try
    BMP.PixelFormat:=pf24bit;
    BMP.SetSize(w,h);
    // Stream read
    aMS:= TMemoryStream.Create;
    try
      // This Picture have such a matrix from a MT9J003 10MPx Digital Image Sensor
      //  GRGR
      //  BGBG
      aMS.LoadFromFile('SGRBG8.raw');
      pos:=aMS.Size;
      if pos > 0 then begin
        aMS.Position:= 0;
        BMP.BeginUpdate;
        cnt:=BMP.RawImage.DataSize;
        SGBRG8_to_BGRA(aMS.Memory , BMP.RawImage.Data, w, h);
        BMP.EndUpdate;
        // Zeichnen
        aRect.Left:=0;
        aRect.Top:=0;
        aRect.Height:=PaintBox.Height;
        aRect.Width:=Paintbox.Width;
        PaintBox.Canvas.StretchDraw(aRect,BMP);
      end
      else
        ShowMessage('Kein Bild gefunden');
    finally
      aMS.Free;
      aMS:= nil;
    end;
  finally
    BMP.Free;
    BMP:= nil;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin

end;

procedure TForm1.FormDestroy(Sender: TObject);
begin

end;

end.

