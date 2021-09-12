unit UFrmDashBoard;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,

  UUsuarios, FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls;

type
  TfrmDashboard = class(TForm)
    Label1: TLabel;
    Rectangle1: TRectangle;
  private
    FUsuario: TUsuarios;
    { Private declarations }
  public
    { Public declarations }
    property Usuario: TUsuarios read FUsuario write FUsuario;
  end;

var
  frmDashboard: TfrmDashboard;

implementation

{$R *.fmx}

end.
