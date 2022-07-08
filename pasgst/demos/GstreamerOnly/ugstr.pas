unit ugstr;

{$mode delphi}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type
  TLogEvent = procedure(Sender: TObject; strLog: String) of object;

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    BuStartSimple: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure BuStartSimpleClick(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    videosrc, pipeline: pointer;
    FOnLog: TLogEvent;
    procedure DoLog(Sender: TObject; strLog: String);
  public
    property OnLog: TLogEvent read FOnLog write FOnLog;

  end;

var
  Form1: TForm1;

implementation

uses
  glib2, gst;


{$R *.lfm}


function cb_bus_call(bus: Pointer; msg: PGstMessage; user_data: Pointer)
  : Boolean; cdecl;
var
  GDebug:               Pgchar;
  GError:               PGError;
  structure:            PGstStructure;
  old_state, new_state: TGstElementState;
  MsgStr:               String;
  i:                    Integer;
  name:                 string;
  typename:             PgChar;
  _type:                TGType;
  GSTObj:               TForm1;
  pduration:             pgint64;
begin
  Result := False;

  if bus = nil then
    exit;

  if user_data = nil then
    exit;

  GSTObj := user_data;

  //MsgStr:= '';
  //MsgStr:= 'MsgType:'+IntToHex(msg^._type,8) + ' ';
  //MsgStr:= 'timestp:'+IntToHex(msg^.timestamp,16) + ':';
  MsgStr:= 'Seq:'+IntToHex(msg^.seqnum,16) + ':';

  //GSTObj.DoLog(nil,MsgStr);
  case msg^._type of
    GST_MESSAGE_STATE_CHANGED:
      begin
        gst_message_parse_state_changed(msg, @old_state, @new_state, nil);
        MsgStr := MsgStr +'State: ' + gst_element_state_get_name(old_state)
          + ' -> ' + gst_element_state_get_name(new_state);
        if Assigned(GSTObj) and Assigned(GSTObj.OnLog) then
          GSTObj.OnLog(GSTObj, MsgStr);
      end;
    GST_MESSAGE_EOS:
      begin
        MsgStr := MsgStr +'loop quit';
        if Assigned(GSTObj.OnLog) then
          GSTObj.OnLog(GSTObj, MsgStr);
      end;
    GST_MESSAGE_ERROR:
      begin
        GDebug := nil;
        GError := nil;
        gst_message_parse_error(msg, GError, GDebug);
        MsgStr := MsgStr +'Error: ' + GError^.message;
        if Assigned(GSTObj) and Assigned(GSTObj.OnLog) then
          GSTObj.OnLog(GSTObj, MsgStr);
        g_error_free(GError);
        if (GDebug <> nil) then
          g_free(GDebug);
      end;
    else
      structure := gst_message_get_structure(msg);
      if (structure <> nil) then
      begin
        MsgStr := MsgStr +'Msg: ' + gst_message_type_get_name(msg^._type) + ' - ' +
          gst_structure_get_name(structure);
        for i := 0 to gst_structure_n_fields(structure) - 1 do
        begin
          if (i <> 0) then
            MsgStr := MsgStr + ', ';
          name := gst_structure_nth_field_name(structure, i);
          _type := gst_structure_get_field_type(structure, @name[1]);
          MsgStr := MsgStr + ' ' + String(name);
          try
            if _Type <= $7FFFFFFF then begin
              typename:= g_type_name(_type);
              MsgStr := MsgStr + ' ' + String(typename)
            end
            else
              MsgStr := MsgStr + ' G_TYPE_INVALID ' + IntToHex(_type,8);
          except
             MsgStr := MsgStr + ' Error';
          end;
        end;

        if Assigned(GSTObj) and Assigned(GSTObj.OnLog) then
          GSTObj.OnLog(GSTObj, MsgStr);
      end
      else
      begin
        MsgStr := MsgStr + String(gst_message_type_get_name(msg^._type));
        if Assigned(GSTObj) and Assigned(GSTObj.OnLog) then
          GSTObj.OnLog(GSTObj, MsgStr);
      end;
  end;

  Result := true;
end;



{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
var
  devstr: string;
  p1,p2,p3,sink, cur_bus: Pointer;
  cur_bus_watch_id : LongWord;
begin
  //
  OnLog:= DoLog;
  DoLog(nil, 'Version '+  gstlib_versionstring);
  //todo: gst-launch-1.0 v4l2src device=/dev/video1 ! image/jpeg,width=800,height=600,framerate=30/1 ! jpegparse ! jpegdec ! autovideosink
  //gst-launch-1.0 v4l2src ! jpegparse ! jpegdec ! autovideosink
  //gst-launch-1.0 tcambin ! jpegenc ! jpegdec ! autovideosink
  pipeline:= nil;
  pipeline := gst_pipeline_new('gsttest');

  if not Assigned(pipeline) then
  begin
    Memo1.Append('pipeline nil');
    //exit;
  end;

  videosrc := nil;
  //videosrc := gst_element_factory_make('v4l2src', 'videosrc');{ TODO -oAF : test with v4l2 only }
  videosrc := gst_element_factory_make('tcambin', 'videosrc');
  if not Assigned(videosrc) then
  begin
    Memo1.Append('videosrc nil');
    //exit;
  end;

  //devstr:= '/dev/video0';
  //if Assigned(videosrc) and not g_object_set_(videosrc, 'device', PAnsiChar(devstr), nil) then
  // begin
  //   Memo1.Append('videosrc object set bad');
  // end;

  //p1 := gst_element_factory_make('image/jpeg', 'imagefilter1');
  //p1 := gst_element_factory_make('jpegenc', 'imagefilter1');
  //if not Assigned(p1) then
  //begin
  //  Memo1.Append('p1 nil');
  //  //exit;
  //end;

  p2 := gst_element_factory_make('jpegenc', 'imagefilter2');
  if not Assigned(p2) then
  begin
    Memo1.Append('p2 nil');
    //exit;
  end;
  p3 := gst_element_factory_make('jpegdec', 'imagefilter3');
  if not Assigned(p3) then
  begin
    Memo1.Append('p3 nil');
    //exit;
  end;

  sink :=  gst_element_factory_make('autovideosink', 'videosink');
  //gst_bin_add_many_5(pipeline, videosrc, p1, p2, p3, sink, nil);
  if not gst_bin_add(pipeline,videosrc) then DoLog(nil,'videosrc not added');
  if not gst_bin_add(pipeline,p2) then DoLog(nil,'p2 not added');
  if not gst_bin_add(pipeline,p3) then DoLog(nil,'p3 not added');
  if not gst_bin_add(pipeline,sink) then DoLog(nil,'sink not added');

  //gst_element_link_many_4(videosrc, p2, p3, sink, nil);

  if not gst_element_link(videosrc, p2) then
  begin
    Memo1.Append('videosrc<->p2');
  end;
  //if not gst_element_link(p1, p2) then
  //begin
  //  Memo1.Append('p1<->p2');
  ////  exit;
  //end;
  if not gst_element_link(p2, p3) then
  begin
    Memo1.Append('p2<->p3');
    //exit;
  end;
  if not gst_element_link(p3, sink) then
  begin
    Memo1.Append('p3<->sink');
    //exit;
  end;

  // we add a message handler
  cur_bus := gst_pipeline_get_bus(pipeline);
  cur_bus_watch_id := gst_bus_add_watch(cur_bus, @cb_bus_call, Self);
  gst_object_unref(cur_bus);

  // Start
  DoLog(nil,'Pipelinestate (should be 2): '+IntToHex(gst_element_set_state(pipeline, GST_STATE_PLAYING),8));
  DoLog(nil,'started');

end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if pipeline <> nil then
  begin
    gst_element_set_state(pipeline, GST_STATE_NULL);
    gst_object_unref(pipeline);
  end;
  DoLog(nil,'stopped');
end;

procedure TForm1.BuStartSimpleClick(Sender: TObject);
var
  GError:               PGError;
  cur_bus: Pointer;
  cur_bus_watch_id : LongWord;
begin
  //
  OnLog:= DoLog;
  DoLog(nil, 'Version '+  gstlib_versionstring);
  //todo: gst-launch-1.0 v4l2src device=/dev/video1 ! image/jpeg,width=800,height=600,framerate=30/1 ! jpegparse ! jpegdec ! autovideosink
  //gst-launch-1.0 v4l2src ! jpegparse ! jpegdec ! autovideosink
  pipeline:= nil;
  GError:=nil; //   identity silent=false ! video/x-raw, format=BGRx ! jpegenc ! filesink location=

  //pipeline := gst_parse_launch('v4l2src device=/dev/video0 ! identity silent=false ! videoconvert ! xvimagesink',GError);
  //pipeline := gst_parse_launch('v4l2src device=/dev/video0 ! identity silent=false ! jpegenc ! filesink location=/tmp/test.jpg',GError);
  //pipeline := gst_parse_launch('playbin uri=https://www.freedesktop.org/software/gstreamer-sdk/data/media/sintel_trailer-480p.webm ! identity silent=false ',GError);
  //pipeline := gst_parse_launch('fakesrc silent=false num-buffers=3 ! identity silent=false ! videoconvert ! xvimagesink',GError);
  pipeline := gst_parse_launch('tcpclientsrc port=5000 host=192.168.1.29 ! decodebin ! jpegenc ! filesink location=/tmp/test.jpg',GError);
  //pipeline := gst_parse_launch('tcamsrc ! jpegenc ! autovideosink',GError);

  if not Assigned(pipeline) then
  begin
    Memo1.Append('pipeline nil');
    //exit;
  end;
  if GError<> nil then begin
    DoLog(nil,'Error: ' + GError^.message);
    g_error_free(GError);
  end;

  // we add a message handler
  cur_bus := gst_pipeline_get_bus(pipeline);
  cur_bus_watch_id := gst_bus_add_watch(cur_bus, @cb_bus_call, Self);
  gst_object_unref(cur_bus);

  // Start
  DoLog(nil,'Pipelinestate (should be 4): '+IntToHex(gst_element_set_state(pipeline, GST_STATE_PLAYING),8));
  DoLog(nil,'started');

end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  DoLog(nil,'Pipelinestate Stop: '+IntToHex(gst_element_set_state(pipeline, GST_STATE_NULL),8));
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  DoLog(nil,'Pipelinestate Start: '+IntToHex(gst_element_set_state(pipeline, GST_STATE_PLAYING),8));
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  DoLog(nil,'Pipelinestate Pause: '+IntToHex(gst_element_set_state(pipeline, GST_STATE_PAUSED),8));
end;

procedure TForm1.Button7Click(Sender: TObject);
var
  duration,position : gint64;
  pdur : Pgint64;
  format : DWord;
begin
  format:= GST_FORMAT_TIME;
  duration:=0;
  position:=0;
  if gst_element_query_duration(pipeline,format, duration) then
    Memo1.Append('Duration ' + IntToStr(duration div 100000))
   else
    Memo1.Append('Duration  NoDur ');
  if gst_element_query_position(pipeline,format, position) then
    Memo1.Append('Position ' + IntToStr(position div 100000))
  else
    Memo1.Append('Position  NoPos ');
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  argc: gint;
  argv:pgchar;
begin
  Memo1.Clear;
  if not gstlib_initdll('') then begin
    ShowMessage('Error in init dll ' + #13+ #13+ gstlib_GetInitError);
    DoLog(nil,'Error in init dll ' + #13+ #13+ gstlib_GetInitError);
    exit;
  end;
  argc:=0;
  argv:=PAnsiChar('');
  gst_init(argc,argv);
end;

procedure TForm1.DoLog(Sender: TObject; strLog: String);
begin
  Memo1.Append(strLog);
end;

end.

