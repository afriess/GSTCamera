(*
 * This is a header translation of
 * tisgrabber.h 3.4.0.51 from TheImageSource
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

unit tisgrabber;

{$mode objfpc}{$H+}

interface

uses
  windows;

{$IFDEF FPC}
  {$PACKRECORDS C}
{$ENDIF}

{
Macro           C++ denition            Delphi denition
CALLBACK        __stdcall               stdcall
WINAPI          __stdcall               stdcall
WINAPIV         __cdecl                 cdecl
APIENTRY        WINAPI                  stdcall
APIPRIVATE      __stdcall               stdcall
PASCAL          __stdcall               stdcall
FAR             (nothing)               (nothing)
}


{ Pointers to basic pascal types}
Type
  PLongint  = ^Longint;
  PSmallInt = ^SmallInt;
  PByte     = ^Byte;
  PWord     = ^Word;
  PDWord    = ^DWord;
  PDouble   = ^Double;
  Pchar     = ^char;

const
  {tisgrabber from TheImageSource
  https://www.theimagingsource.de/support/software-f%C3%BCr-windows/software-development-kits-sdks/tisgrabberdll/
  }
  External_library='tisgrabber.dll'; 

  //COLORFORMAT
  Y800 = 0;
  RGB24 = 1;
  RGB32 = 2;
  UYVY = 3;
  Y16 = 4;
  NONE = 5;
  COLORFORMAT_MEGA = 65536;

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

  FILETYPE_BMP = 0;
  FILETYPE_JPEG = 1;
  FILETYPE_MEGA = 65536;

  PROP_CAM_PAN = 0;
  PROP_CAM_TILT = 1;
  PROP_CAM_ROLL = 2;
  PROP_CAM_ZOOM = 3;
  PROP_CAM_EXPOSURE = 4;
  PROP_CAM_IRIS = 5;
  PROP_CAM_FOCUS = 6;
  PROP_CAM_MEGA = 65536;

  eParamLong = 0;
  eParamBoolean = 1;
  eParamFloat = 2;
  eParamString = 3;
  eParamData = 4;

  ePropertyRange = 0;
  ePropertyAbsoluteValue = 1;
  ePropertySwitch = 2;
  ePropertyButton = 3;
  ePropertyMapStrings = 4;
  ePropertyUnknown = 5;


Type
  PCOLORFORMAT = ^COLORFORMAT;
  COLORFORMAT =  Longint;

  PVIDEO_PROPERTY = ^VIDEO_PROPERTY;
  VIDEO_PROPERTY =  Longint;

  PCAMERA_PROPERTY = ^CAMERA_PROPERTY;
  CAMERA_PROPERTY =  Longint;

  PFRAMEFILTER_PARAM_TYPE = ^FRAMEFILTER_PARAM_TYPE;
  FRAMEFILTER_PARAM_TYPE =  Longint;

  PPROPERTY_INTERFACE_TYPE = ^PROPERTY_INTERFACE_TYPE;
  PROPERTY_INTERFACE_TYPE =  Longint;

  PIMG_FILETYPE  = ^IMG_FILETYPE;
  IMG_FILETYPE =  Longint;

  {//////////////////////////////////////////////////////////////////////// }
  {! This is the handle of an grabber object. Please use the TGRABBER* type to access
  	this object.
   }

  type
    TGRABBER = record
        unused : longint;
      end;
    HGRABBER = ^TGRABBER;
    PHGRABBER = ^HGRABBER;

    //TGRABBER = TGRABBER__;
    //PTGRABBER = ^TGRABBER;

    {/<Internal structure of the grabber object handle. }
  {//////////////////////////////////////////////////////////////////////// }
  {! The TGRABBER* type is used to hold a handle to a grabber object. Each variable of
  	TGRABBER* type can contain one video capture device. It is possible to create more
  	than one variables of this type:
  	TGRABBER* camera1 = IC_CreateGrabber();
  	TGRABBER* camera2 = IC_CreateGrabber();
   }
  {typedef int  _stdcall IC_ENUMCB( char* Name, void*); }

    HFILTERPARAMETER = ^TFILTERPARAMETER;
    TFILTERPARAMETER = record
        Name : array[0..29] of char;
        _Type : FRAMEFILTER_PARAM_TYPE;
      end;

    //FILTERPARAMETER = FILTERPARAMETER_t__;
    //HFILTERPARAMETER_t = ^FILTERPARAMETER_t;

    HFRAMEFILTER = ^TFRAMEFILTER;
    TFRAMEFILTER = record
        pFilter : pointer;
        bHasDialog : longint;
        ParameterCount : longint;
        Parameters : HFILTERPARAMETER;
      end;

    //HFRAMEFILTER_t = HFRAMEFILTER_t__;
    //HFRAMEFILTER_t = ^HFRAMEFILTER_t;

    //PCODECHANDLE_t  = ^CODECHANDLE_t;
    //PCODECHANDLE_t__  = ^CODECHANDLE_t__;


const
  {//////////////////////////////////////////////////////////////////////// }
  {! A return value of IC_SUCCESS indicates that a function has been performed
      without an error.
   }
    IC_SUCCESS = 1;    {/< Return value for success. }
  {//////////////////////////////////////////////////////////////////////// }
  {! If a function returns IC_ERROR, then something went wrong.
   }
    IC_ERROR = 0;    {/< Return value that indicates an error. }
  {//////////////////////////////////////////////////////////////////////// }
  {! This error indicates, that an TGRABBER* handle has not been created yet. Please
  	see IC_CreateGrabber() for creating an TGRABBER* handle. 
   }
    IC_NO_HANDLE = -(1);    {/< No device handle. TGRABBER* is NULL. }
  {//////////////////////////////////////////////////////////////////////// }
  {! This return values indicates that no device has been opened. Please refer to
      IC_OpenVideoCaptureDevice().
   }
    IC_NO_DEVICE = -(2);    {/< No device opened, but TGRABBER* is valid. }
  {//////////////////////////////////////////////////////////////////////// }
  {! This return value indicates, that the video capture device is not in live mode,
      but live mode is for the current function call required. Please refer to
  	IC_StartLive().
   }
    IC_NOT_AVAILABLE = -(3);    {/< Property not avaiable, but TGRABBER* is valid. }
  {//////////////////////////////////////////////////////////////////////// }
  {! This return value indicates, that the video capture device does not support
  	the specified property.
   }
    IC_NO_PROPERTYSET = -(3);    {/< The Propertyset was not queried. }
  {//////////////////////////////////////////////////////////////////////// }
  {! This return value indicates, that the porperty set was not queried for
  	the current grabber handle. Please check, whether IC_QueryPropertySet() 
  	was called once before using the function.
   }
    IC_DEFAULT_WINDOW_SIZE_SET = -(3);    {/< The live display window size could not be set }
  {//////////////////////////////////////////////////////////////////////// }
  {! This return value indicates, that setting of a custom live display window size
  	failed, because IC_SetDefaultWindowPosition() was not called with parameter false
  	somewhere before.
  	@sa IC_SetDefaultWindowPosition
  	@sa IC_SetWindowPosition
   }
    IC_NOT_IN_LIVEMODE = -(3);    {/< A device has been opened, but is is not in live mode. }
  {//////////////////////////////////////////////////////////////////////// }
  {! This return value indicates, that a device does not support the requested property, or
  	the name of a property was written in wrong way.
  
  	@sa IC_GetPropertyValueRange
   }
    IC_PROPERTY_ITEM_NOT_AVAILABLE = -(4);    {/< A requested property item is not available }
  {//////////////////////////////////////////////////////////////////////// }
  {! This return value indicates, that a device does not support the requested element property, or
  	the name of an element was written in wrong way.
  
  	@sa IC_GetPropertyValueRange
   }
    IC_PROPERTY_ELEMENT_NOT_AVAILABLE = -(5);    {/< A requested element of a given property item is not available }
  {//////////////////////////////////////////////////////////////////////// }
  {! This return value indicates, that a property element does not support
      the request, that is wanted. e.g. Exposure Auto has no range, therefore
  	IC_GetPropertyValueRange(hGrabb , "Epxosure","Auto", &min, &max )
  	will return IC_PROPERTY_ELEMENT_WRONG_INTERFACE.
  
  	@sa IC_GetPropertyValueRange
   }
    IC_PROPERTY_ELEMENT_WRONG_INTERFACE = -(6);    {/< A requested element has not the interface, which is needed. }
  {//////////////////////////////////////////////////////////////////////// }
  {! This return value indicates, that there was an index passed, which 
  	was out of range of the number of available elements
  
  	@sa IC_ListDevicesbyIndex
   }
    IC_INDEX_OUT_OF_RANGE = -(7);    {/< A requested element has not the interface, which is needed. }
  {//////////////////////////////////////////////////////////////////////// }
  {! This return value indicates, that that the passed XML file contains no valid XML
  	data.
  
  	@sa IC_LoadDeviceStateFromFileEx
   }
    IC_WRONG_XML_FORMAT = -(1);    
  {//////////////////////////////////////////////////////////////////////// }
  {! This return value indicates, that  the passed XML file contains no compatible XML
  	data.
  
  	@sa IC_LoadDeviceStateFromFileEx
   }
    IC_WRONG_INCOMPATIBLE_XML = -(3);    
  {//////////////////////////////////////////////////////////////////////// }
  {! This return value indicates, that  not all properties have been restored
  	as desired, but the camera itself was opened.
  
  	@sa IC_LoadDeviceStateFromFileEx
   }
    IC_NOT_ALL_PROPERTIES_RESTORED = -(4);    
  {//////////////////////////////////////////////////////////////////////// }
  {! This return value indicates, that the device specified in the XML was not
  	found. E.g. The same model, but different serial number, or no camera 
  	connected at all.
  
  	@sa IC_LoadDeviceStateFromFileEx
   }
    IC_DEVICE_NOT_FOUND = -(5);    
  {//////////////////////////////////////////////////////////////////////// }
  {! This return value indicates, that the passed file does not exist
  
  	@sa IC_LoadDeviceStateFromFileEx
   }
    IC_FILE_NOT_FOUND = 35;    

    {//////////////////////////////////////////////////////////////////////// }
  {! Initialize the ICImagingControl class library. This function must be called
  	only once before any other functions of this library are called.
  	@param szLicenseKey IC Imaging Control license key or NULL if only a trial version is available.
  	@retval IC_SUCCESS on success.
  	@retval IC_ERROR on wrong license key or other errors.
  	@sa IC_CloseLibrary

   int AC IC_InitLibrary( char* szLicenseKey );///<Initialize the library.
   }

  function IC_InitLibrary(szLicenseKey:Pchar):longint;stdcall;external External_library name 'IC_InitLibrary';

  {/<Initialize the library. }
  {//////////////////////////////////////////////////////////////////////// }
  {! Creates a new grabber handle and returns it. A new created grabber should be
  	release with a call to IC_ReleaseGrabber if it is no longer needed.
  	@retval IC_SUCCESS on success.
  	@retval IC_ERROR if an error occurred.
  	@sa IC_ReleaseGrabber

  HGRABBER AC IC_CreateGrabber();///<Create a new grabber handle
  }

  function IC_CreateGrabber:HGRABBER;stdcall;external External_library name 'IC_CreateGrabber';

  {/<Create a new grabber handle }
  {//////////////////////////////////////////////////////////////////////// }
  {! Release the grabber object. Must be called, if the calling application
      does no longer need the grabber.
  	@param hGrabb  The handle to grabber to be released.
  	@sa IC_CreateGrabber

  void AC IC_ReleaseGrabber( HGRABBER *hGrabb  ); ///< Release an HGRABBER object.
  }
  procedure IC_ReleaseGrabber( hGrabb :PHGRABBER);stdcall;external External_library name 'IC_ReleaseGrabber';

  {/< Release an TGRABBER* object. }
  {//////////////////////////////////////////////////////////////////////// }
  {	Must be called at the of the application to release allocated memory.
  	@sa IC_InitLibrary

  void AC IC_CloseLibrary(); ///< Closes the library, cleans up memory.
  }
  procedure IC_CloseLibrary;stdcall;external External_library name 'IC_CloseLibrary';

  {/< Closes the library, cleans up memory.  }
  {//////////////////////////////////////////////////////////////////////// }
  {! Open a video capture device. The hGrabb  handle must have been created previously by
  	a call to IC_CreateGrabber(). Once a hGrabb  handle has been created it can be
  	recycled to open different video capture devices in sequence. 
  	@param hGrabb  The handle to grabber object, that has been created by a call to IC_CreateGrabber
  	@param szDeviceName Friendly name of the video capture device e.g. "DFK 21F04".
  	@retval IC_SUCCESS on success.
  	@retval IC_ERROR on errors.
  	@sa IC_CloseVideoCaptureDevice
  
  	@code
  	#include "tisgrabber.h"
  	void main()
  	
  		TGRABBER* hGrabb ;
  		if( IC_InitLibrary(0) == IC_SUCCESS )
  		
  			hGrabb  = IC_CreateGrabber();
  			if( hGrabb  )
  			
  				if( IC_OpenVideoCaptureDevice(hGrabb ,"DFK 21F04") == IC_SUCCESS )
  				
  
  				// .. do something with the video capture device.
  
  				// Now clean up.
  				IC_CloseVideoCaptureDevice( hGrabb  );
  				IC_ReleaseGrabber( hGrabb  );
  			
  			IC_CloseLibrary();
  		
  	
  	@endcode

  int AC IC_OpenVideoCaptureDevice( HGRABBER hGrabb , char *szDeviceName ); ///< Opens a video capture device.
  }
  function IC_OpenVideoCaptureDevice( hGrabb :HGRABBER; szDeviceName:Pchar):longint;stdcall;external External_library name 'IC_OpenVideoCaptureDevice';

  {/< Opens a video capture device. }
  {//////////////////////////////////////////////////////////////////////// }
  {! Close the current video capture device. The TGRABBER* object will not be deleted.
  	It can be used again for opening another video capture device.
  	@param hGrabb  The handle to the grabber object.

  void AC IC_CloseVideoCaptureDevice( HGRABBER hGrabb  ); ///<Closes a video capture device.
  }
  procedure IC_CloseVideoCaptureDevice( hGrabb :HGRABBER);stdcall;external External_library name 'IC_CloseVideoCaptureDevice';

  {/<Closes a video capture device. }
  {//////////////////////////////////////////////////////////////////////// }
  {! Retrieve the name of the current video capture device. If the device is
  	invalid, NULL is returned.
  	@param hGrabb  The handle to the grabber object.
  	@retval char* The name of the video capture device
  	@retval NULL  If no video capture device is currently opened.
   }
  function IC_GetDeviceName( hGrabb :TGRABBER):Pchar;stdcall;external External_library name 'IC_GetDeviceName';

  {/<Returns the name of the current video capture device. }
  function IC_GetVideoFormatWidth( hGrabb :HGRABBER):longint;stdcall;external External_library name 'IC_GetVideoFormatWidth';

  {/<Returns the width of the video format. }
  function IC_GetVideoFormatHeight( hGrabb :HGRABBER):longint;stdcall;external External_library name 'IC_GetVideoFormatHeight';

  {/<returns the height of the video format. }
  {//////////////////////////////////////////////////////////////////////// }
  {! Set the sink type. A sink type must be set before images can be snapped.
  	The sink type basically describes the format of the buffer where the snapped 
  	images are stored. 
  
  	Possible values for format are:
  	@li Y800	
  	@li RGB24
  	@li RGB32
  	@li UYVY
  
  	The sink type may differ from the currently set video format.
  
  	@param hGrabb  The handle to the grabber object.
  	@param format The desired color format. Possible values for format are:
  		@li Y800	
  		@li RGB24
  		@li RGB32
  		@li UYVY
  	@retval IC_SUCCESS on success
  	@retval IC_ERROR if something went wrong.
  
  	@note Please note that UYVY can only be used in conjunction with a UYVY video format.
  
  
   }
  function IC_SetFormat( hGrabb :HGRABBER; format:COLORFORMAT):longint;stdcall;external External_library name 'IC_SetFormat';

  {/< Sets the color format of the sink.  }
  {//////////////////////////////////////////////////////////////////////// }
  {! Retrieves the format of the sink type currently set (See IC_SetFormat()
  	for possible formats). If no sink type is set
  	or an error occurred, NONE is returned.
  	The function returns a valid value only after IC_PreprareLive() or IC_StartLive()
  	was called. Before these calls, NONE is returned.
  	@param hGrabb  The handle to the grabber object.
  	@return The current sink color format.
   }
  function IC_GetFormat( hGrabb :HGRABBER):COLORFORMAT;stdcall;external External_library name 'IC_GetFormat';

  {/<Returns the current color format of the sink. }
  {//////////////////////////////////////////////////////////////////////// }
  {! Set a video format for the current video capture device. The video format
      must be supported by the current video capture device.
  	@param hGrabb  The handle to the grabber object.
  	@param szFormat A string that contains the desired video format.
  	@retval IC_SUCCESS on success
  	@retval IC_ERROR if something went wrong.
  
  	@code
  	#include "tisgrabber.h"
  	void main()
  	
  		HGRABBER* hGrabb ;
  		if( IC_InitLibrary(0) == IC_SUCCESS )
  		
  			hGrabb  = IC_CreateGrabber();
  			if( hGrabb  )
  			
  				if( IC_OpenVideoCaptureDevice(hGrabb ,"DFK 21F04") == IC_SUCCESS )
  				
  					if( IC_SetVideoFormat(hGrabb ,"UYVY (640x480)" == IC_SUCCESS )
  					
  						// .. do something with the video capture device.
  					
  					// Now clean up.
  					IC_CloseVideoCaptureDevice( hGrabb  );
  					IC_ReleaseGrabber( hGrabb  );
  				
  				IC_CloseLibrary();
  			
  		
  	
  	@endcode
   }
  function IC_SetVideoFormat( hGrabb :HGRABBER; szFormat:Pchar):longint;stdcall;external External_library name 'IC_SetVideoFormat';

  {/<Sets the video format. }
  {//////////////////////////////////////////////////////////////////////// }
  {! Set a video norm for the current video capture device.
  	@note  The current video capture device must support video norms. 
  	@param hGrabb  The handle to the grabber object.
  	@param szNorm A string that contains the desired video format.
  	@retval IC_SUCCESS on success
  	@retval IC_ERROR if something went wrong.
   }
  function IC_SetVideoNorm( hGrabb :HGRABBER; szNorm:Pchar):longint;stdcall;external External_library name 'IC_SetVideoNorm';

  {/<Set the video norm. }
  {//////////////////////////////////////////////////////////////////////// }
  {! Set a input channel for the current video capture device. 
  	@note  The current video capture device must support input channels.. 
  	@param hGrabb  The handle to the grabber object.
  	@param szChannel A string that contains the desired video format.
  	@retval IC_SUCCESS on success
  	@retval IC_ERROR if something went wrong.
   }
  function IC_SetInputChannel( hGrabb :HGRABBER; szChannel:Pchar):longint;stdcall;external External_library name 'IC_SetInputChannel';

  {/<Sets an input channel. }
  {//////////////////////////////////////////////////////////////////////// }
  {! Start the live video. 
  	@param hGrabb  The handle to the grabber object.
  	@param iShow The parameter indicates:   @li 1 : Show the video	@li 0 : Do not show the video, but deliver frames. (For callbacks etc.)
  	@retval IC_SUCCESS on success
  	@retval IC_ERROR if something went wrong.
  	@sa IC_StopLive
   }
  function IC_StartLive( hGrabb :HGRABBER; iShow:longint):longint;stdcall;external External_library name 'IC_StartLive';

  {/<Starts the live video. }
  function IC_PrepareLive( hGrabb :HGRABBER; iShow:longint):longint;stdcall;external External_library name 'IC_PrepareLive';

  {/<Prepare the grabber for starting the live video. }
  function IC_SuspendLive( hGrabb :HGRABBER):longint;stdcall;external External_library name 'IC_SuspendLive';

  {/<Suspends an image stream and puts it into prepared state.  }
  {//////////////////////////////////////////////////////////////////////// }
  {! Check, whether the passed grabber already provides are live video
  	@param hGrabb  The handle to the grabber object.
  	@retval 1 : Livevideo is running, 0 : Livevideo is not running.
  	@retval IC_NO_HANDLE   hGrabb  is not a valid handle. GeHGRABBER was not called.
  	@retval IC_NO_DEVICE   No device opened. Open a device, before this function can be used.
  
   }
  function IC_IsLive( hGrabb :HGRABBER):longint;stdcall;external External_library name 'IC_IsLive';

  {//////////////////////////////////////////////////////////////////////// }
  {! Stop the live video.
  	@param hGrabb  The handle to the grabber object.
  	@sa IC_StartLive
   }
  procedure IC_StopLive( hGrabb :HGRABBER);stdcall;external External_library name 'IC_StopLive';

  {/<Stops the live video. }
  {//////////////////////////////////////////////////////////////////////// }
  {! Check, whether a property is supported by the current video capture device.
  	@param hGrabb  The handle to the grabber object.
  	@sa eProperty The cammera property to be checked
  	@retval IC_SUCCESS	The property is supported.
  	@retval IC_ERROR	The property is not supported.
  	@retval IC_NO_HANDLE   hGrabb  is not a valid handle. GeHGRABBER was not called.
  	@retval IC_NO_DEVICE   No device opened. Open a device, before this function can be used.
  
   }
  function IC_IsCameraPropertyAvailable( hGrabb :HGRABBER; eProperty:CAMERA_PROPERTY):longint;stdcall;external External_library name 'IC_IsCameraPropertyAvailable';

  {/< Check whether a camera property is available. }
  {//////////////////////////////////////////////////////////////////////// }
  {! Set a camera property like exposure, zoom.
  	
  	@param hGrabb  The handle to the grabber object.
  	@param eProperty The property to be set. It can have following values:
  		@li PROP_CAM_PAN	
  		@li PROP_CAM_TILT,
  		@li PROP_CAM_ROLL,
  		@li PROP_CAM_ZOOM,
  		@li PROP_CAM_EXPOSURE,
  		@li PROP_CAM_IRIS,
  		@li PROP_CAM_FOCUS
  	@param lValue The value the property is to be set to.
  	@retval IC_SUCCESS on success
  	@retval IC_ERROR if something went wrong.
  
  	@note  lValue should be in the range of the specified property.
  	If the value could not be set (out of range, auto is currently enabled), the
  	function returns 0. On success, the functions returns 1.
   }
  function IC_SetCameraProperty( hGrabb :HGRABBER; eProperty:CAMERA_PROPERTY; lValue:longint):longint;stdcall;external External_library name 'IC_SetCameraProperty';

  {/< Set a camera property. }
  function IC_CameraPropertyGetRange( hGrabb :HGRABBER; eProperty:CAMERA_PROPERTY; var lMin:longint; var lMax:longint):longint;stdcall;external External_library name 'IC_CameraPropertyGetRange';

  {/<Get the minimum and maximum value of a camera property }
  function IC_GetCameraProperty( hGrabb :HGRABBER; eProperty:CAMERA_PROPERTY; var lValue:longint):longint;stdcall;external External_library name 'IC_GetCameraProperty';

  {/< Get a camera property's value. }
  {//////////////////////////////////////////////////////////////////////// }
  {! Enable or disable automatic for a camera property. 
  	@param hGrabb  The handle to the grabber object.
  	@param iProperty  The property to be set. It can have following values:
  	@li PROP_CAM_PAN	
  	@li PROP_CAM_TILT,
  	@li PROP_CAM_ROLL,
  	@li PROP_CAM_ZOOM,
  	@li PROP_CAM_EXPOSURE,
  	@li PROP_CAM_IRIS,
  	@li PROP_CAM_FOCUS
  	@param iOnOFF Enables or disables the automation. Possible values ar
  	@li 1 : Enable automatic
  	@li 0 : Disable Automatic
  	@retval IC_SUCCESS on success
  	@retval IC_ERROR if something went wrong.
  
  	@note If the property is not supported by the current video capture device or
  	automation of the property is not available with the current video capture
  	device, the function returns 0. On success, the function returns 1.
   }
  function IC_EnableAutoCameraProperty( hGrabb :HGRABBER; iProperty:longint; iOnOff:longint):longint;stdcall;external External_library name 'IC_EnableAutoCameraProperty';

  {/<Enables or disables property automation. }
  function IC_IsCameraPropertyAutoAvailable( hGrabb :HGRABBER; iProperty:CAMERA_PROPERTY):longint;stdcall;external External_library name 'IC_IsCameraPropertyAutoAvailable';

  {/<Check whether automation for a camera property is available. }
  function IC_GetAutoCameraProperty( hGrabb :HGRABBER; iProperty:longint; var iOnOff:longint):longint;stdcall;external External_library name 'IC_GetAutoCameraProperty';

  {/<Retrieve whether automatic is enabled for the specifield camera property. }
  function IC_IsVideoPropertyAvailable( hGrabb :HGRABBER; eProperty:VIDEO_PROPERTY):longint;stdcall;external External_library name 'IC_IsVideoPropertyAvailable';

  {/<Check whether the specified video property is available.  }
  function IC_VideoPropertyGetRange( hGrabb :HGRABBER; eProperty:VIDEO_PROPERTY; var lMin:longint; var lMax:longint):longint;stdcall;external External_library name 'IC_VideoPropertyGetRange';

  {/<Retrieve the lower and upper limit of a video property. }
  function IC_GetVideoProperty( hGrabb :HGRABBER; eProperty:VIDEO_PROPERTY; var lValue:longint):longint;stdcall;external External_library name 'IC_GetVideoProperty';

  {/< Retrieve the the current value of the specified video property. }
  function IC_IsVideoPropertyAutoAvailable( hGrabb :HGRABBER; eProperty:VIDEO_PROPERTY):longint;stdcall;external External_library name 'IC_IsVideoPropertyAutoAvailable';

  {/<Check whether the specified video property supports automation. }
  function IC_GetAutoVideoProperty( hGrabb :HGRABBER; iProperty:longint; var iOnOff:longint):longint;stdcall;external External_library name 'IC_GetAutoVideoProperty';

  {/<Get the automation state of a video property. }
  {//////////////////////////////////////////////////////////////////////// }
  {! Set a video property like brightness, contrast.
  
  	@param hGrabb  The handle to the grabber object.
  	@param eProperty The property to be set. It can have following values:
  	@li PROP_VID_BRIGHTNESS ,
  	@li PROP_VID_CONTRAST,
  	@li PROP_VID_HUE,
  	@li PROP_VID_SATURATION,
  	@li PROP_VID_SHARPNESS,
  	@li PROP_VID_GAMMA,
  	@li PROP_VID_COLORENABLE,
  	@li PROP_VID_WHITEBALANCE,
  	@li PROP_VID_BLACKLIGHTCOMPENSATION,
  	@li PROP_VID_GAIN
  	@param lValue The value the property is to be set to.
  	@retval IC_SUCCESS on success
  	@retval IC_ERROR if something went wrong.
  
      @note lValue should be in the range of the specified property.
  	If the value could not be set (out of range, auto is currently enabled), the
  	function returns 0. On success, the functions returns 1.
   }
  function IC_SetVideoProperty( hGrabb :HGRABBER; eProperty:VIDEO_PROPERTY; lValue:longint):longint;stdcall;external External_library name 'IC_SetVideoProperty';

  {/<Set a video property. }
  {//////////////////////////////////////////////////////////////////////// }
  {! Enable or disable automatic for a video propertery.
  	@param hGrabb  The handle to the grabber object.
  	@param iProperty The property to be set. It can have following values:
  	@li PROP_VID_BRIGHTNESS,
  	@li PROP_VID_CONTRAST,
  	@li PROP_VID_HUE,
  	@li PROP_VID_SATURATION,
  	@li PROP_VID_SHARPNESS,
  	@li PROP_VID_GAMMA,
  	@li PROP_VID_COLORENABLE,
  	@li PROP_VID_WHITEBALANCE,
  	@li PROP_VID_BLACKLIGHTCOMPENSATION,
  	@li PROP_VID_GAIN
  	@param iOnOFF Enables or disables the automation. Possible values ar
  	@li 1 : Enable automatic
  	@li 0 : Disable Automatic
  	@retval IC_SUCCESS on success
  	@retval IC_ERROR if something went wrong.
  
      @note If the property is not supported by the current video capture device or
  	automation of the property is not available with the current video capture
  	device, the function reurns 0. On success, the function returns 1.
   }
  function IC_EnableAutoVideoProperty( hGrabb :HGRABBER; iProperty:longint; iOnOff:longint):longint;stdcall;external External_library name 'IC_EnableAutoVideoProperty';

  {/< Switch automatition for a video property, }
  {//////////////////////////////////////////////////////////////////////// }
  {! Retrieve the properties of the current video format and sink type 
  	@param hGrabb  The handle to the grabber object.
  	@param *lWidth  This recieves the width of the image buffer.
  	@param *lHeight  This recieves the height of the image buffer.
  	@param *iBitsPerPixel  This recieves the count of bits per pixel.
  	@param *format  This recieves the current color format.
  	@retval IC_SUCCESS on success
  	@retval IC_ERROR if something went wrong.
   }
  function IC_GetImageDescription( hGrabb :HGRABBER; var lWidth:longint; var lHeight:longint; var iBitsPerPixel:longint; var format:COLORFORMAT):longint;stdcall;external External_library name 'IC_GetImageDescription';

  {/<Retrieve the properties of the current video format and sink typ. }
  {//////////////////////////////////////////////////////////////////////// }
  {! Snaps an image. The video capture device must be set to live mode and a 
  	sink type has to be set before this call. The format of the snapped images depend on
  	the selected sink type. 
  
  	@param hGrabb  The handle to the grabber object.
  	@param iTimeOutMillisek The Timeout time is passed in milli seconds. A value of -1 indicates, that
  							no time out is set.
  
  	
  	@retval IC_SUCCESS if an image has been snapped
  	@retval IC_ERROR if something went wrong.
  	@retval IC_NOT_IN_LIVEMODE if the live video has not been started.
  
  	@sa IC_StartLive 
  	@sa IC_SetFormat
  
   }
  function IC_SnapImage( hGrabb :HGRABBER; iTimeOutMillisek:longint):longint;stdcall;external External_library name 'IC_SnapImage';

  {/<Snaps an image from the live stream.  }
  {//////////////////////////////////////////////////////////////////////// }
  {! Save the contents of the last snapped image by IC_SnapImage into a file. 
  	@param hGrabb  The handle to the grabber object.
  	@param szFileName String containing the file name to be saved to.
  	@param ft File type if the image, It have be
  		@li FILETYPE_BMP for bitmap files
  		@li FILETYPE_JPEG for JPEG file.
  	@param quality If the JPEG format is used, the image quality must be specified in a range from 0 to 100.
  	@retval IC_SUCCESS if an image has been snapped
  	@retval IC_ERROR if something went wrong.
  
  	@remarks
  	The format of the saved images depend on the sink type. If the sink type 
  	is set to Y800, the saved image will be an 8 Bit grayscale image. In any
  	other case the saved image will be a 24 Bit RGB image.
  
  	@note IC Imaging Control 1.41 only supports FILETYPE_BMP.
  	@sa IC_SnapImage
  	@sa IC_SetFormat
   }
  function IC_SaveImage( hGrabb :HGRABBER; szFileName:Pchar; ft:IMG_FILETYPE; quality:longint):longint;stdcall;external External_library name 'IC_SaveImage';

  {/< Saves an image to a file. }
  {//////////////////////////////////////////////////////////////////////// }
  {! Retrieve a byte pointer to the image data (pixel data) of the last snapped
  	image (see SnapImage()). If the function fails, the return value is NULL
  	otherwise the value is a pointer to the first byte in the lowest image line
  	(the image is saved bottom up!).
  	@param hGrabb  The handle to the grabber object.
  	@retval Nonnull Pointer to the image data
  	@retval NULL Indicates that an error occurred.
  	@sa IC_SnapImage
  	@sa IC_SetFormat
   }
  function IC_GetImagePtr( hGrabb :HGRABBER):Pbyte;stdcall;external External_library name 'IC_GetImagePtr';

  {/< Retuns a pointer to the image data }
  {//////////////////////////////////////////////////////////////////////// }
  {! Assign an Window handle to display the video in.
  	@param hGrabb  The handle to the grabber object.
  	@param hWnd The handle of the window where to display the live video in.
  	@retval IC_SUCCESS if an image has been snapped
  	@retval IC_ERROR if something went wrong.

  int AC IC_SetHWnd( HGRABBER hGrabb , __HWND hWnd ); ///< Sets a window handle for live display
  }
  function IC_SetHWnd({var} hGrabb :HGRABBER; hWnd:HWND):longint;stdcall;external External_library name 'IC_SetHWnd';

  {/< Sets a window handle for live display }
  {//////////////////////////////////////////////////////////////////////// }
  {! Return the serialnumber of the current device. Memory for the serialnumber
      must has been allocated by the application:
  
  	@code
  	char szSerial[20];
  	GetSerialNumber( hGrabb , szSerial );
  	@endcode
  
  	This function decodes the The Imaging Source serialnumbers.
  	@param hGrabb  The handle to the grabber object.
  	@param szSerial char array that recieves the serial number.
  	@retval IC_SUCCESS The serial number could be retrieved.
  	@retval IC_IC_NOT_AVAILABLE The video capture device does not provide a serial number.
  	@retval IC_NO_DEVICE No video capture device opened-
  	@retval IC_NO_HANDLE hGrabb  is NULL.
   }
  function IC_GetSerialNumber({var} hGrabb :HGRABBER; szSerial:Pchar):longint;stdcall;external External_library name 'IC_GetSerialNumber';

  {/<Return the video capture device's serial number. }
  {//////////////////////////////////////////////////////////////////////// }
  {! Count all connected video capture devices. If the Parameter szDeviceList
      is NULL, only the number of devices is queried. The Parameter szDeviceList
  	must be a two dimensional array of char. The iSize parameter specifies the
  	length of the strings, that are used in the array.
  	
  	@param szDeviceList A two dimensional char array that recieves the list. Or NULL if only the count of devices is to be returned.
  	@param iSize Not used.
  	@retval >= 0 Success, count of found devices
  	@retval <0 An error occurred.
  	
  	Simple sample to list the video capture devices:
  	@code
      char szDeviceList[20][40];
  	int iDeviceCount;
  
  	iDeviceCount = IC_ListDevices( (char*)szDeviceList,40 );
  	for( i = 0; i < iDeviceCount; i++ )
  	
  		printf("%2d. %s\n",i+1,szDeviceList[i]);
  	
  	@endcode
   }
  function IC_ListDevices(szDeviceList:Pchar; iSize:longint):longint;stdcall;external External_library name 'IC_ListDevices';

  {/< Count and list devices. }
  {//////////////////////////////////////////////////////////////////////// }
  {! Simpler approach of enumerating devices. No 2D char array needed
  
  	@code
      char szDeviceName[40]; // Use max 39 chars for a device name
  	int iDeviceCount;
  
  	iDeviceCount = IC_GetDeviceCount(); // Query number of connected devices
  	for( i = 0; i < iDeviceCount; i++ )
  	
  		IC_ListDevicesbyIndex(szDeviceName,39, i);
  		printf("%2d. %s\n",i+1,szDeviceName);
  	
  	@endcode
  	@param szDeviceName Char memory, that receives the device name
  	@param iSize Size of the char memory. If names are longer, they will be truncated.
  	@param DeviceIndex Index of the device to be query. Must be between 0 and IC_GetDeviceCount.
  
  	@retval >= 0 Success, count of found devices
  	@retval <0 An error occurred.
  
   }
  function IC_ListDevicesbyIndex(szDeviceName:Pchar; iSize:longint; DeviceIndex:longint):longint;stdcall;external External_library name 'IC_ListDevicesbyIndex';

  {//////////////////////////////////////////////////////////////////////// }
  {! Count all available video formats. If the Parameter szFormatList
      is NULL, only the number of formats is queried. The Parameter szFormatList
  	must be a two dimensional array of char. The iSize parameter specifies the
  	length of the strings, that are used in the array to store the format names.
  
  	@param hGrabb  The handle to the grabber object.
  	@param szFormatList A two dimensional char array that recieves the list. Or NULL if only the count of formats is to be returned.
  
  	@retval >= 0 Success, count of found video formats
  	@retval <0 An error occurred.
  	
  	Simple sample to list the video capture devices:
  	@code
      char szFormatList[80][40];
  	int iFormatCount;
  	HGRABBER* hGrabb ;
  	hGrabb  = IC_CreateGrabber();
  	IC_OpenVideoCaptureDevice(hGrabb , "DFK 21F04" );
  	iFormatCount = IC_ListDevices(hGrabb , (char*)szFormatList,40 );
  	for( i = 0; i < min( iFormatCount, 80); i++ )
  	
  		printf("%2d. %s\n",i+1,szFormatList[i]);
  	
  	IC_ReleaseGrabber( hGrabb  );
  	@endcode
   }
  function IC_ListVideoFormats( hGrabb :HGRABBER; szFormatList:Pchar; iSize:longint):longint;stdcall;external External_library name 'IC_ListVideoFormats';

  {/<List available video formats. }
  {//////////////////////////////////////////////////////////////////////// }
  {! Simpler approach of enumerating video formats. No 2D char array needed.
  
  	@param hGrabb  The handle to the grabber object.
  	@param szFormatName char memory, that will receive the name of the video format. Should be big enough.
  	@param iSize Size in byte of szFormatName
  	@iIndex Index of the video format to query.
  
  	@code
      char szVideoFormatName[40]; // Use max 39 chars for a video format name
  	int FormatCount;
  	HGRABBER* hGrabb ;
  	hGrabb  = IC_CreateGrabber();
  	IC_OpenVideoCaptureDevice(hGrabb , "DFK 21AU04" );
  	FormatCount = IC_GetVideoFormatCount(hGrabb ); // Query number of connected devices
  	for( i = 0; i < FormatCount; i++ )
  	
  		IC_ListVideoFormatbyIndex(szVideoFormatName,39, i);
  		printf("%2d. %s\n",i+1,szVideoFormatName);
  	
  	@endcode
  	@param szDeviceName Char memory, that receives the device name
  	@param iSize Size of the char memory. If names are longer, they will be truncated.
  	@param DeviceIndex Index of the device to be query. Must be between 0 and IC_GetDeviceCount.
  
  	@retval IC_SUCCESS Success,
  	@retval IC_NO_DEVICE No video capture device selected.
  	@retval IC_NO_HANDLE No handle to the grabber object.
  
   }
  function IC_ListVideoFormatbyIndex( hGrabb :HGRABBER; szFormatName:Pchar; iSize:longint; iIndex:longint):longint;stdcall;external External_library name 'IC_ListVideoFormatbyIndex';

  {//////////////////////////////////////////////////////////////////////// }
  {! Get the number of the currently available devices. This function creates an
  	internal array of all connected video capture devices. With each call to this 
  	function, this array is rebuild. The name and the unique name can be retrieved 
  	from the internal array using the functions IC_GetDevice() and IC_GetUniqueNamefromList.
  	They are usefull for retrieving device names for opening devices.
  	
  	@retval >= 0 Success, count of found devices.
  	@retval IC_NO_HANDLE Internal Error.
  
  	@sa IC_GetDevice
  	@sa IC_GetUniqueNamefromList
   }
  function IC_GetDeviceCount:longint;stdcall;external External_library name 'IC_GetDeviceCount';

  {/<Get the number of the currently available devices.  }
  {//////////////////////////////////////////////////////////////////////// }
  {! Get a string representation of a device specified by iIndex. iIndex 
  	must be between 0 and IC_GetDeviceCount(). IC_GetDeviceCount() must 
  	have been called before this function, otherwise it will always fail.
  	
  	@param iIndex The number of the device whose name is to be returned. It must be
  				  in the range from 0 to IC_GetDeviceCount(),
      @return Returns the string representation of the device on success, NULL
  			otherwise.
  
  	@sa IC_GetDeviceCount
  	@sa IC_GetUniqueNamefromList
   }
  function IC_GetDevice(iIndex:longint):Pchar;stdcall;external External_library name 'IC_GetDevice';

  {/< Get the name of a video capture device. }
  {//////////////////////////////////////////////////////////////////////// }
  {! Get unique device name of a device specified by iIndex. The unique device name
  	consist from the device name and its serial number. It allows to differ between 
  	more then one device of the same type connected to the computer. The unique device name
  	is passed to the function IC_OpenDevByUniqueName
  
  	@param iIndex The number of the device whose name is to be returned. It must be
  				in the range from 0 to IC_GetDeviceCount(),
  	@return Returns the string representation of the device on success, NULL
  				otherwise.
  
  	@sa IC_GetDeviceCount
  	@sa IC_GetUniqueNamefromList
  	@sa IC_OpenDevByUniqueName
   }
  function IC_GetUniqueNamefromList(iIndex:longint):Pchar;stdcall;external External_library name 'IC_GetUniqueNamefromList';

  {/< Get the unique name of a video capture device. }
  {//////////////////////////////////////////////////////////////////////// }
  {! Get the number of the available input channels for the current device.
      A video	capture device must have been opened before this call.
  
  	@param hGrabb  The handle to the grabber object.
  
  	@retval >= 0 Success
  	@retval IC_NO_DEVICE No video capture device selected.
  	@retval IC_NO_HANDLE No handle to the grabber object.
  
  	@sa IC_GetInputChannel
   }
  function IC_GetInputChannelCount( hGrabb :HGRABBER):longint;stdcall;external External_library name 'IC_GetInputChannelCount';

  {/<Get the number of the available input channels. }
  {//////////////////////////////////////////////////////////////////////// }
  {! Get a string representation of the input channel specified by iIndex. 
  	iIndex must be between 0 and IC_GetInputChannelCount().
  	IC_GetInputChannelCount() must have been called before this function,
  	otherwise it will always fail.		
  	@param hGrabb  The handle to the grabber object.
  	@param iIndex Number of the input channel to be used..
  
  	@retval Nonnull The name of the specified input channel
  	@retval NULL An error occured.
  	@sa IC_GetInputChannelCount
   }
  function IC_GetInputChannel( hGrabb :HGRABBER; iIndex:longint):Pchar;stdcall;external External_library name 'IC_GetInputChannel';

  {/<Get the name of an input channel. }
  {//////////////////////////////////////////////////////////////////////// }
  {! Get the number of the available video norms for the current device. 
  	A video capture device must have been opened before this call.
  	
  	@param hGrabb  The handle to the grabber object.
  
  	@retval >= 0 Success
  	@retval IC_NO_DEVICE No video capture device selected.
  	@retval IC_NO_HANDLE No handle to the grabber object.
  	
  	@sa IC_GetVideoNorm
   }
  function IC_GetVideoNormCount( hGrabb :HGRABBER):longint;stdcall;external External_library name 'IC_GetVideoNormCount';

  {/<Get the count of available video norms. }
  {//////////////////////////////////////////////////////////////////////// }
  {! Get a string representation of the video norm specified by iIndex. 
  	iIndex must be between 0 and IC_GetVideoNormCount().
  	IC_GetVideoNormCount() must have been called before this function,
  	otherwise it will always fail.		
  	
  	@param hGrabb  The handle to the grabber object.
  	@param iIndex Number of the video norm to be used.
  
  	@retval Nonnull The name of the specified video norm.
  	@retval NULL An error occured.
  	@sa IC_GetVideoNormCount
  
   }
  function IC_GetVideoNorm( hGrabb :HGRABBER; iIndex:longint):Pchar;stdcall;external External_library name 'IC_GetVideoNorm';

  {/<Get the name of a video norm. }
  {//////////////////////////////////////////////////////////////////////// }
  {! Get the number of the available video formats for the current device. 
  	A video capture device must have been opened before this call.
  	
  	@param hGrabb  The handle to the grabber object.
  
  	@retval >= 0 Success
  	@retval IC_NO_DEVICE No video capture device selected.
  	@retval IC_NO_HANDLE No handle to the grabber object.
  
  	@sa IC_GetVideoFormat
   }
  function IC_GetVideoFormatCount( hGrabb :HGRABBER):longint;stdcall;external External_library name 'IC_GetVideoFormatCount';

  {/< Returns the count of available video formats. }
  {//////////////////////////////////////////////////////////////////////// }
  {! Get a string representation of the video format specified by iIndex. 
  	iIndex must be between 0 and IC_GetVideoFormatCount().
  	IC_GetVideoFormatCount() must have been called before this function,
  	otherwise it will always fail.	
  
  	@param hGrabb  The handle to the grabber object.
  	@param iIndex Number of the video format to be used.
  
  	@retval Nonnull The name of the specified video format.
  	@retval NULL An error occured.
  	@sa IC_GetVideoFormatCount
   }
  function IC_GetVideoFormat( hGrabb :HGRABBER; iIndex:longint):Pchar;stdcall;external External_library name 'IC_GetVideoFormat';

  {/<Return the name of a video format. }
  {//////////////////////////////////////////////////////////////////////// }
  {! Save the state of a video capture device to a file. 
  	
  	@param hGrabb  The handle to the grabber object.
  	@param szFileName Name of the file where to save to.
  
  	@retval IC_SUCCESS if an image has been snapped
  	@retval IC_ERROR if something went wrong.
  
  	@sa IC_LoadDeviceStateFromFile
   }
  function IC_SaveDeviceStateToFile( hGrabb :HGRABBER; szFileName:Pchar):longint;stdcall;external External_library name 'IC_SaveDeviceStateToFile';

  {/<Save the state of a video capture device to a file.  }
  {//////////////////////////////////////////////////////////////////////// }
  {! Load a device settings file. On success the device is opened automatically.
  
  	@param hGrabb  The handle to the grabber object. If it is NULL then a new HGRABBER* handle is
  					created. This should be released by a call to IC_ReleaseGrabber when it is no longer needed.
  	@param szFileName Name of the file where to save to.
  
  	@return HGRABBER* The handle of the grabber object, that contains the new opened video capture device.
  
  	@sa IC_SaveDeviceStateToFile
  	@sa IC_ReleaseGrabber
   }
  function IC_LoadDeviceStateFromFile( hGrabb :HGRABBER; szFileName:Pchar):PHGRABBER;stdcall;external External_library name 'IC_LoadDeviceStateFromFile';

  {/<Load a device settings file. }
  {//////////////////////////////////////////////////////////////////////// }
  {! Load a device settings file. 
  
  	@param hGrabb  The handle to the grabber object. If it is NULL then a new HGRABBER* handle is
  					created, in case OpenDevice is true. If OpenDevice is set to false, the a device must be already
  					open in the grabber handle. The properties in the passed XML file will be apllied to 
  					the opened device. 
  					This should be released by a call to IC_ReleaseGrabber when it is no longer needed.
  	@param szFileName Name of the file where to save to.
  	@param OpenDevice If 1, the device specified in the XML file is opened. If 0, then a device must be opened in the hGrabb .
  						The properties and video format specified in the XML file will be applied to the opened device.
  
  	@return IC_SUCCESS The device was successfully opened and the settings saved in the XML file were set.
  	@return IC_NO_DEVICE False was passed to OpenDevice, but no device was opened in the grabber handle or the handle is NULL
  	@return IC_WRONG_XML_FORMAT No device opened.
  	@return IC_WRONG_INCOMPATIBLE_XML No device opened.
  	@return IC_DEVICE_NOT_FOUND No device opened.
  	@return IC_FILE_NOT_FOUND Passed XML file does not exist.
  	@return IC_NOT_ALL_PROPERTIES_RESTORED The device was opened, but not all properties could be set as wanted.
  
  	@sa IC_SaveDeviceStateToFile
  	@sa IC_ReleaseGrabber
   }
  function IC_LoadDeviceStateFromFileEx( hGrabb :HGRABBER; szFileName:Pchar; OpenDevice:longint):longint;stdcall;external External_library name 'IC_LoadDeviceStateFromFileEx';

  {/<Load a device settings file. }
  {//////////////////////////////////////////////////////////////////////// }
  {! Save the device settings to a file specified by szFilename. When used 
  	with IC Imaging Control 1.41 the device name, the input channel, the 
  	video norm and the video format are saved. When used with IC Imaging 
  	Control 2.0, the VCDProperties are saved as well. Returns 1 on success,
  	0 otherwise.
  	Notice that in IC Imaging Control 1.41 the device name includes the trailing 
  	number if there is more than one device of the same type available. This can
  	cause IC_OpenDeviceBySettings() to fail if one of those devices is unplugged.
  	When used with IC Imaging Control 2.0, this cannot happen because the device 
  	name is stored without the trailing number. Instead the first device that 
  	matches the type specified in the settings file is opened.
  
  	@deprecated Use IC_SaveDeviceStateToFile instead.
  
   }
  function IC_SaveDeviceSettings( hGrabb :HGRABBER; szFilename:Pchar):longint;stdcall;external External_library name 'IC_SaveDeviceSettings';

  {//////////////////////////////////////////////////////////////////////// }
  {! Open a device by a settings file specified by szFilename. If succedeed,
  	1 is returned and a device specified in the settings file is opened and
  	initialized with the settings data. If failed, 0 is returned. 
  
  	@deprecated Use IC_LoadDeviceStateFromFile instead.
   }
  function IC_OpenDeviceBySettings( hGrabb :HGRABBER; szFilename:Pchar):longint;stdcall;external External_library name 'IC_OpenDeviceBySettings';

  {//////////////////////////////////////////////////////////////////////// }
  {! Load device settings from a file specified by szFilename. A device must 
  	have been opened before this function is called. A check is performed whether
  	the current device matches the device type stored in the settings file.
  	If so, the settings are loaded and set.
  	Returns 1 on success, 0 otherwise.
  	Notice: This function will only work with IC Imaging Control 2.0. When used
  	with IC Imaging Control 1.41, it will always return 0.
  
  	@deprecated Use IC_LoadDeviceStateFromFile instead.
   }
  function IC_LoadDeviceSettings( hGrabb :HGRABBER; szFilename:Pchar):longint;stdcall;external External_library name 'IC_LoadDeviceSettings';

  {//////////////////////////////////////////////////////////////////////// }
  {! Open a video capture by using its DisplayName. 
  	@param hGrabb  The handle to the grabber object.
  	@param szDisplayname Displayname of the device. Can be retrieved by a call to IC_GetDisplayName().
  
  	@retval IC_SUCCESS if an image has been snapped
  	@retval IC_ERROR if something went wrong.
  
  	@sa IC_GetDisplayName
   }
  function IC_OpenDevByDisplayName( hGrabb :HGRABBER; szDisplayname:Pchar):longint;stdcall;external External_library name 'IC_OpenDevByDisplayName';

  {/<Open a video capture by using its DisplayName.  }
  {//////////////////////////////////////////////////////////////////////// }
  {! Get a DisplayName from a currently open device. The display name of a
  	device can be another on different computer for the same video capture
  	device. 
  	
  	@param hGrabb        Handle to a grabber object
  	@param szDisplayName  Memory that will take the display name. If it is NULL, the
  						  length of the display name will be returned.
  	@param iLen           Size in Bytes of the memory allocated by szDisplayName.
  
  	
  	@retval IC_SUCCESS     On success. szDisplayName contains the display name of the device.
  	@retval IC_ERROR	   iLen is less than the length of the retrieved display name. 
  	@retval IC_NO_HANDLE   hGrabb  is not a valid handle. GeHGRABBER was not called.
  	@retval IC_NO_DEVICE   No device opened. Open a device, before this function can be used.
  	@retval >1             Length of the display name, if szDisplayName is NULL.
  
  	@sa IC_OpenDevByDisplayName
  	@sa IC_ReleaseGrabber
  
   }
  function IC_GetDisplayName( hGrabb :HGRABBER; szDisplayname:Pchar; iLen:longint):longint;stdcall;external External_library name 'IC_GetDisplayName';

  {/<Get the display name of a device. }
  {//////////////////////////////////////////////////////////////////////// }
  {! Open a video capture by using its UniqueName. Use IC_GetUniqueName() to
      retrieve the unique name of a camera.
  
  	@param hGrabb        Handle to a grabber object
  	@param szDisplayName  Memory that will take the display name.
  
  	@sa IC_GetUniqueName
  	@sa IC_ReleaseGrabber
  
   }
  function IC_OpenDevByUniqueName( hGrabb :HGRABBER; szDisplayname:Pchar):longint;stdcall;external External_library name 'IC_OpenDevByUniqueName';

  {//////////////////////////////////////////////////////////////////////// }
  {! Get a UniqueName from a currently open device.
  	
  	@param hGrabb       Handle to a grabber object
  	@param szUniqueName  Memory that will take the Unique name. If it is NULL, the
  						 length of the Unique name will be returned.
  	@param iLen          Size in Bytes of the memory allocated by szUniqueName.
  
  	
  	@retval IC_SUCCESS    On success. szUniqueName contains the Unique name of the device.
  	@retval IC_ERROR	  iLen is less than the length of the retrieved Unique name. 
  	@retval IC_NO_HANDLE  hGrabb  is not a valid handle. GeHGRABBER was not called.
  	@retval IC_NO_DEVICE  No device opened. Open a device, before this function can be used.
  	@retval >1            Length of the Unique name, if szUniqueName is NULL.
  	
   }
  function IC_GetUniqueName( hGrabb :HGRABBER; szUniquename:Pchar; iLen:longint):longint;stdcall;external External_library name 'IC_GetUniqueName';

  {/<Get a UniqueName from a currently open device. }
  {//////////////////////////////////////////////////////////////////////// }
  {! This returns 1, if a valid device has been opened, otherwise it is 0.
  
  	@param hGrabb       Handle to a grabber object.
  
  	@retval IC_ERROR There is no valid video capture device opened
  	@retval IC_SUCCESS There is a valid video capture device openend.
   }
  function IC_IsDevValid( hGrabb :HGRABBER):longint;stdcall;external External_library name 'IC_IsDevValid';

  {/<Returns whether a video capture device is valid. }
  {//////////////////////////////////////////////////////////////////////// }
  {! Show the VCDProperty dialog. 
  
  	@param hGrabb       Handle to a grabber object.
  	@retval IC_SUCCESS on success
  	@retval IC_ERROR on error.
  	@retval IC_NO_DEVICE No video capture device selected.
  	@retval IC_NO_HANDLE Nullpointer.
   }
  function IC_ShowPropertyDialog( hGrabb :HGRABBER):longint;stdcall;external External_library name 'IC_ShowPropertyDialog';

  {/<Show the VCDProperty dialog.  }
  {//////////////////////////////////////////////////////////////////////// }
  {! Show the device selection dialog. This dialogs enables to select the 
  	video capture device, the video norm, video format, input channel and
  	frame rate.
  
  	@param hGrabb       Handle to a grabber object.
  
  	@return The passed hGrabb  object or a new created if hGrabb  was NULL.
  
  	@code
      HGRABBER* hTheGrabber;
  	hTheGrabber = IC_ShowDeviceSelectionDialog( NULL );
  	if( hTheGrabber != NULL )
  	
  		IC_StartLive( hTheGrabber, 1 ); // Show the live video of this grabber
  		IC_ShowPropertyDialog( hTheGrabber );	// Show the property page of this grabber
  	
  	@endcode
   }
  function IC_ShowDeviceSelectionDialog( hGrabb :HGRABBER):PHGRABBER;stdcall;external External_library name 'IC_ShowDeviceSelectionDialog';

  {/<Show the device selection dialog. }
  {//////////////////////////////////////////////////////////////////////// }
  {!	
  	Return whether the current video capture device supports an external 
  	trigger. 
  
  	@param hGrabb       Handle to a grabber object.
  	@retval IC_SUCCESS An external trigger is supported
  	@retval IC_ERROR No external trigger is supported.
  	@retval IC_NO_DEVICE No video capture device selected.
  	@retval IC_NO_HANDLE Internal Grabber does not exist.
  
  	@sa IC_EnableTrigger
   }
  function IC_IsTriggerAvailable( hGrabb :HGRABBER):longint;stdcall;external External_library name 'IC_IsTriggerAvailable';

  {/<Check for external trigger support. }
  {//////////////////////////////////////////////////////////////////////// }
  {!	Enable or disable the external trigger. 
  	@param hGrabb       Handle to a grabber object.
  	@param iEnable 1 = enable the trigger, 0 = disable the trigger
  
  	@retval IC_SUCCESS    Trigger was enabled or disabled successfully.
  	@retval IC_NOT_AVAILABLE The device does not support triggering.
  	@retval IC_NO_PROPERTYSET Failed to query the property set of the device.
  	@retval IC_NO_DEVICE No video capture device selected.
  
  	@retval IC_NO_HANDLE Internal Grabber does not exist or hGrabb  is NULL.
  
  	@sa IC_IsTriggerAvailable
   }
  function IC_EnableTrigger( hGrabb :HGRABBER; iEnable:longint):longint;stdcall;external External_library name 'IC_EnableTrigger';

  {//////////////////////////////////////////////////////////////////////// }
  {!	Remove or insert the  the overlay bitmap to the grabber object. If
  	Y16 format is used, the overlay must be removed,
  
  	@param hGrabb       Handle to a grabber object.
  	@param iEnable = 1 inserts overlay, 0 removes the overlay.
   }
  procedure IC_RemoveOverlay( hGrabb :HGRABBER; iEnable:longint);stdcall;external External_library name 'IC_RemoveOverlay';

  {//////////////////////////////////////////////////////////////////////// }
  {!	Enable or disable the overlay bitmap on the live video
  	@param hGrabb       Handle to a grabber object.
  	@param iEnable = 1 enables the overlay, 0 disables the overlay.
   }
  procedure IC_EnableOverlay( hGrabb :HGRABBER; iEnable:longint);stdcall;external External_library name 'IC_EnableOverlay';

  {/<Enable or disable the overlay bitmap. }
  {//////////////////////////////////////////////////////////////////////// }
  {!  BeginPaint returns an HDC for GDI painting purposes (like TextOut() etc.)
  	When the paintings are finished, the function IC_EndPaint must be called.
  
  	@param hGrabb       Handle to a grabber object.
  
  	@return HDC The function returns not NULL, if the HDC could be retrieved. If the HDC 
  			could not be retrieved or an error has occured, the function returns 0.
  
  	Sample code:
  	@code
  	HDC hPaintDC;
  	hPaintDC = IC_BeginPaint(hGrabb );
  	if( hPaintDC != NULL )
  	
  	    TextOut( hPaintDC,10,10,"Text",4);
  	
  	IC_EndPaint(hGrabb )
  	@endcode
  
  	@sa IC_EndPaint
   }
  function IC_BeginPaint( hGrabb :HGRABBER):longint;stdcall;external External_library name 'IC_BeginPaint';

  {/< BeginPaint returns an HDC for GDI painting purposes. }
  {//////////////////////////////////////////////////////////////////////// }
  {!  The EndPaint functions must be called, after BeginPaint has been called,
      and the painting operations have been finished.
  	@param hGrabb       Handle to a grabber object.
  	@sa IC_BeginPaint
   }
  procedure IC_EndPaint( hGrabb :HGRABBER);stdcall;external External_library name 'IC_EndPaint';

  {/< End painting functions on the overlay bitmap. }
  {//////////////////////////////////////////////////////////////////////// }
  {! Display a windows messagebox.
  	@param szText Message text
  	@param zsTitle Title of the messagebox.
   }
  procedure IC_MsgBox(szText:Pchar; szTitle:Pchar);stdcall;external External_library name 'IC_MsgBox';

  {/<Display a windows messagebox. }
  {//////////////////////////////////////////////////////////////////////// }
  {! Type declaration for the frame ready callback function. 
  	@sa IC_SetFrameReadyCallback
  	@sa IC_SetCallbacks
  	@retval IC_SUCCESS Callback was set successfully
  	@retval IC_ERROR An error occurred, e.g. hGrabb  is NULL.
  
   }

  type

    FRAME_READY_CALLBACK = procedure ( hGrabb :HGRABBER; var pData:byte; frameNumber:dword; _para4:pointer);stdcall;
  {//////////////////////////////////////////////////////////////////////// }
  {! Type declaration for the device lost callback function. 
  	@sa IC_SetCallbacks
   }

    DEVICE_LOST_CALLBACK = procedure ( hGrabb :HGRABBER; _para2:pointer);stdcall;
  {//////////////////////////////////////////////////////////////////////// }
  {!	Enable frame ready callback.
  	@param hGrabb       Handle to a grabber object.
  	@param cb Callback function of type FRAME_READY_CALLBACK
  	@param x1_argument_in_void_userdata Pointer to some userdata.
  	
  	@retval IC_SUCCESS Callback was set successfully
  	@retval IC_ERROR An error occurred, e.g. hGrabb  is NULL.
  
  	@sa FRAME_READY_CALLBACK
  
   }

  function IC_SetFrameReadyCallback( hGrabb :HGRABBER; cb:FRAME_READY_CALLBACK; x1_argument_in_void_userdata:pointer):longint;stdcall;external External_library name 'IC_SetFrameReadyCallback';

  {!	Set callback function
  	@param hGrabb       Handle to a grabber object.
  	@param cb Callback function of type FRAME_READY_CALLBACK, can be NULL, if no callback is needed
  	@param dlcb Callback function of type DEVICE:LOST_CALLBACK, can be NULL, if no device lost handler is needed
  	@param x1_argument_in_void_userdata Pointer to some userdata.
  
  	@sa FRAME_READY_CALLBACK
   }
  function IC_SetCallbacks( hGrabb :HGRABBER; cb:FRAME_READY_CALLBACK; x1_argument_in_void_userdata:pointer; dlCB:DEVICE_LOST_CALLBACK; x2_argument_in_void_userdata:pointer):longint;stdcall;external External_library name 'IC_SetCallbacks';

  {/////////////////////////////////////////////////////////////////////// }
  {!	Set Continuous mode
   
   	In continuous mode, the callback is called for each frame,
   	so that there is no need to use IC_SnapImage etc.
   
  	@param hGrabb       Handle to a grabber object.
  	@param cont			0 : Snap continouos, 1 : do not automatically snap.
  
  	@retval IC_SUCCESS Success
  	@retval IC_NOT_IN_LIVEMODE The device is currently streaming, therefore setting continuous mode failed.
  	@retval IC_NO_HANDLE Internal Grabber does not exist or hGrabb  is NULL
  
  	@remarks
   	Not available in live mode.
   
    }
  function IC_SetContinuousMode( hGrabb :HGRABBER; cont:longint):longint;stdcall;external External_library name 'IC_SetContinuousMode';

  {/<Set Continuous mode. }
  {//////////////////////////////////////////////////////////////////////// }
  {! SignalDetected
  
  	Detects whether a video signal is available.
  
  	@param hGrabb       Handle to a grabber object.
  
  	@retval IC_SUCCESS   Signal detected
  	@retval IC_ERROR  No video signal detected
  	@retval IC_NO_HANDLE  Invalid grabber handle
  	@retval IC_NO_DEVICE    No video capture device opened
  	@retval IC_NOT_IN_LIVEMODE  No live mode, startlive was not called
   }
  function IC_SignalDetected( hGrabb :HGRABBER):longint;stdcall;external External_library name 'IC_SignalDetected';

  {/<Detects whether a video signal is available. }
  {//////////////////////////////////////////////////////////////////////// }
  {! Get trigger modes.
  	Simple sample to list the video capture devices:
  
  	@param hGrabb       Handle to a grabber object.
  	@param szModeList	Twodimensional array of char that will recieve the mode list.
  	@param iSze			Size of the array (first dimension)
  
  	@retval 0 : No trigger modes available
  	@retval >0 : Count of available trigger modes
  	@retval IC_NO_HANDLE  Invalid grabber handle
  	@retval IC_NO_DEVICE  No video capture device opened
  
  	@code
      char szModes[20][10];
  	int iModeCount;
  
  	iModeCount = IC_GetTriggerModes(hGrabb , (char*)szModes,20);
  	for( int i = 0; i < min( iModeCount, 20); i++ )
  	
  		printf("%2d. %s\n",i+1,szModes[i]);
  	
  	@endcode
   }
  function IC_GetTriggerModes( hGrabb :HGRABBER; szModeList:Pchar; iSize:longint):longint;stdcall;external External_library name 'IC_GetTriggerModes';

  {/<Get trigger modes. }
  {//////////////////////////////////////////////////////////////////////// }
  {!  Set the trigger mode.
  	Sets the mode that has been retrieved  by a call to IC_GetTriggerModes.
  
  	@param hGrabb 	Handle to a grabber object.
  	@param szMode	String containing the name of the mode.	
  
  	@retval IC_SUCCESS		Success.
  	@retval IC_NOT_AVAILABLE Triggermode is not supported by the current device.
  	@retval IC_ERROR		An error occurred
  	@retval IC_NO_HANDLE	Invalid grabber handle
  	@retval IC_NO_DEVICE    No video capture device opened
  
   }
  function IC_SetTriggerMode( hGrabb :HGRABBER; szMode:Pchar):longint;stdcall;external External_library name 'IC_SetTriggerMode';

  {/<Set the trigger mode. }
  {//////////////////////////////////////////////////////////////////////// }
  {! Set the trigger polarity
  	
  	Sample:
  	@code
  	IC_SetTriggerPolarity(hGrabb , 0);
  	@endcode
  	or
  	@code
  	IC_SetTriggerPolarity(hGrabb , 1);
  	@endcode
  	@param hGrabb 	Handle to a grabber object.
  	@param iPolarity 
  		@li 0 : Polarity on direction
  		@li 1 : Polarity the other direction
  
  	@retval IC SUCCESS : Polarity could be set successfully
  	@retval IC_NOT_AVAILABLE Triggerpolarity is not supported by the current device.
  	@retval IC_NO_HANDLE	Invalid grabber handle
  	@retval IC_NO_DEVICE    No video capture device opened
   }
  function IC_SetTriggerPolarity( hGrabb :HGRABBER; iPolarity:longint):longint;stdcall;external External_library name 'IC_SetTriggerPolarity';

  {/< Set the trigger polarity. }
  function IC_GetExpRegValRange( hGrabb :HGRABBER; var lMin:longint; var lMax:longint):longint;stdcall;external External_library name 'IC_GetExpRegValRange';

  {/< Retrieve exposure register values lower and upper limits. }
  function IC_GetExpRegVal( hGrabb :HGRABBER; var lValue:longint):longint;stdcall;external External_library name 'IC_GetExpRegVal';

  {/< Retrieve the current register value of exposure. }
  function IC_SetExpRegVal( hGrabb :HGRABBER; lValue:longint):longint;stdcall;external External_library name 'IC_SetExpRegVal';

  {/<Set a register value for exposure. }
  function IC_EnableExpRegValAuto( hGrabb :HGRABBER; iOnOff:longint):longint;stdcall;external External_library name 'IC_EnableExpRegValAuto';

  {/<Enable or disable automatic of exposure. }
  function IC_GetExpRegValAuto( hGrabb :HGRABBER; var iOnOff:longint):longint;stdcall;external External_library name 'IC_GetExpRegValAuto';

  {/<Check whether automatic exposure is enabled. }
  {//////////////////////////////////////////////////////////////////////// }
  {! Functions for the absolute values interface of exposure.
   }
  function IC_IsExpAbsValAvailable( hGrabb :HGRABBER):longint;stdcall;external External_library name 'IC_IsExpAbsValAvailable';

  function IC_GetExpAbsValRange( hGrabb :HGRABBER; var fMin:single; var fMax:single):longint;stdcall;external External_library name 'IC_GetExpAbsValRange';

  function IC_GetExpAbsVal( hGrabb :HGRABBER; var fValue:single):longint;stdcall;external External_library name 'IC_GetExpAbsVal';

  function IC_SetExpAbsVal( hGrabb :HGRABBER; fValue:single):longint;stdcall;external External_library name 'IC_SetExpAbsVal';

  {///////////////////////////////////////////////////////////////// }
  {! Gets the current value of Colorenhancement property
  	Sample:
  	@code
  	int OnOFF
  	IC_GetColorEnhancement(hGrabb , &OnOFF);
  	@endcode
  	@param hGrabb 	Handle to a grabber object.
  	@param OnOff 
  		@li 0 : Color enhancement is off
  		@li 1 : Color enhancement is on
  
  	@retval IC_SUCCESS : Success
  	@retval IC_NOT:AVAILABLE : The property is not supported by the current device
  	@retval IC_NO_HANDLE	Invalid grabber handle
  	@retval IC_NO_DEVICE    No video capture device opened
   }
  function IC_GetColorEnhancement( hGrabb :HGRABBER; var OnOff:longint):longint;stdcall;external External_library name 'IC_GetColorEnhancement';

  {///////////////////////////////////////////////////////////////// }
  {! Sets the  value of Colorenhancement property
  	Sample:
  	@code
  	int OnOFF = 1
  	IC_GetColorEnhancement(hGrabb , OnOFF);
  	@endcode
  	@param hGrabb 	Handle to a grabber object.
  	@param OnOff 
  		@li 0 : Color enhancement is off
  		@li 1 : Color enhancement is on
  
  	@retval IC_SUCCESS : Success
  	@retval IC_NOT:AVAILABLE : The property is not supported by the current device
  	@retval IC_NO_HANDLE	Invalid grabber handle
  	@retval IC_NO_DEVICE    No video capture device opened
   }
  function IC_SetColorEnhancement( hGrabb :HGRABBER; OnOff:longint):longint;stdcall;external External_library name 'IC_SetColorEnhancement';

  {///////////////////////////////////////////////////////////////// }
  {! Sends a software trigger to the camera. The camera must support
  	external trigger. The external trigger has to be enabled previously
  
  	@param hGrabb 	Handle to a grabber object.
  	@retval IC_SUCCESS : Success
  	@retval IC_NOT:AVAILABLE : The property is not supported by the current device
  	@retval IC_NO_HANDLE	Invalid grabber handle
  	@retval IC_NO_DEVICE    No video capture device opened
  
  	@sa IC_EnableTrigger
  
   }
  function IC_SoftwareTrigger( hGrabb :HGRABBER):longint;stdcall;external External_library name 'IC_SoftwareTrigger';

  {///////////////////////////////////////////////////////////////// }
  {! Sets a new frame rate. 
  	@param hGrabb 	Handle to a grabber object.
  	@param FrameRate The new frame rate.
  	@retval IC_SUCCESS : Success
  	@retval IC_NOT_AVAILABLE : The property is not supported by the current device
  	@retval IC_NO_HANDLE	Invalid grabber handle
  	@retval IC_NO_DEVICE    No video capture device opened
  	@retval IC_NOT_IN_LIVEMODE Frame rate can not set, while live video is shown. Stop Live video first!
   }
  function IC_SetFrameRate( hGrabb :HGRABBER; FrameRate:single):longint;stdcall;external External_library name 'IC_SetFrameRate';

  {///////////////////////////////////////////////////////////////// }
  {! Retrieves the current frame rate
  
  	@param hGrabb 	Handle to a grabber object.
  	@retval The current frame rate. If it is 0.0, then frame rates are not supported.
   }
  function IC_GetFrameRate( hGrabb :HGRABBER):single;stdcall;external External_library name 'IC_GetFrameRate';

  {///////////////////////////////////////////////////////////////// }
  {! Retrieves available frame rates.
  	The count of available frame rates depends on the used video capture
  	device and the currently used video format. After a video was changed,
  	the available frame rates usually are changed by the video capture device 
  	too.
  	@code
  	int Index = 0;
  	float fps = 0.0f;
  
  	while( IC_GetAvailableFrameRates(hGrabb , Index, &fps ) == IC_SUCCESS )
  	
  		printf("Frame rate %d : %f fps\n", Index, fps);
  		Index++;
  	
  	@endcode
  
  	@param hGrabb 	Handle to a grabber object.
  	@param Index Index of the frame rates, starting at 0
  	@param fps Pointer to a float variable, that will receive the frame rate of the passed index.
  	@retval IC_SUCCESS, if the frame rate at Index exists, otherwise IC_ERROR,
   }
  function IC_GetAvailableFrameRates( hGrabb :HGRABBER; Index:longint; var fps:single):longint;stdcall;external External_library name 'IC_GetAvailableFrameRates';

  function IC_SetWhiteBalanceAuto( hGrabb :HGRABBER; iOnOff:longint):longint;stdcall;external External_library name 'IC_SetWhiteBalanceAuto';

  {///////////////////////////////////////////////////////////////// }
  {! Sets the value for white balance red.
  
  	@param hGrabb 	Handle to a grabber object.
  	@param Value	Value of the red white balance to be set
  	@retval IC_SUCCESS			: Success
  	@retval IC_NO_HANDLE		: Invalid grabber handle
  	@retval IC_NO_DEVICE		: No video capture device opened
  	@retval IC_NOT_AVAILABLE	: The property is not supported by the current device
  
   }
  function IC_SetWhiteBalanceRed( hGrabb :HGRABBER; Value:longint):longint;stdcall;external External_library name 'IC_SetWhiteBalanceRed';

  {///////////////////////////////////////////////////////////////// }
  {! Sets the value for white balance green.
  
  	@param hGrabb 	Handle to a grabber object.
  	@param Value	Value of the green white balance to be set
  	@retval IC_SUCCESS			: Success
  	@retval IC_NO_HANDLE		: Invalid grabber handle
  	@retval IC_NO_DEVICE		: No video capture device opened
  	@retval IC_NOT_AVAILABLE	: The property is not supported by the current device
  
   }
  function IC_SetWhiteBalanceGreen( hGrabb :HGRABBER; Value:longint):longint;stdcall;external External_library name 'IC_SetWhiteBalanceGreen';

  {///////////////////////////////////////////////////////////////// }
  {! Sets the value for white balance blue.
  
  	@param hGrabb 	Handle to a grabber object.
  	@param Value	Value of the blue white balance to be set
  	@retval IC_SUCCESS			: Success
  	@retval IC_NO_HANDLE		: Invalid grabber handle
  	@retval IC_NO_DEVICE		: No video capture device opened
  	@retval IC_NOT_AVAILABLE	: The property is not supported by the current device
  
   }
  function IC_SetWhiteBalanceBlue( hGrabb :HGRABBER; Value:longint):longint;stdcall;external External_library name 'IC_SetWhiteBalanceBlue';

  {///////////////////////////////////////////////////////////////// }
  {! Performs the one push  for Focus
  
  	@param hGrabb 	Handle to a grabber object.
  	@param Value	Value of the blue white balance to be set
  	@retval IC_SUCCESS			: Success
  	@retval IC_NO_HANDLE		: Invalid grabber handle
  	@retval IC_NO_DEVICE		: No video capture device opened
  	@retval IC_NOT_AVAILABLE	: The property is not supported by the current device
  
   }
  function IC_FocusOnePush( hGrabb :HGRABBER):longint;stdcall;external External_library name 'IC_FocusOnePush';

  {///////////////////////////////////////////////////////////////// }
  {! Show the internal property page of the camera
   }
  function IC_ShowInternalPropertyPage( hGrabb :HGRABBER):longint;stdcall;external External_library name 'IC_ShowInternalPropertyPage';

  {///////////////////////////////////////////////////////////////// }
  {! Resets all properties to their default values. If a property has
  	automation, the automatic will be enabled.
  	If the device supports external trigger, the external trigger will
  	be disabled.
  
  	@param hGrabb 	Handle to a grabber object.
  	@retval IC_SUCCESS			Success
  	@retval IC_NO_HANDLE		Invalid grabber handle
  	@retval IC_NO_DEVICE		No video capture device opened
  
   }
  function IC_ResetProperties( hGrabb :HGRABBER):longint;stdcall;external External_library name 'IC_ResetProperties';

  {///////////////////////////////////////////////////////////////// }
  {! Resets the driver. Do not use, for internl purposes only.
  
  	@param hGrabb 	Handle to a grabber object.
  	@retval IC_SUCCESS			Success
  	@retval IC_NO_HANDLE		Invalid grabber handle
  	@retval IC_NO_DEVICE		No video capture device opened
   }
  function IC_ResetUSBCam( hGrabb :HGRABBER):longint;stdcall;external External_library name 'IC_ResetUSBCam';

  {///////////////////////////////////////////////////////////////// }
  {! This function queries the internal property set (KsPropertySet) of the driver. 
  	It allows an application to access all properties of a video capture devices
  	using the enums and GUIDs from the header files fwcam1394propguid.h and 
  	fwcam1394props.h.
  
  	@param hGrabb 	Handle to a grabber object.
  	@retval IC_SUCCESS			Success
  	@retval IC_NO_HANDLE		Invalid grabber handle
  	@retval IC_NO_DEVICE		No video capture device opened
  	@retval IC_ERROR			The property could not have been retrieved
  
   }
  function IC_QueryPropertySet( hGrabb :HGRABBER):longint;stdcall;external External_library name 'IC_QueryPropertySet';

  {///////////////////////////////////////////////////////////////// }
  {! This function sets a value or structure to the internal property set
  	of the video capture device. The properties and structures are defined
  	in the header file fwcam1394props.h. Before using this function, the
  	properties set must have been queried once using the function IC_QueryPropertySet().
  
  
  	@param hGrabb 	Handle to a grabber object.
  	@retval IC_SUCCESS			Success
  	@retval IC_ERROR			Setting of the values failed
  	@retval IC_NO_PROPERTYSET	The property set was not retrieved or is not available.
  	@retval IC_NO_HANDLE		Invalid grabber handle
  	@retval IC_NO_DEVICE		No video capture device opened
  
  	@sa IC_QueryPropertySet
   }
  {int  IC_PropertySet_Set(HGRABBER* hGrabb , FWCAM1394_CUSTOM_PROP prop, FWCAM1394_CUSTOM_PROP_S& rstruct ); }
  {///////////////////////////////////////////////////////////////// }
  {! Enables or disables the default window size lock of the video window. 
  
  	@param hGrabb 	Handle to a grabber object.
  	@param Default	0 = disable, custome size can be set, 1 = enable, the standard size, which is video format, is used.
  
  	@retval IC_SUCCESS			Success
  	@retval IC_ERROR			Setting of the values failed
  	@retval IC_NO_PROPERTYSET	The property set was not retrieved or is not available.
  	@retval IC_NO_HANDLE		Invalid grabber handle
  	@retval IC_NO_DEVICE		No video capture device opened
  
   }
  function IC_SetDefaultWindowPosition( hGrabb :HGRABBER; Default:longint):longint;stdcall;external External_library name 'IC_SetDefaultWindowPosition';

  {///////////////////////////////////////////////////////////////// }
  {! This function Sets the position and size of the video window. 
  
  	@param hGrabb 	Handle to a grabber object.
  	@param PosX  Specifies the x-coordinate of the upper left hand corner of the video window. It defaults to 0. 
  	@param PosY  Specifies the y-coordinate of the upper left hand corner of the video window. It defaults to 0. 
  	@param width  Specifies the width of the video window. 
  	@param height  Specifies the height of the video window. 
  
   	@retval IC_SUCCESS			Success
  	@retval IC_ERROR			Setting of the values failed
  	@retval IC_DEFAULT_WINDOW_SIZE_SET	The property set was not retrieved or is not available.
  	@retval IC_NO_HANDLE		Invalid grabber handle
  	@retval IC_NO_DEVICE		No video capture device opened
  
   }
  function IC_SetWindowPosition( hGrabb :HGRABBER; PosX:longint; PosY:longint; Width:longint; Height:longint):longint;stdcall;external External_library name 'IC_SetWindowPosition';

  {///////////////////////////////////////////////////////////////// }
  {! Enumerate the available properties of a video capture device.
  
  	@param hGrabb 	Handle to a grabber object.
  	@param cb Callback functions called by the enum function.
  	@param data User data
  
  	@retval IC_SUCCESS No error otherwise an error occured, e.g. no device selected.
  	
   }
//  function IC_enumProperties( hGrabb :HGRABBER; cb:IC_ENUMCB; data:pointer):longint;stdcall;external External_library name 'IC_enumProperties';

  {///////////////////////////////////////////////////////////////// }
  {! Enumerate the available elements of a video capture device and a property.
  
  	@param hGrabb 	Handle to a grabber object.
  	@param Property Name of the property
  	@param cb Callback functions called by the enum function.
  	@param data User data
  
  	@retval IC_SUCCESS No error otherwise an error occured, e.g. no device selected.
  	@retval IC_PROPERTY_ITEM_NOT_AVAILABLE The passed property in Property is not avaialble.
   }
//  function IC_enumPropertyElements( hGrabb :HGRABBER; _Property:Pchar; cb:IC_ENUMCB; data:pointer):longint;stdcall;external External_library name 'IC_enumPropertyElements';

  {///////////////////////////////////////////////////////////////// }
  {! Enumerate the available interfaces of of a video capture device, property and element.
  
  	The string passed to the callback function can contain
  	- Range
  	- Switch
  	- Button
  	- Mapstrings
  	- AbsoluteValues
  	- Unknown
  
  	@param hGrabb 	Handle to a grabber object.
  	@param Property Name of the property
  	@param Property Name of the elemt
  	@param cb Callback functions called by the enum function.
  	@param data User data
  
  	@retval IC_SUCCESS No error otherwise an error occured, e.g. no device selected.
  	@retval IC_PROPERTY_ITEM_NOT_AVAILABLE The passed property in Property is not avaialble.
   }
//  function IC_enumPropertyElementInterfaces( hGrabb :HGRABBER; _Property:Pchar; Element:Pchar; cb:IC_ENUMCB; data:pointer):longint;stdcall;external External_library name 'IC_enumPropertyElementInterfaces';

  {///////////////////////////////////////////////////////////////// }
  {! Check, whether a property is available..  For a list of properties and elements
      use the VCDPropertyInspector of IC Imaging Control.
  
  	@param hGrabb 	Handle to a grabber object.
  	@param Property  The name of the property, e.g. Gain, Exposure
  	@param Element  The type of the interface, e.g. Value, Auto. If NULL, it is not checked.
  
   	@retval IC_SUCCESS			Success
  	@retval IC_NO_HANDLE		Invalid grabber handle
  	@retval IC_NO_DEVICE		No video capture device opened
  	@retval IC_PROPERTY_ELEMENT_NOT_AVAILABLE		A requested element of a given property item is not available
  	@retval IC_PROPERTY_ELEMENT_WRONG_INTERFACE		requested element has not the interface, which is needed.
  	
  	Simple call:
  	@code
  	if( IC_IsPropertyAvailable( hGrabb , "Brightness",NULL) == IC_SUCCESS )
  	
  		printf("Brightness is supported\n");
  	
  	else
  	
  		printf("Brightness is not supported\n");
  	
  	@endcode
  
  	Complex call for a special element:
  	@code
  	if( IC_IsPropertyAvailable( hGrabb , "Trigger","Software Trigger") == IC_SUCCESS )
  	
  		printf("Software trigger is supported\n");
  	
  	else
  	
  		printf("Software trigger is not supported\n");
  	
  	@endcode
   }
  function IC_IsPropertyAvailable( hGrabb :HGRABBER; _Property:Pchar; Element:Pchar):longint;stdcall;external External_library name 'IC_IsPropertyAvailable';

  {///////////////////////////////////////////////////////////////// }
  {! This returns the range of a property.  For a list of properties and elements
      use the VCDPropertyInspector of IC Imaging Control.
  
  	@param hGrabb 	Handle to a grabber object.
  	@param Property  The name of the property, e.g. Gain, Exposure
  	@param Element  The type of the interface, e.g. Value, Auto. If NULL, it is "Value".
  	@param Min  Receives the min value of the property
  	@param Max  Receives the max value of the property
  
   	@retval IC_SUCCESS			Success
  	@retval IC_NO_HANDLE		Invalid grabber handle
  	@retval IC_NO_DEVICE		No video capture device opened
  	@retval IC_PROPERTY_ITEM_NOT_AVAILABLE		A requested property item is not available
  	@retval IC_PROPERTY_ELEMENT_NOT_AVAILABLE		A requested element of a given property item is not available
  	@retval IC_PROPERTY_ELEMENT_WRONG_INTERFACE		requested element has not the interface, which is needed.
  
  	@code
  	HGRABBER* hGrabb ; // The handle of the grabber object.
  
  	int Min;
  	int Max;
  	int Result = IC_ERROR;
  	HGRABBER* hGrabb ;
  
  	if( IC_InitLibrary(0) )
  	
  		hGrabb  = IC_CreateGrabber();
  		IC_OpenVideoCaptureDevice(hGrabb , "DFx 31BG03.H");
  
  		if( hGrabb  )
  		
  			Result = IC_GetPropertyValueRange(hGrabb ,"Exposure","Auto Reference", &Min, &Max );
  
  			if( Result == IC_SUCCESS )
  				printf("Expsure Auto Reference Min %d, Max %d\n", Min, Max);
  
  			Result = IC_GetPropertyValueRange(hGrabb ,"Exposure",NULL, &Min, &Max );
  
  			if( Result == IC_SUCCESS )
  				printf("Exposure Value Min %d, Max %d\n", Min, Max);
  	
  	IC_ReleaseGrabber( hGrabb  );
  	@endcode
  
  
   }
  function IC_GetPropertyValueRange( hGrabb :HGRABBER; _Property:Pchar; Element:Pchar; var Min:longint; var Max:longint):longint;stdcall;external External_library name 'IC_GetPropertyValueRange';

  {///////////////////////////////////////////////////////////////// }
  {! This returns the current value of a property. For a list of properties and elements
      use the VCDPropertyInspector of IC Imaging Control.
  
  	@param hGrabb 	Handle to a grabber object.
  	@param Property  The name of the property, e.g. Gain, Exposure
  	@param Element  The type of the interface, e.g. Value, Auto. If NULL, it is "Value".
  	@param Value  Receives the value of the property
  
   	@retval IC_SUCCESS			Success
  	@retval IC_NO_HANDLE		Invalid grabber handle
  	@retval IC_NO_DEVICE		No video capture device opened
  	@retval IC_PROPERTY_ITEM_NOT_AVAILABLE		A requested property item is not available
  	@retval IC_PROPERTY_ELEMENT_NOT_AVAILABLE		A requested element of a given property item is not available
  	@retval IC_PROPERTY_ELEMENT_WRONG_INTERFACE		requested element has not the interface, which is needed.
   }
  function IC_GetPropertyValue( hGrabb :HGRABBER; _Property:Pchar; Element:Pchar; var Value:longint):longint;stdcall;external External_library name 'IC_GetPropertyValue';

  {///////////////////////////////////////////////////////////////// }
  {! This sets a new value of a property.  For a list of properties and elements
      use the VCDPropertyInspector of IC Imaging Control.
  
  	@param hGrabb 	Handle to a grabber object.
  	@param Property  The name of the property, e.g. Gain, Exposure
  	@param Element  The type of the interface, e.g. Value, Auto. If NULL, it is "Value".
  	@param Value  Receives the value of the property
  
   	@retval IC_SUCCESS			Success
  	@retval IC_NO_HANDLE		Invalid grabber handle
  	@retval IC_NO_DEVICE		No video capture device opened
  	@retval IC_PROPERTY_ITEM_NOT_AVAILABLE		A requested property item is not available
  	@retval IC_PROPERTY_ELEMENT_NOT_AVAILABLE		A requested element of a given property item is not available
  	@retval IC_PROPERTY_ELEMENT_WRONG_INTERFACE		requested element has not the interface, which is needed.
   }
  function IC_SetPropertyValue( hGrabb :HGRABBER; _Property:Pchar; Element:Pchar; Value:longint):longint;stdcall;external External_library name 'IC_SetPropertyValue';

  {///////////////////////////////////////////////////////////////// }
  {! This returns the range of an absolute value property. Usually it is used for exposure. 
  	a list of properties and elements use the VCDPropertyInspector of IC Imaging Control.
  
  	@param hGrabb 	Handle to a grabber object.
  	@param Property  The name of the property, e.g. Gain, Exposure
  	@param Element  The type of the interface, e.g. Value, Auto. If NULL, it is "Value".
  	@param Min  Receives the min value of the property
  	@param Max  Receives the max value of the property
  
   	@retval IC_SUCCESS			Success
  	@retval IC_NO_HANDLE		Invalid grabber handle
  	@retval IC_NO_DEVICE		No video capture device opened
  	@retval IC_PROPERTY_ITEM_NOT_AVAILABLE		A requested property item is not available
  	@retval IC_PROPERTY_ELEMENT_NOT_AVAILABLE		A requested element of a given property item is not available
  	@retval IC_PROPERTY_ELEMENT_WRONG_INTERFACE		requested element has not the interface, which is needed.
   }
  function IC_GetPropertyAbsoluteValueRange( hGrabb :HGRABBER; _Property:Pchar; Element:Pchar; var Min:single; var Max:single):longint;stdcall;external External_library name 'IC_GetPropertyAbsoluteValueRange';

  {///////////////////////////////////////////////////////////////// }
  {! This returns the current value of an absolute value property.
  	Usually it is used for exposure. For a list of properties and elements
      use the VCDPropertyInspector of IC Imaging Control.
  
  	@param hGrabb 	Handle to a grabber object.
  	@param Property  The name of the property, e.g. Gain, Exposure
  	@param Element  The type of the interface, e.g. Value, Auto. If NULL, it is "Value".
  	@param Value  Receives the value of the property
  
   	@retval IC_SUCCESS			Success
  	@retval IC_NO_HANDLE		Invalid grabber handle
  	@retval IC_NO_DEVICE		No video capture device opened
  	@retval IC_PROPERTY_ITEM_NOT_AVAILABLE		A requested property item is not available
  	@retval IC_PROPERTY_ELEMENT_NOT_AVAILABLE		A requested element of a given property item is not available
  	@retval IC_PROPERTY_ELEMENT_WRONG_INTERFACE		requested element has not the interface, which is needed.
   }
  function IC_GetPropertyAbsoluteValue( hGrabb :HGRABBER; _Property:Pchar; Element:Pchar; var Value:single):longint;stdcall;external External_library name 'IC_GetPropertyAbsoluteValue';

  {///////////////////////////////////////////////////////////////// }
  {! This sets a new value of an absolute value property. Usually it is used for exposure. 
  	a list of properties and elements
      use the VCDPropertyInspector of IC Imaging Control.
  
  	@param hGrabb 	Handle to a grabber object.
  	@param Property  The name of the property, e.g. Gain, Exposure
  	@param Element  The type of the interface, e.g. Value, Auto. If NULL, it is "Value".
  	@param Value  Receives the value of the property
  
   	@retval IC_SUCCESS			Success
  	@retval IC_NO_HANDLE		Invalid grabber handle
  	@retval IC_NO_DEVICE		No video capture device opened
  	@retval IC_PROPERTY_ITEM_NOT_AVAILABLE		A requested property item is not available
  	@retval IC_PROPERTY_ELEMENT_NOT_AVAILABLE		A requested element of a given property item is not available
  	@retval IC_PROPERTY_ELEMENT_WRONG_INTERFACE		requested element has not the interface, which is needed.
   }
  function IC_SetPropertyAbsoluteValue( hGrabb :HGRABBER; _Property:Pchar; Element:Pchar; Value:single):longint;stdcall;external External_library name 'IC_SetPropertyAbsoluteValue';

  {///////////////////////////////////////////////////////////////// }
  {! This returns the current value of a switch property. Switch properties
  	are usually used for enabling and disabling of automatics.
  	 For a list of properties and elements
      use the VCDPropertyInspector of IC Imaging Control.
  
  	@param hGrabb 	Handle to a grabber object.
  	@param Property  The name of the property, e.g. Gain, Exposure
  	@param Element  The type of the interface, e.g. Value, Auto. If NULL, it is "Auto".
  	@param On  Receives the value of the property
  
   	@retval IC_SUCCESS			Success
  	@retval IC_NO_HANDLE		Invalid grabber handle
  	@retval IC_NO_DEVICE		No video capture device opened
  	@retval IC_PROPERTY_ITEM_NOT_AVAILABLE		A requested property item is not available
  	@retval IC_PROPERTY_ELEMENT_NOT_AVAILABLE		A requested element of a given property item is not available
  	@retval IC_PROPERTY_ELEMENT_WRONG_INTERFACE		requested element has not the interface, which is needed.
   }
  function IC_GetPropertySwitch( hGrabb :HGRABBER; _Property:Pchar; Element:Pchar; var On:longint):longint;stdcall;external External_library name 'IC_GetPropertySwitch';

  {///////////////////////////////////////////////////////////////// }
  {! This sets the  value of a switch property. Switch properties
  	are usually used for enabling and disabling of automatics.
  	 For a list of properties and elements
      use the VCDPropertyInspector of IC Imaging Control.
  
  	@param hGrabb 	Handle to a grabber object.
  	@param Property  The name of the property, e.g. Gain, Exposure
  	@param Element  The type of the interface, e.g. Value, Auto. If NULL, it is "Auto".
  	@param On  Receives the value of the property
  
   	@retval IC_SUCCESS			Success
  	@retval IC_NO_HANDLE		Invalid grabber handle
  	@retval IC_NO_DEVICE		No video capture device opened
  	@retval IC_PROPERTY_ITEM_NOT_AVAILABLE		A requested property item is not available
  	@retval IC_PROPERTY_ELEMENT_NOT_AVAILABLE		A requested element of a given property item is not available
  	@retval IC_PROPERTY_ELEMENT_WRONG_INTERFACE		requested element has not the interface, which is needed.
   }
  function IC_SetPropertySwitch( hGrabb :HGRABBER; _Property:Pchar; Element:Pchar; On:longint):longint;stdcall;external External_library name 'IC_SetPropertySwitch';

  {//////////////////////////////////////////////////////////////// }
  {! This executes the on push on a property. These properties are used
  	for white balance one push or for software trigger.
  	For a list of properties and elements
      use the VCDPropertyInspector of IC Imaging Control.
  
  	@param hGrabb 	Handle to a grabber object.
  	@param Property  The name of the property, e.g. "Trigger"
  	@param Element  The type of the interface, e.g. "Software Trigger" 
  	@param On  Receives the value of the property
  
   	@retval IC_SUCCESS			Success
  	@retval IC_NO_HANDLE		Invalid grabber handle
  	@retval IC_NO_DEVICE		No video capture device opened
  	@retval IC_PROPERTY_ITEM_NOT_AVAILABLE		A requested property item is not available
  	@retval IC_PROPERTY_ELEMENT_NOT_AVAILABLE		A requested element of a given property item is not available
  	@retval IC_PROPERTY_ELEMENT_WRONG_INTERFACE		requested element has not the interface, which is needed.
   }
  function IC_PropertyOnePush( hGrabb :HGRABBER; _Property:Pchar; Element:Pchar):longint;stdcall;external External_library name 'IC_PropertyOnePush';

  {//////////////////////////////////////////////////////////////// }
  {! 
  
  	@param hGrabb 	Handle to a grabber object.
  	@param Property  The name of the property, e.g. "Strobe"
  	@param Element  The type of the interface, e.g. "Mode" 
  	@param StringCount  Receives the count of strings, that is modes, availble
  	@param Strings pointer to an array of char*, that will contain the mode strings. The array size should be StringCount * 20. Parameter can be null in order to query the number of strings
  
   	@retval IC_SUCCESS			Success
  	@retval IC_NO_HANDLE		Invalid grabber handle
  	@retval IC_NO_DEVICE		No video capture device opened
  	@retval IC_PROPERTY_ITEM_NOT_AVAILABLE		A requested property item is not available
  	@retval IC_PROPERTY_ELEMENT_NOT_AVAILABLE		A requested element of a given property item is not available
  	@retval IC_PROPERTY_ELEMENT_WRONG_INTERFACE		requested element has not the interface, which is needed.
   }
  function IC_GetPropertyMapStrings( hGrabb :HGRABBER; _Property:Pchar; Element:Pchar; var StringCount:longint; Strings:PPchar):longint;stdcall;external External_library name 'IC_GetPropertyMapStrings';

  {//////////////////////////////////////////////////////////////// }
  {! Return the current set string of a mapstring interface
  
  	@param hGrabb 	Handle to a grabber object.
  	@param Property  The name of the property, e.g. "Strobe"
  	@param Element  The type of the interface, e.g. "Mode" 
  	@param String	 pointer to a char*. Size should be atleast 50. There is no check! This contains the result.
  
   	@retval IC_SUCCESS			Success
  	@retval IC_NO_HANDLE		Invalid grabber handle
  	@retval IC_NO_DEVICE		No video capture device opened
  	@retval IC_PROPERTY_ITEM_NOT_AVAILABLE		A requested property item is not available
  	@retval IC_PROPERTY_ELEMENT_NOT_AVAILABLE		A requested element of a given property item is not available
  	@retval IC_PROPERTY_ELEMENT_WRONG_INTERFACE		requested element has not the interface, which is needed.
   }
  function IC_GetPropertyMapString( hGrabb :HGRABBER; _Property:Pchar; Element:Pchar; _String:Pchar):longint;stdcall;external External_library name 'IC_GetPropertyMapString';

  {//////////////////////////////////////////////////////////////// }
  {! Set the string of a mapstring interface
  
  	@param hGrabb 	Handle to a grabber object.
  	@param Property  The name of the property, e.g. "Strobe"
  	@param Element  The type of the interface, e.g. "Mode" 
  	@param String	 pointer to a char*. Size should be atleast 50. There is no check! This contains the result.
  
   	@retval IC_SUCCESS			Success
  	@retval IC_NO_HANDLE		Invalid grabber handle
  	@retval IC_NO_DEVICE		No video capture device opened
  	@retval IC_PROPERTY_ITEM_NOT_AVAILABLE		A requested property item is not available
  	@retval IC_PROPERTY_ELEMENT_NOT_AVAILABLE		A requested element of a given property item is not available
  	@retval IC_PROPERTY_ELEMENT_WRONG_INTERFACE		requested element has not the interface, which is needed.
   }
  function IC_SetPropertyMapString( hGrabb :HGRABBER; _Property:Pchar; Element:Pchar; _String:Pchar):longint;stdcall;external External_library name 'IC_SetPropertyMapString';

  {//////////////////////////////////////////////////////////////// }
  {! Query number of avaialable frame filters
  
  	@retval The count of found frame filters.
   }
  function IC_GetAvailableFrameFilterCount:longint;stdcall;external External_library name 'IC_GetAvailableFrameFilterCount';

  {//////////////////////////////////////////////////////////////// }
  {! Query a list of framefilters
  
  	@param szFilterList A two dimensional char array that recieves the list of found frame filters
  	@param iSize The number of entries in the above list.
  @code
      char szFilterList[80][40];
  	int iCount;
      iCount = IC_GetAvailableFrameFilterCount();
  
  	iFormatCount = IC_GetAvailableFrameFilters(szFormatList,iCount );
  
  	for( i = 0; i < iCount; i++ )
  	
  		printf("%2d. %s\n",i+1,szFormatList[i]);
  	
  	@endcode
   }
  function IC_GetAvailableFrameFilters(szFilterList:PPchar; iSize:longint):longint;stdcall;external External_library name 'IC_GetAvailableFrameFilters';

  {//////////////////////////////////////////////////////////////// }
  {! Create a frame filter
  	@param szFilterName Name of the filter to create
  	@param FilterHandle Address of a pointer, that will receive the handle of the created filter
  
  	@retval IC_SUCCESS	Success
  	@retval IC_ERROR	If the filter creation failed.
  
  	@sa IC_DeleteFrameFilter
   }
  function IC_CreateFrameFilter(szFilterName:Pchar; var FilterHandle:TFRAMEFILTER):longint;stdcall;external External_library name 'IC_CreateFrameFilter';

  {//////////////////////////////////////////////////////////////// }
  {! Add the frame filter to the device's filter list. It is possible to add several
  	frame filter to a grabber, so a filter chain for image processing can be created.
  	A frame filter is removed by a call to IC_RemoveFrameFilter
  
  	@param hGrabb 	Handle to a grabber object.
  	@param FilterHandle	Handle to a frame filter object.
  
  	@retval IC_SUCCESS	Success
  	@retval IC_ERROR Either hGrabb  or FilterHandle was NULL
  
  	@sa IC_RemoveFrameFilterFromDevice
  	@sa IC_CreateFrameFilter
   }
  function IC_AddFrameFilterToDevice( hGrabb :HGRABBER; FilterHandle:TFRAMEFILTER):longint;stdcall;external External_library name 'IC_AddFrameFilterToDevice';

  {//////////////////////////////////////////////////////////////// }
  {! Removes a previously added frame filter from the frame filter list
  	
  	@param hGrabb 	Handle to a grabber object, that uses the passed frame filter.
  	@param FilterHandle	Handle to a frame filter object, to be removed
  
  	@sa IC_AddFrameFilterToDevice
  	@sa IC_CreateFrameFilter
  
   }
  procedure IC_RemoveFrameFilterFromDevice( hGrabb :HGRABBER; FilterHandle:TFRAMEFILTER);stdcall;external External_library name 'IC_RemoveFrameFilterFromDevice';

  {//////////////////////////////////////////////////////////////// }
  {! Deletes a previously created frame filter. Make sure, the frame filter to be deleted 
  	is not in use anymore, otherwise a null pointer access violation will occur.
  	
  	@param FilterHandle	Handle to a frame filter object.
   }
  procedure IC_DeleteFrameFilter(FilterHandle:TFRAMEFILTER);stdcall;external External_library name 'IC_DeleteFrameFilter';

  {///////////////////////////////////////////////////////////// }
  { Delete the memory allocated by the HFRAMEFILTER structure. Please remove the frame filter from the HGrabber, 
     before deleting it.
  
  	@param FilterHandle	Handle to a frame filter object.
  
  	@retval IC_SUCCESS	Success
  	@retval IC_ERROR Either hGrabb  or FilterHandle was NULL or the frame filter has no dialog.
  
   }
  function IC_FrameFilterShowDialog(FilterHandle:TFRAMEFILTER):longint;stdcall;external External_library name 'IC_FrameFilterShowDialog';

  {///////////////////////////////////////////////////////////// }
  {! Query a parameter value of a frame filter
  	@param FilterHandle	Handle to a frame filter object.
  	@param ParameterName Name of the parameter whose value is to be queried
  	@param Data pointer to the data, that receives the value. Memory must be allocated before.
  
  	@retval IC_SUCCESS	Success
  	@retval IC_ERROR  Maybe the parameter name does not exist.
  
   }
  function IC_FrameFilterGetParameter(FilterHandle:TFRAMEFILTER; ParameterName:Pchar; Data:pointer):longint;stdcall;external External_library name 'IC_FrameFilterGetParameter';

  {! Set an int parameter value of a frame filter
  	@param FilterHandle	Handle to a frame filter object.
  	@param ParameterName Name of the parameter whose value is to be set
  	@param Data The data, that contains the value.
  
  	@retval IC_SUCCESS	Success
  	@retval IC_PROPERTY_ITEM_NOT_AVAILABLE the parameter givven by ParameterName does not exist
  	@retval IC_PROPERTY_ELEMENT_WRONG_INTERFACE The data type, e.g. int does not match to the parameter type, e.g. float
  	@retval IC_ERROR  Unknown error
   }
  function IC_FrameFilterSetParameterInt(FilterHandle:TFRAMEFILTER; ParameterName:Pchar; Data:longint):longint;stdcall;external External_library name 'IC_FrameFilterSetParameterInt';

  {! Set a float parameter value of a frame filter
  	@param FilterHandle	Handle to a frame filter object.
  	@param ParameterName Name of the parameter whose value is to be set
  	@param Data The data, that contains the value.
  
  	@retval IC_SUCCESS	Success
  	@retval IC_PROPERTY_ITEM_NOT_AVAILABLE the parameter givven by ParameterName does not exist
  	@retval IC_PROPERTY_ELEMENT_WRONG_INTERFACE The data type, e.g. int does not match to the parameter type, e.g. float
  	@retval IC_ERROR  Unknown error
   }
  function IC_FrameFilterSetParameterFloat(FilterHandle:TFRAMEFILTER; ParameterName:Pchar; Data:single):longint;stdcall;external External_library name 'IC_FrameFilterSetParameterFloat';

  {! Set a boolean parameter value of a frame filter. boolean means int here.
  	@param FilterHandle	Handle to a frame filter object.
  	@param ParameterName Name of the parameter whose value is to be set
  	@param Data The data, that contains the value.
  
  	@retval IC_SUCCESS	Success
  	@retval IC_PROPERTY_ITEM_NOT_AVAILABLE the parameter givven by ParameterName does not exist
  	@retval IC_PROPERTY_ELEMENT_WRONG_INTERFACE The data type, e.g. int does not match to the parameter type, e.g. float
  	@retval IC_ERROR  Unknown error
   }
  function IC_FrameFilterSetParameterBoolean(FilterHandle:TFRAMEFILTER; ParameterName:Pchar; Data:longint):longint;stdcall;external External_library name 'IC_FrameFilterSetParameterBoolean';

  {! Set a string parameter value of a frame filter
  	@param FilterHandle	Handle to a frame filter object.
  	@param ParameterName Name of the parameter whose value is to be set
  	@param Data The data, that contains the value.
  
  	@retval IC_SUCCESS	Success
  	@retval IC_PROPERTY_ITEM_NOT_AVAILABLE the parameter givven by ParameterName does not exist
  	@retval IC_PROPERTY_ELEMENT_WRONG_INTERFACE The data type, e.g. int does not match to the parameter type, e.g. float
  	@retval IC_ERROR  Unknown error
   }
  function IC_FrameFilterSetParameterString(FilterHandle:TFRAMEFILTER; ParameterName:Pchar; Data:Pchar):longint;stdcall;external External_library name 'IC_FrameFilterSetParameterString';

  {////////////////////////////////////////////////////////////////////////// }
  {! Remove all frame filters from the Grabber's device path
  	@param hGrabb 	Handle to a grabber object.
  
   }
  function IC_FrameFilterDeviceClear( hGrabb :HGRABBER):longint;stdcall;external External_library name 'IC_FrameFilterDeviceClear';


  type
    PCODECHANDLE_t__ = ^CODECHANDLE_t__;
    CODECHANDLE_t__ = record
        unused : longint;
      end;
    CODECHANDLE_t = CODECHANDLE_t__;
    PCODECHANDLE_t = ^CODECHANDLE_t;
  {/<Internal structure of the grabber object handle. }
  {//////////////////////////////////////////////////////////////////////// }
  {! 
   }
  { # define	HCODEC CODECHANDLE_t* ///< Type of grabber object handle. Used for all functions.  }
  {////////////////////////////////////////////////////////////////////////// }
  {! Callback type definition for the codec enumenration callback called by
  	IC_enumCodecs
  	@retval 1 : Terminate the enumeration, 0 continue enumrating
   }
  {typedef int ENUMCODECCB( char* CodecName, void*); }
  {////////////////////////////////////////////////////////////////////////// }
  {! Enumerate all installed codecs. It calls the callback function passed by 
  	the cb parameter. It ends, if cb returns 0 or all codecs have been enumerated.
  
  	@param cb pallack function of type ENUMCODECCB
  	@param data Pointer to user data
   }
  {void  IC_enumCodecs(ENUMCODECCB cb, void* data); }
  {////////////////////////////////////////////////////////////////////////// }
  {! Creates the codec by the passed name
  
  	@param Name Name of the codec to be created
  	@retval NULL on error, otherwise the created CODECHANDLE_t*
   }

  function IC_Codec_Create(Name:Pchar):PCODECHANDLE_t;stdcall;external External_library name 'IC_Codec_Create';

  procedure IC_Codec_Release(var Codec:CODECHANDLE_t);stdcall;external External_library name 'IC_Codec_Release';

  {////////////////////////////////////////////////////////////////////////// }
  {! Queries a name of a codec passed by _Codec
  
  	@param _Codec Handle to the codec
  	@param l Size in bytes of the memory allocated for name
  	@param name String that will receive the name of the codec terminated by a \0
  
  	@retval IC_SUCCESS on success
  	@retval IC_NO_HANDLE if _Codec or Name is NULL
   }
  function IC_Codec_getName(var Codec:CODECHANDLE_t; l:longint; Name:Pchar):longint;stdcall;external External_library name 'IC_Codec_getName';

  {////////////////////////////////////////////////////////////////////////// }
  {! Return whether a codec passed by _Codec has a property dialog
  
  	@param _Codec Handle to the codec
  
  	@retval IC_SUCCESS The codec has a dialog
  	@retval IC_ERROR The codec has no dialog
  	@retval IC_NO_HANDLE  _Codec is NULL
   }
  function IC_Codec_hasDialog(var Codec:CODECHANDLE_t):longint;stdcall;external External_library name 'IC_Codec_hasDialog';

  {////////////////////////////////////////////////////////////////////////// }
  {! Shows the property dialog of a codec passed by _Codec
  
  	@param name String that will receive the name of the codec terminated by a \0
  
  	@retval IC_SUCCESS on success
  	@retval IC_ERROR On error, e.g. something went wrong with the codec's dialog.
  	@retval IC_NO_HANDLE if _Codec or Name is NULL
   }
  function IC_Codec_showDialog(var Codec:CODECHANDLE_t):longint;stdcall;external External_library name 'IC_Codec_showDialog';

  {////////////////////////////////////////////////////////////////////////// }
  {! Assigns the selected Codec to the Grabber. AVI Capture is prepared. Image
      capture does not work anymore.
  
  	After doing so, a call to IC_Startlive() starts AVI Capture and IC_Stoplive stopps it,
  
  	@param hlGrabber Handle to a grabber with a valid device
  	@param Codec Handle to the selected codec.
  
  	@retval IC_SUCCESS on success
   }
  function IC_SetCodec( hlGrabber:HGRABBER; var Codec:CODECHANDLE_t):longint;stdcall;external External_library name 'IC_SetCodec';

  {////////////////////////////////////////////////////////////////////////// }
  {! Set the file name for the AVI file
  
  	After doing so, a call to IC_Startlive() starts AVI Capture and IC_Stoplive stopps it,
  
  	@param hlGrabber Handle to a grabber with a valid device
  	@param FileName Filename
  
  	@retval IC_SUCCESS on success
  	@retval IC_NO_HANDLE if the grabber is invalid
  
   }
  function IC_SetAVIFileName( hlGrabber:HGRABBER; FileName:Pchar):longint;stdcall;external External_library name 'IC_SetAVIFileName';

  {////////////////////////////////////////////////////////////////////////// }
  {! Pauses or continues AVI Capture. This allows, to start the stream and see the live video
      but images are not saved into the AVI file.
  
  	
  	@param hlGrabber Handle to a grabber with a valid device
  	@param pause  1 = Pause, nothing saved, 0 = save images!
  
  	@retval IC_SUCCESS on success
  	@retval IC_NO_HANDLE if the grabber is invalid
   }
  function IC_enableAVICapturePause( hlGrabber:HGRABBER; Pause:longint):longint;stdcall;external External_library name 'IC_enableAVICapturePause';


implementation


end.
