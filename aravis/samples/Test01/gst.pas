unit gst;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, glib2;

  function gst_initdll(libname:string):boolean;
  procedure gst_freedll;
  {GST_API
   void		gst_version			(guint *major, guint *minor,
  						 guint *micro, guint *nano);
   @major: a number indicating the major version
   @minor: a number indicating the minor version
   @micro: a number indicating the micro version
   @nano:  a number indicating the compiletime version
     Actual releases have 0, GIT versions have 1, prerelease versions have 2-...}
  procedure gst_version(var major, minor, micro, nano: guint);

  function gst_versionstring:string;

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
  T_gst_version = procedure (var major, minor, micro, nano: guint);

var
  aGST_version : T_gst_version;

  libgst_handle: THandle;

function libGST_dll_get_proc_addr(var addr: Pointer; const name: PAnsiChar): Boolean;
begin
  addr := GetProcedureAddress(libGST_handle, name);
  Result := (addr <> NIL);
  //if not Result then
  //begin
  //  libGST_dynamic_dll_error := 'Procedure "' + name + '" not found!';
  //end;
end;

function libGST_dynamic_dll_init(currLib:string):boolean;
var
  ErrCnt : integer;
begin
  Result := false;
  ErrCnt := 0;
  // check if handle is not allocatet
  if (libGST_handle <> dynlibs.NilHandle) then exit;
  libGST_handle := DynLibs.LoadLibrary(currLib);
  // if handle not allocated well, then exit
  if (libGST_handle = dynlibs.NilHandle) then
  begin
    exit;
  end;
  // allocate the dynamic handles
  if not libGST_dll_get_proc_addr(pointer(aGST_version),  'gst_version') then inc(ErrCnt);

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

function gst_initdll(libname: string): boolean;
begin
  if (libname = '') then
    libname := libgst_name_1_0;
  Result := libGST_dynamic_dll_init(libname);
end;

procedure gst_freedll;
begin
  libgst_dynamic_dll_done();
end;

procedure gst_version(var major, minor, micro, nano: guint);
begin
  if (addr(aGST_version) <> nil) then
    aGST_version(major,minor,micro,nano)
  else begin
    major := 0;
    minor := 0;
    micro := 0;
    nano := 0;
  end;

end;

function gst_versionstring:string;
var
  major,minor,micro,nano : guint;
begin
  gst_version(major, minor, micro, nano);
  Result:=  IntToStr(major)+'.'+IntToStr(minor)+'.'+IntToStr(micro)+'.'+IntToStr(nano)
end;


initialization

  // init the handle with a good value
  libgst_handle := dynlibs.NilHandle;

finalization

end.

