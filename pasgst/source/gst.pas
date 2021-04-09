unit gst;

(*
 * This is a header translation of
 * gst.h from gstreamer 1.x
 * https://gstreamer.freedesktop.org/
 * The library (.dll/.so) itself is not a part of this package and copyrighted by gstreamer Project
 *)

(*
 * Copyright (c) 2018-2020 by Andreas Frieß
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 *)

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, glib2;

type

  PGstElement = Pointer;

  PGstStructure = ^GstStructure;
  GstStructure = packed record
    _type: GType;
  end;

  GstElementState = DWord;
  PGstElementState = ^GstElementState;


const
 (* GstElement.h from gstreamer 1.x tranlastion *)
  // see https://code.woboq.org/qt5/include/gstreamer-1.0/gst/PGstElement.h
  GST_STATE_VOID_PENDING = 0;
  GST_STATE_NULL         = 1;
  GST_STATE_READY        = 2;
  GST_STATE_PAUSED       = 3;
  GST_STATE_PLAYING      = 4;

  (* gstformat.h
  * GstFormat:
  * @GST_FORMAT_UNDEFINED: undefined format
  * @GST_FORMAT_DEFAULT: the default format of the pad/element. This can be
  *    samples for raw audio, frames/fields for raw video (some, but not all,
  *    elements support this; use @GST_FORMAT_TIME if you don't have a good
  *    reason to query for samples/frames)
  * @GST_FORMAT_BYTES: bytes
  * @GST_FORMAT_TIME: time in nanoseconds
  * @GST_FORMAT_BUFFERS: buffers (few, if any, elements implement this as of
  *     May 2009)
  * @GST_FORMAT_PERCENT: percentage of stream (few, if any, elements implement
  *     this as of May 2009)
  *
  * Standard predefined formats
  *)
type
  GstFormat = DWord;
const
  GST_FORMAT_UNDEFINED  =  0;
  GST_FORMAT_DEFAULT    =  1;
  GST_FORMAT_BYTES      =  2;
  GST_FORMAT_TIME       =  3;
  GST_FORMAT_BUFFERS    =  4;
  GST_FORMAT_PERCENT    =  5;


(* gstminiobject.h from gstreamer 1.x tranlastion *)
  // see https://github.com/GStreamer/gstreamer/blob/master/gst/gstminiobject.h
type

  PGstMiniObject = ^GstMiniObject;
  GstMiniObject = record   // NOT PACKED !!!
    _type: GType;
    (*< public >*/ /* with COW *)
    refcount      : gint;
    lockstate     : gint;
    flags         : guint;
    _gst_reserved1: gpointer; //GstMiniObjectCopyFunction copy;
    _gst_reserved2: gpointer; //GstMiniObjectDisposeFunction dispose;
    _gst_reserved3: gpointer; //GstMiniObjectFreeFunction free;
    (* < private > */
    /* Used to keep track of parents, weak ref notifies and qdata *)
    priv_n_qdata : guint;
    priv_qdata   : gpointer;
  end;

  TGType = gsize;     { TODO -oAndi : correct size DWord or QWord ? }
  TGstElementState = DWord;

  (* gstmessage.h from gstreamer 1.x tranlastion *)

  TGstMessageType = guint;

const
  {**
   * GstMessageType:
   * @GST_MESSAGE_UNKNOWN: an undefined message
   * @GST_MESSAGE_EOS: end-of-stream reached in a pipeline. The application will
   * only receive this message in the PLAYING state and every time it sets a
   * pipeline to PLAYING that is in the EOS state. The application can perform a
   * flushing seek in the pipeline, which will undo the EOS state again.
   * @GST_MESSAGE_ERROR: an error occurred. When the application receives an error
   * message it should stop playback of the pipeline and not assume that more
   * data will be played. It is possible to specify a redirection url to the error
   * messages by setting a `redirect-location` field into the error message, application
   * or high level bins might use the information as required.
   * @GST_MESSAGE_WARNING: a warning occurred.
   * @GST_MESSAGE_INFO: an info message occurred
   * @GST_MESSAGE_TAG: a tag was found.
   * @GST_MESSAGE_BUFFERING: the pipeline is buffering. When the application
   * receives a buffering message in the PLAYING state for a non-live pipeline it
   * must PAUSE the pipeline until the buffering completes, when the percentage
   * field in the message is 100%. For live pipelines, no action must be
   * performed and the buffering percentage can be used to inform the user about
   * the progress.
   * @GST_MESSAGE_STATE_CHANGED: a state change happened
   * @GST_MESSAGE_STATE_DIRTY: an element changed state in a streaming thread.
   * This message is deprecated.
   * @GST_MESSAGE_STEP_DONE: a stepping operation finished.
   * @GST_MESSAGE_CLOCK_PROVIDE: an element notifies its capability of providing
   *                             a clock. This message is used internally and
   *                             never forwarded to the application.
   * @GST_MESSAGE_CLOCK_LOST: The current clock as selected by the pipeline became
   *                          unusable. The pipeline will select a new clock on
   *                          the next PLAYING state change. The application
   *                          should set the pipeline to PAUSED and back to
   *                          PLAYING when this message is received.
   * @GST_MESSAGE_NEW_CLOCK: a new clock was selected in the pipeline.
   * @GST_MESSAGE_STRUCTURE_CHANGE: the structure of the pipeline changed. This
   * message is used internally and never forwarded to the application.
   * @GST_MESSAGE_STREAM_STATUS: status about a stream, emitted when it starts,
   *                             stops, errors, etc..
   * @GST_MESSAGE_APPLICATION: message posted by the application, possibly
   *                           via an application-specific element.
   * @GST_MESSAGE_ELEMENT: element-specific message, see the specific element's
   *                       documentation
   * @GST_MESSAGE_SEGMENT_START: pipeline started playback of a segment. This
   * message is used internally and never forwarded to the application.
   * @GST_MESSAGE_SEGMENT_DONE: pipeline completed playback of a segment. This
   * message is forwarded to the application after all elements that posted
   * @GST_MESSAGE_SEGMENT_START posted a GST_MESSAGE_SEGMENT_DONE message.
   * @GST_MESSAGE_DURATION_CHANGED: The duration of a pipeline changed. The
   * application can get the new duration with a duration query.
   * @GST_MESSAGE_ASYNC_START: Posted by elements when they start an ASYNC
   * #GstStateChange. This message is not forwarded to the application but is used
   * internally.
   * @GST_MESSAGE_ASYNC_DONE: Posted by elements when they complete an ASYNC
   * #GstStateChange. The application will only receive this message from the toplevel
   * pipeline.
   * @GST_MESSAGE_LATENCY: Posted by elements when their latency changes. The
   * application should recalculate and distribute a new latency.
   * @GST_MESSAGE_REQUEST_STATE: Posted by elements when they want the pipeline to
   * change state. This message is a suggestion to the application which can
   * decide to perform the state change on (part of) the pipeline.
   * @GST_MESSAGE_STEP_START: A stepping operation was started.
   * @GST_MESSAGE_QOS: A buffer was dropped or an element changed its processing
   * strategy for Quality of Service reasons.
   * @GST_MESSAGE_PROGRESS: A progress message.
   * @GST_MESSAGE_TOC: A new table of contents (TOC) was found or previously found TOC
   * was updated.
   * @GST_MESSAGE_RESET_TIME: Message to request resetting the pipeline's
   *     running time from the pipeline. This is an internal message which
   *     applications will likely never receive.
   * @GST_MESSAGE_STREAM_START: Message indicating start of a new stream. Useful
   *     e.g. when using playbin in gapless playback mode, to get notified when
   *     the next title actually starts playing (which will be some time after
   *     the URI for the next title has been set).
   * @GST_MESSAGE_NEED_CONTEXT: Message indicating that an element wants a specific context (Since: 1.2)
   * @GST_MESSAGE_HAVE_CONTEXT: Message indicating that an element created a context (Since: 1.2)
   * @GST_MESSAGE_EXTENDED: Message is an extended message type (see below).
   *     These extended message IDs can't be used directly with mask-based API
   *     like gst_bus_poll() or gst_bus_timed_pop_filtered(), but you can still
   *     filter for GST_MESSAGE_EXTENDED and then check the result for the
   *     specific type. (Since: 1.4)
   * @GST_MESSAGE_DEVICE_ADDED: Message indicating a #GstDevice was added to
   *     a #GstDeviceProvider (Since: 1.4)
   * @GST_MESSAGE_DEVICE_REMOVED: Message indicating a #GstDevice was removed
   *     from a #GstDeviceProvider (Since: 1.4)
   * @GST_MESSAGE_PROPERTY_NOTIFY: Message indicating a #GObject property has
   *     changed (Since: 1.10)
   * @GST_MESSAGE_STREAM_COLLECTION: Message indicating a new #GstStreamCollection
   *     is available (Since: 1.10)
   * @GST_MESSAGE_STREAMS_SELECTED: Message indicating the active selection of
   *     #GstStreams has changed (Since: 1.10)
   * @GST_MESSAGE_REDIRECT: Message indicating to request the application to
   *     try to play the given URL(s). Useful if for example a HTTP 302/303
   *     response is received with a non-HTTP URL inside. (Since: 1.10)
   * @GST_MESSAGE_DEVICE_CHANGED: Message indicating a #GstDevice was changed
   *     a #GstDeviceProvider (Since: 1.16)
   * @GST_MESSAGE_INSTANT_RATE_REQUEST: Message sent by elements to request the
   *     running time from the pipeline when an instant rate change should
   *     be applied (which may be in the past when the answer arrives). (Since: 1.18)
   * @GST_MESSAGE_ANY: mask for all of the above messages.
   *
   * The different message types that are available.
   */
  /* NOTE: keep in sync with quark registration in gstmessage.c
   * NOTE: keep GST_MESSAGE_ANY a valid gint to avoid compiler warnings.
   */
  /* FIXME: 2.0: Make it NOT flags, just a regular 1,2,3,4.. enumeration */
  /* FIXME: For GST_MESSAGE_ANY ~0 -> 0xffffffff see
   *        https://bugzilla.gnome.org/show_bug.cgi?id=732633
   *}
  GST_MESSAGE_UNKNOWN          = 0;
  GST_MESSAGE_EOS              = (1 shl 0);
  GST_MESSAGE_ERROR            = (1 shl 1);
  GST_MESSAGE_WARNING          = (1 shl 2);
  GST_MESSAGE_INFO             = (1 shl 3);
  GST_MESSAGE_TAG              = (1 shl 4);
  GST_MESSAGE_BUFFERING        = (1 shl 5);
  GST_MESSAGE_STATE_CHANGED    = (1 shl 6);
  GST_MESSAGE_STATE_DIRTY      = (1 shl 7);
  GST_MESSAGE_STEP_DONE        = (1 shl 8);
  GST_MESSAGE_CLOCK_PROVIDE    = (1 shl 9);
  GST_MESSAGE_CLOCK_LOST       = (1 shl 10);
  GST_MESSAGE_NEW_CLOCK        = (1 shl 11);
  GST_MESSAGE_STRUCTURE_CHANGE = (1 shl 12);
  GST_MESSAGE_STREAM_STATUS    = (1 shl 13);
  GST_MESSAGE_APPLICATION      = (1 shl 14);
  GST_MESSAGE_ELEMENT          = (1 shl 15);
  GST_MESSAGE_SEGMENT_START    = (1 shl 16);
  GST_MESSAGE_SEGMENT_DONE     = (1 shl 17);
  GST_MESSAGE_DURATION_CHANGED = (1 shl 18);
  GST_MESSAGE_LATENCY          = (1 shl 19);
  GST_MESSAGE_ASYNC_START      = (1 shl 20);
  GST_MESSAGE_ASYNC_DONE       = (1 shl 21);
  GST_MESSAGE_REQUEST_STATE    = (1 shl 22);
  GST_MESSAGE_STEP_START       = (1 shl 23);
  GST_MESSAGE_QOS              = (1 shl 24);
  GST_MESSAGE_PROGRESS         = (1 shl 25);
  GST_MESSAGE_TOC              = (1 shl 26);
  GST_MESSAGE_RESET_TIME       = (1 shl 27);
  GST_MESSAGE_STREAM_START     = (1 shl 28);
  GST_MESSAGE_NEED_CONTEXT     = (1 shl 29);
  GST_MESSAGE_HAVE_CONTEXT     = (1 shl 30);    //(1073741824)
  GST_MESSAGE_EXTENDED         = (1 shl 31);    //(2147483648) – Message is an extended message type (see below). These extended message IDs can't be used directly with mask-based API like gst_bus_poll or gst_bus_timed_pop_filtered, but you can still filter for GST_MESSAGE_EXTENDED and then check the result for the specific type. (Since: 1.4)
  GST_MESSAGE_DEVICE_ADDED     = GST_MESSAGE_EXTENDED +1; //(2147483649) – Message indicating a GstDevice was added to a GstDeviceProvider (Since: 1.4)
  GST_MESSAGE_DEVICE_REMOVED   = GST_MESSAGE_EXTENDED +2; //(2147483650) – Message indicating a GstDevice was removed from a GstDeviceProvider (Since: 1.4)
  GST_MESSAGE_PROPERTY_NOTIFY  = GST_MESSAGE_EXTENDED +3; //(2147483651) – Message indicating a GObject property has changed (Since: 1.10)
  GST_MESSAGE_STREAM_COLLECTION= GST_MESSAGE_EXTENDED +4; //(2147483652) – Message indicating a new GstStreamCollection is available (Since: 1.10)
  GST_MESSAGE_STREAMS_SELECTED = GST_MESSAGE_EXTENDED +5; //(2147483653) – Message indicating the active selection of GstStream has changed (Since: 1.10)
  GST_MESSAGE_REDIRECT         = GST_MESSAGE_EXTENDED +6; //(2147483654) – Message indicating to request the application to try to play the given URL(s). Useful if for example a HTTP 302/303 response is received with a non-HTTP URL inside. (Since: 1.10)
  GST_MESSAGE_DEVICE_CHANGED   = GST_MESSAGE_EXTENDED +7; //(2147483655) – Message indicating a GstDevice was changed a GstDeviceProvider (Since: 1.16)
  GST_MESSAGE_INSTANT_RATE_REQUEST = (GST_MESSAGE_EXTENDED) +8; //(2147483656) – Message sent by elements to request the running time from the pipeline when an instant rate change should be applied (which may be in the past when the answer arrives). (Since: 1.18)
  GST_MESSAGE_ANY              = ($FFFFFFFF);  // (4294967295) – mask for all of the above messages.

type

 {**
 * GstMessage:
 * @mini_object: the parent structure
 * @type: the #GstMessageType of the message
 * @timestamp: the timestamp of the message
 * @src: the src of the message
 * @seqnum: the sequence number of the message
 *
 * A #GstMessage.
 *}

  PGstMessage = ^GstMessage;
  GstMessage = record
    MiniObject: GstMiniObject;
    (*< public > *//* with COW *)
    _type     : guint;
    dummy     : guint;
    timestamp : guint64;
    src       : gpointer;
    seqnum    : guint32;
    (*< private >*//* with MESSAGE_LOCK *)
    priv_lock : gpointer;                 (* lock and cond for async delivery *)
    Priv_cond :  gpointer;
  end;

  T_gst_bus_func = function(bus: pointer; msg: PGSTmessage; user_data: pointer): Boolean;

  {GST library
    @libname: a string with the libraryname,
              if empty use the default plattform defaultname
    return true if library correct loaded
           false if unsuccessfully - do not make a call to the library}
  function gstlib_initdll(libname:string):boolean;
  // if Errors in initdll, you can get a string with the names , separated by a CR
  function gstlib_GetInitError:String;
  {GST library
    close the library and free the resources}
  procedure gstlib_freedll;
  {GST library
    return string: string of the version- see gst_version}
  function gstlib_versionstring:string;

  {GST_API gst.h
   void	gst_init(int *argc, char **argv[]);}
  procedure gst_init(var argc: gint; var args: pgchar);
  {GST_API gst.h
   gboolean gst_init_check(int *argc, char **argv[],GError ** err);}
  function gst_init_check(var argc: Integer; var args: PAnsiChar; var Error:PGError):gBoolean;
  {GST_API gst.h
   void	gst_version(guint *major, guint *minor, guint *micro, guint *nano);
   @major: a number indicating the major version
   @minor: a number indicating the minor version
   @micro: a number indicating the micro version
   @nano:  a number indicating the compiletime version
     Actual releases have 0, GIT versions have 1, prerelease versions have 2-...}
  procedure gst_version(var major, minor, micro, nano: guint);
  {GST_API gst.h
   gchar * gst_version_string(void);}
  function gst_version_string:Pgchar;

  {GST_API
  GstElement      * gst_parse_launch       (const gchar      * pipeline_description,
                                            GError          ** error) G_GNUC_MALLOC;}
  function gst_parse_launch(pipeline_description: Pgchar; var GError: PGError):pointer;
  {GST_API
   GstElement*     gst_pipeline_new                (const gchar *name) G_GNUC_MALLOC;}
  function gst_pipeline_new(const name: Pgchar): PGstElement;
  function gst_element_factory_make(const factoryname: Pgchar; const name: Pgchar): PGstElement;

  function gst_bin_add(element_1: PGstElement; element_2: PGstElement): Boolean;
  procedure gst_bin_add_many(element_1: PGstElement; element_2: PGstElement; additional: PGstElement);

  function gst_element_link(src: PGstElement; dest: PGstElement): Boolean;
  procedure gst_element_link_many_4(element_1: PGstElement; element_2: PGstElement; element_3: PGstElement; element_4: PGstElement; additional: PGstElement);
  procedure gst_element_link_many_5(element_1: PGstElement; element_2: PGstElement; element_3: PGstElement; element_4: PGstElement; element_5: PGstElement; additional: PGstElement);
  function gst_pipeline_get_bus(pipeline: PGstElement): pointer;
  function gst_bus_add_watch(bus: PGstElement; func: T_gst_bus_func; user_data: pointer): DWord;
  function gst_object_unref(obj: PGstElement): DWord;
  function gst_element_set_state(element: PGstElement; state: GstElementState): GstElementState;

  {gstmessage.h}
  {const GstStructure * gst_message_get_structure       (GstMessage *message);}
  function  gst_message_get_structure(message:PGstMessage): PGstStructure;
  procedure gst_message_parse_state_changed(message: PGSTmessage; oldstate: PGstElementState; newstate: PGstElementState; pending: PGstElementState);
  procedure gst_message_parse_error(msg: PGSTmessage; var GError: PGError; var debug: Pgchar);
  function  gst_message_type_get_name(_type: TGstMessageType): string;


  function gst_element_state_get_name(state: GstElementState): string;

  function gst_element_query_duration(element: PGstElement;format: GstFormat;var duration: gint64):boolean;
  function gst_element_query_position(element: PGstElement;format: GstFormat;var position: gint64):boolean;

  function gst_structure_get_name(structure: PGstStructure): string;
  function gst_structure_n_fields(structure: PGstStructure): gint;
  function gst_structure_nth_field_name(structure: PGstStructure; index: guint): string;
  function gst_structure_get_field_type(structure: PGstStructure; fieldname: Pgchar): GType;



implementation

uses
  dynlibs;

const
{$IFDEF UNIX}
  libgst_name_1_0  = 'libgstreamer-1.0.so.0';
{$ENDIF}
{$IFDEF MSWINDOWS}
  libgst_name_1_0  = 'libgstreamer-1.0-0.dll';
{$ENDIF}

Type
  {gst.h}
  {void	gst_version(guint *major, guint *minor, guint *micro, guint *nano);}
  T_gst_version = procedure (var major, minor, micro, nano: guint);
  {gchar * gst_version_string(void);}
  T_gst_version_string = function():pgchar;
  {void	gst_init (int *argc, char **argv[]);}
  T_gst_init = procedure (var argc: Integer; var args: PAnsiChar); cdecl;
  {gboolean gst_init_check(int *argc, char **argv[],GError ** err);}
  T_gst_init_check = function (var argc: Integer; var args: PAnsiChar; var Error:PGError):gBoolean; cdecl;

  T_gst_parse_launch = function(pipeline_description: Pgchar; var GError: PGError):pointer;
  T_gst_pipeline_new = function(const pipelinename: Pgchar): pointer; cdecl;

  T_gst_bin_add = function(bin: pointer; element: pointer): Boolean; cdecl;
  T_gst_bin_add_many = procedure(bin: pointer; element: pointer; additional: pointer); cdecl;

  T_gst_element_link = function(src: pointer; dest: pointer): Boolean; cdecl;
  T_gst_element_factory_make = function(const factoryname: Pgchar; const name: Pgchar): pointer; cdecl;
  T_gst_element_link_many = function(element_1: pointer; element_2: pointer): Boolean; cdecl;
  T_gst_element_link_many_4 = procedure(element_1: pointer; element_2: pointer; element_3: pointer; element_4: pointer; additional: pointer); cdecl;
  T_gst_element_link_many_5 = procedure(element_1: pointer; element_2: pointer; element_3: pointer; element_4: pointer; element_5: pointer; additional: pointer); cdecl;
  T_gst_pipeline_get_bus = function(pipeline: pointer): pointer; cdecl;
  T_gst_bus_add_watch = function(bus: pointer; func: T_gst_bus_func; user_data: pointer): DWord; cdecl;
  T_gst_object_unref = function(obj: pointer): DWord; cdecl;
  T_gst_element_set_state = function(element: pointer; state: TGstElementState): TGstElementState; cdecl;

  {gstmessage.h}
  {const GstStructure * gst_message_get_structure       (GstMessage *message);}
  T_gst_message_get_structure = function (message:PGstMessage): PGstStructure; cdecl;

  T_gst_message_parse_state_changed = procedure(message: PGSTmessage; oldstate: PGstElementState; newstate: PGstElementState; pending: PGstElementState); cdecl;
  T_gst_message_parse_error = procedure(msg: PGSTmessage; var GError: PGError; var debug: Pgchar); cdecl;

  T_gst_message_type_get_name = function(_type: TGstMessageType): Pgchar; cdecl;

  T_gst_element_state_get_name = function(state: TGstElementState): Pgchar; cdecl;
  T_gst_element_query_duration = function(element: PGstElement;format: GstFormat; var duration: gint64):gboolean;
  T_gst_element_query_position = function(element: PGstElement;format: GstFormat; var position: gint64):gboolean;

  T_gst_structure_get_name = function(structure: PGstStructure): Pgchar; cdecl;
  T_gst_structure_n_fields = function(structure: PGstStructure): gint; cdecl;
  T_gst_structure_nth_field_name = function(structure: PGstStructure; index: guint): Pgchar; cdecl;
  T_gst_structure_get_field_type = function(structure: PGstStructure; fieldname: Pgchar): TGType; cdecl;

  //T_g_type_name = function(_type: TGType): Pgchar; cdecl;

  {gstminiobject.h}


var
  libgst_handle: THandle;

  Init_Errors: String;

  aGST_init                   : T_gst_init;
  aGST_init_check             : T_gst_init_check;
  aGST_version                : T_gst_version;
  aGST_version_string         : T_gst_version_string;


  aGST_parse_launch          : T_gst_parse_launch;
  aGST_object_unref          : T_gst_object_unref;

  aGST_pipeline_new          : T_gst_pipeline_new;
  aGST_pipeline_get_bus      : T_gst_pipeline_get_bus;
  aGST_bus_add_watch         : T_gst_bus_add_watch;

  aGST_bin_add               : T_gst_bin_add;
  aGST_bin_add_many          : T_gst_bin_add_many;

  aGST_element_set_state     : T_gst_element_set_state;
  aGST_element_factory_make  : T_gst_element_factory_make;
  aGST_element_link_many     : T_gst_element_link_many;
  aGST_element_link_many_4   : T_gst_element_link_many_4;
  aGST_element_link_many_5   : T_gst_element_link_many_5;
  aGST_element_link          : T_gst_element_link;

  // gst_message
  aGST_message_get_structure  : T_gst_message_get_structure;
  aGST_message_parse_state_changed : T_gst_message_parse_state_changed;
  aGST_message_parse_error : T_gst_message_parse_error;
  aGST_message_type_get_name : T_gst_message_type_get_name;

  aGST_element_state_get_name :  T_gst_element_state_get_name;
  aGST_element_query_duration : T_gst_element_query_duration;
  aGST_element_query_position : T_gst_element_query_position;

  aGST_structure_get_name :  T_gst_structure_get_name;
  aGST_structure_n_fields : T_gst_structure_n_fields;
  aGST_structure_nth_field_name : T_gst_structure_nth_field_name;
  aGST_structure_get_field_type : T_gst_structure_get_field_type;

//

function libGST_dll_get_proc_addr(var addr: Pointer; const name: PAnsiChar): Boolean;
begin
  addr := GetProcedureAddress(libGST_handle, name);
  Result := (addr <> NIL);
  if not Result then
    Init_Errors := Init_Errors + name + #13;
end;

function libGST_dynamic_dll_init(currLib:string):boolean;
var
  ErrCnt : integer;
  FN2: string;
begin
  Result := false;
  ErrCnt := 0;
  Init_Errors := '';
  // check if handle is not allocatet
  if (libGST_handle <> dynlibs.NilHandle) then exit;
  libGST_handle := DynLibs.LoadLibrary(currLib);
  {$IfDef WINDOWS}
  // the the version with windows it is possible the leading 'lib' is missing
  //   it depends on the installed version of gstreamer
  //   compiled with minGW it has the 'lib'
  //   compiled with MSVC the 'lib' at the beginning of the filename is missing
  if (libGST_handle = dynlibs.NilHandle) then
  begin
    FN2 := RightStr(currLib,length(currLib)-3);
    libGST_handle := DynLibs.LoadLibrary(FN2);
  end;
  {$endif}
  // if handle not allocated well, then exit
  if (libGST_handle = dynlibs.NilHandle) then
  begin
    exit;
  end;
  // allocate the dynamic handles
  if not libGST_dll_get_proc_addr(pointer(aGST_init), 'gst_init') then inc(ErrCnt);
  if not libGST_dll_get_proc_addr(pointer(aGST_init_check), 'gst_init_check') then inc(ErrCnt);
  if not libGST_dll_get_proc_addr(pointer(aGST_version), 'gst_version') then inc(ErrCnt);
  if not libGST_dll_get_proc_addr(pointer(aGST_version_string), 'gst_version_string') then inc(ErrCnt);

  // gst_message
  if not libGST_dll_get_proc_addr(pointer(aGST_message_get_structure), 'gst_message_get_structure') then inc(ErrCnt);
  if not libGST_dll_get_proc_addr(pointer(aGST_message_parse_state_changed), 'gst_message_parse_state_changed') then inc(ErrCnt);
  if not libGST_dll_get_proc_addr(pointer(aGST_message_parse_error), 'gst_message_parse_error') then inc(ErrCnt);
  if not libGST_dll_get_proc_addr(pointer(aGST_message_type_get_name), 'gst_message_type_get_name') then inc(ErrCnt);


  // gst div
  if not libGST_dll_get_proc_addr(pointer(aGST_parse_launch), 'gst_parse_launch') then inc(ErrCnt);
  if not libGST_dll_get_proc_addr(pointer(aGST_object_unref), 'gst_object_unref') then inc(ErrCnt);

  // pipeline
  if not libGST_dll_get_proc_addr(pointer(aGST_pipeline_new), 'gst_pipeline_new') then inc(ErrCnt);
  if not libGST_dll_get_proc_addr(pointer(aGST_pipeline_get_bus), 'gst_pipeline_get_bus') then inc(ErrCnt);
  if not libGST_dll_get_proc_addr(pointer(aGST_bus_add_watch), 'gst_bus_add_watch') then inc(ErrCnt);

  //
  if not libGST_dll_get_proc_addr(pointer(aGST_bin_add), 'gst_bin_add') then inc(ErrCnt);
  if not libGST_dll_get_proc_addr(pointer(aGST_bin_add_many), 'gst_bin_add_many') then inc(ErrCnt);

  // element
  if not libGST_dll_get_proc_addr(pointer(aGST_element_factory_make), 'gst_element_factory_make') then inc(ErrCnt);
  if not libGST_dll_get_proc_addr(pointer(aGST_element_link_many), 'gst_element_link_many') then inc(ErrCnt);
  if not libGST_dll_get_proc_addr(pointer(aGST_element_link_many_4), 'gst_element_link_many') then inc(ErrCnt);
  if not libGST_dll_get_proc_addr(pointer(aGST_element_link_many_5), 'gst_element_link_many') then inc(ErrCnt);
  if not libGST_dll_get_proc_addr(pointer(aGST_element_link), 'gst_element_link') then inc(ErrCnt);
  if not libGST_dll_get_proc_addr(pointer(aGST_element_set_state), 'gst_element_set_state') then inc(ErrCnt);
  if not libGST_dll_get_proc_addr(pointer(aGST_element_query_duration), 'gst_element_query_duration') then inc(ErrCnt);
  if not libGST_dll_get_proc_addr(pointer(aGST_element_query_position), 'gst_element_query_position') then inc(ErrCnt);
  if not libGST_dll_get_proc_addr(pointer(aGST_element_state_get_name), 'gst_element_state_get_name') then inc(ErrCnt);

  // structure
  if not libGST_dll_get_proc_addr(pointer(aGST_structure_get_name), 'gst_structure_get_name') then inc(ErrCnt);
  if not libGST_dll_get_proc_addr(pointer(aGST_structure_n_fields), 'gst_structure_n_fields') then inc(ErrCnt);
  if not libGST_dll_get_proc_addr(pointer(aGST_structure_nth_field_name), 'gst_structure_nth_field_name') then inc(ErrCnt);
  if not libGST_dll_get_proc_addr(pointer(aGST_structure_get_field_type), 'gst_structure_get_field_type') then inc(ErrCnt);

  if ErrCnt = 0 then
    Result := true;
end;

procedure libgst_dynamic_dll_done();
begin
  // if the handle is allocated, so free it
  if (libgst_handle <> dynlibs.NilHandle) then FreeLibrary(libgst_handle);
  libgst_handle := dynlibs.NilHandle;
end;

// ------------

function gstlib_GetInitError:String;
begin
  Result := Init_Errors;
end;

function gstlib_initdll(libname: string): boolean;
begin
  if (libname = '') then
    libname := libgst_name_1_0;
  Result := libGST_dynamic_dll_init(libname);
end;

procedure gstlib_freedll;
begin
  libgst_dynamic_dll_done();
end;

function gstlib_versionstring:string;
var
  major,minor,micro,nano : guint;
begin
  major:=0; minor:=0; micro:=0; nano:=0;
  gst_version(major, minor, micro, nano);
  Result:=  IntToStr(major)+'.'+IntToStr(minor)+'.'+IntToStr(micro)+'.'+IntToStr(nano)
end;

// ------- gst.h ---------

procedure gst_init(var argc: gint; var args: pgchar);
begin
  if (addr(aGST_init) <> nil) then
    aGST_init(argc,args);
end;

function gst_init_check(var argc: Integer; var args: PAnsiChar;
  var Error: PGError): gBoolean;
begin
  Result := false;
  if (addr(aGST_init_check) <> nil) then
    Result := aGST_init_check(argc,args,Error);
end;

procedure gst_version(var major, minor, micro, nano: guint);
begin
  major := 0; minor := 0; micro := 0; nano := 0;
  if (addr(aGST_version) <> nil) then
    aGST_version(major,minor,micro,nano)
end;

function gst_version_string: Pgchar;
begin
  Result := PAnsiChar('');
  if (addr(aGST_version_string) <> nil) then
    Result := aGST_version_string()
end;

function gst_message_get_structure(message: PGstMessage): PGstStructure;
begin
  Result := Nil;
  if (addr(aGST_message_get_structure) <> nil) then
    Result := aGST_message_get_structure(message);
end;

procedure gst_message_parse_state_changed(message: PGSTmessage;
  oldstate: PGstElementState; newstate: PGstElementState;
  pending: PGstElementState);
begin
  if (addr(aGST_message_parse_state_changed) <> nil) then
    aGST_message_parse_state_changed(message, oldstate, newstate, pending);
end;

procedure gst_message_parse_error(msg: PGSTmessage; var GError: PGError;
  var debug: Pgchar);
begin
  if (addr(aGST_message_parse_error) <> nil) then
    aGST_message_parse_error(msg, GError, debug);
end;


function gst_message_type_get_name(_type: TGstMessageType): string;
begin
  Result := '';
  if (addr(aGST_message_type_get_name) <> nil) then
    Result := string(aGST_message_type_get_name(_type));
end;


function gst_element_state_get_name(state: GstElementState): string;
begin
  Result := '';
  if (addr(aGST_element_state_get_name) <> nil) then
    Result := string(aGST_element_state_get_name(state));
end;

function gst_element_query_duration(element: PGstElement; format: GstFormat;
  var duration: gint64): boolean;
begin
  Result := false;
  if (addr(aGST_element_query_duration) <> nil) then
    Result := aGST_element_query_duration(element,format,duration);
end;

function gst_element_query_position(element: PGstElement; format: GstFormat;
  var position: gint64): boolean;
begin
  Result := false;
  if (addr(aGST_element_query_position) <> nil) then
    Result := aGST_element_query_position(element,format,position);
end;

function gst_structure_get_name(structure: PGstStructure): string;
begin
  Result := '';
  if (addr(aGST_structure_get_name) <> nil) then
    Result := string(aGST_structure_get_name(structure));
end;

function gst_structure_n_fields(structure: PGstStructure): gint;
begin
  Result := 0;
  if (addr(aGST_structure_n_fields) <> nil) then
    Result := aGST_structure_n_fields(structure);
end;

function gst_structure_nth_field_name(structure: PGstStructure; index: guint
  ): string;
begin
  Result := '';
  if (addr(aGST_structure_nth_field_name) <> nil) then
    Result := string(aGST_structure_nth_field_name(structure, index));
end;

function gst_structure_get_field_type(structure: PGstStructure;
  fieldname: Pgchar): GType;
begin
  Result := 0;
  if (addr(aGST_structure_get_field_type) <> nil) then
    Result := aGST_structure_get_field_type(structure, fieldname);
end;

function gst_message_parse_error(pipeline_description: Pgchar;
  var GError: PGError): pointer;
begin

end;

function gst_parse_launch(pipeline_description: Pgchar; var GError: PGError
  ): pointer;
begin
  Result := PGstElement(Nil);
  if (addr(aGST_parse_launch) <> nil) then
    Result := aGST_parse_launch(pipeline_description,GError);
end;

function gst_pipeline_new(const name: Pgchar): PGstElement;
begin
  Result := PGstElement(Nil);
  if (addr(aGST_pipeline_new) <> nil) then
    Result := aGST_pipeline_new(name);
end;

function gst_element_factory_make(const factoryname: Pgchar; const name: Pgchar
  ): PGstElement;
begin
  Result := PGstElement(Nil);
  if (addr(aGST_element_factory_make) <> nil) then
    Result := aGST_element_factory_make(factoryname, name);
end;

function gst_bin_add(element_1: PGstElement; element_2: PGstElement): Boolean;
begin
  Result:= false;
  if (addr(aGST_bin_add) <> nil) then
    Result := aGST_bin_add(element_1, element_2);
end;

procedure gst_bin_add_many(element_1: PGstElement; element_2: PGstElement;
  additional: PGstElement);
begin
  if (addr(aGST_bin_add_many) <> nil) then
    aGST_bin_add_many(element_1, element_2, additional);
end;

procedure gst_element_link_many_4(element_1: PGstElement;
  element_2: PGstElement; element_3: PGstElement; element_4: PGstElement;
  additional: PGstElement);
begin
  if (addr(aGST_element_link_many_4) <> nil) then
    aGST_element_link_many_4(element_1, element_2, element_3, element_4, additional);
end;

procedure gst_element_link_many_5(element_1: PGstElement;
  element_2: PGstElement; element_3: PGstElement; element_4: PGstElement;
  element_5: PGstElement; additional: PGstElement);
begin
  if (addr(aGST_element_link_many_5) <> nil) then
    aGST_element_link_many_5(element_1, element_2, element_3, element_4, element_5,additional);
end;

function gst_element_link(src: PGstElement; dest: PGstElement): Boolean;
begin
  Result := false;
  if (addr(aGST_element_link) <> nil) then
    Result := aGST_element_link(src, dest);
end;

function gst_pipeline_get_bus(pipeline: PGstElement): pointer;
begin
  Result := pointer(nil);
  if (addr(aGST_pipeline_get_bus) <> nil) then
    Result := aGST_pipeline_get_bus(pipeline);
end;

function gst_bus_add_watch(bus: PGstElement; func: T_gst_bus_func;
  user_data: pointer): DWord;
begin
  Result := 0;
  if (addr(aGST_bus_add_watch) <> nil) then
    Result := aGST_bus_add_watch(bus, func, user_data);
end;

function gst_object_unref(obj: PGstElement): DWord;
begin
  Result := 0;
  if (addr(aGST_object_unref) <> nil) then
    Result := aGST_object_unref(obj);
end;

function gst_element_set_state(element: PGstElement; state: GstElementState
  ): GstElementState;
begin
  Result := 0;
  if (addr(aGST_element_set_state) <> nil) then
    Result := aGST_element_set_state(element, state);
end;



initialization

  // init the handle with a good value
  libgst_handle := dynlibs.NilHandle;

finalization

end.

