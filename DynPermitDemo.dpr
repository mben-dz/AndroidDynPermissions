program DynPermitDemo;

uses
  System.StartUpCopy,
  FMX.Forms,
  Main.View in 'Main.View.pas' {MainView},
  API.DynamicPermissions in 'API\Permissions\API.DynamicPermissions.pas',
  API.Types in 'API\API.Types.pas',
  API.Telephony.Infos in 'API\Telephony\API.Telephony.Infos.pas',
  API.Resources in 'API\API.Resources.pas';

{$R *.res}

var
  MainView: TMainView;
begin
  ReportMemoryLeaksOnShutdown := True;

  Application.Initialize;
  Application.CreateForm(TMainView, MainView);
  Application.Run;
end.
