unit uv4lmain01;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  FPReadJPEG,IntfGraphics,FPImage,RGB32writer,
  VideoCapture, videodev2;

type

  { TForm1 }

  TForm1 = class(TForm)
    BuStart: TButton;
    BuStop: TButton;
    BuPause: TButton;
    BuRestart: TButton;
    PaintBox: TPaintBox;
    Panel1: TPanel;
    ScrollBox1: TScrollBox;
    procedure BuPauseClick(Sender: TObject);
    procedure BuRestartClick(Sender: TObject);
    procedure BuStartClick(Sender: TObject);
    procedure BuStopClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    Video            : TVideo4L2Device;
    BMP              : TBitmap;
    FScanInProgress  : boolean;
    FFrameTake       : word;

    // for image capturing
    aMS        : TMemoryStream;
    aImage     : TFPCompactImgRGB16Bit;
    aImgReader : TFPReaderJpeg;
    aImgWriter : TFPWriterRGB32;

    PicFinished: Boolean;
    procedure VideoFrameSynchronized(Sender: TObject; Buffer: pointer;
      Size: integer; Error: boolean);
  public

  end;

var
  Form1: TForm1;

implementation

uses
  LCLProc, typinfo, YUV2RGB, SRGGB82RGB;

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
var
  ScaleDivisor:word;
begin
  // v4l
  Video:=TVideo4L2Device.Create(Self);
  // The format is depending on the cameras
  // deBayer RGGB 8 Bit
  {$IfDef FMT_SRGGB8}
  Video.PixelFormat := V4L2_PIX_FMT_SRGGB8;
  {$EndIf}
  // deBayer RGBG 8 Bit
  {$IfDef FMT_SGRBG8}
  Video.PixelFormat := V4L2_PIX_FMT_SGRBG8;
  {$EndIf}
  // A lot of low budgetcameras use this YUYV Format
  {$IfDef FMT_YUYV}
  Video.PixelFormat := V4L2_PIX_FMT_YUYV;
  //Video.PixelFormat := V4L2_PIX_FMT_BGR24;
  {$EndIf}
  {$IfDef FMT_BGR24}
  Video.PixelFormat := V4L2_PIX_FMT_BGR24;
  {$EndIf}
  // Set the resoloution and other parameters depending of the camaera
  Video.Width := 3872;
  Video.Height := 2764;
  Video.FrameRate := 6;
  Video.BufferCount := 2;
  Video.Device:= '/dev/video0';

  Video.OnFrameSynchronized := @VideoFrameSynchronized;

  // BMP for on-form preview
  BMP:=TBitmap.Create;
  BMP.PixelFormat:=pf24bit;
  PaintBox.Width := Video.Width;
  PaintBox.Height := Video.Height;
  BMP.SetSize(Video.Width,Video.Height);

  aMS        := TMemoryStream.Create;
  aImgWriter := TFPWriterRGB32.Create;
  aImgReader := TFPReaderJpeg.Create;

  aImgReader.Performance:=jpBestSpeed;
  aImgReader.Smoothing:=False;
  case aImgReader.Scale of
    jsFullSize:ScaleDivisor:=1;
    jsHalf:ScaleDivisor:=2;
    jsQuarter:ScaleDivisor:=4;
    jsEighth:ScaleDivisor:=8;
  else
    ScaleDivisor:=1;
  end;

  aImage     := TFPCompactImgRGB16Bit.Create(Video.Width DIV ScaleDivisor, Video.Height DIV ScaleDivisor);
  aImage.UsePalette:=False;
end;

procedure TForm1.BuStartClick(Sender: TObject);
begin
  try
    Video.Open := true;
  except
    on E:Exception do begin
        DebugLn(DateTimeToStr(now) + ' Exception:' + E.Classname + ':' + E.Message);
    end;
  end;
end;

procedure TForm1.BuPauseClick(Sender: TObject);
begin
  Video.Capture:=false;
end;

procedure TForm1.BuRestartClick(Sender: TObject);
begin
  Video.Capture:=true;
end;

procedure TForm1.BuStopClick(Sender: TObject);
begin
  Video.Capture:=false;
  Video.Open:=false;
end;

procedure TForm1.VideoFrameSynchronized(Sender: TObject;
  Buffer: pointer; Size: integer; Error: boolean);
var
  IsDebug: boolean;
  aRect:TRect;
begin
  // Inhibit retrigger
  if (FScanInProgress) then begin
    exit;
  end;
  // check if the form is visible, if yes, we want to see the result
  IsDebug:= self.IsVisible;
  if (PicFinished) then begin
    FFrameTake:=0;
    if IsDebug then PicFinished:= false;
    exit;
  end;
  { This code will take every 2 frames. }
  inc(FFrameTake);
  if ((FFrameTake mod 2) <> 0) then begin
    exit;
  end;
  FScanInProgress:=True;
  try
    // V4L2_PIX_FMT_SRGGB8
    if Video.PixelFormat = V4L2_PIX_FMT_SRGGB8 then
    begin
      //aMS.Clear;
      //aMS.Position:=0;
      //aMS.WriteBuffer(Buffer^,Size);
      //aMS.Position:=0;
      //aMS.SaveToFile('/tmp/SRGGB8.raw');
      BMP.BeginUpdate;
      SRGGB8_to_BGRA(PByte(Buffer), PByte(BMP.RawImage.Data), BMP.Width, BMP.Height);
      BMP.EndUpdate;
    end;
    //V4L2_PIX_FMT_SGBRG8
    if Video.PixelFormat = V4L2_PIX_FMT_SGRBG8 then
    begin
      //aMS.Clear;
      //aMS.Position:=0;
      //aMS.WriteBuffer(Buffer^,Size);
      //aMS.Position:=0;
      //aMS.SaveToFile('/tmp/SGRBG8.raw');
      BMP.BeginUpdate;
      SGBRG8_to_BGRA(PByte(Buffer), PByte(BMP.RawImage.Data), Video.Width, Video.Height);
      BMP.EndUpdate;
    end;
    // V4L2_PIX_FMT_YUYV
    if Video.PixelFormat = V4L2_PIX_FMT_YUYV then
    begin
      BMP.BeginUpdate;
      YUYV_to_BGRA(PLongWord(Buffer), PLongWord(BMP.RawImage.Data), BMP.Width*BMP.Height);
      BMP.EndUpdate;
    end;
    // V4L2_PIX_FMT_MJPEG
    if Video.PixelFormat = V4L2_PIX_FMT_MJPEG then
    begin
      aMS.Clear;
      aMS.Position:=0;
      aMS.WriteBuffer(Buffer^,Size);
      aMS.Position:=0;
      aImage.LoadFromStream(aMS,aImgReader);
      aMS.Clear;
      aMS.Position:=0;
      aImage.SaveToStream(aMS,aImgWriter);
      aMS.Position:=0;
      BMP.BeginUpdate;
      Move(aMS.Memory^,PByte(BMP.RawImage.Data)^,Video.Width*Video.Height*aImgWriter.Bpp);
      BMP.EndUpdate;
    end;
    if IsDebug then begin
      aRect.Left:=0;
      aRect.Top:=0;
      aRect.Height:=PaintBox.Height;
      aRect.Width:=Paintbox.Width;
      PaintBox.Canvas.StretchDraw(aRect,BMP);
    end;
    PicFinished:= True;
  finally
    FScanInProgress:=False;
  end;
end;


end.

