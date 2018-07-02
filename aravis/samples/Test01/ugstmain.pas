unit ugstmain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, gst;

type

  { TForm1 }

  TForm1 = class(TForm)
    BuInitLib: TButton;
    BuReleaseLib: TButton;
    BuShowVersion: TButton;
    Memo1: TMemo;
    procedure BuInitLibClick(Sender: TObject);
    procedure BuReleaseLibClick(Sender: TObject);
    procedure BuShowVersionClick(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.BuInitLibClick(Sender: TObject);
begin
  if not gstlib_initdll('') then  begin //Q:\gstreamer\1.0\x86\bin\libgstreamer-1.0-0.dll');
    showmessage('Can not initialize the library');
    exit;
  end;
end;

procedure TForm1.BuReleaseLibClick(Sender: TObject);
begin
  gstlib_freedll;
end;

procedure TForm1.BuShowVersionClick(Sender: TObject);
var
  hstr : string;
  achar : PAnsiChar;
begin
  Memo1.Clear;
  Memo1.Append(gstlib_versionstring);
  hstr := '';
  achar := gst_version_string;
  hstr  := strpas(achar);
  Memo1.Append(hstr);
end;

end.

(* Frfom https://gstreamer.freedesktop.org/documentation/tutorials/basic/hello-world.html
basic-tutorial-1.c

#include <gst/gst.h>

int main(int argc, char *argv[]) {
  GstElement *pipeline;
  GstBus *bus;
  GstMessage *msg;

  /* Initialize GStreamer */
  gst_init (&argc, &argv);

  /* Build the pipeline */
  pipeline = gst_parse_launch ("playbin uri=https://www.freedesktop.org/software/gstreamer-sdk/data/media/sintel_trailer-480p.webm", NULL);

  /* Start playing */
  gst_element_set_state (pipeline, GST_STATE_PLAYING);

  /* Wait until error or EOS */
  bus = gst_element_get_bus (pipeline);
  msg = gst_bus_timed_pop_filtered (bus, GST_CLOCK_TIME_NONE, GST_MESSAGE_ERROR | GST_MESSAGE_EOS);

  /* Free resources */
  if (msg != NULL)
    gst_message_unref (msg);
  gst_object_unref (bus);
  gst_element_set_state (pipeline, GST_STATE_NULL);
  gst_object_unref (pipeline);
  return 0;
}
*)


