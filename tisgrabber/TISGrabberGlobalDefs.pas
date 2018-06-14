(*
 * This is a header translation of
 * TISGrabberGlobalDefs.h 3.4.0.51 from TheImageSource
 * https://www.theimagingsource.de/support/software-f%C3%BCr-windows/software-development-kits-sdks/tisgrabberdll/
 * The dll itself is not a part of this package and copyrighted by TheImageSource
 * 
 *)

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

unit TISGrabberGlobalDefs;
interface

  const
    External_library='kernel32';

  { Pointers to basic pascal types}
  Type
    PLongint  = ^Longint;
    PSmallInt = ^SmallInt;
    PByte     = ^Byte;
    PWord     = ^Word;
    PDWord    = ^DWord;
    PDouble   = ^Double;

  Type
  PCAMERA_PROPERTY  = ^CAMERA_PROPERTY;
  PCOLORFORMAT  = ^COLORFORMAT;
  PFRAMEFILTER_PARAM_TYPE  = ^FRAMEFILTER_PARAM_TYPE;
  PIMG_FILETYPE  = ^IMG_FILETYPE;
  PPROPERTY_INTERFACE_TYPE  = ^PROPERTY_INTERFACE_TYPE;
  PVIDEO_PROPERTY  = ^VIDEO_PROPERTY;
{$IFDEF FPC}
{$PACKRECORDS C}
{$ENDIF}


{$ifndef __GLOBALDEFS_H__}
{$define __GLOBALDEFS_H__}  
  { Borland C++ 6 compatibility }

  type
    PIMG_FILETYPE = ^IMG_FILETYPE;
    IMG_FILETYPE =  Longint;
    Const
      FILETYPE_BMP = 0;
      FILETYPE_JPEG = 1;
      FILETYPE_MEGA = 65536;
;
  { used as return value }
  { Borland C++ 6 compatibility }

  type
    PCOLORFORMAT = ^COLORFORMAT;
    COLORFORMAT =  Longint;
    Const
      Y800 = 0;
      RGB24 = 1;
      RGB32 = 2;
      UYVY = 3;
      Y16 = 4;
      NONE = 5;
      COLORFORMAT_MEGA = 65536;
;
  { Borland C++ 6 compatibility }

  type
    PVIDEO_PROPERTY = ^VIDEO_PROPERTY;
    VIDEO_PROPERTY =  Longint;
    Const
      PROP_VID_BRIGHTNESS = 0;
      PROP_VID_CONTRAST = 1;
      PROP_VID_HUE = 2;
      PROP_VID_SATURATION = 3;
      PROP_VID_SHARPNESS = 4;
      PROP_VID_GAMMA = 5;
      PROP_VID_COLORENABLE = 6;
      PROP_VID_WHITEBALANCE = 7;
      PROP_VID_BLACKLIGHTCOMPENSATION = 8;
      PROP_VID_GAIN = 9;
      PROP_VID_MEGA = 65536;
;
  { Borland C++ 6 compatibility }

  type
    PCAMERA_PROPERTY = ^CAMERA_PROPERTY;
    CAMERA_PROPERTY =  Longint;
    Const
      PROP_CAM_PAN = 0;
      PROP_CAM_TILT = 1;
      PROP_CAM_ROLL = 2;
      PROP_CAM_ZOOM = 3;
      PROP_CAM_EXPOSURE = 4;
      PROP_CAM_IRIS = 5;
      PROP_CAM_FOCUS = 6;
      PROP_CAM_MEGA = 65536;
;

  type
    PFRAMEFILTER_PARAM_TYPE = ^FRAMEFILTER_PARAM_TYPE;
    FRAMEFILTER_PARAM_TYPE =  Longint;
    Const
      eParamLong = 0;
      eParamBoolean = 1;
      eParamFloat = 2;
      eParamString = 3;
      eParamData = 4;
;

  type
    PPROPERTY_INTERFACE_TYPE = ^PROPERTY_INTERFACE_TYPE;
    PROPERTY_INTERFACE_TYPE =  Longint;
    Const
      ePropertyRange = 0;
      ePropertyAbsoluteValue = 1;
      ePropertySwitch = 2;
      ePropertyButton = 3;
      ePropertyMapStrings = 4;
      ePropertyUnknown = 5;
;
{$endif}

implementation


end.
