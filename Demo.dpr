program Demo;

uses
  Vcl.Forms,
  UTeste in 'UTeste.pas' {Form1},
  SimpleJSONReader in 'SimpleJSONReader.pas';


{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  ReportMemoryLeaksOnShutdown := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
