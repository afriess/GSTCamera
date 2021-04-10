unit prffrmvideov4l;

{$IFDEF FPC}
  // we use normally objfpc, because its native and more typesafe
  {$mode objfpc}{$H+}
  {$IFDEF Windows}
    // actual no support for windows
    {$ MESSAGE ERROR 'Only Linux is supported!' }
  {$ENDIF}
{$ENDIF}
{ $Define KameraDebug}

interface

uses
  Classes, SysUtils, XMLConf, FileUtil, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, ActnList, IniFiles,
  FPReadJPEG,IntfGraphics,FPImage,RGB32writer,
  VideoCapture, videodev2;


const
  //DSMax = 1431655765;
  DSNotValid = $55555555;
  coStoreVersion = 2;

type
   DbgLvl = (dbgLvlNo, dbgLvlStart, dbgLvlRun, dbgLvlAll);

type

  TMsgEvent = procedure(const S: string) of object;

  { TFormVideoTmp }

  TFormVideoTmp = class(TForm)
    actCamShowEdit: TAction;
    actCamReadCfg: TAction;
    actCamWriteCfg: TAction;
    actCamReadProps: TAction;
    actCamWriteProps: TAction;
    ActionListCam: TActionList;
    BuClear: TButton;
    BuRead: TButton;
    BuUpdate: TButton;
    ImageListCam: TImageList;
    LblSize: TLabel;
    MemoInfo: TMemo;
    PaintBox: TPaintBox;
    PanButton: TPanel;
    PC: TPageControl;
    PanelControls: TScrollBox;
    TSInfo: TTabSheet;
    TSParams: TTabSheet;
    ToolBar: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    procedure actCamReadCfgExecute(Sender: TObject);
    procedure actCamReadPropsExecute(Sender: TObject);
    procedure actCamShowEditExecute(Sender: TObject);
    procedure actCamWriteCfgExecute(Sender: TObject);
    procedure actCamWritePropsExecute(Sender: TObject);
    procedure BuClearClick(Sender: TObject);
    procedure BuReadClick(Sender: TObject);
    procedure BuUpdateClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    Video            : TVideo4L2Device;
    BMP              : TBitmap;
    //prevTicks        : QWord;
    FScanInProgress  : boolean;
    FFrameTake       : word;

    // for image capturing
    aMS        : TMemoryStream;
    aImage     : TFPCompactImgRGB16Bit;
    aImgReader : TFPReaderJpeg;
    aImgWriter : TFPWriterRGB32;

    FAutoStart: boolean;
    FNameFormat: String;
    FNameKamera: String;
    FNamenNr: Integer;
    FOnMessage: TMsgEvent;
    procedure CamCtrlReadAktProps(StoreName: String; MinVersion: integer);
    procedure CamCtrlWriteAktProps(StoreName: String; Version: integer);
    procedure ClearPanelControls;
    procedure ControlButtonClick(Sender: TObject);
    procedure ControlCheckBoxChange(Sender: TObject);
    procedure ControlComboBoxChange(Sender: TObject);
    procedure ControlTrackBarChange(Sender: TObject);
    procedure DoMessage(msg: String);
    procedure SetAutoStart(AValue: boolean);
    procedure SetNameFormat(AValue: String);
    procedure SetNameKamera(AValue: String);
    procedure SetNamenNr(AValue: Integer);
    procedure SetStoreName(AValue: String);
    procedure ShowPanelControls;
    procedure UpdatePanelControls;
    // v4l
    procedure VideoFrameSynchronized(Sender: TObject; Buffer: pointer;
      Size: integer; Error: boolean);

  protected
    FOldParent: TWinControl;
    FStoreName: String;
    UpdatingControls : boolean;
  public
    PicFinished : boolean;
    INIFileName: String;
    DbgLvl: DbgLvl;
    // Test start
    function CamCtrlReadNameKamera: string;
    function CamCtrlReadNameNr: integer;
    procedure WriteAktPropsXML(Version: integer);
    procedure ReadAktPropsXML(Version: integer);
    procedure ShowPropsXML;
    // Test end
    procedure Init1;
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure SelectDevice(DevNr: integer);
    procedure SnapShot(var aBmp: TBitmap);
    procedure Start;
    procedure Pause;
    procedure Restart;
    procedure Stop;
    function IsStopped:boolean;
    function IsRunning:boolean;
    property NameKamera: String read FNameKamera write SetNameKamera;
    property NameFormat: String read FNameFormat write SetNameFormat;
    property NamenNr: Integer read FNamenNr write SetNamenNr;
    property AutoStart: boolean read FAutoStart write SetAutoStart;
    property OnMessage: TMsgEvent read FOnMessage write FOnMessage;
    property StoreName: String read FStoreName write SetStoreName;
  end;

function GetVideoFormA:TFormVideoTmp;


implementation
uses
  strutils, LCLProc, typinfo, YUV2RGB
  {$IfDef deBayer}
  ,SRGGB82RGB
  {$EndIf}
  ;


var
  FormVideoTmpA: TFormVideoTmp;

function GetVideoFormA: TFormVideoTmp;
begin
  if FormVideoTmpA = nil then begin
    {$ifdef KAMERADEBUG}Debugln(DateTimeToStr(now) + {$I %FILE%} + '->' +{$I %CURRENTROUTINE%} + ' Singleton Create');{$endif}
    FormVideoTmpA := TFormVideoTmp.Create(nil);
  end;
  Result := FormVideoTmpA;
end;


{$R *.lfm}

{ TFormVideoTmp }

procedure TFormVideoTmp.DoMessage(msg: String);
begin
  if FOnMessage <> nil then
    FOnMessage(msg);
end;

procedure TFormVideoTmp.SetNameKamera(AValue: String);
begin
  if FNameKamera= AValue then Exit;
  FNameKamera:= AValue;
end ;

procedure TFormVideoTmp.SetNamenNr(AValue: Integer);
begin
  if FNamenNr=AValue then Exit;
  FNamenNr:=AValue;
end;

procedure TFormVideoTmp.SetStoreName(AValue: String);
begin
  if FStoreName=AValue then Exit;
  FStoreName:=AValue;
end;

procedure TFormVideoTmp.VideoFrameSynchronized(Sender: TObject;
  Buffer: pointer; Size: integer; Error: boolean);
var
  IsDebug: boolean;
  aRect:TRect;
begin
  // Verhindert retrigger
  if (FScanInProgress) then begin
    Debugln(DateTimeToStr(now) + {$I %FILE%} + '->' +{$I %CURRENTROUTINE%} + ' retrigger inhibit');
    exit;
  end;
  // Prüfen wir ob gerade das Fenster offen haben, weil dann wollen wir was sehen
  IsDebug:= self.IsVisible;
  if (PicFinished) then begin
    {$ifdef KAMERADEBUG}Debugln(DateTimeToStr(now) + {$I %FILE%} + '->' +{$I %CURRENTROUTINE%} + ' Pic finished');{$endif}
    FFrameTake:=0;
    if IsDebug then PicFinished:= false;
    exit;
  end;
  { This code will take every 2 frames. }
  inc(FFrameTake);
  if ((FFrameTake mod 2) <> 0) then begin
    {$ifdef KAMERADEBUG}Debugln(DateTimeToStr(now) + {$I %FILE%} + '->' +{$I %CURRENTROUTINE%} + ' Pic waiting ' + IntToStr(FFrameTake));{$endif}
    exit;
  end;
  {$ifdef KAMERADEBUG}Debugln(DateTimeToStr(now) + {$I %FILE%} + '->' +{$I %CURRENTROUTINE%} + ' TakeFrame ' + IntToStr(FFrameTake));{$endif}
  FScanInProgress:=True;
  try
    {$IfDef deBayer}
    // V4L2_PIX_FMT_SRGGB8 für theImageSource möglich
    if Video.PixelFormat = V4L2_PIX_FMT_SRGGB8 then
    begin
      {$ifdef KAMERADEBUG}Debugln(DateTimeToStr(now) + {$I %FILE%} + '->' +{$I %CURRENTROUTINE%} + ' PixelFormat = V4L2_PIX_FMT_SRGGB8');{$endif}
     //aMS.Clear;
      //aMS.Position:=0;
      //aMS.WriteBuffer(Buffer^,Size);
      //aMS.Position:=0;
      //aMS.SaveToFile('/tmp/test.raw');
      BMP.BeginUpdate;
      SRGGB8_to_BGRA(PByte(Buffer), PByte(BMP.RawImage.Data), BMP.Width, BMP.Height);
      BMP.EndUpdate;
    end;
    {$EndIf}

    if Video.PixelFormat = V4L2_PIX_FMT_YUYV then
    begin
      {$ifdef KAMERADEBUG}Debugln(DateTimeToStr(now) + {$I %FILE%} + '->' +{$I %CURRENTROUTINE%} + ' PixelFormat = V4L2_PIX_FMT_YUYV');{$endif}
      BMP.BeginUpdate;
      YUYV_to_BGRA(PLongWord(Buffer), PLongWord(BMP.RawImage.Data), BMP.Width*BMP.Height);
      //YUYV_to_BGRA16(PLongWord(Buffer), PWord(BMP.RawImage.Data), BMP.Width*BMP.Height);
      BMP.EndUpdate;
    end;

    if Video.PixelFormat = V4L2_PIX_FMT_MJPEG then
    begin
      {$ifdef KAMERADEBUG}Debugln(DateTimeToStr(now) + {$I %FILE%} + '->' +{$I %CURRENTROUTINE%} + ' PixelFormat = V4L2_PIX_FMT_MJPEG');{$endif}
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
    Debugln(DateTimeToStr(now) + '->'+ 'FrameSize=' + IntToStr(Size)+ ' Error='+BoolToStr(Error,'True','False') + ' RGB00='+IntToHex(BMP.Canvas.Pixels[0,0],8));
  finally
    FScanInProgress:=False;
  end;

end;

function TFormVideoTmp.CamCtrlReadNameKamera: string;
var
 INI: TIniFile;
begin
  {$ifdef KAMERADEBUG}Debugln(DateTimeToStr(now) + {$I %FILE%} + '->' +{$I %CURRENTROUTINE%});{$endif}
  INI := TIniFile.Create(INIFileName);
  Result:= INI.ReadString(StoreName, 'CameraName', '');
  FreeAndNil(INI);
end;

function TFormVideoTmp.CamCtrlReadNameNr: integer;
var
 INI: TIniFile;
begin
  {$ifdef KAMERADEBUG}Debugln(DateTimeToStr(now) + {$I %FILE%} + '->' +{$I %CURRENTROUTINE%});{$endif}
  INI := TIniFile.Create(INIFileName);
  Result:= INI.ReadInteger(StoreName, 'CameraNr', -1);
  FreeAndNil(INI);
end;




procedure TFormVideoTmp.WriteAktPropsXML(Version:integer);
begin
  {$ifdef KAMERADEBUG}Debugln(DateTimeToStr(now) + {$I %FILE%} + '->' +{$I %CURRENTROUTINE%});{$endif}
  CamCtrlWriteAktProps(FStoreName,Version);
end;

procedure TFormVideoTmp.ReadAktPropsXML(Version:integer);
begin
  {$ifdef KAMERADEBUG}Debugln(DateTimeToStr(now) + {$I %FILE%} + '->' +{$I %CURRENTROUTINE%});{$endif}
  CamCtrlReadAktProps(FStoreName,Version);
end;

procedure TFormVideoTmp.ShowPropsXML;
begin
  {$ifdef KAMERADEBUG}Debugln(DateTimeToStr(now) + {$I %FILE%} + '->' +{$I %CURRENTROUTINE%});{$endif}
  ;
end;

procedure TFormVideoTmp.SetNameFormat(AValue: String);
begin
  if FNameFormat= AValue then Exit;
  FNameFormat:= AValue;
end ;

procedure TFormVideoTmp.SetAutoStart(AValue: boolean);
begin
  if FAutoStart=AValue then Exit;
  FAutoStart:=AValue;
end;

constructor TFormVideoTmp.Create(TheOwner: TComponent);
var
  ScaleDivisor:word;
begin
  inherited;
  {$ifdef KAMERADEBUG}Debugln(DateTimeToStr(now) + {$I %FILE%} + '->' +{$I %CURRENTROUTINE%});{$endif}
  FOnMessage:= nil;
  FOldParent:= self.Parent;
  {$Ifdef KAMERADEBUG}DbgLvl:= dbgLvlAll; {$EndIf}
  NamenNr:= 0;
  NameKamera:= '/dev/video0';

  // v4l
  Video:=TVideo4L2Device.Create(Self);
  {$IfDef deBayer}
  Video.PixelFormat := V4L2_PIX_FMT_SRGGB8; // für theImageSource möglich, falls man es konvertieren kann
  {$Else}
  Video.PixelFormat := V4L2_PIX_FMT_YUYV;
  {$EndIf}
  Debugln('Nativ Read With='+IntToStr(Video.Width) + ' Height='+ IntToStr(Video.Height));
  {$IFDEF AndiTest}
  Video.Width := 3840;
  Video.Height := 2160;
  Video.FrameRate := 15;
  Video.BufferCount := 1;
  Video.Device:=NameKamera;
  {$Else}
  Video.Width := 5472;
  Video.Height := 3648;

  Video.FrameRate := 15;
  Video.BufferCount := 2;
  Video.Device:=NameKamera;
  {$EndIf}
  Video.OnFrameSynchronized := @VideoFrameSynchronized;
  Debugln('After Set  With='+IntToStr(Video.Width) + ' Height='+ IntToStr(Video.Height));

  // BMP for on-form preview
  BMP:=TBitmap.Create;
  BMP.PixelFormat:=pf24bit;
  //PaintBox.Width := Video.Width;
  //PaintBox.Height := Video.Height;
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

  //UpdateParams;
end;

destructor TFormVideoTmp.Destroy;
begin
  {$ifdef KAMERADEBUG}Debugln(DateTimeToStr(now) + {$I %FILE%} + '->' +{$I %CURRENTROUTINE%});{$endif}
  // v4l
  Video.OnFrameSynchronized:=nil;
  Video.Capture:=false;
  Video.Open:=false;
  Video.Free; // free Video BEFORE drawable bitmap or Synchronize will raise AV
  if aMS<>nil then aMS.Free;
  if aImage<>nil then aImage.Free;
  if aImgReader<>nil then aImgReader.Free;
  if aImgWriter<>nil then aImgWriter.Free;
  if BMP<>nil then BMP.Free;
  self.Parent:= FOldParent;
  inherited Destroy;
end;

procedure TFormVideoTmp.FormDestroy(Sender: TObject);
begin
  {$ifdef KAMERADEBUG}Debugln(DateTimeToStr(now) + {$I %FILE%} + '->' +{$I %CURRENTROUTINE%});{$endif}

end;

procedure TFormVideoTmp.FormCreate(Sender: TObject);
begin
  {$ifdef KAMERADEBUG}Debugln(DateTimeToStr(now) + {$I %FILE%} + '->' +{$I %CURRENTROUTINE%});{$endif}
  FAutoStart:=True;
end;

procedure TFormVideoTmp.actCamShowEditExecute(Sender: TObject);
begin
  {$ifdef KAMERADEBUG}Debugln(DateTimeToStr(now) + {$I %FILE%} + '->' +{$I %CURRENTROUTINE%});{$endif}
  ShowPropsXML;
end;

procedure TFormVideoTmp.actCamWriteCfgExecute(Sender: TObject);
begin
  {$ifdef KAMERADEBUG}Debugln(DateTimeToStr(now) + {$I %FILE%} + '->' +{$I %CURRENTROUTINE%});{$endif}
  WriteAktPropsXML(coStoreVersion);
end;

function ControlTypeToStr(t:longword):string;
begin
  case t of
    V4L2_CTRL_TYPE_INTEGER:      Result:='int';
    V4L2_CTRL_TYPE_BOOLEAN:      Result:='bool';
    V4L2_CTRL_TYPE_MENU:         Result:='menu';
    V4L2_CTRL_TYPE_INTEGER_MENU: Result:='int_menu';
    V4L2_CTRL_TYPE_BITMASK:      Result:='bitmask';
    V4L2_CTRL_TYPE_BUTTON:       Result:='button';
    V4L2_CTRL_TYPE_INTEGER64:    Result:='int64';
    V4L2_CTRL_TYPE_STRING:       Result:='string';
  else
    Result:='???';
  end;
end;


procedure TFormVideoTmp.actCamWritePropsExecute(Sender: TObject);
begin
end;

procedure TFormVideoTmp.BuClearClick(Sender: TObject);
begin
  ClearPanelControls;
end;

procedure TFormVideoTmp.BuReadClick(Sender: TObject);
begin
  ShowPanelControls;
end;

procedure TFormVideoTmp.BuUpdateClick(Sender: TObject);
begin
  UpdatePanelControls;
end;

procedure TFormVideoTmp.actCamReadCfgExecute(Sender: TObject);
begin
  {$ifdef KAMERADEBUG}Debugln(DateTimeToStr(now) + {$I %FILE%} + '->' +{$I %CURRENTROUTINE%});{$endif}
  ReadAktPropsXML(coStoreVersion);
end;

procedure TFormVideoTmp.actCamReadPropsExecute(Sender: TObject);
var
  i,j : integer;
begin
  PC.ActivePage:= TSInfo;
  MemoInfo.Clear;
  {$ifdef KAMERADEBUG}Debugln(DateTimeToStr(now) + {$I %FILE%} + '->' +{$I %CURRENTROUTINE%});{$endif}
  if (not Video.Open) then begin
    MemoInfo.Lines.Add('Videodevice not open');
    {$ifdef KAMERADEBUG}Debugln(DateTimeToStr(now) + '-> Videodevice not open');{$endif}
    exit;
  end;
  MemoInfo.Clear;
  for i:=0 to Video.ControlsInfo.Count-1 do begin
    with Video.ControlsInfo[i] do begin
      MemoInfo.Lines.Add(Name+' ('+ControlTypeToStr(ControlType)+') ['+
        IntToStr(Minimum)+'..'+IntToStr(Maximum)+'] ('+IntToStr(DefaultValue)+')');
      if ControlType in [V4L2_CTRL_TYPE_MENU, V4L2_CTRL_TYPE_INTEGER_MENU] then begin
        for j:=0 to Menu.Count-1 do begin
          with Menu[j] do begin
            if TypeInteger then begin
              MemoInfo.Lines.Add('  '+IntToStr(Index)+': (int64) '+Name+' '+IntToHex(Value,8));
            end else begin
              MemoInfo.Lines.Add('  '+IntToStr(Index)+': '+Name)
            end;
          end;
        end;
      end;
    end;
  end;
end;


procedure TFormVideoTmp.ClearPanelControls;
var i: integer;
begin
  for i:=PanelControls.ControlCount-1 downto 0 do begin
    PanelControls.Controls[i].Free;
  end;
end;

procedure TFormVideoTmp.ShowPanelControls;
var i,j:integer;
  ctop: integer;
  LabelControl: TLabel;
  NewControl: TControl;
  TrackBar: TTrackBar;
  CheckBox: TCheckBox;
  ComboBox: TComboBox;
  Button: TButton;
begin
  MemoInfo.Clear;
  for i:=0 to Video.ControlsInfo.Count-1 do begin
    with Video.ControlsInfo[i] do begin
      MemoInfo.Lines.Add(Name+' ('+ControlTypeToStr(ControlType)+') ['+
        IntToStr(Minimum)+'..'+IntToStr(Maximum)+'] ('+IntToStr(DefaultValue)+')');
      if ControlType in [V4L2_CTRL_TYPE_MENU, V4L2_CTRL_TYPE_INTEGER_MENU] then begin
        for j:=0 to Menu.Count-1 do begin
          with Menu[j] do begin
            if TypeInteger then begin
              MemoInfo.Lines.Add('  '+IntToStr(Index)+': (int64) '+Name+' '+IntToHex(Value,8));
            end else begin
              MemoInfo.Lines.Add('  '+IntToStr(Index)+': '+Name)
            end;
          end;
        end;
      end;
    end;
  end;

  UpdatingControls:=True;
  ClearPanelControls;
  ctop:=0;
  for i:=0 to Video.ControlsInfo.Count-1 do begin
    with Video.ControlsInfo[i] do begin
      LabelControl:=TLabel.Create(Self);
      LabelControl.WordWrap:=True;
      LabelControl.AutoSize:=False;
      LabelControl.Font.Size:=8;
      LabelControl.Caption:=Name +' (D:'+IntToStr(DefaultValue)+'/V:' + IntToStr(Value) + ')';
      LabelControl.Top:=14+ctop;
      LabelControl.Left:=4;
      LabelControl.Width:=150;
      LabelControl.Height:=26;
      LabelControl.WordWrap:=True;
      LabelControl.Parent:=PanelControls;
      case ControlType of
        V4L2_CTRL_TYPE_INTEGER: begin
          TrackBar:=TTrackBar.Create(Self);
          TrackBar.Min:=Minimum;
          TrackBar.Max:=Maximum;
          TrackBar.LineSize:=Step;
          TrackBar.PageSize:=Step;
          TrackBar.Position:=Value;
          TrackBar.Height:=38;
          TrackBar.OnChange:=@ControlTrackBarChange;
          NewControl:=TrackBar;
        end;
        V4L2_CTRL_TYPE_BOOLEAN: begin
          CheckBox:=TCheckBox.Create(Self);
          CheckBox.Checked:=Boolean(Value);
          CheckBox.OnChange:=@ControlCheckBoxChange;
          NewControl:=CheckBox;
        end;
        V4L2_CTRL_TYPE_MENU: begin
          ComboBox:=TComboBox.Create(Self);
          ComboBox.Style:=csDropDownList;
          for j:=0 to Menu.Count-1 do begin
              {$ifdef KAMERADEBUG}Debugln('->' +{$I %CURRENTROUTINE%} + ' V4L2_CTRL_TYPE_MENU '+inttostr(j)+ '='+Menu[j].Name);{$endif}
            if (Menu[j].Name = '') then
              ComboBox.Items.Add('Unkown '+IntToStr(j))
            else
              ComboBox.Items.Add(Menu[j].Name);
          end;
          ComboBox.ItemIndex:=Value; // DefaultValue is menu index, we need item index here, so using Value
          ComboBox.OnChange:=@ControlComboBoxChange;
          NewControl:=ComboBox;
        end;
        V4L2_CTRL_TYPE_INTEGER_MENU: begin
          ComboBox:=TComboBox.Create(Self);
          ComboBox.Style:=csDropDownList;
          for j:=0 to Menu.Count-1 do begin
            {$ifdef KAMERADEBUG}Debugln('->' +{$I %CURRENTROUTINE%} + ' V4L2_CTRL_TYPE_INTEGER_MENU '+inttostr(j)+ '='+Menu[j].Name);{$endif}
            if (Menu[j].Name = '') then
              ComboBox.Items.Add('Unkown '+IntToStr(j))
            else
              ComboBox.Items.Add(Menu[j].Name);
          end;
          ComboBox.ItemIndex:=Value; // DefaultValue is menu index, we need item index here, so using Value
          ComboBox.OnChange:=@ControlComboBoxChange;
          NewControl:=ComboBox;
        end;
        V4L2_CTRL_TYPE_BUTTON: begin
          Button:=TButton.Create(Self);
          Button.OnClick:=@ControlButtonClick;
          NewControl:=Button;
        end;
      else
        // V4L2_CTRL_TYPE_BITMASK:
        // V4L2_CTRL_TYPE_INTEGER64:
        // V4L2_CTRL_TYPE_STRING:
        LabelControl:=TLabel.Create(Self);
        LabelControl.Caption:='('+ControlTypeToStr(ControlType)+')';
        NewControl:=LabelControl;
      end;
      NewControl.Tag:=i;
      NewControl.Font.Size:=8;
      NewControl.Top:=4+ctop;
      NewControl.Left:=4+150;
      NewControl.Width:=170;
      NewControl.Parent:=PanelControls;
      ctop:=ctop+40;
    end;
  end;
  UpdatingControls:=False;
end;


procedure TFormVideoTmp.ControlTrackBarChange(Sender: TObject);
begin
  if UpdatingControls then exit;
  with Sender as TTrackBar do begin
    Video.ControlsInfo[Tag].SetValue(Position);
  end;
end;

procedure TFormVideoTmp.ControlCheckBoxChange(Sender: TObject);
begin
  if UpdatingControls then exit;
  with Sender as TCheckBox do begin
    Video.ControlsInfo[Tag].SetValue(Integer(Checked));
  end;
end;

procedure TFormVideoTmp.ControlButtonClick(Sender: TObject);
begin
  if UpdatingControls then exit;
  with Sender as TButton do begin
    Video.ControlsInfo[Tag].SetValue(0); // any value is ok for button control
  end;
end;

procedure TFormVideoTmp.ControlComboBoxChange(Sender: TObject);
begin
  if UpdatingControls then exit;
  with Sender as TComboBox do begin
    Video.ControlsInfo[Tag].SetValue(ItemIndex); // item index will be recalculated to menu index
  end;
end;


procedure TFormVideoTmp.UpdatePanelControls;
var
  i:integer;
  Control:TControl;
begin
  UpdatingControls:=True;
  Video.GetControlValues;
  for i:=0 to Video.ControlsInfo.Count-1 do begin
    with Video.ControlsInfo[i] do begin
      Control:=PanelControls.Controls[i*2+1];
      case ControlType of
        V4L2_CTRL_TYPE_INTEGER: begin
          (Control as TTrackBar).Position:=Value;
        end;
        V4L2_CTRL_TYPE_BOOLEAN: begin
          (Control as TCheckBox).Checked:=Boolean(Value);
        end;
        V4L2_CTRL_TYPE_MENU: begin
          (Control as TComboBox).ItemIndex:=Value;
        end;
        V4L2_CTRL_TYPE_INTEGER_MENU: begin
          (Control as TComboBox).ItemIndex:=Value;
        end;
        V4L2_CTRL_TYPE_BUTTON: begin
          // no value
        end;
      else
        // V4L2_CTRL_TYPE_BITMASK:
        // V4L2_CTRL_TYPE_INTEGER64:
        // V4L2_CTRL_TYPE_STRING:
      end;
    end;
  end;
  UpdatingControls:=False;
end;


procedure TFormVideoTmp.CamCtrlWriteAktProps(StoreName: String; Version: integer
  );
var
  INI: TIniFile;
  i: Integer;

  procedure writeCtrl(prop: TVideoControl; RootName: String);
  var
    pMin, pMax, pSteppingDelta, pDefault, typekey: Longint;
    value : integer;
    enumName : string;
  begin
    // Read the defaults etc.
    enumName:= prop.Name;
    {$ifdef KAMERADEBUG}Debugln(DateTimeToStr(now) + ' '+{$I %FILE%} + '->' +{$I %CURRENTROUTINE%} + ' EnumName='+enumName);{$endif}
    pMin:= prop.Minimum;
    pMax:= prop.Maximum;
    pSteppingDelta:= prop.Step;
    pDefault:= prop.DefaultValue;
    value:= prop.Value;
    typekey:= prop.ControlType;
    {$ifdef KAMERADEBUG}Debugln(DateTimeToStr(now) + ' '+{$I %FILE%} + '->' +{$I %CURRENTROUTINE%} + ' Min='+IntToStr(pMin));{$endif}
    {$ifdef KAMERADEBUG}Debugln(DateTimeToStr(now) + ' '+{$I %FILE%} + '->' +{$I %CURRENTROUTINE%} + ' Max='+IntToStr(pMax));{$endif}
    {$ifdef KAMERADEBUG}Debugln(DateTimeToStr(now) + ' '+{$I %FILE%} + '->' +{$I %CURRENTROUTINE%} + ' Step='+IntToStr(pSteppingDelta));{$endif}
    {$ifdef KAMERADEBUG}Debugln(DateTimeToStr(now) + ' '+{$I %FILE%} + '->' +{$I %CURRENTROUTINE%} + ' Default='+IntToStr(pDefault));{$endif}
    {$ifdef KAMERADEBUG}Debugln(DateTimeToStr(now) + ' '+{$I %FILE%} + '->' +{$I %CURRENTROUTINE%} + ' Value='+IntToStr(value));{$endif}
    if (pDefault = DSNotValid) then begin
      // Not valid remove key
      {$ifdef KAMERADEBUG}Debugln(DateTimeToStr(now) + ' '+{$I %FILE%} + '->' +{$I %CURRENTROUTINE%} + ' Delete Keys');{$endif}
      ini.DeleteKey(RootName,enumName+'-Key');
      ini.DeleteKey(RootName,enumName+'-Min');
      ini.DeleteKey(RootName,enumName+'-Max');
      ini.DeleteKey(RootName,enumName+'-Step');
      ini.DeleteKey(RootName,enumName+'-Default');
      ini.DeleteKey(RootName,enumName+'-Value');
      ini.DeleteKey(RootName,enumName+'-MenuValue');
    end
    else begin
      // valid write key
        ini.WriteInteger(RootName,enumName+'-Key',typekey);
      ini.WriteInteger(RootName,enumName+'-Min',pMin);
      ini.WriteInteger(RootName,enumName+'-Max',pMax);
      ini.WriteInteger(RootName,enumName+'-Step',pSteppingDelta);
      ini.WriteInteger(RootName,enumName+'-Default',pDefault);
      case typekey of
        V4L2_CTRL_TYPE_MENU,
        V4L2_CTRL_TYPE_INTEGER_MENU: begin
            ini.DeleteKey(RootName,enumName+'-Value');
            ini.WriteInteger(RootName,enumName+'-MenuValue',value);
          end
        else
          ini.DeleteKey(RootName,enumName+'-MenuValue');
          ini.WriteInteger(RootName,enumName+'-Value',value);
      end;
    end;
  end;

begin
  UpdatingControls:=True;
  try
    Video.GetControlValues;
    try
      INI := TIniFile.Create(INIFileName);
      // for info
      ini.WriteString(StoreName,'CameraName',NameKamera);
      ini.WriteInteger(StoreName,'CameraNr',NamenNr);
      // ProcAmp
      for i:=0 to Video.ControlsInfo.Count-1 do begin
        writeCtrl(Video.ControlsInfo[i], StoreName + '-CamCtrl');
      end;
      ini.WriteInteger(StoreName,'Version',Version);
    finally
      FreeAndNil(INI);
    end;
  finally
    UpdatingControls:=false;
  end;
end;

procedure TFormVideoTmp.CamCtrlReadAktProps(StoreName: String;
  MinVersion: integer);
var
  INI: TIniFile;
  i,v: Integer;

  procedure readCtrl(prop: TVideoControl; RootName: String);
  var
    pMin, pMax,  pDefault, typekey: Longint;
    value: integer;
    enumName : string;
  begin
    // Read the deaults etc.
    if (prop = nil) then begin
      Debugln(DateTimeToStr(now) + ' '+{$I %FILE%} + '->' +{$I %CURRENTROUTINE%} + ' Warning: VideoControl Info is nil !');
      exit; //==>
    end;
    enumName:= prop.Name;
    {$ifdef KAMERADEBUG}Debugln(DateTimeToStr(now) + ' '+{$I %FILE%} + '->' +{$I %CURRENTROUTINE%} + ' EnumName='+enumName);{$endif}
    pMin:= prop.Minimum;
    pMax:= prop.Maximum;
    pDefault:= prop.DefaultValue;
    typekey:= INI.ReadInteger(RootName,enumName+'-Key', V4L2_CTRL_TYPE_INTEGER);
    case typekey of
      V4L2_CTRL_TYPE_MENU,
      V4L2_CTRL_TYPE_INTEGER_MENU: begin
        value:= INI.ReadInteger(RootName,enumName+'-MenuValue', 0);
      end
      else
        value:= INI.ReadInteger(RootName,enumName+'-Value', pDefault);
    end;
    {$ifdef KAMERADEBUG}Debugln(DateTimeToStr(now) + ' '+{$I %FILE%} + '->' +{$I %CURRENTROUTINE%} + ' Key='+IntToStr(typekey));{$endif}
    {$ifdef KAMERADEBUG}Debugln(DateTimeToStr(now) + ' '+{$I %FILE%} + '->' +{$I %CURRENTROUTINE%} + ' Min='+IntToStr(pMin));{$endif}
    {$ifdef KAMERADEBUG}Debugln(DateTimeToStr(now) + ' '+{$I %FILE%} + '->' +{$I %CURRENTROUTINE%} + ' Max='+IntToStr(pMax));{$endif}
    {$ifdef KAMERADEBUG}Debugln(DateTimeToStr(now) + ' '+{$I %FILE%} + '->' +{$I %CURRENTROUTINE%} + ' Default='+IntToStr(pDefault));{$endif}
    {$ifdef KAMERADEBUG}Debugln(DateTimeToStr(now) + ' '+{$I %FILE%} + '->' +{$I %CURRENTROUTINE%} + ' Value='+IntToStr(value));{$endif}
    if (value >= pMin) and (value <= pMax)  and (value <> DSNotValid) then begin
      if (value <> prop.Value) then begin
        try
          prop.SetValue(value);
        except
       on E:Exception do begin
          DebugLn(DateTimeToStr(now) + 'ExceptError property set Camera ' + E.Classname + ':' + E.Message);
      end;
        end;
         {$ifdef KAMERADEBUG}Debugln(DateTimeToStr(now) + ' '+{$I %FILE%} + '->' +{$I %CURRENTROUTINE%} + ' Value set');{$endif}
      end
      else begin
        ;
        {$ifdef KAMERADEBUG}Debugln(DateTimeToStr(now) + ' '+{$I %FILE%} + '->' +{$I %CURRENTROUTINE%} + ' Same Value -> no set needed');{$endif}
      end;
    end
    else begin
      Debugln(DateTimeToStr(now) + ' '+{$I %FILE%} + '->' +{$I %CURRENTROUTINE%} + ' Error: Value not valid - not set !!!');
    end;
  end;

begin
  if (StoreName = '') then exit; // ==>
  UpdatingControls:=True;
  try
    Video.GetControlValues;
    try
      INI := TIniFile.Create(INIFileName);
      // for info
      //ini.WriteString(StoreName,'CameraName',NameKamera);
      //ini.WriteInteger(StoreName,'CameraNr',NamenNr);
      // ProcAmp
      v:= INI.ReadInteger(StoreName,'Version', 0);
      if v >= coStoreVersion then begin
        for i:=0 to Video.ControlsInfo.Count-1 do begin
          readCtrl(Video.ControlsInfo[i], StoreName + '-CamCtrl');
        end;
      end
      else begin
         Debugln(DateTimeToStr(now) + ' '+{$I %FILE%} + '->' +{$I %CURRENTROUTINE%} + ' Warning: wrong version of parameterfile');
      end;
    finally
      FreeAndNil(INI);
    end;
  finally
    UpdatingControls:=false;
  end;
end;



procedure TFormVideoTmp.Init1;
begin
  {$ifdef KAMERADEBUG}Debugln(DateTimeToStr(now) + {$I %FILE%} + '->' +{$I %CURRENTROUTINE%});{$endif}
 //
end;

procedure TFormVideoTmp.SelectDevice(DevNr: integer);
begin
  {$ifdef KAMERADEBUG}Debugln(DateTimeToStr(now) + {$I %FILE%} + '->' +{$I %CURRENTROUTINE%});{$endif}
  //
end;

procedure TFormVideoTmp.SnapShot(var aBmp: TBitmap);
var
  Cnt : Integer;
  {$Ifdef KAMERADEBUG}
  ATimer: QWord;
{$EndIf}
begin
  {$ifdef KAMERADEBUG}Debugln(DateTimeToStr(now) + {$I %FILE%} + '->' +{$I %CURRENTROUTINE%});{$endif}
  {$Ifdef KAMERADEBUG}ATimer:=GetTickCount64; {$EndIf}
  cnt := 200;
  PicFinished:= False;
  //while not PicFinished and (FScanInProgress) do begin
  while (not PicFinished) or (FScanInProgress) do begin
    Application.ProcessMessages;
    sleep(100);
    dec(Cnt);
    if Cnt <= 0 then begin
      Debugln(DateTimeToStr(now) + {$I %FILE%} + '->' +{$I %CURRENTROUTINE%} + ' Camera timeout ');
      exit;
    end;
  end;
  aBmp.Assign(BMP);
  {$Ifdef KAMERADEBUG}if (DbgLvl>dbgLvlStart) then DoMessage('SnapShot ='+IntToStr(GetTickCount64-ATimer)+'ms'); {$EndIf}
end;

//Brightness (int) [0..1023] (50)
//Saturation (int) [0..255] (64)
//Hue (int) [-180..180] (0)
//*White Balance Component, Auto (bool) [0..1] (1)
//*White Balance Red Component (int) [0..255] (64)
//*White Balance Blue Component (int) [0..255] (64)
//Gamma (int) [1..500] (100)
//Gain (int) [0..1957] (0)
//Exposure, Auto (menu) [0..3] (3)
//  1: Manual Mode
//  3: Aperture Priority Mode
//Exposure (Absolute) (int) [1..300000] (3)

procedure TFormVideoTmp.Start;
var
 i,idx: integer;
 srch: String;
 {$Ifdef KAMERADEBUG}
  ATimer: QWord;
{$EndIf}
begin
  {$ifdef KAMERADEBUG}Debugln(DateTimeToStr(now) + {$I %FILE%} + '->' +{$I %CURRENTROUTINE%});{$endif}
  {$Ifdef KAMERADEBUG}ATimer:=GetTickCount64; {$EndIf}
  {$Ifdef KAMERADEBUG}DebugLn('VideoOpen'); {$EndIf}
  try
    Video.Open := true;
  except
    on E:Exception do begin
        DebugLn(DateTimeToStr(now) + ' Exception:' + E.Classname + ':' + E.Message);
    end;
  end;
  if Video.Open then begin
    // Wir starten hier mit fixen defaults, falls die Konfiguration nicht geladen werden kann/darf
    {$Ifdef KAMERADEBUG}DebugLn('Set Controlinfo'); {$EndIf}
    idx:= -1;
    srch := 'White Balance Component';
    for i:=0 to Video.ControlsInfo.Count-1 do begin
      if SameStr(LowerCase(LeftStr(Video.ControlsInfo[i].Name,Length(srch))),LowerCase(srch)) then begin
        idx := i;
        DebugLn('Found '+srch+ ' at ' + IntToStr(idx));
        break;
      end;
    end;
    if (idx >= 0) then begin
      // Autobalance off
      Video.ControlsInfo[idx].SetValue(0);
      DebugLn('Deactivate '+srch+ ' at ' + IntToStr(idx));
    end;
    //
    idx:= -1;
    srch := 'White Balance Red';
    for i:=0 to Video.ControlsInfo.Count-1 do begin
      if SameStr(LowerCase(LeftStr(Video.ControlsInfo[i].Name,Length(srch))),LowerCase(srch)) then begin
        idx := i;
        DebugLn('Found '+srch+ ' at ' + IntToStr(idx));
        break;
      end;
    end;
    if (idx >= 0) then begin
      // White Balance Red
      Video.ControlsInfo[idx].SetValue(119);
      DebugLn('Deactivate '+srch+ ' at ' + IntToStr(idx));
    end;
    idx:= -1;
    srch := 'White Balance Blue';
    for i:=0 to Video.ControlsInfo.Count-1 do begin
      if SameStr(LowerCase(LeftStr(Video.ControlsInfo[i].Name,Length(srch))),LowerCase(srch)) then begin
        idx := i;
        DebugLn('Found '+srch+ ' at ' + IntToStr(idx));
        break;
      end;
    end;
    if (idx >= 0) then begin
      // White Balance Blue
      Video.ControlsInfo[idx].SetValue(132);
      DebugLn('Deactivate '+srch+ ' at ' + IntToStr(idx));
    end;
    idx:= -1;
    srch := 'White Balance Green';
    for i:=0 to Video.ControlsInfo.Count-1 do begin
      if SameStr(LowerCase(LeftStr(Video.ControlsInfo[i].Name,Length(srch))),LowerCase(srch)) then begin
        idx := i;
        DebugLn('Found '+srch+ ' at ' + IntToStr(idx));
        break;
      end;
    end;
    if (idx >= 0) then begin
      // White Balance Green
      Video.ControlsInfo[idx].SetValue(64);
      DebugLn('Deactivate '+srch+ ' at ' + IntToStr(idx));
    end;
    {$Ifdef KAMERADEBUG}DebugLn('Start VideoCapture'); {$EndIf}
    try
      Video.Capture := true;
    except
      on E:Exception do begin
          DebugLn(DateTimeToStr(now) + ' Exception:' + E.Classname + ':' + E.Message);
      end;
    end;
  end;
  PicFinished:=False;
  {$Ifdef KAMERADEBUG}if (DbgLvl>dbgLvlStart) then DoMessage('Play ='+IntToStr(GetTickCount64-ATimer)+'ms'); {$EndIf}
end;

procedure TFormVideoTmp.Pause;
{$Ifdef KAMERADEBUG}
var
  ATimer: QWord;
{$EndIf}
begin
  {$ifdef KAMERADEBUG}Debugln(DateTimeToStr(now) + {$I %FILE%} + '->' +{$I %CURRENTROUTINE%});{$endif}
  {$Ifdef KAMERADEBUG}ATimer:=GetTickCount64; {$EndIf}
  Video.Capture:=false;
  {$Ifdef KAMERADEBUG}if (DbgLvl>dbgLvlStart) then DoMessage('Pause ='+IntToStr(GetTickCount64-ATimer)+'ms'); {$EndIf}
end;

procedure TFormVideoTmp.Restart;
{$Ifdef KAMERADEBUG}
var
  ATimer: QWord;
{$EndIf}
begin
  {$ifdef KAMERADEBUG}Debugln(DateTimeToStr(now) + {$I %FILE%} + '->' +{$I %CURRENTROUTINE%});{$endif}
  {$Ifdef KAMERADEBUG}ATimer:=GetTickCount64; {$EndIf}
  Video.Capture:=true;
  {$Ifdef KAMERADEBUG}if (DbgLvl>dbgLvlStart) then DoMessage('Pause ='+IntToStr(GetTickCount64-ATimer)+'ms'); {$EndIf}
end;


procedure TFormVideoTmp.Stop;
{$Ifdef KAMERADEBUG}
var
  ATimer: QWord;
{$EndIf}
begin
  {$ifdef KAMERADEBUG}Debugln(DateTimeToStr(now) + {$I %FILE%} + '->' +{$I %CURRENTROUTINE%});{$endif}
  {$Ifdef KAMERADEBUG}ATimer:=GetTickCount64; {$EndIf}
  Video.Capture:=false;
  Video.Open:=false;
  {$Ifdef KAMERADEBUG}if (DbgLvl>dbgLvlStart) then DoMessage('Stop ='+IntToStr(GetTickCount64-ATimer)+'ms'); {$EndIf}
end;

function TFormVideoTmp.IsStopped: boolean;
begin
  Result := not Video.Capture;
end;

function TFormVideoTmp.IsRunning: boolean;
begin
  Result := Video.Capture;
end;

initialization
  FormVideoTmpA:= nil;

finalization
  if FormVideoTmpA <> nil then
  begin
    FormVideoTmpA.Stop;
    FormVideoTmpA.free;
  end;
end.


