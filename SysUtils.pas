{*******************************************************}
{                                                       }
{           CodeGear Delphi Runtime Library             }
{                                                       }
{ Copyright(c) 1995-2010 Embarcadero Technologies, Inc. }
{                                                       }
{   Copyright and license exceptions noted in source    }
{                                                       }
{*******************************************************}
{  Minimalistic edition controllable via defines        }
{  Makes EXE about  kB smaller                          }
{ * PosEx moved here from StrUtils                      }
{ * (Min/Max)(Single/Double) moved here from Math       }
{ * IsValidIdent available only when CHAR defined       }
{   (Character unit is used)                            }
{ * IsAssembly removed                                  }
{ Control different features with defines (see below)   }


{  Define MiniRTL variable to switch mini-mode on       }
{  (and ensure the unit is included before              }
{  its standard RTL copy!)                              }
{  If you use RTL units that use SysUtils, you'll have  }
{  to copy them near this file                          }

{*******************************************************}
{               System Utilities Unit                   }
{*******************************************************}

unit SysUtils;

{$H+,B-,R-}
{$WARN SYMBOL_PLATFORM OFF}
{$WARN UNSAFE_TYPE OFF}

{$IFDEF MiniRTL} // don't show compiler messages leaving all these places for EBMT to fix
  {$WARNINGS OFF}
  {$HINTS OFF}
  
  {.$DEFINE LANG}   // TLanguages, ...
  {.$DEFINE SB}     // TStringBuilder
  {.$DEFINE ENC}    // TEncoding
  {.$DEFINE CHAR}   // use Character unit, enable IsValidIdent function
  {$DEFINE FMTSET} // GetFormatSettings in init section. Adds ~7 kB but conversion routines
                    // (and Format too) needs this values to work properly. You may use
                    // thread-safe analog with record got from GetLocaleFormatSettings but
                    // it adds ~5 kB anyway.
  
{$ENDIF}

interface

uses
{$IFDEF MSWINDOWS}
Windows,
{$ENDIF}
{$IFDEF POSIX}
Types,
{$IFDEF MACOSX}
MiniLibc,
{$ELSE !MACOSX}
Libc,
{$ENDIF !MACOSX}
{$ENDIF}
SysConst;

const
{ File open modes }

{$IFDEF POSIX}
  fmOpenRead       = O_RDONLY;
  fmOpenWrite      = O_WRONLY;
  fmOpenReadWrite  = O_RDWR;
//  fmShareCompat not supported
   {$IFDEF LINUX} // need to get MAC OS/X values
  fmShareExclusive = $0010;
  fmShareDenyWrite = $0020;
//  fmShareDenyRead  not supported
  fmShareDenyNone  = $0030;
   {$ENDIF LINUX}
{$ENDIF}
{$IFDEF MSWINDOWS}
  fmOpenRead       = $0000;
  fmOpenWrite      = $0001;
  fmOpenReadWrite  = $0002;

  fmShareCompat    = $0000 platform; // DOS compatibility mode is not portable
  fmShareExclusive = $0010;
  fmShareDenyWrite = $0020;
  fmShareDenyRead  = $0030 platform; // write-only not supported on all platforms
  fmShareDenyNone  = $0040;
{$ENDIF}

{ File attribute constants }

  faReadOnly  = $00000001 platform;
  faHidden    = $00000002 platform;
  faSysFile   = $00000004 platform;
  faVolumeID  = $00000008 platform deprecated;  // not used in Win32
  faDirectory = $00000010;
  faArchive   = $00000020 platform;
  faSymLink   = $00000040 platform;
  faNormal    = $00000080 platform;
  faTemporary = $00000100 platform;
  faAnyFile   = $000001FF;

{ Units of time }

  HoursPerDay   = 24;
  MinsPerHour   = 60;
  SecsPerMin    = 60;
  MSecsPerSec   = 1000;
  MinsPerDay    = HoursPerDay * MinsPerHour;
  SecsPerDay    = MinsPerDay * SecsPerMin;
  SecsPerHour   = SecsPerMin * MinsPerHour;  
  MSecsPerDay   = SecsPerDay * MSecsPerSec;

{ Days between 1/1/0001 and 12/31/1899 }

  DateDelta = 693594;

{ Days between TDateTime basis (12/31/1899) and Unix time_t basis (1/1/1970) }

  UnixDateDelta = 25569;

{$IFDEF MiniRTL}
  // from Math
  MinSingle   =  1.5e-45;
  (*$EXTERNALSYM MinSingle*)
  (*$HPPEMIT 'extern const Extended MinSingle /*= 1.500000E-45*/;'*)
  MaxSingle   =  3.4e+38;
  (*$EXTERNALSYM MaxSingle*)
  (*$HPPEMIT 'extern const Extended MaxSingle /*= 3.400000E+38*/;'*)
  MinDouble   =  5.0e-324;
  (*$EXTERNALSYM MinDouble*)
  (*$HPPEMIT 'extern const Extended MinDouble /*= 5.000000E-324*/;'*)
  MaxDouble   =  1.7e+308;
  (*$EXTERNALSYM MaxDouble*)
  (*$HPPEMIT 'extern const Extended MaxDouble /*= 1.700000E+308*/;'*)
{$ENDIF}

type

  TBytes = array of Byte;

{ Standard Character set type }

  TSysCharSet = set of AnsiChar;

{ Set access to an integer }

  TIntegerSet = set of 0..SizeOf(Integer) * 8 - 1;

{ Type conversion records }

  WordRec = packed record
    case Integer of
      0: (Lo, Hi: Byte);
      1: (Bytes: array [0..1] of Byte);
  end;

  LongRec = packed record
    case Integer of
      0: (Lo, Hi: Word);
      1: (Words: array [0..1] of Word);
      2: (Bytes: array [0..3] of Byte);
  end;

  Int64Rec = packed record
    case Integer of
      0: (Lo, Hi: Cardinal);
      1: (Cardinals: array [0..1] of Cardinal);
      2: (Words: array [0..3] of Word);
      3: (Bytes: array [0..7] of Byte);
  end;

{ General arrays }

  PByteArray = ^TByteArray;
  TByteArray = array[0..32767] of Byte;

  PWordArray = ^TWordArray;
  TWordArray = array[0..16383] of Word;

{ Generic procedure pointer }

  TProcedure = procedure;

{ Generic filename type }

  TFileName = type string;

{ Search record used by FindFirst, FindNext, and FindClose }

  TSearchRec = record
    Time: Integer;
    Size: Int64;
    Attr: Integer;
    Name: TFileName;
    ExcludeAttr: Integer;
{$IFDEF MSWINDOWS}
    FindHandle: THandle  platform;
    FindData: TWin32FindData  platform;
{$ENDIF MSWINDOWS}
{$IFDEF POSIX}
    Mode: mode_t  platform;
    FindHandle: Pointer  platform;
    PathOnly: String  platform;
    Pattern: String  platform;
{$ENDIF POSIX}
  end;

{ FloatToText, FloatToTextFmt, TextToFloat, and FloatToDecimal type codes }

  TFloatValue = (fvExtended, fvCurrency);

{ FloatToText format codes }

  TFloatFormat = (ffGeneral, ffExponent, ffFixed, ffNumber, ffCurrency);

{ FloatToDecimal result record }

  TFloatRec = packed record
    Exponent: Smallint;
    Negative: Boolean;
    Digits: array[0..20] of AnsiChar;
  end;

{ Date and time record }

  TTimeStamp = record
    Time: Integer;      { Number of milliseconds since midnight }
    Date: Integer;      { One plus number of days since 1/1/0001 }
  end;

{ MultiByte Character Set (MBCS) byte type }
  TMbcsByteType = (mbSingleByte, mbLeadByte, mbTrailByte);

{ System Locale information record }
  TSysLocale = packed record
    DefaultLCID: Integer;
    PriLangID: Integer;
    SubLangID: Integer;
    FarEast: Boolean;
    MiddleEast: Boolean;
  end;

{$IFDEF MSWINDOWS}

{$IFDEF Lang}

{ This is used by TLanguages }
  TLangRec = packed record
    FName: string;
    FLCID: LCID;
    FExt: string;
  end;

{ This stores the languages that the system supports }
  TLanguages = class
  private
    FSysLangs: array of TLangRec;
    class destructor Destroy;
    function LocalesCallback(LocaleID: PChar): Integer; stdcall;
    function GetExt(Index: Integer): string;
    function GetID(Index: Integer): string;
    function GetLCID(Index: Integer): LCID;
    function GetName(Index: Integer): string;
    function GetNameFromLocaleID(ID: LCID): string;
    function GetNameFromLCID(const ID: string): string;
    function GetCount: integer;
  public
    constructor Create;
    function IndexOf(ID: LCID): Integer;
    property Count: Integer read GetCount;
    property Name[Index: Integer]: string read GetName;
    property NameFromLocaleID[ID: LCID]: string read GetNameFromLocaleID;
    property NameFromLCID[const ID: string]: string read GetNameFromLCID;
    property ID[Index: Integer]: string read GetID;
    property LocaleID[Index: Integer]: LCID read GetLCID;
    property Ext[Index: Integer]: string read GetExt;
  end platform;

{$ENDIF}

{$ENDIF}

{$IFDEF LINUX}
  TEraRange = record
    StartDate : Integer;         // whole days since 12/31/1899 (TDateTime basis)
    EndDate   : Integer;         // whole days since 12/31/1899 (TDateTime basis)
//    Direction : Char;
  end;
{$ENDIF}

{ Exceptions }

{$IFDEF MSWINDOWS}
  PExceptionRecord = ^TExceptionRecord;
  TExceptionRecord = record
    ExceptionCode: Cardinal;
    ExceptionFlags: Cardinal;
    ExceptionRecord: PExceptionRecord;
    ExceptionAddress: Pointer;
    NumberParameters: Cardinal;
    case {IsOsException:} Boolean of
      True:  (ExceptionInformation : array [0..14] of Longint);
      False: (ExceptAddr: Pointer; ExceptObject: Pointer);
  end;
{$ENDIF}

  Exception = class(TObject)
  private
    FMessage: string;
    FHelpContext: Integer;
    FInnerException: Exception;
    FStackInfo: Pointer;
    FAcquireInnerException: Boolean;
    class constructor Create;
    class destructor Destroy;
  protected
    procedure SetInnerException;
    procedure SetStackInfo(AStackInfo: Pointer);
    function GetStackTrace: string;
{$IFDEF MSWINDOWS}
    // This virtual function will be called right before this exception is about to be
    // raised. In the case of an external non-Delphi exception, this is called soon after
    // the object is created since the "raise" condition is already in progress.
    procedure RaisingException(P: PExceptionRecord); virtual;
{$ENDIF}
  public
    constructor Create(const Msg: string);
    constructor CreateFmt(const Msg: string; const Args: array of const);
    constructor CreateRes(Ident: Integer); overload;
    constructor CreateRes(ResStringRec: PResStringRec); overload;
    constructor CreateResFmt(Ident: Integer; const Args: array of const); overload;
    constructor CreateResFmt(ResStringRec: PResStringRec; const Args: array of const); overload;
    constructor CreateHelp(const Msg: string; AHelpContext: Integer);
    constructor CreateFmtHelp(const Msg: string; const Args: array of const;
      AHelpContext: Integer);
    constructor CreateResHelp(Ident: Integer; AHelpContext: Integer); overload;
    constructor CreateResHelp(ResStringRec: PResStringRec; AHelpContext: Integer); overload;
    constructor CreateResFmtHelp(ResStringRec: PResStringRec; const Args: array of const;
      AHelpContext: Integer); overload;
    constructor CreateResFmtHelp(Ident: Integer; const Args: array of const;
      AHelpContext: Integer); overload;
    destructor Destroy; override;
    function GetBaseException: Exception; virtual;
    function ToString: string; override;
    property BaseException: Exception read GetBaseException;
    property HelpContext: Integer read FHelpContext write FHelpContext;
    property InnerException: Exception read FInnerException;
    property Message: string read FMessage write FMessage;
    property StackTrace: string read GetStackTrace;
    property StackInfo: Pointer read FStackInfo;
{$IFDEF MSWINDOWS}
  class var
    // Hook this function to return an opaque data structure that contains stack information
    // for the given exception information record. This function will be called when the
    // exception is about to be raised or if this is an external exception such as an
    // Access Violation, called soon after the object is created.
    GetExceptionStackInfoProc: function (P: PExceptionRecord): Pointer;
    // This function is called to return a string representation of the above opaque
    // data structure
    GetStackInfoStringProc: function (Info: Pointer): string;
    // This function is called when the destructor is called to clean up any data associated
    // with the given opaque data structure.
    CleanUpStackInfoProc: procedure (Info: Pointer);
    // Use this function to raise an exception instance from within an exception handler and
    // you want to "acquire" the active exception and chain it to the new exception and preserve
    // the context. This will cause the FInnerException field to get set with the exception
    // in currently in play.
    // You should only call this procedure from within an except block where the this new
    // exception is expected to be handled elsewhere.
    class procedure RaiseOuterException(E: Exception); static;
    // Provide another method that does the same thing as RaiseOuterException, but uses the
    // C++ vernacular of "throw"
    class procedure ThrowOuterException(E: Exception); static;
{$ENDIF}
  end;

  EArgumentException = class(Exception);
  EArgumentOutOfRangeException = class(EArgumentException);

  EPathTooLongException = class(Exception);
  ENotSupportedException = class(Exception);
  EDirectoryNotFoundException = class(Exception);
  EFileNotFoundException = class(Exception);

  ENoConstructException = class(Exception);

  ExceptClass = class of Exception;

  EAbort = class(Exception);

  EHeapException = class(Exception)
  private
    AllowFree: Boolean;
{$IFDEF MSWINDOWS}
  protected
    procedure RaisingException(P: PExceptionRecord); override;
{$ENDIF}
  public
    procedure FreeInstance; override;
  end;

  EOutOfMemory = class(EHeapException);

  EInOutError = class(Exception)
  public
    ErrorCode: Integer;
  end;

  EExternal = class(Exception)
  public
{$IFDEF MSWINDOWS}
    ExceptionRecord: PExceptionRecord platform;
{$ENDIF}
{$IF defined(LINUX) or defined(MACOSX)}
    ExceptionAddress: LongWord platform;
    AccessAddress: LongWord platform;
    SignalNumber: Integer platform;
{$IFEND LINUX or MACOSX}
  end;

  EExternalException = class(EExternal);

  EIntError = class(EExternal);
  EDivByZero = class(EIntError);
  ERangeError = class(EIntError);
  EIntOverflow = class(EIntError);

  EMathError = class(EExternal);
  EInvalidOp = class(EMathError);
  EZeroDivide = class(EMathError);
  EOverflow = class(EMathError);
  EUnderflow = class(EMathError);

  EInvalidPointer = class(EHeapException);

  EInvalidCast = class(Exception);

  EConvertError = class(Exception);

  EAccessViolation = class(EExternal);
  EPrivilege = class(EExternal);
  EStackOverflow = class(EExternal)
    end deprecated;
  EControlC = class(EExternal);
{$IFDEF LINUX}
  EQuit = class(EExternal) end platform;
{$ENDIF}

{$IFDEF POSIX}
  ECodesetConversion = class(Exception) end platform;
{$ENDIF POSIX}

  EVariantError = class(Exception);

  EPropReadOnly = class(Exception);
  EPropWriteOnly = class(Exception);

  EAssertionFailed = class(Exception);

{$IFNDEF PC_MAPPED_EXCEPTIONS}
  EAbstractError = class(Exception) end platform;
{$ENDIF}

  EIntfCastError = class(Exception);

  EInvalidContainer = class(Exception);
  EInvalidInsert = class(Exception);

  EPackageError = class(Exception);

  EOSError = class(Exception)
  public
    ErrorCode: DWORD;
  end;
{$IFDEF MSWINDOWS}
  EWin32Error = class(EOSError)
  end deprecated;
{$ENDIF}

  ESafecallException = class(Exception);

  EMonitor = class(Exception);
  EMonitorLockException = class(EMonitor);
  ENoMonitorSupportException = class(EMonitor);

  EProgrammerNotFound = class(Exception);

{$IF defined(LINUX) or defined(MACOSX)}

{
        Signals

    External exceptions, or signals, are, by default, converted to language
    exceptions by the Delphi RTL.  Under Linux, a Delphi application installs
    signal handlers to trap the raw signals, and convert them.  Delphi libraries
    do not install handlers by default.  So if you are implementing a standalone
    library, such as an Apache DSO, and you want to have signals converted to
    language exceptions that you can catch, you must install signal hooks
    manually, using the interfaces that the Delphi RTL provides.

    For most libraries, installing signal handlers is pretty
    straightforward.  Call HookSignal(RTL_SIGDEFAULT) at initialization time,
    and UnhookSignal(RTL_SIGNALDEFAULT) at shutdown.  This will install handlers
    for a set of signals that the RTL normally hooks for Delphi applications.

    There are some cases where the above initialization will not work properly:
    The proper behaviour for setting up signal handlers is to set
    a signal handler, and then later restore the signal handler to its previous
    state when you clean up.  If you have two libraries lib1 and lib2, and lib1
    installs a signal handler, and then lib2 installs a signal handler, those
    libraries have to uninstall in the proper order if they restore signal
    handlers, or the signal handlers can be left in an inconsistent and
    potentially fatal state.  Not all libraries behave well with respect to
    installing signal handlers.  To hedge against this possibility, and allow
    you to manage signal handlers better in the face of whatever behaviour
    you may find in external libraries, we provide a set of four interfaces to
    allow you to tailor the Delphi signal handler hooking/unhooking in the
    event of an emergency.  These are:
        InquireSignal
        AbandonSignalHandler
        HookSignal
        UnhookSignal

    InquireSignal allows you to look at the state of a signal handler, so
    that you can find out if someone grabbed it out from under you.

    AbandonSignalHandler tells the RTL never to unhook a particular
    signal handler.  This can be used if you find a case where it would
    be unsafe to return to the previous state of signal handling.  For
    example, if the previous signal handler was installed by a library
    which has since been unloaded.

    HookSignal/UnhookSignal setup signal handlers that map certain signals
    into language exceptions.

    See additional notes at InquireSignal, et al, below.
}

const
    RTL_SIGINT          = 0;    // User interrupt (SIGINT)
    RTL_SIGFPE          = 1;    // Floating point exception (SIGFPE)
    RTL_SIGSEGV         = 2;    // Segmentation violation (SIGSEGV)
    RTL_SIGILL          = 3;    // Illegal instruction (SIGILL)
    RTL_SIGBUS          = 4;    // Bus error (SIGBUS)
    RTL_SIGQUIT         = 5;    // User interrupt (SIGQUIT)
    RTL_SIGLAST         = RTL_SIGQUIT; // Used internally.  Don't use this.
    RTL_SIGDEFAULT      = -1;   // Means all of a set of signals that the we capture
                                // normally.  This is currently all of the preceding
                                // signals.  You cannot pass this to InquireSignal.

type
    { TSignalState is the state of a given signal handler, as returned by
      InquireSignal.  See InquireSignal, below.
    }
    TSignalState = (ssNotHooked, ssHooked, ssOverridden);

var

  {
    If DeferUserInterrupts is set, we do not raise either SIGINT or SIGQUIT as
    an exception, instead, we set SIGINTIssued or SIGQUITIssued when the
    signal arrives, and swallow the signal where the OS issued it.  This gives
    GUI applications the chance to defer the actual handling of the signal
    until a time when it is safe to do so.
  }

  DeferUserInterrupts: Boolean;
  SIGINTIssued: Boolean;
  SIGQUITIssued: Boolean;
{$IFEND LINUX or MACOSX}

{$IFNDEF MSWINDOWS}
const
  MAX_PATH =
{$IFDEF LINUX}
     4095;  // From /usr/include/linux/limits.h PATH_MAX
{$ENDIF LINUX}
{$IFDEF MACOSX}
     1024;
{$ENDIF MACOSX}
{$ENDIF !MSWINDOWS}

var

{ Empty string and null string pointer. These constants are provided for
  backwards compatibility only.  }

  EmptyStr: string = '';
  NullStr: PString = @EmptyStr;

  EmptyWideStr: WideString = '';
  NullWideStr: PWideString = @EmptyWideStr;
  
  EmptyAnsiStr: AnsiString = '';
  NullAnsiStr: PAnsiString = @EmptyAnsiStr;

{$IFDEF MSWINDOWS}
{ Win32 platform identifier.  This will be one of the following values:

    VER_PLATFORM_WIN32s
    VER_PLATFORM_WIN32_WINDOWS
    VER_PLATFORM_WIN32_NT

  See WINDOWS.PAS for the numerical values. }

  Win32Platform: Integer = 0;

{ Win32 OS version information -

  see TOSVersionInfo.dwMajorVersion/dwMinorVersion/dwBuildNumber }

  Win32MajorVersion: Integer = 0;
  Win32MinorVersion: Integer = 0;
  Win32BuildNumber: Integer = 0;

{ Win32 OS extra version info string -

  see TOSVersionInfo.szCSDVersion }

  Win32CSDVersion: string = '';

{ Win32 OS version tester }

function CheckWin32Version(AMajor: Integer; AMinor: Integer = 0): Boolean;

{ GetFileVersion returns the most significant 32 bits of a file's binary
  version number. Typically, this includes the major and minor version placed
  together in one 32-bit integer. It generally does not include the release
  or build numbers. It returns Cardinal(-1) if it failed. }
function GetFileVersion(const AFileName: string): Cardinal;

{$ENDIF}

{ Currency and date/time formatting options

  The initial values of these variables are fetched from the system registry
  using the GetLocaleInfo function in the Win32 API. The description of each
  variable specifies the LOCALE_XXXX constant used to fetch the initial
  value.

  CurrencyString - Defines the currency symbol used in floating-point to
  decimal conversions. The initial value is fetched from LOCALE_SCURRENCY.

  CurrencyFormat - Defines the currency symbol placement and separation
  used in floating-point to decimal conversions. Possible values are:

    0 = '$1'
    1 = '1$'
    2 = '$ 1'
    3 = '1 $'

  The initial value is fetched from LOCALE_ICURRENCY.

  NegCurrFormat - Defines the currency format for used in floating-point to
  decimal conversions of negative numbers. Possible values are:

    0 = '($1)'      4 = '(1$)'      8 = '-1 $'      12 = '$ -1'
    1 = '-$1'       5 = '-1$'       9 = '-$ 1'      13 = '1- $'
    2 = '$-1'       6 = '1-$'      10 = '1 $-'      14 = '($ 1)'
    3 = '$1-'       7 = '1$-'      11 = '$ 1-'      15 = '(1 $)'

  The initial value is fetched from LOCALE_INEGCURR.

  ThousandSeparator - The character used to separate thousands in numbers
  with more than three digits to the left of the decimal separator. The
  initial value is fetched from LOCALE_STHOUSAND.  A value of #0 indicates
  no thousand separator character should be output even if the format string
  specifies thousand separators.

  DecimalSeparator - The character used to separate the integer part from
  the fractional part of a number. The initial value is fetched from
  LOCALE_SDECIMAL.  DecimalSeparator must be a non-zero value.

  CurrencyDecimals - The number of digits to the right of the decimal point
  in a currency amount. The initial value is fetched from LOCALE_ICURRDIGITS.

  DateSeparator - The character used to separate the year, month, and day
  parts of a date value. The initial value is fetched from LOCATE_SDATE.

  ShortDateFormat - The format string used to convert a date value to a
  short string suitable for editing. For a complete description of date and
  time format strings, refer to the documentation for the FormatDate
  function. The short date format should only use the date separator
  character and the  m, mm, d, dd, yy, and yyyy format specifiers. The
  initial value is fetched from LOCALE_SSHORTDATE.

  LongDateFormat - The format string used to convert a date value to a long
  string suitable for display but not for editing. For a complete description
  of date and time format strings, refer to the documentation for the
  FormatDate function. The initial value is fetched from LOCALE_SLONGDATE.

  TimeSeparator - The character used to separate the hour, minute, and
  second parts of a time value. The initial value is fetched from
  LOCALE_STIME.

  TimeAMString - The suffix string used for time values between 00:00 and
  11:59 in 12-hour clock format. The initial value is fetched from
  LOCALE_S1159.

  TimePMString - The suffix string used for time values between 12:00 and
  23:59 in 12-hour clock format. The initial value is fetched from
  LOCALE_S2359.

  ShortTimeFormat - The format string used to convert a time value to a
  short string with only hours and minutes. The default value is computed
  from LOCALE_ITIME and LOCALE_ITLZERO.

  LongTimeFormat - The format string used to convert a time value to a long
  string with hours, minutes, and seconds. The default value is computed
  from LOCALE_ITIME and LOCALE_ITLZERO.

  ShortMonthNames - Array of strings containing short month names. The mmm
  format specifier in a format string passed to FormatDate causes a short
  month name to be substituted. The default values are fecthed from the
  LOCALE_SABBREVMONTHNAME system locale entries.

  LongMonthNames - Array of strings containing long month names. The mmmm
  format specifier in a format string passed to FormatDate causes a long
  month name to be substituted. The default values are fecthed from the
  LOCALE_SMONTHNAME system locale entries.

  ShortDayNames - Array of strings containing short day names. The ddd
  format specifier in a format string passed to FormatDate causes a short
  day name to be substituted. The default values are fecthed from the
  LOCALE_SABBREVDAYNAME system locale entries.

  LongDayNames - Array of strings containing long day names. The dddd
  format specifier in a format string passed to FormatDate causes a long
  day name to be substituted. The default values are fecthed from the
  LOCALE_SDAYNAME system locale entries.

  ListSeparator - The character used to separate items in a list.  The
  initial value is fetched from LOCALE_SLIST.

  TwoDigitYearCenturyWindow - Determines what century is added to two
  digit years when converting string dates to numeric dates.  This value
  is subtracted from the current year before extracting the century.
  This can be used to extend the lifetime of existing applications that
  are inextricably tied to 2 digit year data entry.  The best solution
  to Year 2000 (Y2k) issues is not to accept 2 digit years at all - require
  4 digit years in data entry to eliminate century ambiguities.

  Examples:

  Current TwoDigitCenturyWindow  Century  StrToDate() of:
  Year    Value                  Pivot    '01/01/03' '01/01/68' '01/01/50'
  -------------------------------------------------------------------------
  1998    0                      1900     1903       1968       1950
  2002    0                      2000     2003       2068       2050
  1998    50 (default)           1948     2003       1968       1950
  2002    50 (default)           1952     2003       1968       2050
  2020    50 (default)           1970     2003       2068       2050
 }

var
  CurrencyString: string;
  CurrencyFormat: Byte;
  NegCurrFormat: Byte;
  ThousandSeparator: Char;
  DecimalSeparator: Char;
  CurrencyDecimals: Byte;
  DateSeparator: Char;
  ShortDateFormat: string;
  LongDateFormat: string;
  TimeSeparator: Char;
  TimeAMString: string;
  TimePMString: string;
  ShortTimeFormat: string;
  LongTimeFormat: string;
  ShortMonthNames: array[1..12] of string;
  LongMonthNames: array[1..12] of string;
  ShortDayNames: array[1..7] of string;
  LongDayNames: array[1..7] of string;
  SysLocale: TSysLocale;
  TwoDigitYearCenturyWindow: Word = 50;
  ListSeparator: Char;


{ Thread safe currency and date/time formatting

  The TFormatSettings record is designed to allow thread safe formatting,
  equivalent to the gloabal variables described above. Each of the
  formatting routines that use the gloabal variables have overloaded
  equivalents, requiring an additional parameter of type TFormatSettings.

  A TFormatSettings record must be populated before use. This can be done
  using the GetLocaleFormatSettings function, which will populate the
  record with values based on the given locale (using the Win32 API
  function GetLocaleInfo). Note that some format specifiers still require
  specific thread locale settings (such as period/era names).
}

type
  TFormatSettings = record
    CurrencyFormat: Byte;
    NegCurrFormat: Byte;
    ThousandSeparator: Char;
    DecimalSeparator: Char;
    CurrencyDecimals: Byte;
    DateSeparator: Char;
    TimeSeparator: Char;
    ListSeparator: Char;
    CurrencyString: string;
    ShortDateFormat: string;
    LongDateFormat: string;
    TimeAMString: string;
    TimePMString: string;
    ShortTimeFormat: string;
    LongTimeFormat: string;
    ShortMonthNames: array[1..12] of string;
    LongMonthNames: array[1..12] of string;
    ShortDayNames: array[1..7] of string;
    LongDayNames: array[1..7] of string;
    TwoDigitYearCenturyWindow: Word;
  end;

  TLocaleOptions = (loInvariantLocale, loUserLocale);

const
  MaxEraCount = 7;

var
  EraNames: array [1..MaxEraCount] of string;
  EraYearOffsets: array [1..MaxEraCount] of Integer;
{$IFDEF LINUX}
  EraRanges : array [1..MaxEraCount] of TEraRange platform;
  EraYearFormats: array [1..MaxEraCount] of string platform;
  EraCount: Byte platform;
{$ENDIF}

const
  PathDelim  = {$IFDEF MSWINDOWS} '\'; {$ELSE} '/'; {$ENDIF}
  DriveDelim = {$IFDEF MSWINDOWS} ':'; {$ELSE} '';  {$ENDIF}
  PathSep    = {$IFDEF MSWINDOWS} ';'; {$ELSE} ':'; {$ENDIF}

{$IFDEF MSWINDOWS}
{$IFDEF Lang}
function Languages: TLanguages;
{$ENDIF}
{$ENDIF}

{ Exit procedure handling }

{ AddExitProc adds the given procedure to the run-time library's exit
  procedure list. When an application terminates, its exit procedures are
  executed in reverse order of definition, i.e. the last procedure passed
  to AddExitProc is the first one to get executed upon termination. }

procedure AddExitProc(Proc: TProcedure);

{ String handling routines }

{ NewStr allocates a string on the heap. NewStr is provided for backwards
  compatibility only. }

function NewStr(const S: AnsiString): PAnsiString; deprecated;

{ DisposeStr disposes a string pointer that was previously allocated using
  NewStr. DisposeStr is provided for backwards compatibility only. }

procedure DisposeStr(P: PAnsiString); deprecated;

{ AssignStr assigns a new dynamically allocated string to the given string
  pointer. AssignStr is provided for backwards compatibility only. }

procedure AssignStr(var P: PAnsiString; const S: AnsiString); deprecated;

{ AppendStr appends S to the end of Dest. AppendStr is provided for
  backwards compatibility only. Use "Dest := Dest + S" instead. }

procedure AppendStr(var Dest: AnsiString; const S: AnsiString); deprecated;

{ UpperCase converts all ASCII characters in the given string to upper case.
  The conversion affects only 7-bit ASCII characters between 'a' and 'z'. To
  convert 8-bit international characters, use AnsiUpperCase. }

function UpperCase(const S: string): string; overload;
function UpperCase(const S: string; LocaleOptions: TLocaleOptions): string; overload; inline;

{ LowerCase converts all ASCII characters in the given string to lower case.
  The conversion affects only 7-bit ASCII characters between 'A' and 'Z'. To
  convert 8-bit international characters, use AnsiLowerCase. }

function LowerCase(const S: string): string; overload;
function LowerCase(const S: string; LocaleOptions: TLocaleOptions): string; overload; inline;

{ CompareStr compares S1 to S2, with case-sensitivity. The return value is
  less than 0 if S1 < S2, 0 if S1 = S2, or greater than 0 if S1 > S2. The
  compare operation is based on the 8-bit ordinal value of each character
  and is not affected by the current user locale. }

function CompareStr(const S1, S2: string): Integer; overload;
function CompareStr(const S1, S2: string; LocaleOptions: TLocaleOptions): Integer; overload;

{ SameStr compares S1 to S2, with case-sensitivity. Returns true if
  S1 and S2 are the equal, that is, if CompareStr would return 0. }

function SameStr(const S1, S2: string): Boolean; overload;
function SameStr(const S1, S2: string; LocaleOptions: TLocaleOptions): Boolean; overload;

{ CompareMem performs a binary compare of Length bytes of memory referenced
  by P1 to that of P2.  CompareMem returns True if the memory referenced by
  P1 is identical to that of P2. }

function CompareMem(P1, P2: Pointer; Length: Integer): Boolean; assembler;

{ CompareText compares S1 to S2, without case-sensitivity. The return value
  is the same as for CompareStr. The compare operation is based on the 8-bit
  ordinal value of each character, after converting 'a'..'z' to 'A'..'Z',
  and is not affected by the current user locale. }

function CompareText(const S1, S2: string): Integer; overload;
function CompareText(const S1, S2: string; LocaleOptions: TLocaleOptions): Integer; overload;

{ SameText compares S1 to S2, without case-sensitivity. Returns true if
  S1 and S2 are the equal, that is, if CompareText would return 0. SameText
  has the same 8-bit limitations as CompareText }

function SameText(const S1, S2: string): Boolean; overload;
function SameText(const S1, S2: string; LocaleOptions: TLocaleOptions): Boolean; overload;

{ AnsiUpperCase converts all characters in the given string to upper case.
  The conversion uses the current user locale. }

function AnsiUpperCase(const S: string): string; overload;

{ AnsiLowerCase converts all characters in the given string to lower case.
  The conversion uses the current user locale. }

function AnsiLowerCase(const S: string): string; overload;

{ AnsiCompareStr compares S1 to S2, with case-sensitivity. The compare
  operation is controlled by the current user locale. The return value
  is the same as for CompareStr. }

function AnsiCompareStr(const S1, S2: string): Integer; overload;

{ AnsiSameStr compares S1 to S2, with case-sensitivity. The compare
  operation is controlled by the current user locale. The return value
  is True if AnsiCompareStr would have returned 0. }

function AnsiSameStr(const S1, S2: string): Boolean; inline; overload;

{ AnsiCompareText compares S1 to S2, without case-sensitivity. The compare
  operation is controlled by the current user locale. The return value
  is the same as for CompareStr. }

function AnsiCompareText(const S1, S2: string): Integer; overload;

{ AnsiSameText compares S1 to S2, without case-sensitivity. The compare
  operation is controlled by the current user locale. The return value
  is True if AnsiCompareText would have returned 0. }

function AnsiSameText(const S1, S2: string): Boolean; inline; overload;

{ AnsiStrComp compares S1 to S2, with case-sensitivity. The compare
  operation is controlled by the current user locale. The return value
  is the same as for CompareStr. }

function AnsiStrComp(S1, S2: PAnsiChar): Integer; inline; overload;
function AnsiStrComp(S1, S2: PWideChar): Integer; inline; overload;

{ AnsiStrIComp compares S1 to S2, without case-sensitivity. The compare
  operation is controlled by the current user locale. The return value
  is the same as for CompareStr. }

function AnsiStrIComp(S1, S2: PAnsiChar): Integer; inline; overload;
function AnsiStrIComp(S1, S2: PWideChar): Integer; inline; overload;

{ AnsiStrLComp compares S1 to S2, with case-sensitivity, up to a maximum
  length of MaxLen bytes. The compare operation is controlled by the
  current user locale. The return value is the same as for CompareStr. }

function AnsiStrLComp(S1, S2: PAnsiChar; MaxLen: Cardinal): Integer; overload;
function AnsiStrLComp(S1, S2: PWideChar; MaxLen: Cardinal): Integer; inline; overload;

{ AnsiStrLIComp compares S1 to S2, without case-sensitivity, up to a maximum
  length of MaxLen bytes. The compare operation is controlled by the
  current user locale. The return value is the same as for CompareStr. }

function AnsiStrLIComp(S1, S2: PAnsiChar; MaxLen: Cardinal): Integer; overload;
function AnsiStrLIComp(S1, S2: PWideChar; MaxLen: Cardinal): Integer; inline; overload;

{ AnsiStrLower converts all characters in the given string to lower case.
  The conversion uses the current user locale. }

function AnsiStrLower(Str: PAnsiChar): PAnsiChar; overload;
function AnsiStrLower(Str: PWideChar): PWideChar; inline; overload;

{ AnsiStrUpper converts all characters in the given string to upper case.
  The conversion uses the current user locale. }

function AnsiStrUpper(Str: PAnsiChar): PAnsiChar; overload;
function AnsiStrUpper(Str: PWideChar): PWideChar; inline; overload;

{ AnsiLastChar returns a pointer to the last full character in the string.
  This function supports multibyte characters  }

function AnsiLastChar(const S: AnsiString): PAnsiChar; overload;
function AnsiLastChar(const S: UnicodeString): PWideChar; overload;

{ AnsiStrLastChar returns a pointer to the last full character in the string.
  This function supports multibyte characters.  }

function AnsiStrLastChar(P: PAnsiChar): PAnsiChar; overload;
function AnsiStrLastChar(P: PWideChar): PWideChar; overload;

{ WideUpperCase converts all characters in the given string to upper case. }

function WideUpperCase(const S: WideString): WideString;

{ WideLowerCase converts all characters in the given string to lower case. }

function WideLowerCase(const S: WideString): WideString;

{ WideCompareStr compares S1 to S2, with case-sensitivity. The return value
  is the same as for CompareStr. }

function WideCompareStr(const S1, S2: WideString): Integer;

{ WideSameStr compares S1 to S2, with case-sensitivity. The return value
  is True if WideCompareStr would have returned 0. }

function WideSameStr(const S1, S2: WideString): Boolean; inline;

{ WideCompareText compares S1 to S2, without case-sensitivity. The return value
  is the same as for CompareStr. }

function WideCompareText(const S1, S2: WideString): Integer;

{ WideSameText compares S1 to S2, without case-sensitivity. The return value
  is True if WideCompareText would have returned 0. }

function WideSameText(const S1, S2: WideString): Boolean; inline;

{ Trim trims leading and trailing spaces and control characters from the
  given string. }

function Trim(const S: string): string; overload;

{ TrimLeft trims leading spaces and control characters from the given
  string. }

function TrimLeft(const S: string): string; overload;

{ TrimRight trims trailing spaces and control characters from the given
  string. }

function TrimRight(const S: string): string; overload;

{ QuotedStr returns the given string as a quoted string. A single quote
  character is inserted at the beginning and the end of the string, and
  for each single quote character in the string, another one is added. }

function QuotedStr(const S: string): string; overload;

{ AnsiQuotedStr returns the given string as a quoted string, using the
  provided Quote character.  A Quote character is inserted at the beginning
  and end of the string, and each Quote character in the string is doubled.
  This function supports multibyte character strings (MBCS). }

function AnsiQuotedStr(const S: string; Quote: Char): string; overload;

{ AnsiExtractQuotedStr removes the Quote characters from the beginning and end
  of a quoted string, and reduces pairs of Quote characters within the quoted
  string to a single character. If the first character in Src is not the Quote
  character, the function returns an empty string.  The function copies
  characters from the Src to the result string until the second solitary
  Quote character or the first null character in Src. The Src parameter is
  updated to point to the first character following the quoted string.  If
  the Src string does not contain a matching end Quote character, the Src
  parameter is updated to point to the terminating null character in Src.
  This function supports multibyte character strings (MBCS).  }

function AnsiExtractQuotedStr(var Src: PAnsiChar; Quote: AnsiChar): AnsiString; overload;
function AnsiExtractQuotedStr(var Src: PWidechar; Quote: WideChar): UnicodeString; overload;

{ AnsiDequotedStr is a simplified version of AnsiExtractQuotedStr }

function AnsiDequotedStr(const S: string; AQuote: Char): string; overload;

{ AdjustLineBreaks adjusts all line breaks in the given string to the
  indicated style.
  When Style is tlbsCRLF, the function changes all
  CR characters not followed by LF and all LF characters not preceded
  by a CR into CR/LF pairs.
  When Style is tlbsLF, the function changes all CR/LF pairs and CR characters
  not followed by LF to LF characters. }

function AdjustLineBreaks(const S: string; Style: TTextLineBreakStyle =
        {$IFDEF LINUX} tlbsLF {$ENDIF}
        {$IFDEF MACOSX} tlbsLF {$ENDIF}
        {$IFDEF MSWINDOWS} tlbsCRLF {$ENDIF}): string; overload;

{ IsValidIdent returns true if the given string is a valid identifier. An
  identifier is defined as an alphabetic letter or '_' followed by zero or
  more alphabetic letters, digits or '_'. In some cases identifiers may
  contain dots, for example with nested types.
  For more information see: http://msdn.microsoft.com/en-us/library/aa664670(VS.71).aspx }

{$IFDEF CHAR}
function IsValidIdent(const Ident: string; AllowDots: Boolean = False): Boolean;
{$ENDIF}

{ IntToStr converts the given value to its decimal string representation. }

function IntToStr(Value: Integer): string; overload;
function IntToStr(Value: Int64): string; overload;

{ UIntToStr converts the given unsigned value to its decimal string representation. }

function UIntToStr(Value: Cardinal): string; overload;
function UIntToStr(Value: UInt64): string; overload;

{ IntToHex converts the given value to a hexadecimal string representation
  with the minimum number of digits specified. }

function IntToHex(Value: Integer; Digits: Integer): string; overload;
function IntToHex(Value: Int64; Digits: Integer): string; overload;

{ StrToInt converts the given string to an integer value. If the string
  doesn't contain a valid value, an EConvertError exception is raised. }

function StrToInt(const S: string): Integer; overload;
function StrToIntDef(const S: string; Default: Integer): Integer; overload;
function TryStrToInt(const S: string; out Value: Integer): Boolean; overload;

{ Similar to the above functions but for Int64 instead }

function StrToInt64(const S: string): Int64; overload;
function StrToInt64Def(const S: string; const Default: Int64): Int64; overload;
function TryStrToInt64(const S: string; out Value: Int64): Boolean; overload;

{ StrToBool converts the given string to a boolean value.  If the string
  doesn't contain a valid value, an EConvertError exception is raised.
  BoolToStr converts boolean to a string value that in turn can be converted
  back into a boolean.  BoolToStr will always pick the first element of
  the TrueStrs/FalseStrs arrays. }

var
  TrueBoolStrs: array of String;
  FalseBoolStrs: array of String;

const
  DefaultTrueBoolStr = 'True';   // DO NOT LOCALIZE
  DefaultFalseBoolStr = 'False'; // DO NOT LOCALIZE

function StrToBool(const S: string): Boolean; overload;
function StrToBoolDef(const S: string; const Default: Boolean): Boolean; overload;
function TryStrToBool(const S: string; out Value: Boolean): Boolean; overload;

function BoolToStr(B: Boolean; UseBoolStrs: Boolean = False): string;

{ LoadStr loads the string resource given by Ident from the application's
  executable file or associated resource module. If the string resource
  does not exist, LoadStr returns an empty string. }

function LoadStr(Ident: Integer): string;

{ FmtLoadStr loads the string resource given by Ident from the application's
  executable file or associated resource module, and uses it as the format
  string in a call to the Format function with the given arguments. }

function FmtLoadStr(Ident: Integer; const Args: array of const): string;

{ File management routines }

{ FileOpen opens the specified file using the specified access mode. The
  access mode value is constructed by OR-ing one of the fmOpenXXXX constants
  with one of the fmShareXXXX constants. If the return value is positive,
  the function was successful and the value is the file handle of the opened
  file. A return value of -1 indicates that an error occurred. }

function FileOpen(const FileName: string; Mode: LongWord): Integer;

{ FileCreate creates a new file by the specified name. If the return value
  is positive, the function was successful and the value is the file handle
  of the new file. A return value of -1 indicates that an error occurred.
  On Linux, this calls FileCreate(FileName, DEFFILEMODE) to create
  the file with read and write access for the current user only.  }

function FileCreate(const FileName: string): Integer; overload; inline;

{ This second version of FileCreate lets you specify the access rights to put on the newly
  created file.  The access rights parameter is ignored on Win32 }

function FileCreate(const FileName: string; Rights: Integer): Integer; overload; inline;

{ This third version of FileCreate lets you specify the share mode for the newly
  created file. }

function FileCreate(const FileName: string; Mode: LongWord; Rights: Integer): Integer; overload;

{ FileRead reads Count bytes from the file given by Handle into the buffer
  specified by Buffer. The return value is the number of bytes actually
  read; it is less than Count if the end of the file was reached. The return
  value is -1 if an error occurred. }

function FileRead(Handle: Integer; var Buffer; Count: LongWord): Integer;

{ FileWrite writes Count bytes to the file given by Handle from the buffer
  specified by Buffer. The return value is the number of bytes actually
  written, or -1 if an error occurred. }

function FileWrite(Handle: Integer; const Buffer; Count: LongWord): Integer;

{ FileSeek changes the current position of the file given by Handle to be
  Offset bytes relative to the point given by Origin. Origin = 0 means that
  Offset is relative to the beginning of the file, Origin = 1 means that
  Offset is relative to the current position, and Origin = 2 means that
  Offset is relative to the end of the file. The return value is the new
  current position, relative to the beginning of the file, or -1 if an error
  occurred. }

function FileSeek(Handle, Offset, Origin: Integer): Integer; overload;
function FileSeek(Handle: Integer; const Offset: Int64; Origin: Integer): Int64; overload;

{ FileClose closes the specified file. }

procedure FileClose(Handle: Integer); inline;

{ FileAge returns the date-and-time stamp of the specified file. The return
  value can be converted to a TDateTime value using the FileDateToDateTime
  function. The return value is -1 if the file does not exist. This version
  does not support date-and-time stamps prior to 1980 and after 2107. }

function FileAge(const FileName: string): Integer; overload; deprecated;

{ FileAge retrieves the date-and-time stamp of the specified file as a
  TDateTime. This version supports all valid NTFS date-and-time stamps
  and returns a boolean value that indicates whether the specified
  file exists. }

{$IFDEF MSWINDOWS}
function FileAge(const FileName: string; out FileDateTime: TDateTime): Boolean; overload;
{$ENDIF}

{ FileExists returns a boolean value that indicates whether the specified
  file exists. }

function FileExists(const FileName: string): Boolean;

{ DirectoryExists returns a boolean value that indicates whether the
  specified directory exists (and is actually a directory) }

function DirectoryExists(const Directory: string): Boolean;

{ ForceDirectories ensures that all the directories in a specific path exist.
  Any portion that does not already exist will be created.  Function result
  indicates success of the operation.  The function can fail if the current
  user does not have sufficient file access rights to create directories in
  the given path.  }

function ForceDirectories(Dir: string): Boolean;

{ FindFirst searches the directory given by Path for the first entry that
  matches the filename given by Path and the attributes given by Attr. The
  result is returned in the search record given by SearchRec. The return
  value is zero if the function was successful. Otherwise the return value
  is a system error code. After calling FindFirst, always call FindClose.
  FindFirst is typically used with FindNext and FindClose as follows:

    Result := FindFirst(Path, Attr, SearchRec);
    while Result = 0 do
    begin
      ProcessSearchRec(SearchRec);
      Result := FindNext(SearchRec);
    end;
    FindClose(SearchRec);

  where ProcessSearchRec represents user-defined code that processes the
  information in a search record. }

function FindFirst(const Path: string; Attr: Integer;
  var F: TSearchRec): Integer;

{ FindNext returs the next entry that matches the name and attributes
  specified in a previous call to FindFirst. The search record must be one
  that was passed to FindFirst. The return value is zero if the function was
  successful. Otherwise the return value is a system error code. }

function FindNext(var F: TSearchRec): Integer;

{ FindClose terminates a FindFirst/FindNext sequence and frees memory and system
  resources allocated by FindFirst.
  Every FindFirst/FindNext must end with a call to FindClose. }

procedure FindClose(var F: TSearchRec);

{ FileGetDate returns the OS date-and-time stamp of the file given by
  Handle. The return value is -1 if the handle is invalid. The
  FileDateToDateTime function can be used to convert the returned value to
  a TDateTime value. }

function FileGetDate(Handle: Integer): Integer;

{ FileSetDate sets the OS date-and-time stamp of the file given by FileName
  to the value given by Age. The DateTimeToFileDate function can be used to
  convert a TDateTime value to an OS date-and-time stamp. The return value
  is zero if the function was successful. Otherwise the return value is a
  system error code.        }

function FileSetDate(const FileName: string; Age: Integer): Integer; overload;

{$IFDEF MSWINDOWS}
{  FileSetDate by handle is not available on Unix platforms because there
  is no standard way to set a file's modification time using only a file
  handle, and no standard way to obtain the file name of an open
  file handle.  }

function FileSetDate(Handle: Integer; Age: Integer): Integer; overload; platform;

{ FileGetAttr returns the file attributes of the file given by FileName. The
  attributes can be examined by AND-ing with the faXXXX constants defined
  above. A return value of -1 indicates that an error occurred. }

function FileGetAttr(const FileName: string): Integer; platform;

{ FileSetAttr sets the file attributes of the file given by FileName to the
  value given by Attr. The attribute value is formed by OR-ing the
  appropriate faXXXX constants. The return value is zero if the function was
  successful. Otherwise the return value is a system error code. }

function FileSetAttr(const FileName: string; Attr: Integer): Integer; platform;
{$ENDIF}

{ FileIsReadOnly tests whether a given file is read-only for the current
  process and effective user id.  If the file does not exist, the
  function returns False.  (Check FileExists before calling FileIsReadOnly)
  This function is platform portable. }

function FileIsReadOnly(const FileName: string): Boolean; inline;

{ FileSetReadOnly sets the read only state of a file.  The file must
  exist and the current effective user id must be the owner of the file.
  On Unix systems, FileSetReadOnly attempts to set or remove
  all three (user, group, and other) write permissions on the file.
  If you want to grant partial permissions (writeable for owner but not
  for others), use platform specific functions such as chmod.
  The function returns True if the file was successfully modified,
  False if there was an error.  This function is platform portable.  }

function FileSetReadOnly(const FileName: string; ReadOnly: Boolean): Boolean;

{ DeleteFile deletes the file given by FileName. The return value is True if
  the file was successfully deleted, or False if an error occurred. }

function DeleteFile(const FileName: string): Boolean; inline;

{ RenameFile renames the file given by OldName to the name given by NewName.
  The return value is True if the file was successfully renamed, or False if
  an error occurred. }

function RenameFile(const OldName, NewName: string): Boolean; inline;

{ IsAssembly returns a boolean value that indicates whether the specified
  file is a .NET assembly. }
{}{
function IsAssembly(const FileName: string): Boolean;
}
{ ChangeFileExt changes the extension of a filename. FileName specifies a
  filename with or without an extension, and Extension specifies the new
  extension for the filename. The new extension can be a an empty string or
  a period followed by up to three characters. }

function ChangeFileExt(const FileName, Extension: string): string; overload;

{ ChangeFilePath changes the path of a filename. FileName specifies a
  filename with or without an extension, and Path specifies the new
  path for the filename. The new path is not required to contain the trailing
  path delimiter. }

function ChangeFilePath(const FileName, Path: string): string; overload;

{ ExtractFilePath extracts the drive and directory parts of the given
  filename. The resulting string is the leftmost characters of FileName,
  up to and including the colon or backslash that separates the path
  information from the name and extension. The resulting string is empty
  if FileName contains no drive and directory parts. }

function ExtractFilePath(const FileName: string): string; overload;

{ ExtractFileDir extracts the drive and directory parts of the given
  filename. The resulting string is a directory name suitable for passing
  to SetCurrentDir, CreateDir, etc. The resulting string is empty if
  FileName contains no drive and directory parts. }

function ExtractFileDir(const FileName: string): string; overload;

{ ExtractFileDrive extracts the drive part of the given filename.  For
  filenames with drive letters, the resulting string is '<drive>:'.
  For filenames with a UNC path, the resulting string is in the form
  '\\<servername>\<sharename>'.  If the given path contains neither
  style of filename, the result is an empty string. }

function ExtractFileDrive(const FileName: string): string; overload;

{ ExtractFileName extracts the name and extension parts of the given
  filename. The resulting string is the leftmost characters of FileName,
  starting with the first character after the colon or backslash that
  separates the path information from the name and extension. The resulting
  string is equal to FileName if FileName contains no drive and directory
  parts. }

function ExtractFileName(const FileName: string): string; overload;

{ ExtractFileExt extracts the extension part of the given filename. The
  resulting string includes the period character that separates the name
  and extension parts. The resulting string is empty if the given filename
  has no extension. }

function ExtractFileExt(const FileName: string): string; overload;

{ ExpandFileName expands the given filename to a fully qualified filename.
  The resulting string consists of a drive letter, a colon, a root relative
  directory path, and a filename. Embedded '.' and '..' directory references
  are removed. }

function ExpandFileName(const FileName: string): string; overload;

{ ExpandFilenameCase returns a fully qualified filename like ExpandFilename,
  but performs a case-insensitive filename search looking for a close match
  in the actual file system, differing only in uppercase versus lowercase of
  the letters.  This is useful to convert lazy user input into useable file
  names, or to convert filename data created on a case-insensitive file
  system (Win32) to something useable on a case-sensitive file system (Linux).

  The MatchFound out parameter indicates what kind of match was found in the
  file system, and what the function result is based upon:

  ( in order of increasing difficulty or complexity )
  mkExactMatch:  Case-sensitive match.  Result := ExpandFileName(FileName).
  mkSingleMatch: Exactly one file in the given directory path matches the
        given filename on a case-insensitive basis.
        Result := ExpandFileName(FileName as found in file system).
  mkAmbiguous: More than one file in the given directory path matches the
        given filename case-insensitively.
        In many cases, this should be considered an error.
        Result := ExpandFileName(First matching filename found).
  mkNone:  File not found at all.  Result := ExpandFileName(FileName).

  Note that because this function has to search the file system it may be
  much slower than ExpandFileName, particularly when the given filename is
  ambiguous or does not exist.  Use ExpandFilenameCase only when you have
  a filename of dubious orgin - such as from user input - and you want
  to make a best guess before failing.  }

type
  TFilenameCaseMatch = (mkNone, mkExactMatch, mkSingleMatch, mkAmbiguous);

function ExpandFileNameCase(const FileName: string;
  out MatchFound: TFilenameCaseMatch): string; overload;

{ ExpandUNCFileName expands the given filename to a fully qualified filename.
  This function is the same as ExpandFileName except that it will return the
  drive portion of the filename in the format '\\<servername>\<sharename> if
  that drive is actually a network resource instead of a local resource.
  Like ExpandFileName, embedded '.' and '..' directory references are
  removed. }

function ExpandUNCFileName(const FileName: string): string; overload;

{ ExtractRelativePath will return a file path name relative to the given
  BaseName.  It strips the common path dirs and adds '..\' on Windows,
  and '../' on Linux for each level up from the BaseName path. Note: Directories
  passed in should include trailing backslashes}

function ExtractRelativePath(const BaseName, DestName: string): string; overload;

{$IFDEF MSWINDOWS}
{ ExtractShortPathName will convert the given filename to the short form
  by calling the GetShortPathName API.  Will return an empty string if
  the file or directory specified does not exist }

function ExtractShortPathName(const FileName: string): string; overload;
{$ENDIF}

{ FileSearch searches for the file given by Name in the list of directories
  given by DirList. The directory paths in DirList must be separated by
  PathSep chars. The search always starts with the current directory of the
  current drive. The returned value is a concatenation of one of the
  directory paths and the filename, or an empty string if the file could not
  be located. }

function FileSearch(const Name, DirList: string): string;

{$IFDEF MSWINDOWS}
{ DiskFree returns the number of free bytes on the specified drive number,
  where 0 = Current, 1 = A, 2 = B, etc. DiskFree returns -1 if the drive
  number is invalid. }

function DiskFree(Drive: Byte): Int64;

{ DiskSize returns the size in bytes of the specified drive number, where
  0 = Current, 1 = A, 2 = B, etc. DiskSize returns -1 if the drive number
  is invalid. }

function DiskSize(Drive: Byte): Int64;
{$ENDIF}

{ FileDateToDateTime converts an OS date-and-time value to a TDateTime
  value. The FileAge, FileGetDate, and FileSetDate routines operate on OS
  date-and-time values, and the Time field of a TSearchRec used by the
  FindFirst and FindNext functions contains an OS date-and-time value. }

function FileDateToDateTime(FileDate: Integer): TDateTime;

{ DateTimeToFileDate converts a TDateTime value to an OS date-and-time
  value. The FileAge, FileGetDate, and FileSetDate routines operate on OS
  date-and-time values, and the Time field of a TSearchRec used by the
  FindFirst and FindNext functions contains an OS date-and-time value. }

function DateTimeToFileDate(DateTime: TDateTime): Integer;

{ GetCurrentDir returns the current directory. }

function GetCurrentDir: string;

{ SetCurrentDir sets the current directory. The return value is True if
  the current directory was successfully changed, or False if an error
  occurred. }

function SetCurrentDir(const Dir: string): Boolean;

{ CreateDir creates a new directory. The return value is True if a new
  directory was successfully created, or False if an error occurred. }

function CreateDir(const Dir: string): Boolean;

{ RemoveDir deletes an existing empty directory. The return value is
  True if the directory was successfully deleted, or False if an error
  occurred. }

function RemoveDir(const Dir: string): Boolean;

{ PChar routines }
{ const params help simplify C++ code.  No effect on pascal code }

{ StrLen returns the number of characters in Str, not counting the null
  terminator. }

function StrLen(const Str: PAnsiChar): Cardinal; overload;
function StrLen(const Str: PWideChar): Cardinal; overload;

{ StrEnd returns a pointer to the null character that terminates Str. }

function StrEnd(const Str: PAnsiChar): PAnsiChar; overload;
function StrEnd(const Str: PWideChar): PWideChar; overload;

{ StrMove copies exactly Count characters from Source to Dest and returns
  Dest. Source and Dest may overlap. }

function StrMove(Dest: PAnsiChar; const Source: PAnsiChar; Count: Cardinal): PAnsiChar; overload;
function StrMove(Dest: PWideChar; const Source: PWideChar; Count: Cardinal): PWideChar; overload;

{ StrCopy copies Source to Dest and returns Dest. }

function StrCopy(Dest: PAnsiChar; const Source: PAnsiChar): PAnsiChar; overload;
function StrCopy(Dest: PWideChar; const Source: PWideChar): PWideChar; overload;

{ StrECopy copies Source to Dest and returns StrEnd(Dest). }

function StrECopy(Dest: PAnsiChar; const Source: PAnsiChar): PAnsiChar; overload;
function StrECopy(Dest: PWideChar; const Source: PWideChar): PWideChar; overload;

{ StrLCopy copies at most MaxLen characters from Source to Dest and
  returns Dest. }

function StrLCopy(Dest: PAnsiChar; const Source: PAnsiChar; MaxLen: Cardinal): PAnsiChar; overload;
function StrLCopy(Dest: PWideChar; const Source: PWideChar; MaxLen: Cardinal): PWideChar; overload;

{ StrPCopy copies the Pascal style string Source into Dest and
  returns Dest. }

function StrPCopy(Dest: PAnsiChar; const Source: AnsiString): PAnsiChar; overload;
function StrPCopy(Dest: PWideChar; const Source: UnicodeString): PWideChar; overload;

{ StrPLCopy copies at most MaxLen characters from the Pascal style string
  Source into Dest and returns Dest. }

function StrPLCopy(Dest: PAnsiChar; const Source: AnsiString;
  MaxLen: Cardinal): PAnsiChar; overload;
function StrPLCopy(Dest: PWideChar; const Source: UnicodeString;
  MaxLen: Cardinal): PWideChar; overload;

{ StrCat appends a copy of Source to the end of Dest and returns Dest. }

function StrCat(Dest: PAnsiChar; const Source: PAnsiChar): PAnsiChar; overload;
function StrCat(Dest: PWideChar; const Source: PWideChar): PWideChar; overload;

{ StrLCat appends at most MaxLen - StrLen(Dest) characters from Source to
  the end of Dest, and returns Dest. }

function StrLCat(Dest: PAnsiChar; const Source: PAnsiChar; MaxLen: Cardinal): PAnsiChar; overload;
function StrLCat(Dest: PWideChar; const Source: PWideChar; MaxLen: Cardinal): PWideChar; overload;

{ StrComp compares Str1 to Str2. The return value is less than 0 if
  Str1 < Str2, 0 if Str1 = Str2, or greater than 0 if Str1 > Str2. }

function StrComp(const Str1, Str2: PAnsiChar): Integer; overload;
function StrComp(const Str1, Str2: PWideChar): Integer; overload;

{ StrIComp compares Str1 to Str2, without case sensitivity. The return
  value is the same as StrComp. }

function StrIComp(const Str1, Str2: PAnsiChar): Integer; overload;
function StrIComp(const Str1, Str2: PWideChar): Integer; overload;

{ StrLComp compares Str1 to Str2, for a maximum length of MaxLen
  characters. The return value is the same as StrComp. }

function StrLComp(const Str1, Str2: PAnsiChar; MaxLen: Cardinal): Integer; overload;
function StrLComp(const Str1, Str2: PWideChar; MaxLen: Cardinal): Integer; overload;

{ StrLIComp compares Str1 to Str2, for a maximum length of MaxLen
  characters, without case sensitivity. The return value is the same
  as StrComp. }

function StrLIComp(const Str1, Str2: PAnsiChar; MaxLen: Cardinal): Integer; overload;
function StrLIComp(const Str1, Str2: PWideChar; MaxLen: Cardinal): Integer; overload;

{ StrScan returns a pointer to the first occurrence of Chr in Str. If Chr
  does not occur in Str, StrScan returns NIL. The null terminator is
  considered to be part of the string. }

function StrScan(const Str: PAnsiChar; Chr: AnsiChar): PAnsiChar; overload;
function StrScan(const Str: PWideChar; Chr: WideChar): PWideChar; overload;

{ StrRScan returns a pointer to the last occurrence of Chr in Str. If Chr
  does not occur in Str, StrRScan returns NIL. The null terminator is
  considered to be part of the string. }

function StrRScan(const Str: PAnsiChar; Chr: AnsiChar): PAnsiChar; overload;
function StrRScan(const Str: PWideChar; Chr: WideChar): PWideChar; overload;

function PosEx(const SubStr, S: string; Offset: Integer = 1): Integer;

{ TextPos: Same as StrPos but is case insensitive }

function TextPos(Str, SubStr: PAnsiChar): PAnsiChar; overload;
function TextPos(Str, SubStr: PWideChar): PWideChar; overload;

{ StrPos returns a pointer to the first occurrence of Str2 in Str1. If
  Str2 does not occur in Str1, StrPos returns NIL. }

function StrPos(const Str1, Str2: PAnsiChar): PAnsiChar; overload;
function StrPos(const Str1, Str2: PWideChar): PWideChar; overload;

{ StrUpper converts Str to upper case and returns Str. }

function StrUpper(Str: PAnsiChar): PAnsiChar; overload;
function StrUpper(Str: PWideChar): PWideChar; overload;

{ StrLower converts Str to lower case and returns Str. }

function StrLower(Str: PAnsiChar): PAnsiChar; overload;
function StrLower(Str: PWideChar): PWideChar; overload;

{ StrPas converts Str to a Pascal style string. This function is provided
  for backwards compatibility only. To convert a null terminated string to
  a Pascal style string, use a string type cast or an assignment. }

function StrPas(const Str: PAnsiChar): AnsiString; overload;
function StrPas(const Str: PWideChar): UnicodeString; overload;

{ StrAlloc allocates a buffer of the given size on the heap. The size of
  the allocated buffer is encoded in a four byte header that immediately
  preceeds the buffer. To dispose the buffer, use StrDispose. }

function AnsiStrAlloc(Size: Cardinal): PAnsiChar;
function WideStrAlloc(Size: Cardinal): PWideChar;
function StrAlloc(Size: Cardinal): PChar;

{ StrBufSize returns the allocated size of the given buffer, not including
  the two byte header. }

function StrBufSize(const Str: PAnsiChar): Cardinal; overload;
function StrBufSize(const Str: PWideChar): Cardinal; overload;

{ StrNew allocates a copy of Str on the heap. If Str is NIL, StrNew returns
  NIL and doesn't allocate any heap space. Otherwise, StrNew makes a
  duplicate of Str, obtaining space with a call to the StrAlloc function,
  and returns a pointer to the duplicated string. To dispose the string,
  use StrDispose. }

function StrNew(const Str: PAnsiChar): PAnsiChar; overload;
function StrNew(const Str: PWideChar): PWideChar; overload;

{ StrDispose disposes a string that was previously allocated with StrAlloc
  or StrNew. If Str is NIL, StrDispose does nothing. }

procedure StrDispose(Str: PAnsiChar); overload;
procedure StrDispose(Str: PWideChar); overload;

{ String formatting routines }

{ The Format routine formats the argument list given by the Args parameter
  using the format string given by the Format parameter.

  Format strings contain two types of objects--plain characters and format
  specifiers. Plain characters are copied verbatim to the resulting string.
  Format specifiers fetch arguments from the argument list and apply
  formatting to them.

  Format specifiers have the following form:

    "%" [index ":"] ["-"] [width] ["." prec] type

  A format specifier begins with a % character. After the % come the
  following, in this order:

  -  an optional argument index specifier, [index ":"]
  -  an optional left-justification indicator, ["-"]
  -  an optional width specifier, [width]
  -  an optional precision specifier, ["." prec]
  -  the conversion type character, type

  The following conversion characters are supported:

  d  Decimal. The argument must be an integer value. The value is converted
     to a string of decimal digits. If the format string contains a precision
     specifier, it indicates that the resulting string must contain at least
     the specified number of digits; if the value has less digits, the
     resulting string is left-padded with zeros.

  u  Unsigned decimal.  Similar to 'd' but no sign is output.

  e  Scientific. The argument must be a floating-point value. The value is
     converted to a string of the form "-d.ddd...E+ddd". The resulting
     string starts with a minus sign if the number is negative, and one digit
     always precedes the decimal point. The total number of digits in the
     resulting string (including the one before the decimal point) is given
     by the precision specifer in the format string--a default precision of
     15 is assumed if no precision specifer is present. The "E" exponent
     character in the resulting string is always followed by a plus or minus
     sign and at least three digits.

  f  Fixed. The argument must be a floating-point value. The value is
     converted to a string of the form "-ddd.ddd...". The resulting string
     starts with a minus sign if the number is negative. The number of digits
     after the decimal point is given by the precision specifier in the
     format string--a default of 2 decimal digits is assumed if no precision
     specifier is present.

  g  General. The argument must be a floating-point value. The value is
     converted to the shortest possible decimal string using fixed or
     scientific format. The number of significant digits in the resulting
     string is given by the precision specifier in the format string--a
     default precision of 15 is assumed if no precision specifier is present.
     Trailing zeros are removed from the resulting string, and a decimal
     point appears only if necessary. The resulting string uses fixed point
     format if the number of digits to the left of the decimal point in the
     value is less than or equal to the specified precision, and if the
     value is greater than or equal to 0.00001. Otherwise the resulting
     string uses scientific format.

  n  Number. The argument must be a floating-point value. The value is
     converted to a string of the form "-d,ddd,ddd.ddd...". The "n" format
     corresponds to the "f" format, except that the resulting string
     contains thousand separators.

  m  Money. The argument must be a floating-point value. The value is
     converted to a string that represents a currency amount. The conversion
     is controlled by the CurrencyString, CurrencyFormat, NegCurrFormat,
     ThousandSeparator, DecimalSeparator, and CurrencyDecimals global
     variables, all of which are initialized from locale settings provided
     by the operating system.  For example, Currency Format preferences can be
     set in the International section of the Windows Control Panel. If the format
     string contains a precision specifier, it overrides the value given
     by the CurrencyDecimals global variable.

  p  Pointer. The argument must be a pointer value. The value is converted
     to a string of the form "XXXX:YYYY" where XXXX and YYYY are the
     segment and offset parts of the pointer expressed as four hexadecimal
     digits.

  s  String. The argument must be a character, a string, or a PChar value.
     The string or character is inserted in place of the format specifier.
     The precision specifier, if present in the format string, specifies the
     maximum length of the resulting string. If the argument is a string
     that is longer than this maximum, the string is truncated.

  x  Hexadecimal. The argument must be an integer value. The value is
     converted to a string of hexadecimal digits. If the format string
     contains a precision specifier, it indicates that the resulting string
     must contain at least the specified number of digits; if the value has
     less digits, the resulting string is left-padded with zeros.

  Conversion characters may be specified in upper case as well as in lower
  case--both produce the same results.

  For all floating-point formats, the actual characters used as decimal and
  thousand separators are obtained from the DecimalSeparator and
  ThousandSeparator global variables.

  Index, width, and precision specifiers can be specified directly using
  decimal digit string (