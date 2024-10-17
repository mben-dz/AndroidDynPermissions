unit API.Types;

interface

uses
  System.Classes,
  System.SysUtils,
  System.SyncObjs
;

type
  TProcLog = TProc<string>;
  TProcLogView = TProc<string, Boolean>;

  TLogView = class
  strict private
    fLockView: TCriticalSection;
    fLogView: TProcLogView;
  private
  public
    constructor Create(aLogView: TProcLogView);
    destructor Destroy; override;

    procedure Log(const aLogMsg: string; aNewLine: Boolean = True);
  end;

implementation

{ TLogView }

constructor TLogView.Create(aLogView: TProcLogView);
begin
  fLockView := TCriticalSection.Create;
  fLogView     := aLogView;
end;

destructor TLogView.Destroy;
begin
  fLockView.Free;

  inherited;
end;

procedure TLogView.Log(const aLogMsg: string; aNewLine: Boolean);
begin
  if Assigned(fLogView) then
  TThread.Queue(nil, procedure begin
    fLockView.Acquire;
    try
      fLogView(aLogMsg, aNewLine);
    finally
      fLockView.Release;
    end;
  end);
end;

end.
