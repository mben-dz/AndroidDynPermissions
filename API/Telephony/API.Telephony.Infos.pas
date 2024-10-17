   unit API.Telephony.Infos;

interface

  function GetPhoneInfo: string;

implementation

uses
  System.SysUtils,
  Androidapi.Helpers,
  Androidapi.JNIBridge,
  Androidapi.JNI.JavaTypes,
  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNI.Telephony;

function GetTelephonyManager: JTelephonyManager;
begin
  Result := TJTelephonyManager.Wrap(
    (TAndroidHelper.Context
       .getSystemService(
         TJContext.JavaClass.TELEPHONY_SERVICE) as ILocalObject)
          .GetObjectID);
end;

function GetPhoneInfo: string;
var
  LTelephonyMgr: JTelephonyManager;
begin
  LTelephonyMgr := GetTelephonyManager;
  Result := Format('Device Info:%sOS Version: %s%sNetwork Operator: %s',
                   [sLineBreak, TOSVersion.ToString, sLineBreak,
                    JStringToString(LTelephonyMgr.getNetworkOperatorName)]);
end;

end.
