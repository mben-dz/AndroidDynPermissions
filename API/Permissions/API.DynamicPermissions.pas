unit API.DynamicPermissions;

interface

uses
{$REGION '  System''s .. '}
  System.SysUtils,
  System.Permissions,
  System.Classes,
  System.Types,
  System.Generics.Collections,
  System.SyncObjs,
  System.Threading,
{$ENDREGION}
{$REGION '  Androidapi''s .. '}
  Androidapi.Helpers,
  Androidapi.Jni,
  Androidapi.JNIBridge,
  Androidapi.JNI.JavaTypes,
  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNI.Os,
{$ENDREGION}
//
  FMX.Helpers.Android,
//
  API.Types // Include your new log view class
;
type
{$IFDEF ANDROID}
  IAndroidDynPermit = interface ['{AFC76F5C-5A6D-4905-8F55-BFB5C37BB91F}']

    procedure SetAllGranted(aAfterFinish: TProc = nil); // Procedure to set permissions
    function GetDeniedList: TStringDynArray;
    function IsGrantedFor(const aPermission: JString): Boolean; // ex Arg: TJManifest_permission.JavaClass.CALL_PHONE
    function IsAllGranted: Boolean;
    function GetPermissionListWithStatus: TDictionary<string, Boolean>;
    function GetRequiredPermissionsCount: Byte;
    function GetNeededPermissionsCount: Byte;

    procedure TerminateInstance(aInstance: IAndroidDynPermit);
  end;

function CreateAndroidPermit(aLogView: TProcLogView): IAndroidDynPermit;

{$ENDIF}

implementation

type
  TAndroidDynPermit = class(TInterfacedObject, IAndroidDynPermit)
  strict private
    fPermissions: TStringDynArray;
    fDeniedPermissions: TList<string>;
    fLogView: TLogView;
    fAfterFinish: TProc;
    fIsAllGranted: Boolean;
    fPermissionPrefix: string;
    fRequiredPermissionsCount,
    fNeededPermissionsCount: Byte;

    function GetPermissionsFromManifest: TStringDynArray;
    procedure HandlePermissionResult(
      const APermissions: TClassicStringDynArray;
      const AGrantResults: TClassicPermissionStatusDynArray);

    procedure Log(const aLogMsg: string);
  private
    procedure SetAllGranted(aAfterFinish: TProc = nil); // Procedure to set permissions Dynamically from Manifest..
    function GetDeniedList: TStringDynArray;
    function IsGrantedFor(const aPermission: JString): Boolean;
    function IsAllGranted: Boolean;
    function GetPermissionListWithStatus: TDictionary<string, Boolean>;
    function GetRequiredPermissionsCount: Byte;
    function GetNeededPermissionsCount: Byte;
    procedure TerminateInstance(aInstance: IAndroidDynPermit);
  public
    constructor Create(aLogView: TProcLogView);
    destructor Destroy; override;
  end;

function CreateAndroidPermit(aLogView: TProcLogView): IAndroidDynPermit;
begin
  Result := TAndroidDynPermit.Create(aLogView);
end;

function TAndroidDynPermit.GetPermissionsFromManifest: TStringDynArray;
var
  LPackageManager: JPackageManager;
  LPackageInfo: JPackageInfo;
  LPermissions: TList<string>;
  I: Integer;
begin
  LPackageManager := TAndroidHelper.Context.getPackageManager;
  LPackageInfo := LPackageManager
    .getPackageInfo(TAndroidHelper.Context.getPackageName, TJPackageManager.JavaClass.GET_PERMISSIONS);

  LPermissions := TList<string>.Create;
  try
    if Assigned(LPackageInfo.requestedPermissions) then
    begin
      for I := 0 to LPackageInfo.requestedPermissions.Length - 1 do
        LPermissions.Add(JStringToString(LPackageInfo.requestedPermissions.Items[I]));
    end;
    Result := LPermissions.ToArray;
  finally
    LPermissions.Free;
    fRequiredPermissionsCount := LPackageInfo.requestedPermissions.Length;
  end;

end;

{ TAndroidPermit }

constructor TAndroidDynPermit.Create(aLogView: TProcLogView);
begin
  fRequiredPermissionsCount := 0;
  fNeededPermissionsCount   := 0;

  fIsAllGranted := False;
  fAfterFinish  := nil;

  if Assigned(aLogView) then
    fLogView := TLogView.Create(aLogView);

  fPermissions := GetPermissionsFromManifest;
  fDeniedPermissions := TList<string>.Create;

  fPermissionPrefix := 'android.permission.'; // Constant for the prefix to remove

end;

destructor TAndroidDynPermit.Destroy;
begin
  if Assigned(fLogView) then
    fLogView.Free;

  fDeniedPermissions.Free;

  inherited;
end;

procedure TAndroidDynPermit.TerminateInstance(aInstance: IAndroidDynPermit);
begin
  aInstance := nil;
  Self.Free;
end;

procedure TAndroidDynPermit.Log(const aLogMsg: string);
begin
  if Assigned(fLogView) then begin
    fLogView.Log('======================');
    fLogView.Log(aLogMsg);
  end;
end;

procedure TAndroidDynPermit.HandlePermissionResult(
  const APermissions: TClassicStringDynArray;
  const AGrantResults: TClassicPermissionStatusDynArray);
var
  LIndex: Integer;
  LPermissionName: string;
begin
  fIsAllGranted := True; // Second Call inside TTask
  fDeniedPermissions.Clear; // Second Call inside TTask

  for LIndex := 0 to High(aGrantResults) do
  begin
    if aPermissions[LIndex].StartsWith(fPermissionPrefix) then
      LPermissionName := aPermissions[LIndex].Substring(fPermissionPrefix.Length)
    else
      LPermissionName := aPermissions[LIndex];

    if aGrantResults[LIndex] = TPermissionStatus.Granted then
    begin
      Log('Permission Granted for: ' + LPermissionName);
    end else begin
      Log('Permission Denied for: ' + LPermissionName);
      fDeniedPermissions.Add(APermissions[LIndex]);
      fIsAllGranted := False;
    end;
  end;

  if not fIsAllGranted then
  begin
    Log('Some permissions were denied!');
  end;

  if Assigned(fAfterFinish) then
    TThread.Queue(nil, procedure begin
      fAfterFinish();
  end);
end;

procedure TAndroidDynPermit.SetAllGranted(aAfterFinish: TProc);
var
  LPermissionsToRequest: TStringDynArray;
  LPermission, LPermissionName: string;
begin
  SetLength(LPermissionsToRequest, 0);
  fIsAllGranted := True; // First Call..
  fDeniedPermissions.Clear; // First Call..

  fAfterFinish := aAfterFinish;

  for LPermission in fPermissions do
  begin
    if LPermission.StartsWith(fPermissionPrefix) then
      LPermissionName := LPermission.Substring(fPermissionPrefix.Length)
    else
      LPermissionName := LPermission;

    if not PermissionsService.IsPermissionGranted(LPermission) then
    begin
      SetLength(LPermissionsToRequest, Length(LPermissionsToRequest) + 1);
      LPermissionsToRequest[High(LPermissionsToRequest)] := LPermission;
      Inc(fNeededPermissionsCount);
      Log('Permission needed for: ' + LPermissionName);

      fDeniedPermissions.Add(LPermission);
      fIsAllGranted := False;
    end else
      Log('Permission already granted for: ' +LPermissionName);
  end;

  if FIsAllGranted then
  begin
    try
      if Assigned(fAfterFinish) then
        TThread.Queue(nil, procedure begin
          fAfterFinish();
        end);

    finally
      Log('All permissions are already granted.');
    end;

    Exit; // No need to request permissions if all are already granted
  end;

  // Request the permissions asynchronously
  CallInUIThread(
    procedure
    begin
      PermissionsService
        .RequestPermissions(LPermissionsToRequest, HandlePermissionResult);
    end
  );
end;

function TAndroidDynPermit.GetDeniedList: TStringDynArray;
begin
  Result := fDeniedPermissions.ToArray;
end;

function TAndroidDynPermit.GetRequiredPermissionsCount: Byte;
begin
  Result := fRequiredPermissionsCount;
end;

function TAndroidDynPermit.GetNeededPermissionsCount: Byte;
begin
  Result := fNeededPermissionsCount;
end;

function TAndroidDynPermit.IsAllGranted: Boolean;
begin
  Result := fIsAllGranted;
end;

function TAndroidDynPermit.IsGrantedFor(const aPermission: JString): Boolean;
var
  PermissionString: string;
begin
  PermissionString := JStringToString(aPermission);
  Result := PermissionsService.IsPermissionGranted(PermissionString);
end;

function TAndroidDynPermit.GetPermissionListWithStatus: TDictionary<string, Boolean>;
var
  LPermission, LPermissionName: string;
  LPermissionStatus: Boolean;
  LPermissionList: TDictionary<string, Boolean>;
begin
  LPermissionList := TDictionary<string, Boolean>.Create;

  for LPermission in fPermissions do
  begin
    if LPermission.StartsWith(fPermissionPrefix) then
      LPermissionName := LPermission.Substring(fPermissionPrefix.Length)
    else
      LPermissionName := LPermission;

    LPermissionStatus := PermissionsService.IsPermissionGranted(LPermission);
    LPermissionList.Add(LPermissionName, LPermissionStatus);
  end;

  Result := LPermissionList;
end;

end.
