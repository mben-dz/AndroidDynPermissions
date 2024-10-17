unit Main.View;

interface

uses
{$REGION '  System''s .. '}
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  System.Generics.Collections,
{$ENDREGION}
{$REGION '  FMX''s .. '}
  FMX.Types,
  FMX.Graphics,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.TabControl,
  FMX.StdCtrls,
  FMX.Gestures,
  FMX.Memo.Types,
  FMX.ScrollBox,
  FMX.Memo,
  FMX.Objects,
  FMX.Controls.Presentation,
  FMX.ListView.Types,
  FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base,
  FMX.ListView
{$ENDREGION}

, API.DynamicPermissions
, API.Types, FMX.Layouts;

type
  TMainView = class(TForm)
{$REGION '  Components .. '}
    HeaderToolBar: TToolBar;
    ToolBarLabel: TLabel;
    TabView: TTabControl;
    Tab_Permissions: TTabItem;
    Tab_Log: TTabItem;
    Rect_AppStatus: TRectangle;
    Txt_AppStatus: TText;
    StyleMgr_APP: TStyleBook;
    Memo_Log: TMemo;
    LV_Permissions: TListView;
    Img_Status: TImage;
    Lyt_StatusLV: TLayout;
    Txt_Needed: TText;
    Rect_StatusLV: TRectangle;
    GridLyt_Counts: TGridPanelLayout;
    Txt_RequiredCount: TText;
  {$ENDREGION}

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    fGrantedIcon, fDeniedIcon: TBitmap;
    fLogView: TProcLogView;
    fDynPermit: IAndroidDynPermit;
    function GetDynPermit: IAndroidDynPermit;

    procedure PopulatePermissions(aListView: TListView);
  public
    constructor Create(AOwner: TComponent); override;

    property DynPermit: IAndroidDynPermit read GetDynPermit;
  end;

implementation

uses
  API.Telephony.Infos,
  API.Resources,
  Androidapi.JNI.Os;

{$R *.fmx}

function LoadIconFromBase64(const Base64Str: string): TBitmap;
var
  LIconStream: TStringStream;
begin
  Result := TBitmap.Create;
  LIconStream := TStringStream.Create(Base64Str);
  try
    Result.LoadFromStream(LIconStream.DecodeBase64);
  finally
    LIconStream.Free;
  end;
end;

constructor TMainView.Create(AOwner: TComponent);
begin inherited Create(AOwner);

  fLogView := procedure (aLogMsg: string; aNewLine: Boolean) begin
        if (not aNewLine)and(Memo_Log.Lines.Count > 0) then
          Memo_Log.Lines.Delete(Memo_Log.Lines.Count - 1);

        Memo_Log.Lines.Append(aLogMsg);
      end;

  fGrantedIcon := LoadIconFromBase64(GrantedIconBase64);
  fDeniedIcon := LoadIconFromBase64(DeniedIconBase64);
end;

function TMainView.GetDynPermit: IAndroidDynPermit;
begin
  if not Assigned(fDynPermit) then
    fDynPermit :=
      CreateAndroidPermit(fLogView);

  Result := fDynPermit;
end;

procedure TMainView.PopulatePermissions(aListView: TListView);
var
  LPermissionList: TDictionary<string, Boolean>;
  LPermission: string;
  LIsGranted: Boolean;
  LListItem: TListViewItem;
begin
  // Clear existing items
  aListView.Items.Clear;

  try
    // Get the permissions with their statuses
    LPermissionList := DynPermit.GetPermissionListWithStatus;

    aListView.BeginUpdate;
    try
      for LPermission in LPermissionList.Keys do
      begin
        LIsGranted := LPermissionList[LPermission];

          LListItem := aListView.Items.Add;
          LListItem.Text := LPermission;

          if LIsGranted then
            LListItem.Bitmap := fGrantedIcon
          else
            LListItem.Bitmap := fDeniedIcon;
      end;
    finally
      aListView.EndUpdate;
    end;
  finally
    fGrantedIcon.Free;
    fDeniedIcon.Free;
  end;
end;

procedure TMainView.FormCreate(Sender: TObject);
begin
  TabView.ActiveTab := Tab_Permissions;

  DynPermit.SetAllGranted(procedure begin

    if DynPermit
      .IsGrantedFor(TJManifest_permission.JavaClass.READ_PHONE_STATE) then
      Txt_AppStatus.Text :=  GetPhoneInfo;
    Txt_RequiredCount.Text :=
     'Required Permissions Count: '+DynPermit.GetRequiredPermissionsCount.ToString;
    Txt_Needed.Text :=
     'Needed Permissions Count: '+DynPermit.GetNeededPermissionsCount.ToString;

    PopulatePermissions(LV_Permissions);

  end);

end;

procedure TMainView.FormDestroy(Sender: TObject);
begin
  DynPermit.TerminateInstance(fDynPermit);
end;

end.
