(*
 * This is a header translation of
 * gst.h from gstreamer 1.x
 * https://gstreamer.freedesktop.org/
 * The library (.dll/.so) itself is not a part of this package and copyrighted by gstreamer Project
 *)

(*
 * Copyright (c) 2018 by Andreas Frieß
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

unit gst;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, glib2;
  {GST library
    @libname: a string with the libraryname,
              if empty use the default plattform defaultname
    return true if library correct loaded
           false if unsuccessfully - do not make a call to the library}
  function gstlib_initdll(libname:string):boolean;
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

var
  libgst_handle: THandle;

  aGST_init                   : T_gst_init;
  aGST_init_check             : T_gst_init_check;
  aGST_version                : T_gst_version;
  aGST_version_string         : T_gst_version_string;


function libGST_dll_get_proc_addr(var addr: Pointer; const name: PAnsiChar): Boolean;
begin
  addr := GetProcedureAddress(libGST_handle, name);
  Result := (addr <> NIL);
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
  if not libGST_dll_get_proc_addr(pointer(aGST_init), 'gst_init') then inc(ErrCnt);
  if not libGST_dll_get_proc_addr(pointer(aGST_init_check), 'gst_init_check') then inc(ErrCnt);
  if not libGST_dll_get_proc_addr(pointer(aGST_version), 'gst_version') then inc(ErrCnt);
  if not libGST_dll_get_proc_addr(pointer(aGST_version_string), 'gst_version_string') then inc(ErrCnt);

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



initialization

  // init the handle with a good value
  libgst_handle := dynlibs.NilHandle;

finalization

end.

