(*
 * copyright (c) 2018 Noll Industrietechnik by Andreas Frieß
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

unit udlltest;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  tisgrabber;

type

  { TForm1 }

  TForm1 = class(TForm)
    buOpenDevice: TButton;
    buCloseDevice: TButton;
    buShow: TButton;
    buSerial: TButton;
    cbDevice: TCheckBox;
    cbLibrary: TCheckBox;
    lblShowInfo: TLabel;
    lblSerial: TLabel;
    Panel1: TPanel;
    procedure buCloseDeviceClick(Sender: TObject);
    procedure buOpenDeviceClick(Sender: TObject);
    procedure buShowClick(Sender: TObject);
    procedure buSerialClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
  private
    grabber : HGRABBER;
  public

  end;

var
  Form1: TForm1;

implementation

// This sample need the correct dll's
// 32 Bit
//   tisgrabber.dll
//   TIS_UDSHL11.dll
// 64 Bit (untested)
//   tisgrabber_x64.dll
//   TIS_UDSHL11_x64.dll
// to work, in the same directory like the exe

{$R *.lfm}

{ TForm1 }

procedure TForm1.buOpenDeviceClick(Sender: TObject);
begin
  cbLibrary.Checked := (IC_InitLibrary(pchar('')) = IC_SUCCESS);
  if cbLibrary.Checked then begin
    grabber := IC_CreateGrabber;
    // You have to insert YOUR Camratype
    cbDevice.Checked := (IC_OpenVideoCaptureDevice(grabber,'DFK 33GX178e') = IC_SUCCESS );
  end;
end;

procedure TForm1.buShowClick(Sender: TObject);
var
  w,h : longint;
begin
  ////showmessage('Open OK');
  IC_SetHWnd(grabber, Panel1.Handle);
  w := IC_GetVideoFormatHeight(grabber);
  h := IC_GetVideoFormatWidth(grabber);
  lblShowInfo.Caption:= 'Size: ' + IntToStr(w) + 'x' + IntToStr(h);
  IC_StartLive(grabber,1);
  ////showmessage('Open OK');

end;

procedure TForm1.buSerialClick(Sender: TObject);
var
  pSerial: pchar;
  info : string;
begin
  GetMem(pSerial,50);
  if IC_GetSerialNumber(grabber, pSerial) <> IC_SUCCESS then
    ShowMessage('Serial fails');
  info := String(pSerial);
  lblSerial.caption := info;
  FreeMem(pSerial);
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  buCloseDeviceClick(nil);
end;

procedure TForm1.buCloseDeviceClick(Sender: TObject);
begin
  if cbDevice.Checked then begin
    IC_CloseVideoCaptureDevice(grabber);
    IC_ReleaseGrabber(@grabber);
    cbDevice.Checked := false;
  end;
  if cbLibrary.Checked then begin
    IC_CloseLibrary;
    cbLibrary.Checked:= false;
  end;
end;

end.

