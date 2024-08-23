unit UTeste;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,system.JSON;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    Memo2: TMemo;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses  SimpleJSONReader;

procedure TForm1.Button1Click(Sender: TObject);
var
 i :integer;
 Lres : ISimpleJSONReader;
begin
  LRes := TSimpleJSONReader.New(Memo1.Text).GetValueFromArray(1)
        .GetObject('alteracoes')
          .GetArray('alteracoes')
          .GetValueFromArray(2);


  Memo2.Lines.Add(LRes.GetValueAsString('campo')) ;
  Memo2.Lines.Add(LRes.GetValueAsString('valorNovo')) ;
  Memo2.Lines.Add(LRes.GetValueAsString('valorAntigo')) ;
end;

end.
